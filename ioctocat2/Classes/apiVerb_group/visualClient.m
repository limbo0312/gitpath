//
//  visualClient.m
//  iOctocat
//
//  Created by EGS on 14-8-6.
//
//

#import "visualClient.h"

#define kOSRC_APIVer1 @"http://osrc.dfm.io/"

#define innerVerb [visualClient shareClient]

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
        
    });
    
    return _sharedClient;
    
}



-(void)getV_visualizationDataBy:(NSString *)userName
                               :(BOOL)forceUpdate
                               :(visualData)blok
{
    //===cache for each userName（key）
    NSDictionary *cacheDic = USER_PLIST_GETdic(userName);
    if (cacheDic!=nil) {
        //===划属 数据
        self.lint_languagesTake_arr = [[cacheDic objectForKeyOrNil:@"usage"] objectForKeyOrNil:@"languages"];
        
        self.codeD_weekEvent_arr = [[cacheDic objectForKeyOrNil:@"usage"] objectForKeyOrNil:@"events"];
        
        self.push_repositories_arr = [cacheDic objectForKeyOrNil:@"repositories"];
        
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
