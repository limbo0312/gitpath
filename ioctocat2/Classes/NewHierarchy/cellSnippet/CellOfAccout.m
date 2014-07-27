//
//  CellOfAccout.m
//  iOctocat
//
//  Created by Engels on 14-7-27.
//
//

#import "CellOfAccout.h"
#import "GHUser.h"

@interface CellOfAccout()

@property(nonatomic,readonly)GHUser *object;
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

#pragma mark main M
-(void)setupUserObject:(GHUser *)userObj
{

}

@end
