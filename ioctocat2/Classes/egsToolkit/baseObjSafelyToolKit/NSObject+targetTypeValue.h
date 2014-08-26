//
//  NSObject+targetTypeValue.h
//  crazyBall
//
//  Created by EGS on 13-12-21.
//  Copyright (c) 2013年 EGS. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NullDataType   42424242

/**
 *  针对dic中出现NSNull，而直接intValue(typeValue),造成的错误；
 */
@interface NSObject (targetTypeValue)

-(NSInteger)targetIntValue;

-(BOOL)targetBoolValue;

-(float)targetFloatValue;
@end
