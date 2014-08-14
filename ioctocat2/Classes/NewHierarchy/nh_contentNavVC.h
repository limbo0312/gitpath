//
//  nh_contentNavVC.h
//  footballData
//
//  Created by EGS on 14-6-12.
//  Copyright (c) 2014年 www.kantai.co. All rights reserved.
//

#import <UIKit/UIKit.h>

@class innerDashboardVC;

@interface nh_contentNavVC : UINavigationController

@property (nonatomic,strong) innerDashboardVC *innerDash_fix;

//== 生成 菜单按钮
-(void)makeLeftMenuBtn;
@end
