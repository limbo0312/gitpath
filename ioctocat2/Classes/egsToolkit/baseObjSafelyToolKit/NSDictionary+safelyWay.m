//
//  NSDictionary+ObjectForKeyOrNil.m
//  crazyBall
//
//  Created by EGS on 13-11-25.
//  Copyright (c) 2013年 EGS. All rights reserved.
//

#import "NSDictionary+safelyWay.h"

@implementation NSDictionary (safelyWay)


- (id)objectForKeyOrNil:(id)key {
    
    if ([self isKindOfClass:[NSDictionary class]]
        ||[self isKindOfClass:[NSMutableDictionary class]]) {
        
        id val = [self objectForKey:key];
        
        if ([val isEqual:[NSNull null]]) {
            return nil;
        }
        
        return val;
    }
    else
    {
        DebugLog(@"err on this ");
        return nil;
    }
    
    
    return  nil;
}


- (NSMutableDictionary *)filterNullKey
{
    if ([self isKindOfClass:[NSDictionary class]]
        ||[self isKindOfClass:[NSMutableDictionary class]]) {
        
        NSArray *arrKey = [self allKeys];
        
        NSMutableDictionary *mDic = [[NSMutableDictionary alloc] initWithDictionary:self];
        
        for (NSString *strKey in arrKey) {
            id val = [self objectForKey:strKey];
            
            if ([val isEqual:[NSNull null]]) {
                [mDic removeObjectForKey:strKey];
            }
            
            //====递归 内部
            // todo ...  使用专用过滤器  egsFilter_KillNull
            
        }
        
        return mDic;
    }
    else
    {
        DebugLog(@"err on this ");
        return  nil;
    }
    
    return nil;
}

-(id)objectAtIndexSavely:(NSInteger)index
{
    DebugLog(@"==errCode:dicButAsArr==严重错误:dic 不能够msg arr的method");
    
    return nil;
}
@end
