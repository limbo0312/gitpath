//
//  nh_menuViewController.h
//  footballData
//
//  Created by EGS on 14-6-12.
//  Copyright (c) 2014年 www.kantai.co. All rights reserved.
//

#import <UIKit/UIKit.h>



@class GHUser;

@interface nh_menuViewController : UIViewController

@property(nonatomic,strong)IBOutlet UIView *footerView;
@property(nonatomic,weak)IBOutlet UILabel *versionLabel;





@property(nonatomic,weak)IBOutlet UITableView *tableView;

@property(nonatomic,strong)UIViewController *initialViewController;

@property (weak, nonatomic) IBOutlet UIView *IB_headerView;

@property (weak, nonatomic) IBOutlet UIView *IB_catBgColor;//=== 技巧式  变色 bgView Color
@property (weak, nonatomic) IBOutlet UILabel *IB_visualThisGuy;//=== name lbl
@property (weak, nonatomic) IBOutlet UIImageView *IB_realAvarImg;


- (id)initWithUser:(GHUser *)user;
- (BOOL)openViewControllerForGitHubURL:(NSURL *)url;
- (void)openNotificationsController;
- (void)openNotificationControllerWithId:(NSInteger)notificationId url:(NSURL *)itemURL;

//==== new type 4 dataObj User
-(void)setupUserObj_info:(GHUser *)user;

- (IBAction)openInsightPower:(id)sender;


@end