//
//  baseViewController.m
//  footballData
//
//  Created by EGS on 14-5-19.
//  Copyright (c) 2014年 www.kantai.co. All rights reserved.
//

#import "nh_baseViewController.h"

@interface nh_baseViewController ()

@end

@implementation nh_baseViewController

- (void)awakeFromNib
{
 
    self.limitMenuViewSize = YES;
    
    self.contentViewController = [MainSB_New instantiateViewControllerWithIdentifier:@"contentController_fake4indeti"];
    
    self.menuViewController = [MainSB_New instantiateViewControllerWithIdentifier:@"nh_menuViewController"];
    
    [self setMenuViewSize:CGSizeMake(250, iheight_screen)];
    
    
    
}
 
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];


    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    
//    DebugLog(@"baseVC will appear");
    
//    TREE_View(self.view);
    

}
-(void)viewDidAppear:(BOOL)animated
{
    //safeType imp innerConsole
#ifdef DEBUG
//    if (![[UIApplication sharedApplication].keyWindow isKindOfClass:[iConsoleWindow class]]) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"safeInnerConsoleIMP"
//                                                            object:nil];
//    }
    
#endif
}

#pragma mark -
#pragma mark Gesture recognizer

 

@end
