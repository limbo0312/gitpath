//
//  JBAreaChartViewController.h
//  JBChartViewDemo
//
//  Created by Lars Ott on 21.04.14.
//  Copyright (c) 2014 Jawbone. All rights reserved.
//

#import "JBBaseChartViewController.h"

@class JBChartInformationView;
@interface JBAreaChartViewController : JBBaseChartViewController

//===egs add
-(void)setupData2codeD:(id)objData;

//egs open public
@property (nonatomic, strong) JBChartInformationView *informationView;

@end
