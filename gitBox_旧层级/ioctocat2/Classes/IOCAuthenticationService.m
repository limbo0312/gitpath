#import "IOCAuthenticationService.h"
#import "GHAccount.h"
#import "GHUser.h"
#import "SVProgressHUD.h"


@implementation IOCAuthenticationService

+ (void)authenticateAccount:(GHAccount *)account
                    success:(void (^)(GHAccount *))success
                    failure:(void (^)(GHAccount *))failure {
    
	[account.user loadWithParams:nil
                           start:^(GHResource *instance) {
                               //====授权进度 。。。
                                [SVProgressHUD showWithStatus:@"Authenticating"
                                                     maskType:SVProgressHUDMaskTypeGradient];
                            }
                         success:^(GHResource *instance, id data) {
                             // ==== 授权成功
                                [SVProgressHUD dismiss];
                                if (success)
                                    success(account);
                            }
                         failure:^(GHResource *instance, NSError *error) {
                             //===== 授权失败
                                [SVProgressHUD dismiss];
                                if (failure)
                                    failure(account);
                            }];
}

@end