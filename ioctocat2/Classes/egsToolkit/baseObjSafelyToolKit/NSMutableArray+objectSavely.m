//
//  NSMutableArray+objectSavely.m
//  footballData
//
//  Created by EGS on 14-6-13.
//  Copyright (c) 2014年 www.kantai.co. All rights reserved.
//

#import "NSMutableArray+objectSavely.h"

@implementation NSMutableArray (objectSavely)

-(void)addObjectSafely:(id)anObject
{
    if (anObject!=nil) {
        [self addObject:anObject];
    }
    else
    {
        DebugLog(@"不能够添加nil");
    }


}

-(void)insertObjectSafely:(id)anObject atIndex:(NSUInteger)index
{
    if (anObject!=nil
        &&index <= [self count]) {
        
        [self insertObject:anObject atIndex:index];
    }
    else
    {
        DebugLog(@"不能够添加nil");
    }
    
}


@end
