//
//  EAlertView.h
//  EReader
//
//  Created by along on 13-4-12.
//  Copyright (c) 2013年 along. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EAlertView : UIAlertView

typedef void (^EAlertViewBlock)(int btnIndex);

+ (void)showWithMsg:(NSString *)msg block:(EAlertViewBlock)block;


+ (void)showWithMsg:(NSString *)msg
                   :(NSString *)leftTitle
                   :(NSString *)rightTitle
              block:(EAlertViewBlock)block;

@end
