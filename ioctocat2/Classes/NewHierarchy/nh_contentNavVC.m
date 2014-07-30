//
//  nh_contentNavVC.m
//  footballData
//
//  Created by EGS on 14-6-12.
//  Copyright (c) 2014年 www.kantai.co. All rights reserved.
//

#import "nh_contentNavVC.h"
#import "nh_baseViewController.h"

@interface nh_contentNavVC ()

@end

@implementation nh_contentNavVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationBar.tintColor = COLOR(74 , 77 , 105, 1);

}

-(void)viewWillAppear:(BOOL)animated
{
    // ======关键 leftBtn menu
    [super viewWillAppear:YES];
    
    [self makeLeftMenuBtn];
}
- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:YES];
    
    TREE_View(self.view);
    
    
    
//    for (id ViewObj in [self.view subviews]) {
//        
//        if ([[[ViewObj class] description] isEqualToString:@"UINavigationItemView"]) {
//            
//            for (UIView *v_X in [ViewObj subviews]) {
//                
//                if ([v_X isKindOfClass:[UILabel class]]) {
//                    
//                    v_X.backgroundColor = COLOR(74, 77, 105, 1);
//                }
//            }
//        }
//    }
    
    
    UIView * xNavigationBar = [[self.view subviews] objectAtIndexSavely:1];//UINavigationBar
    
    UIView * xItemView = [[xNavigationBar subviews] objectAtIndexSavely:1];//UINavigationItemView
    
    UILabel *xLabl = [[xItemView subviews] objectAtIndexSavely:0];
    
    if ([xLabl isKindOfClass:[UILabel class]]) {
        xLabl.textColor = COLOR(74, 77, 105, 1);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//== 生成 菜单按钮
-(void)makeLeftMenuBtn
{
    [(UIViewController *)self.viewControllers[0] navigationItem].leftBarButtonItem = self.toggleBarButtonItem;
}

#pragma mark Toggle Button

+ (UIImage *)menuButtonImage {
	static UIImage *menuButtonImage = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(20.f, 13.f), NO, 0.0f);
		
		[[UIColor blackColor] setFill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 20, 1)] fill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(0, 5, 20, 1)] fill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(0, 10, 20, 1)] fill];
		
		[[UIColor whiteColor] setFill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(0, 1, 20, 2)] fill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(0, 6,  20, 2)] fill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(0, 11, 20, 2)] fill];
		
		menuButtonImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
	});
    return menuButtonImage;
}

//=== menu btn ...
- (UIBarButtonItem *)toggleBarButtonItem {
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:self.class.menuButtonImage
                                                             style:UIBarButtonItemStyleBordered
                                                            target:self
                                                            action:@selector(toggleLeftMenu)];
    
    item.accessibilityLabel = NSLocalizedString(@"Menu", nil);
    item.accessibilityHint = NSLocalizedString(@"Double-tap to reveal menu on the left. If you need to close the menu without choosing its item, find the menu button in top-right corner (slightly to the left) and double-tap it again.", nil);
    
    return item;
}

#pragma mark Menu Colors

- (UIColor *)lightBackgroundColor {
	return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone ?
    [UIColor colorWithRed:0.176 green:0.261 blue:0.401 alpha:1.000] :
    [UIColor colorWithRed:0.240 green:0.268 blue:0.297 alpha:1.000];
}

- (UIColor *)darkBackgroundColor {
	return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone ?
    [UIColor colorWithRed:0.150 green:0.220 blue:0.334 alpha:1.000] :
    [UIColor colorWithRed:0.200 green:0.223 blue:0.248 alpha:1.000];
}

- (UIColor *)highlightBackgroundColor {
	return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone ?
    [UIColor colorWithRed:0.112 green:0.167 blue:0.254 alpha:1.000] :
    [UIColor colorWithRed:0.124 green:0.139 blue:0.154 alpha:1.000];
}


#pragma mark private method
-(void)toggleLeftMenu
{
    UIViewController *isBaseVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    if ([isBaseVC isKindOfClass:[nh_baseViewController  class]]) {
        [(nh_baseViewController *)isBaseVC presentMenuViewController];
    }
}

@end
