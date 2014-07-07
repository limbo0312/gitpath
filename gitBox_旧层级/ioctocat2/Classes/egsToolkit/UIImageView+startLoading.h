//
//  UIImageView+startLoading.h
//  crazyBall
//
//  Created by EGS on 13-12-23.
//  Copyright (c) 2013年 EGS. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIImageView (startLoading)

- (void)startAnimationEGS;
- (void)stopAnimationEGS;

+(instancetype)reedomIMG:(CGRect)frame;
@end


/*
@interface UIButton (refreshBtnAnimation)

@property (nonatomic,readonly)UIImageView *animationView;

-(void)startAnimation_refreshBtn;
-(void)stopAnimation_refreshBtn;


@end
*/

