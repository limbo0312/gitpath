//
//  CellOfAccout.h
//  iOctocat
//
//  Created by Engels on 14-7-27.
//
//

#import <UIKit/UIKit.h>


@class GHAccount;
@interface CellOfAccout : UITableViewCell


@property (weak, nonatomic) IBOutlet UIView *IB_bgView;
@property (weak, nonatomic) IBOutlet UILabel *IB_lblName;

@property (weak, nonatomic) IBOutlet UIImageView *IB_realAvartar;

-(void)setupAccout:(GHAccount *)accObj
                  :(BOOL)makeAddBtn;

@end
