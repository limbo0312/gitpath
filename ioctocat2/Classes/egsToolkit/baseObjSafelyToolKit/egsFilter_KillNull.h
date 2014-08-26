//
//  egsFilter_KillNull.h
//  footballData
//
//  Created by EGS on 14-5-26.
//  Copyright (c) 2014年 www.kantai.co. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface egsFilter_KillNull : NSObject

+ (id)emptyObjectFilter:(id)object;
+ (void)setObject:(id)anObject forKey:(NSString *)aKey toDictionary:(NSMutableDictionary **)dict;
+ (void)addObject:(id)anObject toArray:(NSMutableArray **)array;

@end
