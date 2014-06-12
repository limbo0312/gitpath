//
//  UIViewController+ios7match.m
//  crazyBall
//
//  Created by EGS on 13-11-8.
//  Copyright (c) 2013年 EGS. All rights reserved.
//

#import "UIViewController+ios7match.h"

@implementation UIViewController (ios7match)

-(void)matching_iOS7_tableviewType
{
    if (isIOS7_OR_LATER)
    { 
#if __IPHONE_7_0// __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        if (isIOS7_OR_LATER) {
            self.automaticallyAdjustsScrollViewInsets = NO;
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
#endif
        
    }
    
    if (isIOS7_OR_LATER&&isSCREEN_5inchTYPE)
    {    
        self.view.frame = CGRectMake(0, yValue_ios7, 320, SCREEN_HEIGHT-yValue_ios7/*-20*/);
        
        for (UIView * viewSub in [self.view subviews])
        {
            if ([viewSub isKindOfClass:[UITableView class]])
            {
                viewSub.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);;
                
//                DebugLogFrame(viewSub.frame);
            }
        }
    }
    else if (isIOS7_OR_LATER&&!isSCREEN_5inchTYPE)
    {
//fixMe:  这里的20个像素有点诡异，暂未琢磨透，其作用效果好像会改变。非常费解！！！！
        self.view.frame = CGRectMake(0, yValue_ios7, 320, SCREEN_HEIGHT-yValue_ios7/*-20*/);
        
        for (UIView * viewSub in [self.view subviews])
        {
            if ([viewSub isKindOfClass:[UITableView class]])
            {
                viewSub.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);;
                
            }
        }
    }
}


-(void)matching_iOS7_viewType
{
    if (isIOS7_OR_LATER) {
        
#if __IPHONE_7_0// __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        if (isIOS7_OR_LATER) {
            self.automaticallyAdjustsScrollViewInsets = NO;
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
#endif
        
        
    }
    
    if (isIOS7_OR_LATER&&isSCREEN_5inchTYPE)
    {
        self.view.frame = CGRectMake(0, yValue_ios7, 320, SCREEN_HEIGHT-yValue_ios7-20);
    }
    else if (isIOS7_OR_LATER&&!isSCREEN_5inchTYPE)
    {
        self.view.frame = CGRectMake(0, yValue_ios7, 320, SCREEN_HEIGHT-yValue_ios7-17);
    }
     
}
@end
