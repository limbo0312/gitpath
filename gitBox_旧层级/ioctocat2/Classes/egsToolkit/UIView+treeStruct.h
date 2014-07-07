//
//  UIView+treeStruct.h
//  testNav
//
//  Created by Engels on 13-11-7.
//  Copyright (c) 2013年 smartscreen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (treeStruct)

+ (NSString *)treeViewStruct:(UIView *)view;

+ (UIView *)treeViewGet:(id)viewType
                       :(UIView *)fatView;

@end
