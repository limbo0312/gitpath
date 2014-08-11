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

#import "cellOfDash.h"

//==jbCart
#import "JBBarChartViewController.h"
#import "JBLineChartViewController.h"

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
    
    //=====>init view Herarchy
    
    [self configureViewHerarchy];
    
}

-(void)viewWillAppear:(BOOL)animated
{

    [[visualClient shareClient] getV_visualizationDataBy:iOctocatDelegate.sharedInstance.currentAccount.login
                                                        :^(BOOL succ) {
                                                            
                                                            if (succ) {
                                                                //===do dataGet3arr drawChart
                                                            };
                                                        }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- main method
-(void)configureViewHerarchy
{
    //111===== lint skill insight  {0,0,320,370}
    {
        cellOfDash *cell;
        
        cell = [cellOfDash xibCell];
        
        [cell forceDataChart_skillInsight];
        
        [_IB_dataScrollView addSubview:cell];
    }
    


    //222===== codeDesire insight  {0,370,320,560}
    {
        
        JBBarChartViewController *barChartController = [[JBBarChartViewController alloc] init];
        [self addChildViewController:barChartController];
        
        barChartController.view.frame = R_MAKE(0, 370, 320, barChartController.view.bounds.size.height);
        
        [_IB_dataScrollView addSubview:barChartController.view];
    }
    
    
    //333===== pullWill insight    {0,370+560,320,560}
    {
        
        JBLineChartViewController *lineChartController = [[JBLineChartViewController alloc] init];
        [self addChildViewController:lineChartController];
        
        lineChartController.view.frame = R_MAKE(0, 370+520, 320, lineChartController.view.bounds.size.height);
        
        [_IB_dataScrollView addSubview:lineChartController.view];
    }
    
    
    [_IB_dataScrollView setFrame:R_MAKE(0, 0, 320, self.view.height)];
    
    [_IB_dataScrollView setContentSize:CGSizeMake(320, 370+520+520)];
}

#pragma mark - Table  old


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     cellOfDash *cell ;
     
     if (indexPath.row==0) {
         
         cell = (cellOfDash *)[tableView dequeueReusableCellWithIdentifier:@"cellOfDash00"];
         
         if (!cell) {
             cell = [cellOfDash xibCell];
         }
         
         //==call & visual data00
         [cell forceDataChart_skillInsight];
     }
     else if (indexPath.row==1)
     {
         
         cell = (cellOfDash *)[tableView dequeueReusableCellWithIdentifier:@"cellOfDash01"];
         
         if (!cell) {
             
         }
         
         
     }
     else if (indexPath.row==2)
     {
         
         cell = (cellOfDash *)[tableView dequeueReusableCellWithIdentifier:@"cellOfDash02"];
         
         if (!cell) {
             
             JBLineChartViewController *lineChartController = [[JBLineChartViewController alloc] init];
             
             cell = [cellOfDash xibCell_3pos];
             
             [cell addSubview:lineChartController.view];
             cell.frame = lineChartController.view.bounds;
         }
         
         
     }
     
 
 // Configure the cell...
 
     return cell;
 }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.height;
}

@end
