//
//  PDAFNetworkDomainController.m
//  PonyDebugger
//
//  Created by Mike Lewis on 2/27/12.
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import "swizzOnNSURLConnection.h"
//#import "PDPrettyStringPrinter.h"
//#import "NSDate+PDDebugger.h"

#import <objc/runtime.h>
#import <objc/message.h>
#import <dispatch/queue.h>

#import "innerConsole.h"
@interface _PDRequestState : NSObject

@property (nonatomic, copy) NSURLRequest *request;
@property (nonatomic, copy) NSURLResponse *response;
@property (nonatomic, strong) NSMutableData *dataAccumulator;
@property (nonatomic, copy) NSString *requestID;

@end


@interface swizzOnNSURLConnection ()

- (void)setResponse:(NSData *)responseBody forRequestID:(NSString *)requestID response:(NSURLResponse *)response request:(NSURLRequest *)request;
- (void)performBlock:(dispatch_block_t)block;

@end


@implementation swizzOnNSURLConnection {
    NSCache *_responseCache;
    NSMutableDictionary *_connectionStates;
    dispatch_queue_t _queue;
}

#pragma mark - Statics

+ (swizzOnNSURLConnection *)defaultInstance;
{
    static swizzOnNSURLConnection *defaultInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultInstance = [[swizzOnNSURLConnection alloc] init];
    });
    return defaultInstance;
}

+ (NSString *)nextRequestID;
{
    static NSInteger sequenceNumber = 0;
    static NSString *seed = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CFUUIDRef uuid = CFUUIDCreate(CFAllocatorGetDefault());
        seed = (__bridge NSString *)CFUUIDCreateString(CFAllocatorGetDefault(), uuid);
        CFRelease(uuid);
    });
    
    return [[NSString alloc] initWithFormat:@"%@-%ld", seed, (long)(++sequenceNumber)];
}


#pragma mark Delegate Injection Convenience Methods

+ (SEL)swizzledSelectorForSelector:(SEL)selector;
{
    return NSSelectorFromString([NSString stringWithFormat:@"_pd_swizzle_%x_%@", arc4random(), NSStringFromSelector(selector)]);
}

+ (void)domainControllerSwizzleGuardForSwizzledObject:(NSObject *)object selector:(SEL)selector implementationBlock:(void (^)(void))implementationBlock;
{
    void *key = (__bridge void *)[[NSString alloc] initWithFormat:@"PDSelectorGuardKeyForSelector:%@", NSStringFromSelector(selector)];
    if (!objc_getAssociatedObject(object, key)) {
        objc_setAssociatedObject(object, key, [NSNumber numberWithBool:YES], OBJC_ASSOCIATION_ASSIGN);
        implementationBlock();
        objc_setAssociatedObject(object, key, nil, OBJC_ASSOCIATION_ASSIGN);
    }
}

+ (BOOL)instanceRespondsButDoesNotImplementSelector:(SEL)selector class:(Class)cls;
{
    if ([cls instancesRespondToSelector:selector]) {
        unsigned int numMethods = 0;
        Method *methods = class_copyMethodList(cls, &numMethods);
        
        BOOL implementsSelector = NO;
        for (int index = 0; index < numMethods; index++) {
            SEL methodSelector = method_getName(methods[index]);
            if (selector == methodSelector) {
                implementsSelector = YES;
                break;
            }
        }
        
        free(methods);
        
        if (!implementsSelector) {
            return YES;
        }
    }
    
    return NO;
}

+ (void)replaceImplementationOfSelector:(SEL)selector withSelector:(SEL)swizzledSelector forClass:(Class)cls withMethodDescription:(struct objc_method_description)methodDescription implementationBlock:(id)implementationBlock undefinedBlock:(id)undefinedBlock;
{
    if ([self instanceRespondsButDoesNotImplementSelector:selector class:cls]) {
        return;
    }

#ifdef __IPHONE_6_0
    IMP implementation = imp_implementationWithBlock((id)([cls instancesRespondToSelector:selector] ? implementationBlock : undefinedBlock));
#else
    IMP implementation = imp_implementationWithBlock((__bridge void *)([cls instancesRespondToSelector:selector] ? implementationBlock : undefinedBlock));
#endif
    
    Method oldMethod = class_getInstanceMethod(cls, selector);
    if (oldMethod) {
        class_addMethod(cls, swizzledSelector, implementation, methodDescription.types);
         
        Method newMethod = class_getInstanceMethod(cls, swizzledSelector);
        
        method_exchangeImplementations(oldMethod, newMethod);
    } else {
        class_addMethod(cls, selector, implementation, methodDescription.types);
    }
}

#pragma mark - Delegate Injection

+ (void)injectIntoAllNSURLConnectionDelegateClasses;
{
    // Only allow swizzling once.
    static BOOL swizzled = NO;
    if (swizzled) {
        return;
    }
    
    swizzled = YES;

    // Swizzle any classes that implement one of these selectors.
    const SEL selectors[] = {
        @selector(connectionDidFinishLoading:),
        @selector(connection:didReceiveResponse:)
    };
    
    const int numSelectors = sizeof(selectors) / sizeof(SEL);

    Class *classes = NULL;
    int numClasses = objc_getClassList(NULL, 0);
    
    if (numClasses > 0) {
        classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
        for (NSInteger classIndex = 0; classIndex < numClasses; ++classIndex) {
            Class class = classes[classIndex];
            
            if (class_getClassMethod(class, @selector(isSubclassOfClass:)) == NULL) {
                continue;
            }
            
            if (![class isSubclassOfClass:[NSObject class]]) {
                continue;
            }
            
            if ([class isSubclassOfClass:[swizzOnNSURLConnection class]]) {
                continue;
            }
            
            for (int selectorIndex = 0; selectorIndex < numSelectors; ++selectorIndex) {
                if ([class instancesRespondToSelector:selectors[selectorIndex]]) {
                    [self injectIntoDelegateClass:class];
                    break;
                }
            }
        }
        
        free(classes);
    }
}

+ (void)injectIntoDelegateClass:(Class)cls;
{
//    [self injectWillSendRequestIntoDelegateClass:cls];
    [self injectDidReceiveDataIntoDelegateClass:cls];
    [self injectDidReceiveResponseIntoDelegateClass:cls];
    [self injectDidFinishLoadingIntoDelegateClass:cls];
//    [self injectDidFailWithErrorIntoDelegateClass:cls];
}

+ (void)injectWillSendRequestIntoDelegateClass:(Class)cls;
{
    SEL selector = @selector(connection:willSendRequest:redirectResponse:);
    SEL swizzledSelector = [self swizzledSelectorForSelector:selector];
    
    Protocol *protocol = @protocol(NSURLConnectionDataDelegate);
    if (!protocol) {
        protocol = @protocol(NSURLConnectionDelegate);
    }
    
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    
    typedef NSURLRequest *(^NSURLConnectionWillSendRequestBlock)(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSURLRequest *request, NSURLResponse *response);
    
    NSURLConnectionWillSendRequestBlock undefinedBlock = ^NSURLRequest *(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSURLRequest *request, NSURLResponse *response) {
        [self domainControllerSwizzleGuardForSwizzledObject:slf selector:selector implementationBlock:^{
            [[swizzOnNSURLConnection defaultInstance] connection:connection willSendRequest:request redirectResponse:response];
        }];
        
        return request;
    };
    
    NSURLConnectionWillSendRequestBlock implementationBlock = ^NSURLRequest *(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSURLRequest *request, NSURLResponse *response) {
        NSURLRequest *returnValue = ((id(*)(id, SEL, id, id, id))objc_msgSend)(slf, swizzledSelector, connection, request, response);
        undefinedBlock(slf, connection, request, response);
        return returnValue;
    };
    
    [self replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription implementationBlock:implementationBlock undefinedBlock:undefinedBlock];
}

+ (void)injectDidReceiveResponseIntoDelegateClass:(Class)cls;
{
    SEL selector = @selector(connection:didReceiveResponse:);
    SEL swizzledSelector = [self swizzledSelectorForSelector:selector];
    
    Protocol *protocol = @protocol(NSURLConnectionDataDelegate);
    if (!protocol) {
        protocol = @protocol(NSURLConnectionDelegate);
    }
    
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    
    typedef void (^NSURLConnectionDidReceiveResponseBlock)(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSURLResponse *response);
    
    NSURLConnectionDidReceiveResponseBlock undefinedBlock = ^(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSURLResponse *response) {
        [self domainControllerSwizzleGuardForSwizzledObject:slf selector:selector implementationBlock:^{
            [[swizzOnNSURLConnection defaultInstance] connection:connection didReceiveResponse:response];
        }];
    };
    
    NSURLConnectionDidReceiveResponseBlock implementationBlock = ^(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSURLResponse *response) {
        undefinedBlock(slf, connection, response);
        ((void(*)(id, SEL, id, id))objc_msgSend)(slf, swizzledSelector, connection, response);
    };
    
    [self replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription implementationBlock:implementationBlock undefinedBlock:undefinedBlock];
}

+ (void)injectDidReceiveDataIntoDelegateClass:(Class)cls;
{
    SEL selector = @selector(connection:didReceiveData:);
    SEL swizzledSelector = [self swizzledSelectorForSelector:selector];
    
    Protocol *protocol = @protocol(NSURLConnectionDataDelegate);
    if (!protocol) {
        protocol = @protocol(NSURLConnectionDelegate);
    }
    
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    
    typedef void (^NSURLConnectionDidReceiveDataBlock)(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSData *data);
    
    NSURLConnectionDidReceiveDataBlock undefinedBlock = ^(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSData *data) {
        [[swizzOnNSURLConnection defaultInstance] connection:connection didReceiveData:data];
    };
    
    NSURLConnectionDidReceiveDataBlock implementationBlock = ^(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSData *data) {
        undefinedBlock(slf, connection, data);
        ((void(*)(id, SEL, id, id))objc_msgSend)(slf, swizzledSelector, connection, data);
    };
    
    [self replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription implementationBlock:implementationBlock undefinedBlock:undefinedBlock];
}

+ (void)injectDidFinishLoadingIntoDelegateClass:(Class)cls;
{
    SEL selector = @selector(connectionDidFinishLoading:);
    SEL swizzledSelector = [self swizzledSelectorForSelector:selector];
    
    Protocol *protocol = @protocol(NSURLConnectionDataDelegate);
    if (!protocol) {
        protocol = @protocol(NSURLConnectionDelegate);
    }
    
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    
    typedef void (^NSURLConnectionDidFinishLoadingBlock)(id <NSURLConnectionDelegate> slf, NSURLConnection *connection);
    
    NSURLConnectionDidFinishLoadingBlock undefinedBlock = ^(id <NSURLConnectionDelegate> slf, NSURLConnection *connection) {
        [[swizzOnNSURLConnection defaultInstance] connectionDidFinishLoading:connection];
    };
    
    NSURLConnectionDidFinishLoadingBlock implementationBlock = ^(id <NSURLConnectionDelegate> slf, NSURLConnection *connection) {
        undefinedBlock(slf, connection);
        ((void(*)(id, SEL, id))objc_msgSend)(slf, swizzledSelector, connection);
    };
    
    [self replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription implementationBlock:implementationBlock undefinedBlock:undefinedBlock];
}

+ (void)injectDidFailWithErrorIntoDelegateClass:(Class)cls;
{
    SEL selector = @selector(connection:didFailWithError:);
    SEL swizzledSelector = [self swizzledSelectorForSelector:selector];
    
    Protocol *protocol = @protocol(NSURLConnectionDelegate);
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    
    typedef void (^NSURLConnectionDidFailWithErrorBlock)(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSError *error);
    
    NSURLConnectionDidFailWithErrorBlock undefinedBlock = ^(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSError *error) {
        [[swizzOnNSURLConnection defaultInstance] connection:connection didFailWithError:error];
    };
    
    NSURLConnectionDidFailWithErrorBlock implementationBlock = ^(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSError *error) {
        undefinedBlock(slf, connection, error);
        ((void(*)(id, SEL, id, id))objc_msgSend)(slf, swizzledSelector, connection, error);
    };
    
    [self replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription implementationBlock:implementationBlock undefinedBlock:undefinedBlock];
}

#pragma mark - Initialization

- (id)init;
{
    self = [super init];
    if (!self) {
        return nil;
    }

    _connectionStates = [[NSMutableDictionary alloc] init];
    _responseCache = [[NSCache alloc] init];
    _queue = dispatch_queue_create("com.squareup.ponydebugger.swizzOnNSURLConnection", DISPATCH_QUEUE_SERIAL);
    
    return self;
}

#pragma mark - Private Methods

- (void)setResponse:(NSData *)responseBody forRequestID:(NSString *)requestID response:(NSURLResponse *)response request:(NSURLRequest *)request;
{
//    id<PDPrettyStringPrinting> prettyStringPrinter = [swizzOnNSURLConnection prettyStringPrinterForResponse:response withRequest:request];

    NSString *encodedBody;
    BOOL isBinary;
//    if (!prettyStringPrinter) {
        encodedBody = responseBody.base64Encoding;
        isBinary = YES;
//    } else {
//        encodedBody = [prettyStringPrinter prettyStringForData:responseBody forResponse:response request:request];
//        isBinary = NO;
//    }

    NSDictionary *responseDict = [NSDictionary dictionaryWithObjectsAndKeys:
        encodedBody, @"body",
        [NSNumber numberWithBool:isBinary], @"base64Encoded",
        nil];

    [_responseCache setObject:responseDict forKey:requestID cost:[responseBody length]];
}

- (_PDRequestState *)requestStateForConnection:(NSURLConnection *)connection;
{
    NSValue *key = [NSValue valueWithNonretainedObject:connection];
    _PDRequestState *state = [_connectionStates objectForKey:key];
    if (!state) {
        state = [[_PDRequestState alloc] init];
        state.requestID = [[self class] nextRequestID];
        [_connectionStates setObject:state forKey:key];
    }

    return state;
}

- (NSString *)requestIDForConnection:(NSURLConnection *)connection;
{
    return [self requestStateForConnection:connection].requestID;
}

- (void)setResponse:(NSURLResponse *)response forConnection:(NSURLConnection *)connection;
{
    [self requestStateForConnection:connection].response = response;
}

- (NSURLResponse *)responseForConnection:(NSURLConnection *)connection;
{
    return [self requestStateForConnection:connection].response;
}

- (void)setRequest:(NSURLRequest *)request forConnection:(NSURLConnection *)connection;
{
    [self requestStateForConnection:connection].request = request;
}

- (NSURLRequest *)requestForConnection:(NSURLConnection *)connection;
{
    return [self requestStateForConnection:connection].request;
}

- (void)setAccumulatedData:(NSMutableData *)data forConnection:(NSURLConnection *)connection;
{
    _PDRequestState *requestState = [self requestStateForConnection:connection];
    requestState.dataAccumulator = data;
}

- (void)addAccumulatedData:(NSData *)data forConnection:(NSURLConnection *)connection;
{
    if ([self requestStateForConnection:connection].dataAccumulator==nil) {
        [self requestStateForConnection:connection].dataAccumulator = [NSMutableData new];
    }
    
    NSMutableData *dataAccumulator = [self requestStateForConnection:connection].dataAccumulator;
    
    [dataAccumulator appendData:data];
}

- (NSData *)accumulatedDataForConnection:(NSURLConnection *)connection;
{
    return [self requestStateForConnection:connection].dataAccumulator;
}

// This removes storing the accumulated request/response from the dictionary so we can release connection
- (void)connectionFinished:(NSURLConnection *)connection;
{
    NSValue *key = [NSValue valueWithNonretainedObject:connection];
    [_connectionStates removeObjectForKey:key];
}

- (void)performBlock:(dispatch_block_t)block;
{
    dispatch_async(_queue, block);
}

@end

@implementation swizzOnNSURLConnection (NSURLConnectionHelpers)

//- (void)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response;
//{
//    [self performBlock:^{
//        [self setRequest:request forConnection:connection];
//        PDNetworkRequest *networkRequest = [PDNetworkRequest networkRequestWithURLRequest:request];
//        PDNetworkResponse *networkRedirectResponse = response ? [[PDNetworkResponse alloc] initWithURLResponse:response request:request] : nil;
//        
//        [self.domain requestWillBeSentWithRequestId:[self requestIDForConnection:connection]
//                                            frameId:@""
//                                           loaderId:@""
//                                        documentURL:[request.URL absoluteString]
//                                            request:networkRequest
//                                          timestamp:[NSDate PD_timestamp]
//                                          initiator:nil
//                                   redirectResponse:networkRedirectResponse];
//    }];
//}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
{
    [self performBlock:^{
        
        if ([response respondsToSelector:@selector(copyWithZone:)]) {
            
//            NSURLRequest *request = [self requestForConnection:connection];
         
            
            [self setResponse:response forConnection:connection];
            
            NSMutableData *dataAccumulator = nil;
            if (response.expectedContentLength < 0) {
                dataAccumulator = [[NSMutableData alloc] init];
            } else {
                dataAccumulator = [[NSMutableData alloc] initWithCapacity:(NSUInteger)response.expectedContentLength];
            }
            
            [self setAccumulatedData:dataAccumulator forConnection:connection];
            
//            NSString *requestID = [self requestIDForConnection:connection];
        }
        
    }];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
{
    // Just to be safe since we're doing this async
    data = [data copy];
    [self performBlock:^{
        [self addAccumulatedData:data forConnection:connection];
        
        if ([self accumulatedDataForConnection:connection] == nil) return;
       
    }];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
{
    [self performBlock:^{
        
        if (![innerConsole sharedConsole].globalTrackUrl) {
            //don't output anything about urlActionInfo
            return ;
        }
        
        NSURLResponse *response = [self responseForConnection:connection];
//        NSString *requestID = [self requestIDForConnection:connection];
//
        NSData *accumulatedData = [self accumulatedDataForConnection:connection];
        
        //===过滤不输出内容
        if ([response.MIMEType isEqualToString:@"image/*"]||
            [response.MIMEType isEqualToString:@"image/png"]||
            [response.MIMEType isEqualToString:@"image/jpeg"]||
            [response.MIMEType isEqualToString:@"image/jpg"]||
            [response.MIMEType isEqualToString:@"image/gif"]) {
            
            //==filter this type
            return ;
        }
        
//====requestLaunch
        if (connection.currentRequest.HTTPBody!=nil) {
            id objBody = [NSJSONSerialization JSONObjectWithData:connection.currentRequest.HTTPBody
                                                         options:0
                                                           error:nil];
            
            DebugLog_Ver2(@"\n==RequestInfo==\n Verb:%@;\n URL:%@;\n HeaderFields:%@;\n HTTPBody:%@",connection.currentRequest.HTTPMethod,connection.currentRequest.URL,connection.currentRequest.allHTTPHeaderFields,objBody);
        }
        else
        {
         DebugLog_Ver2(@"\n==RequestInfo==\n Verb:%@;\n URL:%@;\n HeaderFields:%@;\n ",connection.currentRequest.HTTPMethod,connection.currentRequest.URL,connection.currentRequest.allHTTPHeaderFields);
        }

//====receiveReponse

        if (response!=nil) {
            DebugLog_Ver2(@"\n==receiveReponse headerData==\n %@;",response);
        }
        
        if ([accumulatedData  length]> 0) {
            DebugLog_Ver2(@"\n==receiveReponse bodyData==\n %@;",[NSJSONSerialization JSONObjectWithData:accumulatedData
                                                                                  options:0
                                                                                    error:nil]);
        }
     
    }];
}

//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
//{
//    [self performBlock:^{
//        [self.domain loadingFailedWithRequestId:[self requestIDForConnection:connection]
//                                      timestamp:[NSDate PD_timestamp]
//                                      errorText:[error localizedDescription]
//                                       canceled:[NSNumber numberWithBool:NO]];
//        
//        [self connectionFinished:connection];
//    }];
//    
//}

@end



@implementation _PDRequestState

@synthesize request = _request;
@synthesize response = _response;
@synthesize requestID = _requestID;
@synthesize dataAccumulator = _dataAccumulator;

@end
