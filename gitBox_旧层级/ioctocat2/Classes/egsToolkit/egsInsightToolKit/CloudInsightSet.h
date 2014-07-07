//
//  EGS_CloudTool.h
//  RNSwipeViewController
//
//  Created by Engels on 12-11-23.
//  Copyright (c) 2012年 Ryan Nystrom. All rights reserved.
//

/*专门用于云端工具的辅助分析使用*/

#import <Foundation/Foundation.h>

@interface CloudInsightSet : NSObject
{

}

/*启动：parse  云端数据存储*/
//-(void)startParse;

+ (void)startJPush;


/*启动：crittercism bug报告*/
+(void)startCrittercism;
/*启动：app  使用情况分析*/
+(void)startTalkingData;


/*启动友盟统计*/
+(void)startMobClick;
+(void)startMobFeedback;//um 反馈

//===>模拟器：pc端调试    真机：真机safari 调式(后者需重设计)
+(void)start_viewerHierarchy;
@end
