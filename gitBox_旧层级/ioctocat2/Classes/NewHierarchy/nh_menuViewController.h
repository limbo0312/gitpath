//
//  nh_menuViewController.h
//  footballData
//
//  Created by EGS on 14-6-12.
//  Copyright (c) 2014年 www.kantai.co. All rights reserved.
//

#import <UIKit/UIKit.h>



@class GHUser;

@interface nh_menuViewController : UITableViewController

@property(nonatomic,strong)IBOutlet UIView *footerView;
@property(nonatomic,weak)IBOutlet UILabel *versionLabel;

@property(nonatomic,strong)UIViewController *initialViewController;

- (id)initWithUser:(GHUser *)user;
- (BOOL)openViewControllerForGitHubURL:(NSURL *)url;
- (void)openNotificationsController;
- (void)openNotificationControllerWithId:(NSInteger)notificationId url:(NSURL *)itemURL;


@end