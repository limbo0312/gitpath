//
//  JBBarChartViewController.h
//  JBChartViewDemo
//
//  Created by Terry Worona on 11/5/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "JBBaseChartViewController.h"

@class JBChartInformationView;
@interface JBBarChartViewController : JBBaseChartViewController


//===egs add
-(void)setupData2pushCount:(id)dataObj;

@property (nonatomic, strong) JBChartInformationView *informationView;

@end
