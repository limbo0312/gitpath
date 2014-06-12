//
//  NSObject+safelyOrNil.h
//  footballData
//
//  Created by EGS on 14-5-15.
//  Copyright (c) 2014年 www.kantai.co. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (safelyOrNil)


//-(id)objectAtIndexSavely:(NSInteger)index;
//
- (id)objectForKeyOrNil:(id)key;

//-(NSInteger)count;
//- (id)firstObject;
//- (id)lastObject;
//- (id)removeAllObjects;
//
//-(NSArray *)subviews;
@end
