//
//  NSMutableDictionary+safelyWay.h
//  footballData
//
//  Created by EGS on 14-5-20.
//  Copyright (c) 2014年 www.kantai.co. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (safelyWay)

//====避免set 入 nil
-(void)setObjectSafely:(id)anObject forKey:(id<NSCopying>)aKey;
@end
