//
//  cellOfDash.h
//  iOctocat
//
//  Created by EGS on 14-8-8.
//
//

#import <UIKit/UIKit.h>

@class customPieView;

@interface cellOfDash : UITableViewCell


@property (weak, nonatomic) IBOutlet customPieView *pieView;




-(void)forceDataChart_skillInsight;
-(void)forceDataChart_codeDesireInsight;
-(void)forceDataChart_pushCountInsight;

@end
