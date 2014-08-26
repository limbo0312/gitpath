//
//  NSMutableArray+objectSavely.h
//  footballData
//
//  Created by EGS on 14-6-13.
//  Copyright (c) 2014年 www.kantai.co. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (objectSavely)

-(void)addObjectSafely:(id)anObject;

-(void)insertObjectSafely:(id)anObject atIndex:(NSUInteger)index;
@end
