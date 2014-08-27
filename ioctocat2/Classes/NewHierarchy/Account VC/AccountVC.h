//
//  AccountVC.h
//  iOctocat
//
//  Created by EGS on 14-7-25.
//
//

#import <UIKit/UIKit.h>

@interface AccountVC : UIViewController<UIActionSheetDelegate>


@property (weak,nonatomic) IBOutlet UITableView * tableView;


//==  IB  group
@property (weak, nonatomic) IBOutlet UILabel *IB_lblInspired;
@property (weak, nonatomic) IBOutlet UILabel *IB_lblEGSDesign;

@property (weak, nonatomic) IBOutlet UISwitch *IB_autoLogin;
@property (weak, nonatomic) IBOutlet UILabel *IB_helperLblAuto;

@property (weak, nonatomic) IBOutlet UIButton *IB_editBtn;


//====授权  最新  save  那个
- (void)authenticateAccountAtIndex_Last;

@end
