//
//  MacroDefinition.h
//  MacroDefinitionDemo
//
//  Created by egs on 13-2-9.
//  Copyright (c) 2013年 ss. All rights reserved.
//



#ifndef MacroDefinition_h
#define MacroDefinition_h

//-------------------获取设备大小\ios版本\屏幕尺寸-------------------------
//NavBar高度
#define NavigationBar_HEIGHT 44
//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


//iOS7 macro
#define NLSystemVersionGreaterOrEqualThan(version) ([[[UIDevice currentDevice] systemVersion] floatValue] >= version)
#define isIOS7_OR_LATER NLSystemVersionGreaterOrEqualThan(7.0)


//screen InchType macro
#define isSCREEN_5inchTYPE ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//ios7 全屏模式 故有navbar时起点改变
#define yValue_ios7 (44+20)

//判断 ipad  还是 iphone
#define isIPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad?YES:NO
#define isIPHONE UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone?YES:NO

//-------------------获取设备大小\ios版本\屏幕尺寸-------------------------


//-------------------打印日志-------------------------
//==调式器 add egs
#import "innerConsole.h"

//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#   define DebugLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

//===
#   define InnerLog(fmt, ...) [innerConsole log:(@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__];  //iconsole式移除：ver1 notWorking  (...)///

#define DebugLog_Ver2(fmt, ...) [innerConsole log:(@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__];

#else
#   define DebugLog(...)
#   define InnerLog(...)
#   define DebugLog_Ver2(...)
#endif



//----------------------系统----------------------------

//获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion]

//获取当前语言
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//判断是否 Retina屏、设备是否%fhone 5、是否是iPad
#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


//判断是真机还是模拟器
#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif


//----------------------系统----------------------------





//----------------------图片----------------------------

//读取本地图片
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

//定义UIImage对象
#define IMAGE(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]

//定义UIImage对象
#define ImageNamed(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer]]

//建议使用前两种宏定义,性能高于后者
//----------------------图片----------------------------



//----------------------颜色类---------------------------
// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define RGB_HEX(c,a)    [UIColor colorWithRed:((c>>16)&0xFF)/256.0  green:((c>>8)&0xFF)/256.0   blue:((c)&0xFF)/256.0   alpha:a]

#define UIColorFromRGBA(rgbValue,A) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:A]


//带有RGBA的颜色设置
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

//背景色
#define BACKGROUND_COLOR [UIColor colorWithRed:242.0/255.0 green:236.0/255.0 blue:231.0/255.0 alpha:1.0]

//清除背景色
#define CLEARCOLOR [UIColor clearColor]

#pragma mark - color functions
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

//关于颜色的几个宏定义
#define Color255ToCGColor(x)   ((x) / 255.0) 

#define RGBCOLOR_ALPHA(r, g, b, l) [UIColor colorWithRed:Color255ToCGColor(r) green:Color255ToCGColor(g) blue:Color255ToCGColor(b) alpha:l]

//----------------------颜色类--------------------------



//----------------------其他----------------------------

//方正黑体简体字体定义
#define FONT(F) [UIFont fontWithName:@"FZHTJW--GB1-0" size:F]



//设置View的tag属性
#define VIEWWITHTAG(_OBJECT, _TAG)    [_OBJECT viewWithTag : _TAG]
//程序的本地化,引用国际化的文件
#define MyLocal(x, ...) NSLocalizedString(x, nil)

//G－C－D~~~~~~~~~~  常用GCD
#define BACK_BLK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)

#define DATA_BLK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)

#define MAIN_UI_Blok(block) dispatch_async(dispatch_get_main_queue(),block)

//NSUserDefaults 实例化
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]


//由角度获取弧度 有弧度获取角度
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian*180.0)/(M_PI)



//单例化一个类========>快捷单例实现
#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)shared##classname \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [[self alloc] init]; \
} \
} \
\
return shared##classname; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [super allocWithZone:zone]; \
return shared##classname; \
} \
} \
\
return nil; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return self; \
}



#endif

//----------------------EGS 针对特定App----------------------------

//EGS add 20130620
#define APP_DELEGATE [[UIApplication sharedApplication] delegate]

#define AppRoot_VC [UIApplication sharedApplication].keyWindow.rootViewController
//==>便携使用 MBProgressHUD

#import "MBProgressHUD.h"
#define APP_WINDOW_ROOTVC   [[[UIApplication sharedApplication] keyWindow] rootViewController]
#define ROOT_VIEW   (UIView *)[APP_WINDOW_ROOTVC view]
#define SHOW_PROGRESS(view) [view showProgressHUD]
#define HIDE_PROGRESS(view) [view hideProgressHUD]

//bundle 操作宏
#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]


//FMDB
#define FMDBQuickCheck(SomeBool) { if (!(SomeBool)) { NSLog(@"严重：数据库操作错误：Failure on line %d", __LINE__); abort(); } }

#define DATABASE_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]stringByAppendingString:@"/weChat.db"]
//中国省市区数据库
#define DB_sourcePath [[NSBundle mainBundle] pathForResource:@"china_city" ofType:@"db"]

//用户信息
#define kMY_USER_ID @"myUserId"



////cellXib ==> 便携获取
#import "UITableViewCell+xibCell.h"



#define R_MAKE(X, Y, W, H) CGRectMake(X,Y,W,H)


#define  PopupDistance   64

//===》打印tree 结构
#import "UIView+treeStruct.h"
#define TREE_View(view)  [UIView treeViewStruct:view]
#define TREE_View_GetSubView(viewFat,viewType)  [UIView treeViewGet:viewType :viewFat]


#define DebugLogFrame(frame) NSLog(@"My view frame: %@", NSStringFromCGRect(frame));
#define DebugLogSize(size) NSLog(@"My view size: %@", NSStringFromCGSize(size));

//==>免除vcView全屏情况
#import "UIViewController+ios7match.h"

//==>便携
#import "EAlertView.h"


//==>正圆 圆角 category
#import "UIView+perfectCircle.h"


//==>宏使用 MLNav_dragback
//#import "MLNavigationController.h"
//#define ENABLE_DragbackNav(RootVC) [[MLNavigationController alloc] initWithRootViewController:centervc]


//==>切换宏：between demoData 和 realData
//#import "APPSetting.h"


//==>针对包含特殊情况NSNull下的changeValue
#import "NSObject+targetTypeValue.h"

//==>用户单例
//#import "userInstanceObj.h"
//#define USER_OBJ [userInstanceObj shareUserInstance]

//==>
//#define SERVER_TIME_FORMAT  @"yyyy-MM-dd'T'HH:mm:ss.SSSZ'Z'"

//==>
//#define NetStatus_OffNotification @"NetStatusOffNotification"

//==>方便的工具包
//#import "BGUtilities.h"

//==>
//#import "ALAlertBanner.h"

//==>
#import "NSObject+safelyOrNil.h"
#import "NSDictionary+safelyWay.h"
#import "NSArray+objectSavely.h"
#import "NSMutableDictionary+safelyWay.h"

//=>
#import "UIDevice+MemoryInfo.h"//内存相关
#define MEMO_available      [[UIDevice currentDevice]  availableMemory]
#define MEMO_used           [[UIDevice currentDevice]  usedMemory]

/***********************
    userPlist 存取
**********************/
#import "egsFilter_KillNull.h"//

#define USER_PLIST_Set(idX,keyStr)  [[NSUserDefaults standardUserDefaults] setObject:[egsFilter_KillNull emptyObjectFilter:idX] forKey:keyStr];\
                                    [[NSUserDefaults standardUserDefaults] synchronize];

#define USER_PLIST_GETdic(idX)         [[NSUserDefaults standardUserDefaults] dictionaryForKey:idX];\
                                       [[NSUserDefaults standardUserDefaults] synchronize];

#define USER_PLIST_GETarr(idX)         [[NSUserDefaults standardUserDefaults] arrayForKey:idX];\
                                       [[NSUserDefaults standardUserDefaults] synchronize];

#define USER_PLIST_GETstr(idX)         [[NSUserDefaults standardUserDefaults] stringForKey:idX];\
                                       [[NSUserDefaults standardUserDefaults] synchronize];

#define USER_PLIST_GETbool(idX)         [[NSUserDefaults standardUserDefaults] boolForKey:idX];\
                                        [[NSUserDefaults standardUserDefaults] synchronize];

//--------end
//#import "AppDelegate.h"
//#define DELEGATE_OF_APP  ((AppDelegate *)[[UIApplication sharedApplication] delegate])

//---date unility
#import "NSDate-Utilities.h"

//-------storyboard macro
#define MainSB [UIStoryboard storyboardWithName:@"Main" bundle:nil]
#define MainSB_New [UIStoryboard storyboardWithName:@"MainNew" bundle:nil]

//-------saidian Define
#define iwidth_screen      [[UIScreen mainScreen] bounds].size.width
#define iheight_screen     [[UIScreen mainScreen] bounds].size.height

#define iwidth_app      [[UIScreen mainScreen] applicationFrame].size.width
#define iheight_app     [[UIScreen mainScreen] applicationFrame].size.height
#define iapplicationFrame   CGRectMake(0, 0, [[UIScreen mainScreen] applicationFrame].size.width, [[UIScreen mainScreen] applicationFrame].size.height)

#define SPONIA_APPSTOREID                      @"KSponia_appstore_id"

#define KSponiaSettingPhoneReceiveNotice       @"SponiaPhoneReceiveNotice"

#pragma mark - 我收藏的是球队还是热门联赛
typedef enum SponiaMySaveType {
    SponiaMySaveTypeUnknow,
    SponiaMySaveTypeTeam,
    SponiaMySaveTypeLeague
}SponiaMySaveType;


#define  GetCurrVer    [[[NSBundle mainBundle] infoDictionary] objectForKeyOrNil:@"CFBundleVersion"]

#import "UIView+helper.h"

//com.sina.weibo.SNWeiboSDKDemo
#define kAppKey         @"3606220954"
#define kRedirectURI    @"http://www.sina.com"

//weixin
#define wAppKey         @"wx86ee26135ea28116"


#import "Reachability.h"
#define isViaWifi  [[Reachability reachabilityWithHostname:@"www.baidu.com"] isReachableViaWiFi]


#import "Chameleon.h"
#define RamFlatColor [UIColor randomFlatColor]

#define RamFlatColor_Shade(x) [UIColor colorWithRandomFlatColorOfShadeStyle:x]

#import "JBConstants.h"

//SDWEB  main use 
#import "UIImageView+WebCache.h"



//==>safely helper
#import "NSObject+safelyOrNil.h"
#import "NSDictionary+safelyWay.h"
#import "NSArray+objectSavely.h"
#import "NSMutableDictionary+safelyWay.h"
#import "NSMutableArray+objectSavely.h"
#import "egsFilter_KillNull.h"//


