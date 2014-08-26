//
//  NSObject+safelyOrNil.m
//  footballData
//
//  Created by EGS on 14-5-15.
//  Copyright (c) 2014年 www.kantai.co. All rights reserved.
//

#import "NSObject+safelyOrNil.h"

@implementation NSObject (safelyOrNil)


//====4  nonObj   msg arrMeghod  dicMethod
-(id)objectAtIndexSavely:(NSInteger)index
{
    DebugLog(@"==errCode:dicButAsArr==严重错误:obj 不能够msg arr的method");
    
    return nil;
}

- (id)objectForKeyOrNil:(id)key
{
    DebugLog(@"==errCode:arrButAsDic==严重错误:obj 不能够msg Dic的method");//特殊情况下，用来做判断。。。
    
    if ([self isKindOfClass:[NSUserDefaults class]]) {
        //==userDic  直接自  nsobject
        
        return [(NSUserDefaults *)self objectForKey:key];
    }
    
    return nil;
}



//====4  nonObj   msg arrMeghod
-(NSInteger)count
{
    if (![self isKindOfClass:[NSArray class]]
        &&![self isKindOfClass:[NSMutableArray class]]) {
        
        DebugLog(@"==errCode:count on nonArr");
        
        return 0;
    }
    
    return 0;
}

- (id)firstObject
{
    if (![self isKindOfClass:[NSArray class]]
        &&![self isKindOfClass:[NSMutableArray class]]) {
        
        DebugLog(@"==errCode:count on nonArr");
        
        return nil;
    }
    return nil;
}

- (id)lastObject
{
    if (![self isKindOfClass:[NSArray class]]
        &&![self isKindOfClass:[NSMutableArray class]]) {
        
        DebugLog(@"==errCode:count on nonArr");
        
        return nil;
    }
    return nil;
}

- (id)removeAllObjects
{
    if (![self isKindOfClass:[NSMutableArray class]]) {
        
        DebugLog(@"==errCode:count on nonArr");
        
        return nil;
    }
    return nil;
}

-(NSArray *)subviews
{
    return nil;
}
@end
