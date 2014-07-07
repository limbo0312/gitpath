//
//  webTextView.h
//  footballData
//
//  Created by EGS on 14-5-22.
//  Copyright (c) 2014年 www.kantai.co. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^trigerHandleUrlBlok)(NSURL *url);

@interface webTextView : UIView <UIWebViewDelegate>

@property (nonatomic,strong) trigerHandleUrlBlok handleUrlBlok;

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIWebView *aWebView;

- (id)initWithFrame:(CGRect)frame :(trigerHandleUrlBlok)blok;

-(void)keyReInit_byXib;


-(void)keyAction_parseText;
-(void)keyAction_frameNew;
@end