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
                               :(visualData)blok
{

    [innerVerb getPath:[NSString stringWithFormat:@"%@.json",userName]
            parameters:nil
               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                   
                   DebugLog(@"%@",responseObject);
                   
                   //===划属 数据
                   self.lint_languagesTake_arr = [[responseObject objectForKeyOrNil:@"usage"] objectForKeyOrNil:@"languages"];
                   
                   self.codeD_weekAction_arr = [[responseObject objectForKeyOrNil:@"usage"] objectForKeyOrNil:@"week"];
                   
                   self.push_repositories_arr = [responseObject objectForKeyOrNil:@"repositories"];
                   
                   blok(YES);
               }
               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   
                   DebugLog(@"%@",error);
                   
                   blok(NO);
               }];

}


@end
