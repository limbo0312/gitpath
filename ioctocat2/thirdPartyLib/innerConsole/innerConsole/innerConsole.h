

#import <UIKit/UIKit.h>
#import <Availability.h>

#undef weak_delegate
#if __has_feature(objc_arc_weak)
#define weak_delegate weak
#else
#define weak_delegate unsafe_unretained
#endif


#define ICONSOLE_ADD_EXCEPTION_HANDLER 1 //add automatic crash logging
#define ICONSOLE_USE_GOOGLE_STACK_TRACE 1 //use GTM functions to improve stack trace


typedef enum
{
    iConsoleLogLevelNone = 0,
    iConsoleLogLevelCrash,
    iConsoleLogLevelError,
    iConsoleLogLevelWarning,
    iConsoleLogLevelInfo
}
iConsoleLogLevel;


@interface innerConsole : UIViewController

//enabled/disable console features
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) BOOL saveLogToDisk;
@property (nonatomic, assign) NSUInteger maxLogItems;
@property (nonatomic, assign) iConsoleLogLevel logLevel;

//console activation
@property (nonatomic, assign) NSUInteger simulatorTouchesToShow;
@property (nonatomic, assign) NSUInteger deviceTouchesToShow;
@property (nonatomic, assign) BOOL simulatorShakeToShow;
@property (nonatomic, assign) BOOL deviceShakeToShow;

//branding and feedback
@property (nonatomic, copy) NSString *infoString;
@property (nonatomic, copy) NSString *logSubmissionEmail;

//styling
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) UIScrollViewIndicatorStyle indicatorStyle;

@property (assign,nonatomic) BOOL globalTrackUrl;//默认，不输出urlAction info

//main fetrues===
+ (innerConsole *)sharedConsole;
- (void)enableConsoleMode;//启用：内嵌控制台
- (void)open_swizzURLConnection;//启动：swizz urlConnection



//main methods===
+ (void)log:(NSString *)format, ...;
+ (void)info:(NSString *)format, ...;
+ (void)warn:(NSString *)format, ...;
+ (void)error:(NSString *)format, ...;
+ (void)crash:(NSString *)format, ...;
//===
+ (void)clear;
+ (void)show;
+ (void)hide;

@end


@interface iConsoleWindow : UIWindow

@end