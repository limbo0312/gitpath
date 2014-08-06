//
//  visualClient.h
//  iOctocat
//
//  Created by EGS on 14-8-6.
//
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "AFHTTPClient.h"


typedef void(^visualData)(BOOL succ);

@interface visualClient : AFHTTPClient

//111===skill insight====>擅长区域
@property (nonatomic,strong) NSArray *lint_languagesTake_arr;
//222===codeDesire insight====>代码热情
@property (nonatomic,strong) NSArray *codeD_weekAction_arr;
//333===pushCount insight====>参与力度
@property (nonatomic,strong) NSArray *push_repositories_arr;


+(visualClient *)shareClient;

-(void)getV_visualizationDataBy:(NSString *)userName
                               :(visualData)blok;


@end
