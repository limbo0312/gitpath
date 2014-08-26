//
//  NSMutableArray+objectSavely.h
//  crazyBall
//
//  Created by EGS on 14-1-14.
//  Copyright (c) 2014年 EGS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (objectSavely)

-(id)objectAtIndexSavely:(NSInteger)index;

//=======避免 id msgSend 严重错误
- (id)objectForKeyOrNil:(id)key;
@end
