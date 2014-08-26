//
//  NSMutableDictionary+safelyWay.m
//  footballData
//
//  Created by EGS on 14-5-20.
//  Copyright (c) 2014年 www.kantai.co. All rights reserved.
//

#import "NSMutableDictionary+safelyWay.h"

@implementation NSMutableDictionary (safelyWay)


//====避免set 入 nil
-(void)setObjectSafely:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (anObject==nil) {
        DebugLog(@"严重错误:不可以set nil obj");
        
        return;
    }
    else
    {
        [self setObject:anObject forKey:aKey];
    }

}

@end
