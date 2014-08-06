//
//  innerDashboardVC.m
//  iOctocat
//
//  Created by Engels on 14-7-27.
//
//

#import "innerDashboardVC.h"
#import "AccountVC.h"

#import "iOctocatDelegate.h"

#import "visualClient.h"
#import "GHAccount.h"

@interface innerDashboardVC ()

@end

@implementation innerDashboardVC

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
    
    
    //=====判断: 如果 未登陆  则调到账号页面
    if (iOctocatDelegate.sharedInstance.currentAccount==nil) {
        
        AccountVC *accoutVC = [MainSB_New instantiateViewControllerWithIdentifier:@"AccountVC_iden"];
        
        UINavigationController *navVC_accout = [[UINavigationController alloc] initWithRootViewController:accoutVC];
        
        [self presentViewController:navVC_accout
                           animated:NO
                         completion:^{ }];
    }
    
    
    self.title = @"Insight Your Power";
    
    
}

-(void)viewWillAppear:(BOOL)animated
{

    [[visualClient shareClient] getV_visualizationDataBy:iOctocatDelegate.sharedInstance.currentAccount.login
                                                        :^(BOOL succ, id responseO) {
                                                            
                                                            DebugLog(@"%@",responseO);
                                                        }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
