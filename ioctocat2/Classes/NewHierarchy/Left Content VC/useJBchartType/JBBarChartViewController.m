//
//  JBBarChartViewController.m
//  JBChartViewDemo
//
//  Created by Terry Worona on 11/5/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "JBBarChartViewController.h"

// Views
#import "JBBarChartView.h"
#import "JBChartHeaderView.h"
#import "JBBarChartFooterView.h"
#import "JBChartInformationView.h"

// Numerics
CGFloat const kJBBarChartViewControllerChartHeight = 250.0f;
CGFloat const kJBBarChartViewControllerChartPadding = 10.0f;
CGFloat const kJBBarChartViewControllerChartHeaderHeight = 80.0f;
CGFloat const kJBBarChartViewControllerChartHeaderPadding = 10.0f;
CGFloat const kJBBarChartViewControllerChartFooterHeight = 25.0f;
CGFloat const kJBBarChartViewControllerChartFooterPadding = 5.0f;
NSUInteger kJBBarChartViewControllerBarPadding = 1;
NSInteger const kJBBarChartViewControllerNumBars = 12;
NSInteger const kJBBarChartViewControllerMaxBarHeight = 10;
NSInteger const kJBBarChartViewControllerMinBarHeight = 5;

// Strings
NSString * const kJBBarChartViewControllerNavButtonViewKey = @"view";

@interface JBBarChartViewController () <JBBarChartViewDelegate, JBBarChartViewDataSource>

@property (nonatomic, strong) JBBarChartView *barChartView;
@property (nonatomic, strong) JBChartInformationView *informationView;
@property (nonatomic, strong) NSMutableArray *chartData;
@property (nonatomic, strong) NSMutableArray *symbolsData;

// Buttons
- (void)chartToggleButtonPressed:(id)sender;

// Data
- (void)initFakeData;

@end

@implementation JBBarChartViewController

#pragma mark - Alloc/Init

- (id)init
{
    self = [super init];
    if (self)
    {
        [self initFakeData];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initFakeData];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self initFakeData];
    }
    return self;
}

#pragma mark - Date

- (void)initFakeData
{
    NSMutableArray *mutableChartData = [NSMutableArray array];
    for (int i=0; i<kJBBarChartViewControllerNumBars; i++)
    {
        NSInteger delta = (kJBBarChartViewControllerNumBars - abs((kJBBarChartViewControllerNumBars - i) - i)) + 2;
        [mutableChartData addObject:[NSNumber numberWithFloat:MAX((delta * kJBBarChartViewControllerMinBarHeight), arc4random() % (delta * kJBBarChartViewControllerMaxBarHeight))]];

    }
    _chartData = [NSMutableArray arrayWithArray:mutableChartData];
    _symbolsData =  [NSMutableArray arrayWithArray:[[[NSDateFormatter alloc] init] shortMonthSymbols]];
}

#pragma mark - View Lifecycle

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = kJBColorBarChartControllerBackground;
    self.navigationItem.rightBarButtonItem = [self chartToggleButtonWithTarget:self action:@selector(chartToggleButtonPressed:)];

    if (self.barChartView==nil) {
        
        self.barChartView = [[JBBarChartView alloc] init];
        
        self.barChartView.frame = CGRectMake(kJBBarChartViewControllerChartPadding,
                                             kJBBarChartViewControllerChartPadding,
                                             self.view.bounds.size.width - (kJBBarChartViewControllerChartPadding * 2),
                                             kJBBarChartViewControllerChartHeight);
        
        self.barChartView.delegate = self;
        self.barChartView.dataSource = self;
        
        self.barChartView.headerPadding = kJBBarChartViewControllerChartHeaderPadding;
        self.barChartView.minimumValue = 0.0f;
        self.barChartView.backgroundColor = kJBColorBarChartBackground;
        
        //===header===
        JBChartHeaderView *headerView = [[JBChartHeaderView alloc] initWithFrame:CGRectMake(kJBBarChartViewControllerChartPadding,
                                                                                            ceil(self.view.bounds.size.height * 0.5) -
                                                                                            ceil(kJBBarChartViewControllerChartHeaderHeight * 0.5),
                                                                                            self.view.bounds.size.width -
                                                                                            (kJBBarChartViewControllerChartPadding * 2),
                                                                                            kJBBarChartViewControllerChartHeaderHeight)];
        
        headerView.titleLabel.text = [@"Push Will Power" uppercaseString];//[kJBStringLabelAverageMonthlyTemperature uppercaseString];
        headerView.subtitleLabel.text = @"push count";//kJBStringLabel2012;
        headerView.separatorColor = kJBColorBarChartHeaderSeparatorColor;
        self.barChartView.headerView = headerView;
        
        //===footer===
        JBBarChartFooterView *footerView = [[JBBarChartFooterView alloc] initWithFrame:CGRectMake(kJBBarChartViewControllerChartPadding,
                                                                                                  ceil(self.view.bounds.size.height * 0.5) -
                                                                                                  ceil(kJBBarChartViewControllerChartFooterHeight * 0.5),
                                                                                                  self.view.bounds.size.width - (kJBBarChartViewControllerChartPadding * 2),
                                                                                                  kJBBarChartViewControllerChartFooterHeight)];
        footerView.padding = kJBBarChartViewControllerChartFooterPadding;
        footerView.leftLabel.text = [[self.symbolsData firstObject] uppercaseString];
        footerView.leftLabel.textColor = [UIColor whiteColor];
        footerView.rightLabel.text = [[self.symbolsData lastObject] uppercaseString];
        footerView.rightLabel.textColor = [UIColor whiteColor];
        self.barChartView.footerView = footerView;
        
        //===info===
        self.informationView = [[JBChartInformationView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x,
                                                                                        CGRectGetMaxY(self.barChartView.frame),
                                                                                        self.view.bounds.size.width,
                                                                                        self.view.bounds.size.height -
                                                                                        CGRectGetMaxY(self.barChartView.frame) -
                                                                                        CGRectGetMaxY(self.navigationController.navigationBar.frame))];
        
        
        [self.view addSubview:self.informationView];
        
        [self.view addSubview:self.barChartView];
        [self.barChartView reloadData];
        
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.barChartView setState:JBChartViewStateExpanded];
    
   
}

#pragma mark - JBBarChartViewDataSource

- (NSUInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView
{
    return [_chartData count];//kJBBarChartViewControllerNumBars;
}

- (void)barChartView:(JBBarChartView *)barChartView didSelectBarAtIndex:(NSUInteger)index touchPoint:(CGPoint)touchPoint
{
    NSNumber *valueNumber = [self.chartData objectAtIndex:index];
    
//    [self.informationView setValueText:[NSString stringWithFormat:kJBStringLabelDegreesFahrenheit, [valueNumber intValue], kJBStringLabelDegreeSymbol]
//                              unitText:nil];
//    
//    [self.informationView setTitleText:kJBStringLabelWorldwideAverage];
//    [self.informationView setHidden:NO
//                           animated:YES];
    
    [self.informationView setValueText:[NSString stringWithFormat:@"%@",valueNumber]
                              unitText:nil];
    
    [self.informationView setTitleText:[_symbolsData objectAtIndex:index]];
    [self.informationView setHidden:NO
                           animated:YES];
    
    [self setTooltipVisible:YES
                   animated:YES
               atTouchPoint:touchPoint];
    
//    [self.tooltipView setText:[[self.symbolsData objectAtIndex:index] uppercaseString]];
    
     [self.tooltipView setText:[NSString stringWithFormat:@"%@",valueNumber]];
}

- (void)didDeselectBarChartView:(JBBarChartView *)barChartView
{
//    [self.informationView setHidden:YES animated:YES];
    
    [self setTooltipVisible:NO animated:YES];
}

#pragma mark - JBBarChartViewDelegate

- (CGFloat)barChartView:(JBBarChartView *)barChartView heightForBarViewAtIndex:(NSUInteger)index
{
    return [[self.chartData objectAtIndex:index] floatValue];
}

- (UIColor *)barChartView:(JBBarChartView *)barChartView colorForBarViewAtIndex:(NSUInteger)index
{
    //===color egs
    return  RamFlatColor;//(index % 2 == 0) ? kJBColorBarChartBarBlue : kJBColorBarChartBarGreen;
}

- (UIColor *)barSelectionColorForBarChartView:(JBBarChartView *)barChartView
{
    return COLOR(246, 246, 246, 1);//[UIColor whiteColor];
}

- (NSUInteger)barPaddingForBarChartView:(JBBarChartView *)barChartView
{
    return kJBBarChartViewControllerBarPadding;
}

#pragma mark - Buttons

- (void)chartToggleButtonPressed:(id)sender
{
    UIView *buttonImageView = [self.navigationItem.rightBarButtonItem valueForKey:kJBBarChartViewControllerNavButtonViewKey];
    buttonImageView.userInteractionEnabled = NO;
    
    CGAffineTransform transform = self.barChartView.state == JBChartViewStateExpanded ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformMakeRotation(0);
    buttonImageView.transform = transform;
    
    [self.barChartView setState:self.barChartView.state == JBChartViewStateExpanded ? JBChartViewStateCollapsed : JBChartViewStateExpanded
                       animated:YES
                       callback:^{
        buttonImageView.userInteractionEnabled = YES;
    }];
}

#pragma mark - Overrides

- (JBChartView *)chartView
{
    return self.barChartView;
}


#pragma mark EGS add group 
//===egs add
-(void)setupData2pushCount:(id)dataObj
{
    //===old data
    DebugLog(@"%@",_chartData);
    DebugLog(@"%@",_symbolsData);
    
                  
    //====
    if (dataObj==nil)
        return;

    DebugLog(@"%@",dataObj);
    //===new data setup
    [_chartData  removeAllObjects];
    [_symbolsData removeAllObjects];
    
    for (NSDictionary *dicX in dataObj) {
        
        float countX = [[dicX objectForKeyOrNil:@"count"] targetFloatValue];
        
        NSString *repoName = [dicX objectForKeyOrNil:@"repo"];
        
        [_chartData addObject:[NSNumber numberWithFloat:countX]];
        [_symbolsData addObject:repoName];
    }
    
    //===重新  update data display
    [self.barChartView reloadData];
}


@end
