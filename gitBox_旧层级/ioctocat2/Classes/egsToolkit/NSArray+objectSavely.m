//
//  NSMutableArray+objectSavely.m
//  crazyBall
//
//  Created by EGS on 14-1-14.
//  Copyright (c) 2014年 EGS. All rights reserved.
//

#import "NSArray+objectSavely.h"

@implementation NSArray (objectSavely)

-(id)objectAtIndexSavely:(NSInteger)index
{
    if (![self isKindOfClass:[NSArray class]]
        &&![self isKindOfClass:[NSMutableArray class]]) {
        DebugLog(@"严重错误");
        return nil;
    }
    
    if ([self count]==0) {
        return nil;
    }

    else if ([self count] > index) {
        return [self objectAtIndex:index];
    }
    else{
 
        DebugLog(@"严重:数组越界请检查.");
        return nil;
    }

    
    return nil;
}

- (id)objectForKeyOrNil:(id)key
{
    DebugLog(@"==errCode:arrButAsDic==严重错误:arr 不能够msg Dic的method");
    
    return nil;
}


@end
