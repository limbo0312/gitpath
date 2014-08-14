//
//  NSObject+targetTypeValue.m
//  crazyBall
//
//  Created by EGS on 13-12-21.
//  Copyright (c) 2013年 EGS. All rights reserved.
//

#import "NSObject+targetTypeValue.h"

@implementation NSObject (targetTypeValue)

-(NSInteger)targetIntValue
{
    if ([self isKindOfClass:[NSNull class]]) {
        return NullDataType;
    }
    
    if ([self isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)self integerValue];
    }
    
    if ([self isKindOfClass:[NSString class]]) {
        return  [(NSString *)self intValue];
    }
    
    
    return 0;
}

-(BOOL)targetBoolValue
{
    if ([self isKindOfClass:[NSNull class]]) {
        return NO;
    }
    
    if ([self isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)self boolValue];
    }
    return YES;
}

-(float)targetFloatValue
{
    if ([self isKindOfClass:[NSNull class]]) {
        return NullDataType;
    }
    
    if ([self isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)self floatValue];
    }
    
    if ([self isKindOfClass:[NSString class]]) {
        return  [(NSString *)self floatValue];
    }
    
    
    return 0;
}

@end
