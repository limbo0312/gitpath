//
//  nh_mainRouteTabVC.m
//  footballData
//
//  Created by EGS on 14-6-12.
//  Copyright (c) 2014年 www.kantai.co. All rights reserved.
//

#import "nh_mainRouteTabVC.h"
#import "REFrostedViewController.h"

@interface nh_mainRouteTabVC ()

@end

@implementation nh_mainRouteTabVC

 

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    //===left navbarItem menu
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,0,44,44)];
    [button setBackgroundImage:[UIImage imageNamed:@"topbar_left_ic_myteam_default"] forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(showMenu)
     forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btn;
    
    //===试一试  模糊着色
    self.tabBar.barTintColor = COLOR(124, 159, 20, 1);
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 
- (IBAction)showMenu
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    
    [self.frostedViewController presentMenuViewController];
    
}


@end
