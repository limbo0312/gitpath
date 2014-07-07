//
//  UIDevice+MemoryInfo.h
//  crazyBall
//
//  Created by EGS on 14-1-14.
//  Copyright (c) 2014年 EGS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (MemoryInfo)

// 获取当前设备可用内存(单位：MB）
- (double)availableMemory;
// 获取当前任务所占用的内存（单位：MB）
- (double)usedMemory;
@end
