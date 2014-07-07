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

//    DebugLog(@"弃用  awakeFromNib这类 mMethod");
    
    self.limitMenuViewSize = YES;
    
    self.contentViewController = [MainSB_New instantiateViewControllerWithIdentifier:@"contentController_fake4indeti"];
    
    self.menuViewController = [MainSB_New instantiateViewControllerWithIdentifier:@"nh_menuController"];
    [self setMenuViewSize:CGSizeMake(250, iheight_screen)];
    
    
#warning TODO: 这里存在logic bug
    
    //    [self launchtImage];
   
}



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


#pragma mark - Animation
-(void)launchtImage{
    self.bView=[[UIImageView alloc]initWithFrame:self.view.frame];
    self.bView.image=[UIImage imageNamed:@"Default-568h@2x.png"];
    
    UIImageView *maskView=[[UIImageView alloc]initWithFrame:CGRectMake(80.0f, 125.0f, 160.0f, 140.0f)];
    maskView.image=[UIImage imageNamed:@"defaul_mask@2x.jpg"];
    [self.bView addSubview:maskView];
    
    
    [self.view addSubview:self.bView];
    
    [[APIClient_saidian shareClient]getV_LaunchImage:^(BOOL bol, id responseObj) {
        if (!bol) {
            self.bView.hidden=YES;
            return ;
        }
        NSString *stringURL=(NSString *)responseObj;
        self.mView=[[UIImageView alloc]initWithFrame:self.view.frame];
        self.mView.alpha=0.1f;
        [self.mView cacheM_setImageWithURL:[NSURL URLWithString:stringURL] placeholderImage:nil];
        
        [self.view addSubview:self.mView];
        
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        //animation.duration = 0.7 ;  // 动画持续时间(秒)
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionFade;//淡入淡出效果
        
        [[self.mView layer] addAnimation:animation forKey:@"animation"];
        
        
        [UIView animateWithDuration:1.5
                         animations:^{
                             [self.mView setAlpha:1.0f];
                           
                         }
                         completion:^(BOOL finished){
                             self.bView.hidden=YES;
                         }];
        [self performSelector:@selector(FadeOut) withObject:nil afterDelay:1.5];
    }];
    
    
    
    
    
}

- (void)FadeOut {
    
    [UIView animateWithDuration:1.5
                     animations:^{
                         self.mView.frame = CGRectMake(0-iwidth_screen*0.5,
                                                       0-iheight_screen*0.5,
                                                       iwidth_screen*2,
                                                       iheight_screen*2);
                         [self.mView setAlpha:0];
                     }
     
                     completion:^(BOOL finished){
                         self.mView.hidden=YES;
                         
                     }];
    
}


@end
