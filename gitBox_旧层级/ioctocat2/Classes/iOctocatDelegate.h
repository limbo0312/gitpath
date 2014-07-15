


@class GHAccount, GHUser, GHOrganization;

@interface iOctocatDelegate : NSObject<UIApplicationDelegate>
@property(nonatomic,strong)GHAccount *currentAccount;// 当前 登陆 accountObj
@property(nonatomic,strong)NSString *deviceToken;
@property(nonatomic,strong)IBOutlet UIWindow *window;

@property(nonatomic,readonly)NSMutableArray *accounts;//账户 arr

+ (instancetype)sharedInstance;
+ (void)reportWarning:(NSString *)title with:(NSString *)message;
+ (void)reportError:(NSString *)title with:(NSString *)message;
+ (void)reportLoadingError:(NSString *)message;
- (BOOL)openURL:(NSURL *)url;
- (void)bringStatusViewToFront;
- (void)registerForRemoteNotifications;
- (GHUser *)currentUser;
- (GHUser *)userWithLogin:(NSString *)login;
- (GHOrganization *)organizationWithLogin:(NSString *)login;

@end