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

//==pie chart
#import "customPieView.h"
#import "xPieElement.h"

@interface innerDashboardVC ()

@property (nonatomic,strong)IBOutlet customPieView *pieView;
@end

@implementation innerDashboardVC{
    BOOL showPercent;
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
    
    //=====>init view Herarchy
    [self configureViewHerarchy];
    
    //=====判断: 如果 未登陆  则调到账号页面
    if (iOctocatDelegate.sharedInstance.currentAccount==nil) {
        
        AccountVC *accoutVC = [MainSB_New instantiateViewControllerWithIdentifier:@"AccountVC_iden"];
        
        UINavigationController *navVC_accout = [[UINavigationController alloc] initWithRootViewController:accoutVC];
        
        [self presentViewController:navVC_accout
                           animated:NO
                         completion:^{
                         
                         }];
    }
    
    
    self.title = @"Insight Your Power";
    
    //=====拉取 data on OSRC生成器
    [[visualClient shareClient] getV_visualizationDataBy:iOctocatDelegate.sharedInstance.currentAccount.login
                                                        :^(BOOL succ) {
                                                            
                                                            if (succ) {
                                                                //===do dataGet3arr drawChart
                                                            };
                                                        }];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{

//    //====
//    [_IB_dataScrollView setContentSize:CGSizeMake(320, 370+520+520)];
//    
//    _IB_dataScrollView.scrollEnabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//==========key  method
//===生成图表   合成dataVisual
//
-(void)forceDataChart_skillInsight
{
    
    for(int year = 2009; year <= 2014; year++){
        
        xPieElement* elem = [xPieElement pieElementWithValue:(5+arc4random()%8)
                                                       color:RamFlatColor];
        
        
        elem.title = [NSString stringWithFormat:@"%d year", year];
        
        [self.pieView.layer addValues:@[elem] animated:NO];
    }
    
    //mutch easier do this with array outside
    showPercent = NO;
    self.pieView.layer.transformTitleBlock = ^(PieElement* elem, float percent){
        
        return [(xPieElement *)elem title];
    };
    
    
    self.pieView.frame = R_MAKE(0, 0, 320, 370);
    
    self.pieView.layer.showTitles = ShowTitlesAlways;
    
    [self.IB_dataScrollView addSubview:self.pieView];

}

#pragma mark -- main method
-(void)configureViewHerarchy
{
    //111===== lint skill insight  {0,0,320,370}
    {
        [self forceDataChart_skillInsight];
    }
    

    //222===== codeDesire insight  {0,370,320,560}
    {
        
        JBBarChartViewController *barChartController = [[JBBarChartViewController alloc] init];
        [self addChildViewController:barChartController];
        
        barChartController.view.frame = R_MAKE(0, 370, 320, 520);
        
        [_IB_dataScrollView addSubview:barChartController.view];
    }
    
    
    //333===== pullWill insight    {0,370+560,320,560}
    {
        
        JBLineChartViewController *lineChartController = [[JBLineChartViewController alloc] init];
        [self addChildViewController:lineChartController];
        
        lineChartController.view.frame = R_MAKE(0, 370+520, 320, 520);
        
        [_IB_dataScrollView addSubview:lineChartController.view];
    }
    
    
    [_IB_dataScrollView setFrame:R_MAKE(0, 0, 320, self.view.height)];
    
    [_IB_dataScrollView setContentSize:CGSizeMake(320, 370+520+520)];
    
    _IB_dataScrollView.frame =R_MAKE(0, 64, 320, self.view.height-64);
}



@end
