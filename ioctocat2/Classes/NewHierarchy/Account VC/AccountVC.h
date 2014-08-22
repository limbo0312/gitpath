//
//  AccountVC.h
//  iOctocat
//
//  Created by EGS on 14-7-25.
//
//

#import <UIKit/UIKit.h>

@interface AccountVC : UIViewController


@property (weak,nonatomic) IBOutlet UITableView * tableView;


//==  helper LBL  
@property (weak, nonatomic) IBOutlet UILabel *IB_lblInspired;
@property (weak, nonatomic) IBOutlet UILabel *IB_lblEGSDesign;


@end
