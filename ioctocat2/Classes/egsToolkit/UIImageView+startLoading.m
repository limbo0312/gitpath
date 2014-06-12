//
//  UIImageView+startLoading.m
//  crazyBall
//
//  Created by EGS on 13-12-23.
//  Copyright (c) 2013年 EGS. All rights reserved.
//

#import "UIImageView+startLoading.h"
#import <objc/runtime.h>

#ifndef MB_INSTANCETYPE
#if __has_feature(objc_instancetype)
#define MB_INSTANCETYPE instancetype
#else
#define MB_INSTANCETYPE id
#endif
#endif

@implementation UIImageView (startLoading)


- (void)startAnimationEGS
{
    CABasicAnimation *animation =[CABasicAnimation animationWithKeyPath:@"transform" ];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue =[NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 0, 1.0)];
    animation.duration = 0.15;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    [self.layer addAnimation:animation forKey:nil];
}

- (void)stopAnimationEGS
{
    [self.layer removeAllAnimations];
}

//+(instancetype)reedomIMG:(CGRect)frame
//{
//    return [[UIImageView alloc] initWithFrame:frame];
//}
@end



/*
@implementation UIButton (refreshBtnAnimation)
@dynamic animationView;

static const char *kAnimationView = "AnimationViewBG";

- (UIImageView *)animationView{
    return objc_getAssociatedObject(self, kAnimationView);
}


- (void)setanimationView:(UIImageView *)imgView{
    objc_setAssociatedObject(self, kAnimationView, imgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



-(void)startAnimation_refreshBtn
{
    if (self.animationView==nil) {
        
        UIImageView *imaView = [[UIImageView alloc] initWithFrame:self.bounds];
        imaView.image = [[UIImage alloc] initWithCIImage:self.currentBackgroundImage.CIImage];
        imaView.userInteractionEnabled =NO;
        [self addSubview:imaView];
        
        [self setanimationView:imaView];
        
    }
    
    
    [self.animationView startAnimationEGS];
    
//    [self setBackgroundImage:nil forState:UIControlStateNormal];
}

-(void)stopAnimation_refreshBtn
{
    if (self.animationView==nil) {
        return;
    }
    
    [self setBackgroundImage:[[UIImage alloc] initWithCIImage:self.animationView.image.CIImage]
                    forState:UIControlStateNormal];
    
    [self.animationView removeFromSuperview];

    objc_setAssociatedObject(self, kAnimationView, nil, OBJC_ASSOCIATION_ASSIGN);
}

@end
*/