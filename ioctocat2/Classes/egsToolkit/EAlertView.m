//
//  EAlertView.m
//  EReader
//
//  Created by along on 13-4-12.
//  Copyright (c) 2013年 along. All rights reserved.
//

#import "EAlertView.h"
//#import "SOUND_PLAY.h"

@interface EAlertView ()<UIAlertViewDelegate>{
    EAlertViewBlock _block;
}

@end

@implementation EAlertView

+ (void)showWithMsg:(NSString *)msg block:(EAlertViewBlock)block{
    EAlertView * alert = [[EAlertView alloc] initWithMsg:msg
                                                        :@"YES"
                                                        :@"NO"
                                                   block:block];
    [alert show];
}

+ (void)showWithMsg:(NSString *)msg
                   :(NSString *)leftTitle
                   :(NSString *)rightTitle
              block:(EAlertViewBlock)block{

    EAlertView * alert = [[EAlertView alloc] initWithMsg:msg
                                                        :leftTitle
                                                        :rightTitle
                                                   block:block];
    [alert show];
}
- (id)initWithMsg:(NSString *)msg
                 :(NSString *)leftTitle
                 :(NSString *)rightTitle
            block:(EAlertViewBlock)block{
    self = [super initWithTitle:nil
                        message:msg
                       delegate:self
              cancelButtonTitle:leftTitle
              otherButtonTitles:rightTitle, nil];
    
    if (self) {
        // Initialization code
        _block = block;
    }
    return self;
}


- (id)initWithMsg:(NSString *)msg block:(EAlertViewBlock)block{
    self = [super initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    if (self) {
        // Initialization code
        _block = block;        
    }
    return self;
}

- (void)show{
    
//    [SOUND_PLAY soundPlay:@"alertShow"
//                     type:@"caf"];
    
    [super show];
    for (UIView *view in [self subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            [button setBackgroundImage:[UIImage imageNamed:@"1_29"] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
            [button.titleLabel setShadowOffset:CGSizeZero];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        else if ([view isKindOfClass:[UIImageView class]]){
            UIImageView *imageView = (UIImageView *)view;
            [imageView setImage:[UIImage imageNamed:@"1_28"]];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (_block) {
        _block(buttonIndex);
    }
}

@end
