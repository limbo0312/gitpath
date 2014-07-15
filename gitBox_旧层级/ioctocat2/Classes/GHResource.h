


@class GHAccount, GHResource, AFHTTPRequestOperation;

typedef enum {
	GHResourceStatusFailed   = -1,
	GHResourceStatusUnloaded =  0,
	GHResourceStatusLoading  =  1,
	GHResourceStatusLoaded   =  2,
	GHResourceStatusChanged  =  3
} GHResourceStatus;

typedef void (^resourceStart)(GHResource *instance);
typedef void (^resourceSuccess)(GHResource *instance, id data);
typedef void (^resourceFailure)(GHResource *instance, NSError *error);
typedef void (^loadSuccess)(AFHTTPRequestOperation *operation, id data);
typedef void (^loadFailure)(AFHTTPRequestOperation *operation, NSError *error);

/**
 *  GH netdataObj 的根资源  obj  包含了 ：  最根基的资源
 */

@interface GHResource : NSObject

@property(nonatomic,strong)NSString *resourcePath;// 资源位置
@property(nonatomic,strong)NSString *resourceContentType;//  资源类型
@property(nonatomic,readonly)GHAccount *account;//=============所属账号
@property(nonatomic,readonly)BOOL isNew;
@property(nonatomic,readonly)BOOL isEmpty;
@property(nonatomic,readonly)BOOL isFailed;
@property(nonatomic,readonly)BOOL isUnloaded;
@property(nonatomic,readonly)BOOL isLoaded;
@property(nonatomic,readonly)BOOL isLoading;
@property(nonatomic,readonly)BOOL isChanged;
@property(nonatomic,readonly)loadSuccess onLoadSuccess;// 成功blok
@property(nonatomic,readonly)loadFailure onLoadFailure;// 失败blok

- (id)initWithPath:(NSString *)path;
- (void)markAsUnloaded;
- (void)markAsLoaded;
- (void)markAsChanged;
- (void)setHeaderValues:(NSDictionary *)values;
- (void)setValues:(id)response;
- (void)whenLoaded:(resourceSuccess)success;
- (void)loadWithSuccess:(resourceSuccess)success;
- (void)loadWithParams:(NSDictionary *)params start:(resourceStart)start success:(resourceSuccess)success failure:(resourceFailure)failure;
- (void)loadWithParams:(NSDictionary *)params path:(NSString *)path method:(NSString *)method start:(resourceStart)start success:(resourceSuccess)success failure:(resourceFailure)failure;
- (void)saveWithParams:(NSDictionary *)params start:(resourceStart)start success:(resourceSuccess)success failure:(resourceFailure)failure;
- (void)saveWithParams:(NSDictionary *)values path:(NSString *)path method:(NSString *)method start:(resourceStart)start success:(resourceSuccess)success failure:(resourceFailure)failure;
- (void)deleteWithStart:(resourceStart)start success:(resourceSuccess)success failure:(resourceFailure)failure;
- (NSString *)resourceContentType;


@end


