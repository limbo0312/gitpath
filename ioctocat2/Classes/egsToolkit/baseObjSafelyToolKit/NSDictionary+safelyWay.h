//
//  NSDictionary+ObjectForKeyOrNil.h
//  crazyBall
//
//  Created by EGS on 13-11-25.
//  Copyright (c) 2013年 EGS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (safelyWay)

- (id)objectForKeyOrNil:(id)key;

- (NSMutableDictionary *)filterNullKey;


//=======避免 id msgSend 严重错误(4 dic)
-(id)objectAtIndexSavely:(NSInteger)index;

 
@end
