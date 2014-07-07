//
//  UIImageView+perfectCircle.m
//  crazyBall
//
//  Created by EGS on 13-12-5.
//  Copyright (c) 2013年 EGS. All rights reserved.
//

#import "UIView+perfectCircle.h"

@implementation UIView (perfectCircle)

-(void)MakePerfectCircle
{
    double imageSize = self.frame.size.width;//or self.frame.size.height

    // 必須加上這一行，這樣圓角才會加在圖片的「外側」
    self.layer.masksToBounds = YES;
    
    // 其實就是設定圓角，只是圓角的弧度剛好就是圖片尺寸的一半
    self.layer.cornerRadius = imageSize / 2.0;
    
}

-(void)MakeCircularBead
{
    self.layer.masksToBounds=YES;
    self.layer.cornerRadius=4.0;
//    self.layer.borderWidth=1.0;
//    self.layer.borderColor=[[UIColor grayColor] CGColor];
    
}

-(void)AddShadowAlound
{
    self.layer.shadowOffset = CGSizeMake(0, 3);
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 0.5;

}


@end
