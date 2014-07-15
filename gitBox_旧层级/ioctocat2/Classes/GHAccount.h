@class GHOAuthClient, GHUserObjectsRepository, GHUser;

/**
 *  github 账户 dataObj
 */
@interface GHAccount : NSObject <NSCoding>

@property(nonatomic,readonly)GHUserObjectsRepository *userObjects;// 仓库dataObj
@property(nonatomic,strong)GHOAuthClient *apiClient;//=====================api auth key
@property(nonatomic,strong)GHUser *user;// user dataObj
@property(nonatomic,strong)NSString *login;
@property(nonatomic,strong)NSString *endpoint;
@property(nonatomic,strong)NSString *authToken;
@property(nonatomic,strong)NSString *pushToken;
@property(nonatomic,readonly)NSString *accountId;
@property(nonatomic,readonly)BOOL isGitHub;

- (id)initWithDict:(NSDictionary *)dict;

@end