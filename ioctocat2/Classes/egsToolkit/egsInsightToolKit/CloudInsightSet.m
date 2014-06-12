//
//  EGS_CloudTool.m
//  RNSwipeViewController
//
//  Created by Engels on 12-11-23.
//  Copyright (c) 2012年 Ryan Nystrom. All rights reserved.
//

#import "CloudInsightSet.h"
#import "TalkingData.h" //talkingdata 统计
#import "Crittercism.h"//Crittercism 分析工具
//#import <Parse/Parse.h>//parse 存储云工具

#import "TestFlight.h"
//#import <HockeySDK/HockeySDK.h>

#import "MobClick.h"
//#import "UMFeedback.h"
#import "iOSHierarchyViewer.h"

@implementation CloudInsightSet

#pragma mark - 注册消息 推送  方式
+ (void)startJPush
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert |
                                                                           UIRemoteNotificationTypeSound |
                                                                           UIRemoteNotificationTypeBadge)];
}

#pragma mark app启动的辅助工具


+(void)startCrittercism
{
    // ****************************************************************************
    //  Crittercism 云端bug报告统计
    // ****************************************************************************
    [Crittercism enableWithAppID:@"52e11c6146b7c24db0000002"];//saidian  zuqiukong
}

+(void)startTalkingData
{
    // ****************************************************************************
    // talkingdata 云端用户使用情况分析
    // ****************************************************************************
    [TalkingData  sessionStarted:@"D4CDFDBC309C3974226F33E152465A95"//BALL
                   withChannelId:@"zuqiukong"];
}


+(void)startMobClick
{
    //umeng 统计
    [MobClick startWithAppkey:@"52e35d1d56240b8b8e07abfe"];//saidian    zuqiukong
}

+(void)startMobFeedback
{
    //um 反馈
//    @try {
    
#warning todo: fix
//        [UMFeedback checkWithAppkey:@"52e35d1d56240b8b8e07abfe"];//saidian    zuqiukong
//        [UMFeedback setLogEnabled:NO];
//    }
//    @catch (NSException *exception) {
//        DebugLog(@"um %@",exception);
//    }

}

//===>模拟器：pc端调试    真机：真机safari 调式(后者需重设计)
+(void)start_viewerHierarchy{
    
#ifdef DEBUG
    [iOSHierarchyViewer start];
#endif
    
}


-(void)startTestFlight
{
    // ****************************************************************************
    //  testflight 云端bug报告统计
    // ****************************************************************************
    
//    [TestFlight takeOff:@"81c5cc46-b8f4-4d7b-925c-9fd04ad49e6b"];// zuqiukong

}
 

-(void)starthockeyapp
{
//    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"562ad3ce0f3a58f04548c0d85351aefa"
//                                                           delegate:self];
//    [[BITHockeyManager sharedHockeyManager] startManager];
}



@end
