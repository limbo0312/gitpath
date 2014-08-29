//
//  visualClient.m
//  iOctocat
//
//  Created by EGS on 14-8-6.
//
//

#import "visualClient.h"
#import "iOctocatDelegate.h"
#import "GHAccount.h"
#import "GHUser.h"

#import "NSString+Extensions.h"
#import "NSDate-Utilities.h"

#define kOSRC_APIVer1 @"http://osrc.dfm.io/"

#define innerVerb [visualClient shareClient]

@interface visualClient ()

@property(nonatomic,assign) NSInteger  VisualiseCount;

@end

#define kVisualCount @"visualCount_dash"
#define kVisualToday @"todayString"

@implementation visualClient

+ (visualClient *)shareClient
{
    static visualClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedClient = [[visualClient alloc]  initWithBaseURL:[NSURL URLWithString:kOSRC_APIVer1]];
        
        //====配置：：：：：：：verbPre
        [_sharedClient setDefaultHeader:@"Accept" value:@"application/json"];
        [_sharedClient setParameterEncoding:AFJSONParameterEncoding];
        [_sharedClient registerHTTPOperationClass:AFJSONRequestOperation.class];
        
#ifdef GitColorProVer
        _sharedClient.VisualiseCount = -1;
#endif
        
#ifdef GitColorLiteVer
        NSString *dateStrSave = USER_PLIST_GETstr(kVisualToday);
        NSDate *dateX = [NSString  getDateByString:dateStrSave Format:@"yyyy-MM-dd EEEE HH:mm:ss a"];
        
        DebugLog(@"%@",dateStrSave );
        
        if ([dateX isToday]) {
            
            NSInteger coutVisual = USER_PLIST_GETint(kVisualCount);
            
            DebugLog(@"%d",coutVisual );
            
            if (coutVisual!=0) {
                
                _sharedClient.VisualiseCount = coutVisual;
            }
            else
                _sharedClient.VisualiseCount = 0;
        }
        else
        {
            _sharedClient.VisualiseCount = 0;
        }
#endif
        
        
        
        
    });
    
    return _sharedClient;
    
}



-(void)getV_visualizationDataBy:(NSString *)userName
                               :(BOOL)forceUpdate
                               :(BOOL)noUseCache
                               :(visualData)blok
{
    if (self.VisualiseCount==-1) {
        //===无限制
    }
    else
    {
        //===限制
        if (![userName isEqualToString:iOctocatDelegate.sharedInstance.currentAccount.user.login]) {
            //===insight other guy 才计数
            self.VisualiseCount++;
            USER_PLIST_Set(@(self.VisualiseCount), kVisualCount);
            USER_PLIST_Set([NSString getcurrDateWithFormat:@"yyyy-MM-dd EEEE HH:mm:ss a"], kVisualToday);
            
            if (self.VisualiseCount>=5)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [EAlertView  showWithMsg:@"free ver limit visualise codePower 5/day, would you want to buy a pro version ?"
                                            :@"no"
                                            :@"yes"
                                       block:^(int btnIndex) {
                                           if (btnIndex==0) {
                                               
                                           }
                                           else if (btnIndex==1)
                                           {
                                               //=== 跳到appStore
                                               NSURL *appUrl = [NSURL URLWithString:@"https://itunes.apple.com/us/app/gitcolor-pro-colorful-codemind/id905069897?l=zh&ls=1&mt=8"];
                                               
                                               [[UIApplication sharedApplication]  openURL:appUrl];
                                           }
                                       }];
                    
                    
                });
                
                blok(NO,@"freeVerLimit");
                return;
            }
        }
        


        
        
    }
    

    
    //===cache for each userName（key）
    NSDictionary *cacheDic = USER_PLIST_GETdic(userName);
    if (cacheDic!=nil) {
        //===划属 数据
        self.lint_languagesTake_arr = [[cacheDic objectForKeyOrNil:@"usage"] objectForKeyOrNil:@"languages"];
        
        self.codeD_weekEvent_arr = [[cacheDic objectForKeyOrNil:@"usage"] objectForKeyOrNil:@"events"];
        
        self.push_repositories_arr = [cacheDic objectForKeyOrNil:@"repositories"];
        
        if (!noUseCache)
            blok(YES,cacheDic);
        
        if (!forceUpdate) {
            
            return;
        }
        else
            ;//go on update
    }
    
    
    
    //===real netVerb
    [innerVerb getPath:[NSString stringWithFormat:@"%@.json",userName]
            parameters:nil
               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                   
                   DebugLog(@"%@",responseObject);
                   
                   //===划属 数据
                   self.lint_languagesTake_arr = [[responseObject objectForKeyOrNil:@"usage"] objectForKeyOrNil:@"languages"];
                   
                   self.codeD_weekEvent_arr = [[responseObject objectForKeyOrNil:@"usage"] objectForKeyOrNil:@"events"];
                   
                   self.push_repositories_arr = [responseObject objectForKeyOrNil:@"repositories"];
                   
                   
                   DATA_BLK(^{
                       USER_PLIST_Set(responseObject, userName);
                   });
                   
                   
                   blok(YES,responseObject);
               }
               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   
                   DebugLog(@"%@",error);
                   
                   blok(NO,nil);
               }];

}


@end
