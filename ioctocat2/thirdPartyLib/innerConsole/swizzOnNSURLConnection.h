//
//  PDAFNetworkDomainController.h
//  PonyDebugger
//
//  Created by Mike Lewis on 2/27/12.
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

//#import "PDDomainController.h"
//#import "PDNetworkTypes.h"
//#import "PDNetworkDomain.h"


#ifdef DEBUG
//#   define DebugLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define DebugLog(...)///[innerConsole log:(@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__];  //iconsole式移除：ver1 notWorking  (...)///
#define DebugLog_Ver2(fmt, ...) [innerConsole log:(@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__];

#else
#   define DebugLog(...)
#   define DebugLog_Ver2(...)
#endif

@interface swizzOnNSURLConnection : NSObject //<PDNetworkCommandDelegate>

//@property (nonatomic, strong) PDNetworkDomain *domain;

+ (swizzOnNSURLConnection *)defaultInstance;
+ (void)injectIntoAllNSURLConnectionDelegateClasses;
+ (void)injectIntoDelegateClass:(Class)cls;

//+ (void)registerPrettyStringPrinter:(id<PDPrettyStringPrinting>)prettyStringPrinter;
//+ (void)unregisterPrettyStringPrinter:(id<PDPrettyStringPrinting>)prettyStringPrinter;

@end


@interface swizzOnNSURLConnection (NSURLConnectionHelpers)

- (void)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;

- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;

@end


 

@interface NSURLResponse (PDNetworkHelpers)

- (NSString *)PD_responseType;

@end
