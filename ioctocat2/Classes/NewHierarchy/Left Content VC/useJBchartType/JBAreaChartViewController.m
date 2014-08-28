//
//  JBAreaChartViewController.m
//  JBChartViewDemo
//
//  Created by Lars Ott on 21.04.14.
//  Copyright (c) 2014 Jawbone. All rights reserved.
//

#import "JBAreaChartViewController.h"

// Views
#import "JBLineChartView.h"
#import "JBChartHeaderView.h"
#import "JBLineChartFooterView.h"
#import "JBChartInformationView.h"

//#import "JBConstants.h"
#define ARC4RANDOM_MAX 0x100000000

typedef NS_ENUM(NSInteger, JBLineChartLine){
	JBLineChartLineSun,
    JBLineChartLineMoon,
    JBLineChartLineCount
};

// Numerics
CGFloat const kJBAreaChartViewControllerChartHeight = 250.0f;
CGFloat const kJBAreaChartViewControllerChartPadding = 10.0f;
CGFloat const kJBAreaChartViewControllerChartHeaderHeight = 75.0f;
CGFloat const kJBAreaChartViewControllerChartHeaderPadding = 20.0f;
CGFloat const kJBAreaChartViewControllerChartFooterHeight = 20.0f;
CGFloat const kJBAreaChartViewControllerChartLineWidth = 2.0f;
NSInteger const kJBAreaChartViewControllerMaxNumChartPoints = 12;

// Strings
NSString * const kJBAreaChartViewControllerNavButtonViewKey = @"view";

@interface JBAreaChartViewController () <JBLineChartViewDelegate, JBLineChartViewDataSource>

@property (nonatomic, strong) JBLineChartView *lineChartView;


@property (nonatomic, strong) NSMutableArray *chartData;
@property (nonatomic, strong) NSMutableArray *symbolsData;//====fix week A B C。。。

// Buttons
- (void)chartToggleButtonPressed:(id)sender;

// Helpers
- (void)initFakeData;
- (NSArray *)largestLineData; // largest collection of fake line data


// color ramFlat
@property (nonatomic,strong)UIColor *colorWatch;
@property (nonatomic,strong)UIColor *colorPush;
@property (nonatomic,strong)UIColor *colorFork;
@end

@implementation JBAreaChartViewController

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

#pragma mark - Data

- (void)initFakeData
{
    NSMutableArray *mutableLineCharts = [NSMutableArray array];
    for (int lineIndex=0; lineIndex<JBLineChartLineCount; lineIndex++)
    {
        NSMutableArray *mutableChartData = [NSMutableArray array];
        for (int i=0; i<kJBAreaChartViewControllerMaxNumChartPoints; i++)
        {
            [mutableChartData addObject:[NSNumber numberWithFloat:((double)arc4random() / ARC4RANDOM_MAX) * 12]]; // random number between 0 and 12
        }
        [mutableLineCharts addObject:mutableChartData];
    }
    _chartData = [NSMutableArray arrayWithArray:mutableLineCharts];
    
    _symbolsData = [NSMutableArray arrayWithArray:@[@"Week 1",@"Week 2",@"Week 3",@"Week 4",@"Week 5",@"Week 6",@"Week 7"]];
    //[NSMutableArray arrayWithArray:[[[NSDateFormatter alloc] init] shortMonthSymbols]];
    
    //===reem color
    self.colorWatch = RamFlatColor;
    self.colorPush  = RamFlatColor;
    self.colorFork  = RamFlatColor;
}

- (NSArray *)largestLineData
{
    NSArray *largestLineData = nil;
    for (NSArray *lineData in self.chartData)
    {
        if ([lineData count] > [largestLineData count])
        {
            largestLineData = lineData;
        }
    }
    return largestLineData;
}

#pragma mark - View Lifecycle

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = kJBColorLineChartControllerBackground;
    self.navigationItem.rightBarButtonItem = [self chartToggleButtonWithTarget:self action:@selector(chartToggleButtonPressed:)];
    
    if (self.lineChartView==nil) {
        
        //===new life
        self.lineChartView = [[JBLineChartView alloc] init];
        
        self.lineChartView.frame = CGRectMake(kJBAreaChartViewControllerChartPadding,
                                              kJBAreaChartViewControllerChartPadding,
                                              self.view.bounds.size.width - (kJBAreaChartViewControllerChartPadding * 2),
                                              kJBAreaChartViewControllerChartHeight);
        self.lineChartView.delegate = self;
        self.lineChartView.dataSource = self;
        self.lineChartView.headerPadding =kJBAreaChartViewControllerChartHeaderPadding;
        self.lineChartView.backgroundColor = kJBColorLineChartBackground;
        
        //===header
        JBChartHeaderView *headerView = [[JBChartHeaderView alloc] initWithFrame:CGRectMake(kJBAreaChartViewControllerChartPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(kJBAreaChartViewControllerChartHeaderHeight * 0.5), self.view.bounds.size.width - (kJBAreaChartViewControllerChartPadding * 2), kJBAreaChartViewControllerChartHeaderHeight)];
        headerView.titleLabel.text = [@"Code Digg Desire" uppercaseString];//[kJBStringLabelAverageShineHoursOfSunMoon uppercaseString];
        headerView.titleLabel.textColor = kJBColorLineChartHeader;
        headerView.titleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.25];
        headerView.titleLabel.shadowOffset = CGSizeMake(0, 1);
        
        headerView.subtitleLabel.text = @"dig frequency";//kJBStringLabel2011;
        headerView.subtitleLabel.textColor = kJBColorLineChartHeader;
        headerView.subtitleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.25];
        headerView.subtitleLabel.shadowOffset = CGSizeMake(0, 1);
        headerView.separatorColor = kJBColorLineChartHeaderSeparatorColor;
        self.lineChartView.headerView = headerView;
        
        //====footer
        JBLineChartFooterView *footerView = [[JBLineChartFooterView alloc] initWithFrame:CGRectMake(kJBAreaChartViewControllerChartPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(kJBAreaChartViewControllerChartFooterHeight * 0.5), self.view.bounds.size.width - (kJBAreaChartViewControllerChartPadding * 2), kJBAreaChartViewControllerChartFooterHeight)];
        footerView.backgroundColor = [UIColor clearColor];
        footerView.leftLabel.text = [[self.symbolsData firstObject] uppercaseString];
        footerView.leftLabel.textColor = [UIColor whiteColor];
        footerView.rightLabel.text = [[self.symbolsData lastObject] uppercaseString];;
        footerView.rightLabel.textColor = [UIColor whiteColor];
        footerView.sectionCount = [[self chartData] count];
        self.lineChartView.footerView = footerView;
        
        [self.view addSubview:self.lineChartView];
        
        //===info view
        self.informationView = [[JBChartInformationView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, CGRectGetMaxY(self.lineChartView.frame), self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(self.lineChartView.frame) - CGRectGetMaxY(self.navigationController.navigationBar.frame))];
        [self.informationView setValueAndUnitTextColor:[UIColor colorWithWhite:1.0 alpha:0.75]];
        [self.informationView setTitleTextColor:kJBColorLineChartHeader];
        [self.informationView setTextShadowColor:nil];
        [self.informationView setSeparatorColor:kJBColorLineChartHeaderSeparatorColor];
        [self.view addSubview:self.informationView];
    }
    
    
    
    [self.lineChartView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.lineChartView setState:JBChartViewStateExpanded];
}

#pragma mark - JBLineChartViewDataSource

- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView
{
    return [self.chartData count];
}

- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex
{
    return [[self.chartData objectAtIndex:lineIndex] count];
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView showsDotsForLineAtLineIndex:(NSUInteger)lineIndex
{
    return NO;
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView smoothLineAtLineIndex:(NSUInteger)lineIndex
{
    return YES;
}

#pragma mark - JBLineChartViewDelegate

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return [[[self.chartData objectAtIndex:lineIndex] objectAtIndex:horizontalIndex] floatValue];
}

- (void)lineChartView:(JBLineChartView *)lineChartView didSelectLineAtIndex:(NSUInteger)lineIndex horizontalIndex:(NSUInteger)horizontalIndex touchPoint:(CGPoint)touchPoint
{
    NSNumber *valueNumber = [[self.chartData objectAtIndex:lineIndex] objectAtIndex:horizontalIndex];
    
//    [self.informationView setValueText:[NSString stringWithFormat:@"%.1f", [valueNumber floatValue]] unitText:kJBStringLabelHours];
//    [self.informationView setTitleText:lineIndex == JBLineChartLineSun ? kJBStringLabelSun : kJBStringLabelMoon];

    //===111
    [self.informationView setValueText:[NSString stringWithFormat:@"%d", [valueNumber integerValue]]
                              unitText:@"/w"];
    
    
    //====222
    NSString *infoTitle;
    if (lineIndex==0) {
        infoTitle = [NSString stringWithFormat:@"%@ Watch Event",[[self.symbolsData objectAtIndex:horizontalIndex] uppercaseString]];
    }
    else if (lineIndex==1)
    {
        infoTitle = [NSString stringWithFormat:@"%@ Push Event",[[self.symbolsData objectAtIndex:horizontalIndex] uppercaseString]];
    }
    else if (lineIndex==2)
    {
        infoTitle = [NSString stringWithFormat:@"%@ Fork Event",[[self.symbolsData objectAtIndex:horizontalIndex] uppercaseString]];
    }
    
    [self.informationView setTitleText:infoTitle];// 显示week
    
    
    [self.informationView setHidden:NO animated:YES];
    [self setTooltipVisible:YES animated:YES atTouchPoint:touchPoint];
    
    
    [self.tooltipView setText:[[self.symbolsData objectAtIndex:horizontalIndex] uppercaseString]];
}

- (void)didDeselectLineInLineChartView:(JBLineChartView *)lineChartView
{
//    [self.informationView setHidden:YES animated:YES];
    
    
    [self setTooltipVisible:NO animated:YES];
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForLineAtLineIndex:(NSUInteger)lineIndex
{
//    return (lineIndex == JBLineChartLineSun) ? kJBColorAreaChartDefaultSunLineColor: kJBColorAreaChartDefaultMoonLineColor;
    
    UIColor *colorX;
    
    if (lineIndex==0) {
        colorX =  _colorWatch;
    }
    else if (lineIndex==1){
        colorX = _colorPush;
    }
    else if (lineIndex==2){
        colorX = _colorFork;
    }
    
    return colorX;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView fillColorForLineAtLineIndex:(NSUInteger)lineIndex
{
//    return (lineIndex == JBLineChartLineSun) ? kJBColorAreaChartDefaultSunAreaColor : kJBColorAreaChartDefaultMoonAreaColor;
    
    UIColor *colorX;
    
    if (lineIndex==0) {
        colorX =  _colorWatch;
    }
    else if (lineIndex==1){
        colorX = _colorPush;
    }
    else if (lineIndex==2){
        colorX = _colorFork;
    }
    
    return colorX;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
//    return (lineIndex == JBLineChartLineSun) ? kJBColorAreaChartDefaultSunLineColor: kJBColorAreaChartDefaultMoonLineColor;
    
    UIColor *colorX;
    
    if (lineIndex==0) {
        colorX =  _colorWatch;
    }
    else if (lineIndex==1){
        colorX = _colorPush;
    }
    else if (lineIndex==2){
        colorX = _colorFork;
    }
    
    return colorX;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView widthForLineAtLineIndex:(NSUInteger)lineIndex
{
    return kJBAreaChartViewControllerChartLineWidth;
}

- (UIColor *)verticalSelectionColorForLineChartView:(JBLineChartView *)lineChartView
{
    return COLOR(246, 246, 246, 1);//[UIColor whiteColor];
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionColorForLineAtLineIndex:(NSUInteger)lineIndex
{
//    return (lineIndex == JBLineChartLineSun) ? kJBColorAreaChartDefaultSunSelectedLineColor: kJBColorAreaChartDefaultMoonSelectedLineColor;
    
    UIColor *colorX;
    
    if (lineIndex==0) {
        colorX =  _colorWatch;
    }
    else if (lineIndex==1){
        colorX = _colorPush;
    }
    else if (lineIndex==2){
        colorX = _colorFork;
    }
    
    return colorX;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionFillColorForLineAtLineIndex:(NSUInteger)lineIndex
{
//    return (lineIndex == JBLineChartLineSun) ? kJBColorAreaChartDefaultSunSelectedAreaColor : kJBColorAreaChartDefaultMoonSelectedAreaColor;
    
    UIColor *colorX;
    
    if (lineIndex==0) {
        colorX =  _colorWatch;
    }
    else if (lineIndex==1){
        colorX = _colorPush;
    }
    else if (lineIndex==2){
        colorX = _colorFork;
    }
    
    return colorX;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionColorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
//    return (lineIndex == JBLineChartLineSun) ? kJBColorAreaChartDefaultSunSelectedLineColor: kJBColorAreaChartDefaultMoonSelectedLineColor;
    
    
    UIColor *colorX;
    
    if (lineIndex==0) {
        colorX =  _colorWatch;
    }
    else if (lineIndex==1){
        colorX = _colorPush;
    }
    else if (lineIndex==2){
        colorX = _colorFork;
    }
    
    return colorX;
}

- (JBLineChartViewLineStyle)lineChartView:(JBLineChartView *)lineChartView lineStyleForLineAtLineIndex:(NSUInteger)lineIndex
{
    return JBLineChartViewLineStyleSolid;
}

#pragma mark - Buttons

- (void)chartToggleButtonPressed:(id)sender
{
	UIView *buttonImageView = [self.navigationItem.rightBarButtonItem valueForKey:kJBAreaChartViewControllerNavButtonViewKey];
    buttonImageView.userInteractionEnabled = NO;
    
    CGAffineTransform transform = self.lineChartView.state == JBChartViewStateExpanded ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformMakeRotation(0);
    buttonImageView.transform = transform;
    
    [self.lineChartView setState:self.lineChartView.state == JBChartViewStateExpanded ? JBChartViewStateCollapsed : JBChartViewStateExpanded animated:YES callback:^{
        buttonImageView.userInteractionEnabled = YES;
    }];
}

#pragma mark - Overrides

- (JBChartView *)chartView
{
    return self.lineChartView;
}


#pragma mark -- egs add group
//===egs add
-(void)setupData2codeD:(id)objData
{
    //====old data
    DebugLog(@"%@",self.chartData);
    DebugLog(@"%@",self.symbolsData);
    
    //=====setup new data
    if (objData==nil)
        return;
    
    DebugLog(@"%@",objData);
    //=====new data setup
    [self.chartData removeAllObjects];

    
    
    //=====
    if ([objData isKindOfClass:[NSArray class]]
        &&[(NSArray *)objData count]==3){
        
        //===watch  event
        NSDictionary *dicWatch = [objData objectAtIndex:0];
        NSArray *arrWeekWatch = [dicWatch objectForKeyOrNil:@"week"];
        
        
        
        //===push event
        NSDictionary *dicPush = [objData objectAtIndex:1];
        NSArray *arrWeekPush = [dicPush objectForKeyOrNil:@"week"];
        
        //===push event
        NSDictionary *dicFork = [objData objectAtIndex:2];
        NSArray *arrWeekFork = [dicFork objectForKeyOrNil:@"week"];
        
        //===new data setIn
        [self.chartData addObject:arrWeekWatch];
        [self.chartData addObject:arrWeekPush];
        [self.chartData addObject:arrWeekFork];
    }
    
    //===reem color new
    self.colorWatch = RamFlatColor;
    self.colorPush  = RamFlatColor;
    self.colorFork  = RamFlatColor;
    
    [self.lineChartView reloadData];
}

@end