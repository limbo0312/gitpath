//
//  CellOfAccout.m
//  iOctocat
//
//  Created by Engels on 14-7-27.
//
//

#import "CellOfAccout.h"
#import "GHUser.h"
#import "GHAccount.h"


@interface CellOfAccout()

@property(nonatomic,strong)GHUser *currUserObj;

@property(nonatomic,strong)GHAccount *currAccObj;

@end

@implementation CellOfAccout

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma  mark main method
-(void)setupAccout:(GHAccount *)accObj
                  :(BOOL)makeAddBtn
{

    self.currAccObj= accObj;
    self.currUserObj = accObj.user;
    
    //====已经登陆账号
    if (!makeAddBtn) {
        
        _IB_realAvartar.hidden = NO;
        
        _IB_lblName.text = _currUserObj.login;
        
        [_IB_realAvartar setImageWithURL_SD:_currUserObj.gravatarURL
                           placeholderImage:_currUserObj.gravatar];
        
    }
    //====最后 一行
    else if (makeAddBtn)
    {
        _IB_realAvartar.hidden = YES;
        _IB_lblName.text = @"Add Account";
    }
    
    //==helper method
    [_IB_realAvartar MakePerfectCircle];
}

@end
