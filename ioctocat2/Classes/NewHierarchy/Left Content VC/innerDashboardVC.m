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
#import "JBAreaChartViewController.h"

//==pie chart
#import "customPieView.h"
#import "xPieElement.h"

@interface innerDashboardVC ()

@property (nonatomic,strong)IBOutlet customPieView *pieView;
@property (nonatomic,strong)NSMutableArray *mArrPieData;// lintData  合成图表的数据
@property (nonatomic,strong)NSMutableArray *mArrElementPie ;//xPieElement arrIn

//=====
@property (nonatomic,strong)JBBarChartViewController *pullWillbarChart;
@property (nonatomic,strong)JBAreaChartViewController *codeDbarChart;

//=====
@property (nonatomic,strong) UILabel * lbl_lintSkill;


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
    self.mArrPieData = [NSMutableArray new];
    self.mArrElementPie = [NSMutableArray new];
    
    //=====>init view Herarchy
//    [self configureViewHerarchy:nil];
    
    //=====判断: 如果 未登陆  则调到账号页面
    if (iOctocatDelegate.sharedInstance.currentAccount==nil) {
        
        AccountVC *accoutVC = [MainSB_New instantiateViewControllerWithIdentifier:@"AccountVC_iden"];
        
        UINavigationController *navVC_accout = [[UINavigationController alloc] initWithRootViewController:accoutVC];
        
        [self presentViewController:navVC_accout
                           animated:NO
                         completion:^{
                             
                         }];
    }
    
    
    //===右侧 按键  强制刷新
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                           target:self
                                                                                           action:@selector(refreshForce)];
    
}

-(void)viewWillAppear:(BOOL)animated
{
//    SHOW_PROGRESS(self.view);
    //=====拉取 data on OSRC生成器
    if (_isSelf)
    {
        self.title = @"Your Power Map";
        
        [[visualClient shareClient] getV_visualizationDataBy:iOctocatDelegate.sharedInstance.currentAccount.login
                                                            :NO
                                                            :NO
                                                            :^(BOOL succ, id responseObj) {
                                                                
                                                                DebugLog(@"%@",[visualClient shareClient].lint_languagesTake_arr);
                                                                DebugLog(@"%@",[visualClient shareClient].codeD_weekEvent_arr);
                                                                DebugLog(@"%@",[visualClient shareClient].push_repositories_arr);
                                                                
                                                                if (succ) {
                                                                    //===do dataGet3arr drawChart
                                                                };
                                                                
                                                                //===重新合成图表
                                                                [self configureViewHerarchy:responseObj];
                                                                
                                                                //                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                //                                                                HIDE_PROGRESS(self.view);
                                                                //                                                            });
                                                                
                                                                
                                                            }];
    }
        

    else
    {
        if ([_lint_arr count]!=0
            ||[_codeD_arr count]!=0
            ||[_push_arr count]!=0) {
            
            [self configureViewHerarchy:nil];
        }

    }

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -- main method
-(void)configureViewHerarchy:(id)responseObj
{
    if (responseObj) {
        
        self.lint_arr = [[responseObj objectForKeyOrNil:@"usage"] objectForKeyOrNil:@"languages"];
        
        self.codeD_arr = [[responseObj objectForKeyOrNil:@"usage"] objectForKeyOrNil:@"events"];
        
        self.push_arr = [responseObj objectForKeyOrNil:@"repositories"];
    }
    else
    {
        //==insight  some guyGeeker
        if (self.lint_arr==nil) {
//            return;
            //==lint 1
            
        }
    
    }
    
    
    //111===== lint skill insight  {0,0,320,370}
    {
        if ([self.lint_arr count]!=0) {
            [self forceDataChart_skillInsight:self.lint_arr];
        }
    }
    

    //222===== codeDesire insight  {0,370,320,560}
    {
        if (self.codeDbarChart==nil) {
            
            self.codeDbarChart = [[JBAreaChartViewController alloc] init];
            [self addChildViewController:self.codeDbarChart];
            
            self.codeDbarChart.view.frame = R_MAKE(0, 370, 320, 520);
            
            [_IB_dataScrollView addSubview:self.codeDbarChart.view];
        }
        
        //==data setIn
        [self.codeDbarChart setupData2codeD:self.codeD_arr];
    }
    
    
    //333===== pullWill insight    {0,370+560,320,560}
    {
        if (self.pullWillbarChart==nil) {
            
            self.pullWillbarChart = [[JBBarChartViewController alloc] init];
            [self addChildViewController:self.pullWillbarChart];
            
            self.pullWillbarChart.view.frame = R_MAKE(0, 370+520, 320, 520);
            
            [_IB_dataScrollView addSubview:self.pullWillbarChart.view];
            
        }
        
        //===data setIn
        [self.pullWillbarChart  setupData2pushCount:self.push_arr];
    }
    
    
    
    //====base setup 4 scrollView
    
    [_IB_dataScrollView setFrame:R_MAKE(0, 0, 320, self.view.height)];
    
    [_IB_dataScrollView setContentSize:CGSizeMake(320, 370+520+520)];
    
//    _IB_dataScrollView.frame =R_MAKE(0, 0, 320, self.view.height-64);
}

#pragma mark ==== 生成图表  lint skill insight
-(void)forceDataChart_skillInsight:(NSArray *)arrLint
{
    
    //111=====data setIn road ====old
    [self.mArrPieData removeAllObjects];
    
    if (arrLint==nil) {
        
        //===clear pie data
        if (self.mArrElementPie)
        [self.pieView.layer deleteValues:self.mArrElementPie
                                animated:YES];
        
        for(int year = 2009; year <= 2014; year++){
            
            xPieElement* elem = [xPieElement pieElementWithValue:(5+arc4random()%8)
                                                           color:RamFlatColor];
            
            
            elem.title = [NSString stringWithFormat:@"%@", @"lint--X"];
            
            [self.pieView.layer addValues:@[elem] animated:NO];
            
            [self.mArrElementPie addObject:elem];
        }
        
    }
    
    
    
    //222====
    if (arrLint!=nil) {
        
        //===clear pie data
        [self.pieView.layer deleteValues:self.mArrElementPie
                                animated:YES];
        
        //===计算合成。。。 lintPie pic
        [self makeLintArrData:arrLint];
        
       
        [self.mArrElementPie removeAllObjects];
        //===使用合成 后的data
        for (NSDictionary *dicX in self.mArrPieData) {
            
            xPieElement* elem = [xPieElement pieElementWithValue:[[dicX objectForKeyOrNil:@"percent"] targetFloatValue]
                                                           color:RamFlatColor];
            
            
            elem.title = [NSString stringWithFormat:@"%@", [dicX objectForKeyOrNil:@"language"]];
            
            [self.pieView.layer addValues:@[elem] animated:NO];
            
            [self.mArrElementPie addObject:elem];
        }
        
    }
     
    
    //333==== helper setup
    showPercent = YES;
    self.pieView.layer.transformTitleBlock = ^(PieElement* elem, float percent){
        
        return [(xPieElement *)elem title];
        
    };
    
    
    self.pieView.frame = R_MAKE(0, 0, 320, 370);
    self.pieView.layer.showTitles = ShowTitlesAlways;
    [self.IB_dataScrollView addSubview:self.pieView];
    
    
    //===标题lable
    {
        if (_lbl_lintSkill==nil) {
            
            _lbl_lintSkill = [[UILabel alloc] initWithFrame:R_MAKE(0, 0, 320, 44)];
            
            _lbl_lintSkill.numberOfLines = 1;
            _lbl_lintSkill.adjustsFontSizeToFitWidth = YES;
            _lbl_lintSkill.textAlignment = NSTextAlignmentCenter;
            _lbl_lintSkill.font = kJBFontHeaderTitle;
            _lbl_lintSkill.textColor = COLOR(183, 227, 227, 1);
            _lbl_lintSkill.shadowColor = [UIColor blackColor];
            _lbl_lintSkill.shadowOffset = CGSizeMake(0, 1);
            _lbl_lintSkill.backgroundColor = [UIColor clearColor];
            
            _lbl_lintSkill.text = [@"language insight" uppercaseString];
            
            
            [self.IB_dataScrollView  addSubview:_lbl_lintSkill];
        }
        else
        {
            [self.IB_dataScrollView bringSubviewToFront:_lbl_lintSkill];
        }
    }
    
    
    //===延迟三秒   draw
    [self performSelector:@selector(reDrawPieChart)
               withObject:nil
               afterDelay:1.5];
}

-(void)reDrawPieChart
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.pieView.layer  pieElementWillAnimateUpdate];    
    });

}

-(void)makeLintArrData:(NSArray *)arrLint
{
    DebugLog(@"%@",arrLint);
    
    //====取得  基本数据
    NSMutableArray *arrLimit10 = [NSMutableArray new];
    
    if ([arrLint count]<=10) {
        
        //===小于10
        arrLimit10 = [NSMutableArray arrayWithArray:[visualClient shareClient].lint_languagesTake_arr];
        
    }
    else
    {
        for (NSDictionary *dicX in arrLint) {
            
            [arrLimit10 addObject:[NSMutableDictionary dictionaryWithDictionary:dicX]];
            
            //===只取前10个。
            if ([arrLimit10 count]==10)
                break;
            
        }
    }
    
    
    //====计算基本数据  百分比
    int coutTotal = 0;
    
    
    //==1
    for (NSDictionary *dicX in arrLimit10) {
        
        coutTotal = coutTotal + [[dicX objectForKeyOrNil:@"count"] targetIntValue];
        
    }
    
    //==2
    [self.mArrPieData removeAllObjects];
    
    for (NSDictionary *dicX in arrLimit10) {
        
        int currInt = [[dicX objectForKeyOrNil:@"count"] targetIntValue];
        
        double  percertX  =   (double)((double)currInt/(double)coutTotal);
        
        NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:dicX];
        
        [mDic setObject:@(percertX) forKey:@"percent"];
        
        [self.mArrPieData addObject:mDic];
    }
    
    DebugLog(@"%@",self.mArrPieData);
}

#pragma  mark --- private helper method
-(void)refreshForce
{
    SHOW_PROGRESS(self.view);
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [[visualClient shareClient] getV_visualizationDataBy:iOctocatDelegate.sharedInstance.currentAccount.login
                                                        :YES
                                                        :YES
                                                        :^(BOOL succ, id responseObj) {
                                                            
                                                            DebugLog(@"%@",[visualClient shareClient].lint_languagesTake_arr);
                                                            DebugLog(@"%@",[visualClient shareClient].codeD_weekEvent_arr);
                                                            DebugLog(@"%@",[visualClient shareClient].push_repositories_arr);
                                                            
                                                            if (succ) {
                                                                //===do dataGet3arr drawChart
                                                            };
                                                            
                                                            //===重新合成图表
                                                            [self configureViewHerarchy:responseObj];
                                                            
                                                            self.navigationItem.rightBarButtonItem.enabled = YES;
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                HIDE_PROGRESS(self.view);
                                                            });
                                                            
                                                            
                                                        }];
}


@end
