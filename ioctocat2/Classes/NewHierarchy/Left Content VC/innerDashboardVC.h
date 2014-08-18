//
//  innerDashboardVC.h
//  iOctocat
//
//  Created by Engels on 14-7-27.
//
//

#import <UIKit/UIKit.h>

@class customPieView;

@interface innerDashboardVC : UIViewController


@property (weak, nonatomic) IBOutlet UIScrollView *IB_dataScrollView;


@property (nonatomic,assign) BOOL isSelf;

@property (nonatomic,strong) NSString *currLoginName;

//====当前insight guy dataInfo

//111===skill insight====>擅长区域
@property (nonatomic,strong) NSArray *lint_arr;
//222===codeDesire insight====>代码热情
@property (nonatomic,strong) NSArray *codeD_arr;
//333===pushCount insight====>参与力度
@property (nonatomic,strong) NSArray *push_arr;

@end
