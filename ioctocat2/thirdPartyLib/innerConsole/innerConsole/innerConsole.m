
#import "innerConsole.h"
#import <stdarg.h>
#import <string.h>

#import <objc/runtime.h>
#import <objc/message.h>
#import <dispatch/queue.h>

#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

#if ICONSOLE_USE_GOOGLE_STACK_TRACE
#import "GTMStackTrace.h"
#endif

#import "iOctocat.h"
#define DELEGATE_OF_APP  ((iOctocat *)[[UIApplication sharedApplication] delegate])

#define EDITFIELD_HEIGHT    28
#define ACTION_BUTTON_WIDTH 28
#define R_MAKE(X, Y, W, H) CGRectMake(X,Y,W,H)
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

#import "swizzOnNSURLConnection.h"

#define iConsoleKey @"innerConsoleLog"

#import <sys/sysctl.h>
#import <mach/mach.h>

//#import "NSString+Extensions.h"




@interface innerConsole() <UIActionSheetDelegate>

//1===>
@property (nonatomic, strong) UITextView     *consoleView;
@property (nonatomic, strong) UITextField    *inputField;
@property (nonatomic, strong) UIButton       *actionButton;
@property (nonatomic, strong) NSMutableArray *log_mArr;

@property (nonatomic, assign) BOOL           animating;

@property (nonatomic, assign) BOOL go_upDown;
@property (nonatomic, strong) UILabel        *RAM_Lbl;
- (void)saveSettings;

void exceptionHandler(NSException *exception);

//2===>

@end


@implementation innerConsole

#pragma mark Life cycle
+ (innerConsole *)sharedConsole
{
    @synchronized(self)
    {
        static innerConsole *sharedConsole = nil;
        if (sharedConsole == nil)
        {
            sharedConsole = [[self alloc] init];
        }
        return sharedConsole;
    }
}

//启用：内嵌控制台
-(void)enableConsoleMode
{
    id rootVC;
    if (DELEGATE_OF_APP.window.rootViewController!=nil) {
         rootVC = DELEGATE_OF_APP.window.rootViewController;
    }
    
    if (![DELEGATE_OF_APP.window isKindOfClass:[iConsoleWindow class]]) {
        
        DELEGATE_OF_APP.window = [[iConsoleWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        DELEGATE_OF_APP.window.rootViewController = rootVC;

    }
    else
    {
        [self performSelector:@selector(enableConsoleMode)
                   withObject:nil
                   afterDelay:3];
    }
}

#pragma mark -  Injection  the  connection
//启动：swizz urlConn
- (void)open_swizzURLConnection
{
    self.globalTrackUrl = NO;
    
    [swizzOnNSURLConnection injectIntoAllNSURLConnectionDelegateClasses];
}

#pragma mark --
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
	{
#if ICONSOLE_ADD_EXCEPTION_HANDLER
        NSSetUncaughtExceptionHandler(&exceptionHandler);
#endif
        _enabled       = YES;
        _logLevel      = iConsoleLogLevelInfo;
        _saveLogToDisk = YES;
        _maxLogItems   = 1000;
        
        _simulatorTouchesToShow = 2;
        _deviceTouchesToShow    = 3;
        _simulatorShakeToShow   = YES;
        _deviceShakeToShow      = NO;
        
        self.infoString = @"\n innerConsole: in fascinating vision--@若虚EGS \n inspired from iConsole&ponyDebugger&MARuntimeAPI";
        self.logSubmissionEmail = @"mw@kantai.co";//开发者mailFeedback
        
        self.backgroundColor = [UIColor blackColor];
        self.textColor       = [UIColor whiteColor];
        self.indicatorStyle  = UIScrollViewIndicatorStyleWhite;
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.log_mArr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:iConsoleKey]];
        
        if (&UIApplicationDidEnterBackgroundNotification != NULL)
        {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(saveSettings)
                                                         name:UIApplicationDidEnterBackgroundNotification
                                                       object:nil];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(saveSettings)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(rotateView:)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(resizeView:)
                                                     name:UIApplicationWillChangeStatusBarFrameNotification
                                                   object:nil];
	}
	return self;
}

- (void)viewDidLoad
{
    self.view.clipsToBounds = YES;
	self.view.backgroundColor = _backgroundColor;
	self.view.autoresizesSubviews = YES;
    self.view.alpha = 0.85;
    
    //1===>console View
    CGRect tempRect = R_MAKE(0, 0, 320, self.view.bounds.size.height);
    
	self.consoleView = ({
                            UITextView *tview =    [[UITextView alloc] initWithFrame:tempRect];
                            tview.font                           = [UIFont fontWithName:@"Courier" size:10];
                            tview.textColor                      = COLOR(101, 191, 107, 1);//_textColor;
                            tview.backgroundColor                = [UIColor blackColor];
                            tview.indicatorStyle                 = UIScrollViewIndicatorStyleWhite;//_indicatorStyle;
                            tview.editable                       = NO;
                            tview.autoresizingMask               = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
                            tview.showsHorizontalScrollIndicator = YES;
                            tview.showsVerticalScrollIndicator   = YES;
        
        
                             tview;
                        });
    

	[self setConsoleText];
	[self.view addSubview:_consoleView];
	
    //2===>main Btn
	self.actionButton = ({
        UIButton *btnT = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnT setTitle:@"⚙" forState:UIControlStateNormal];
        [btnT setTitleColor:_textColor forState:UIControlStateNormal];
        [btnT setTitleColor:[_textColor colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
        btnT.titleLabel.font = [btnT.titleLabel.font fontWithSize:ACTION_BUTTON_WIDTH];
        
        btnT.frame = CGRectMake(self.view.frame.size.width - ACTION_BUTTON_WIDTH - 5,
                                         self.view.frame.size.height - EDITFIELD_HEIGHT - 5 - 15,
                                         ACTION_BUTTON_WIDTH+8,
                                         EDITFIELD_HEIGHT+8);
        [btnT addTarget:self
                          action:@selector(infoAction_configure)
                forControlEvents:UIControlEventTouchUpInside];
        
        _actionButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        
        btnT;
    });
    
    
	[self.view addSubview:_actionButton];
	
    //3===>ram lable index
    self.RAM_Lbl = ({
        UILabel *lbl = [[UILabel alloc] initWithFrame:R_MAKE(0, 50, 320, 24)];
    
        lbl.backgroundColor = COLOR(0, 207, 150, 1);
        lbl.textColor = COLOR(226, 47, 121, 1);
        lbl.adjustsFontSizeToFitWidth = YES;
        lbl.alpha = 0.55;
        lbl;
    });
    [self.view addSubview:self.RAM_Lbl];


	[self.consoleView scrollRangeToVisible:NSMakeRange(self.consoleView.text.length, 0)];
}

- (void)viewDidUnload
{
	self.consoleView = nil;
	self.inputField = nil;
	self.actionButton = nil;
    
    [super viewDidUnload];
}


#pragma mark -
#pragma mark Public methods  log类型

+ (void)log:(NSString *)format arguments:(va_list)argList
{
	NSLogv(format, argList);
	
    if ([self sharedConsole].enabled)
    {
        NSString *message = [[NSString alloc] initWithFormat:format arguments:argList];
        
//        NSString *messageWithoutUnicode = [NSString stringByReplaceUnicode:message];//===>输出汉字的log
        
        if ([NSThread currentThread] == [NSThread mainThread])
        {
            [[self sharedConsole] logOnMainThread:message];
        }
        else
        {
            [[self sharedConsole] performSelectorOnMainThread:@selector(logOnMainThread:)
                                                   withObject:message
                                                waitUntilDone:NO];
        }
    }
}

+ (void)log:(NSString *)format, ...
{
    if ([self sharedConsole].logLevel >= iConsoleLogLevelNone)
    {
        va_list argList;
        va_start(argList,format);
        [self log:format arguments:argList];
        va_end(argList);
    }
}

+ (void)info:(NSString *)format, ...
{
    if ([self sharedConsole].logLevel >= iConsoleLogLevelInfo)
    {
        va_list argList;
        va_start(argList, format);
        [self log:[@"INFO: " stringByAppendingString:format] arguments:argList];
        va_end(argList);
    }
}

+ (void)warn:(NSString *)format, ...
{
	if ([self sharedConsole].logLevel >= iConsoleLogLevelWarning)
    {
        va_list argList;
        va_start(argList, format);
        [self log:[@"WARNING: " stringByAppendingString:format] arguments:argList];
        va_end(argList);
    }
}

+ (void)error:(NSString *)format, ...
{
    if ([self sharedConsole].logLevel >= iConsoleLogLevelError)
    {
        va_list argList;
        va_start(argList, format);
        [self log:[@"ERROR: " stringByAppendingString:format] arguments:argList];
        va_end(argList);
    }
}

+ (void)crash:(NSString *)format, ...
{
    if ([self sharedConsole].logLevel >= iConsoleLogLevelCrash)
    {
        va_list argList;
        va_start(argList, format);
        [self log:[@"CRASH: " stringByAppendingString:format] arguments:argList];
        va_end(argList);
    }
}

+ (void)clear
{
	[[innerConsole sharedConsole] resetLog];
}

+ (void)show
{
	[[innerConsole sharedConsole] showConsole];
}

+ (void)hide
{
	[[innerConsole sharedConsole] hideConsole];
}

#pragma mark -- private helper method
- (void)resetLog
{
	self.log_mArr = [NSMutableArray array];
	[self setConsoleText];
}
- (void)showConsole
{
	if (!_animating && self.view.superview == nil)
	{
        [self setConsoleText];
        
		[self findAndResignFirstResponder:[self mainWindow]];
		
		[innerConsole sharedConsole].view.frame = [self offscreenFrame];
		[[self mainWindow] addSubview:[innerConsole sharedConsole].view];
		
		_animating = YES;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(consoleShown)];
		[innerConsole sharedConsole].view.frame = [self onscreenFrame];
        [innerConsole sharedConsole].view.transform = [self viewTransform];
		[UIView commitAnimations];
	}

        //===update info on RAM
    self.RAM_Lbl.text = [NSString   stringWithFormat:@"MEMO_available is %f, MEMO_used is %f",[self availableMemory],[self usedMemory]];
}
- (void)hideConsole
{
	if (!_animating && self.view.superview != nil)
	{
		[self findAndResignFirstResponder:[self mainWindow]];
		
		_animating = YES;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(consoleHidden)];
		[innerConsole sharedConsole].view.frame = [self offscreenFrame];
		[UIView commitAnimations];
	}
}

- (NSString *)URLEncodedString:(NSString *)string
{
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, CFSTR("!*'\"();:@&=+$,/?%#[]% "), kCFStringEncodingUTF8));
}

#pragma mark Private methods

void exceptionHandler(NSException *exception)
{
	
#if ICONSOLE_USE_GOOGLE_STACK_TRACE
    extern NSString *GTMStackTraceFromException(NSException *e);
    [innerConsole crash:@"%@\n\nStack trace:\n%@)", exception, GTMStackTraceFromException(exception)];
#else
	[innerConsole crash:@"%@", exception];
#endif
	[[innerConsole sharedConsole] saveSettings];
}

+ (void)load
{
    //initialise the console
    [innerConsole performSelectorOnMainThread:@selector(sharedConsole) withObject:nil waitUntilDone:NO];
}

- (UIWindow *)mainWindow
{
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)])
    {
        return [app.delegate window];
    }
    else
    {
        return [app keyWindow];
    }
}

- (void)setConsoleText
{
	NSString *text = _infoString;//EGS note word
    
	int touches = (TARGET_IPHONE_SIMULATOR ? _simulatorTouchesToShow: _deviceTouchesToShow);
	if (touches > 0 && touches < 11)
	{
		text = [text stringByAppendingFormat:@"\nSwipe down with %i finger%@ to hide console", touches, (touches != 1)? @"s": @""];
	}
	else if (TARGET_IPHONE_SIMULATOR ? _simulatorShakeToShow: _deviceShakeToShow)
	{
		text = [text stringByAppendingString:@"\nShake device to hide console"];
	}
    
    
	text = [text stringByAppendingString:@"\n--------------------------------------\n--------------------------------------\n"];
	text = [text stringByAppendingString:[[_log_mArr arrayByAddingObject:@"$$$$$$======> "] componentsJoinedByString:@"\n"]];
    
	_consoleView.text = text;
	
    if (!_go_upDown)
        [_consoleView scrollRangeToVisible:NSMakeRange(_consoleView.text.length, 0)];
}



- (void)saveSettings
{
    if (_saveLogToDisk)
    {
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (BOOL)findAndResignFirstResponder:(UIView *)view
{
    if ([view isFirstResponder])
	{
        [view resignFirstResponder];
        return YES;
    }
    for (UIView *subview in view.subviews)
	{
        if ([self findAndResignFirstResponder:subview])
        {
			return YES;
		}
    }
    return NO;
}

//action sheet init
- (void)infoAction_configure
{
	[self findAndResignFirstResponder:[self mainWindow]];
	
	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@""
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:@"Clear Log"
                                              otherButtonTitles:@"report Email",@"dumpCurrView",@"dumpUserPlist",@"trackUrl_OnOff",@"Scroll_UpDown",@"Quit", nil];
    
	sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[sheet showInView:self.view];
}

- (CGAffineTransform)viewTransform
{
	CGFloat angle = 0;
	switch ([UIApplication sharedApplication].statusBarOrientation)
    {
        case UIInterfaceOrientationPortrait:
            angle = 0;
            break;
		case UIInterfaceOrientationPortraitUpsideDown:
			angle = M_PI;
			break;
		case UIInterfaceOrientationLandscapeLeft:
			angle = -M_PI_2;
			break;
		case UIInterfaceOrientationLandscapeRight:
			angle = M_PI_2;
			break;
	}
	return CGAffineTransformMakeRotation(angle);
}

- (CGRect)onscreenFrame
{
	return [UIScreen mainScreen].bounds;
}

- (CGRect)offscreenFrame
{
	CGRect frame = [self onscreenFrame];
	switch ([UIApplication sharedApplication].statusBarOrientation)
    {
		case UIInterfaceOrientationPortrait:
			frame.origin.y = frame.size.height;
			break;
		case UIInterfaceOrientationPortraitUpsideDown:
			frame.origin.y = -frame.size.height;
			break;
		case UIInterfaceOrientationLandscapeLeft:
			frame.origin.x = frame.size.width;
			break;
		case UIInterfaceOrientationLandscapeRight:
			frame.origin.x = -frame.size.width;
			break;
	}
	return frame;
}

- (void)consoleShown
{
	_animating = NO;
	[self findAndResignFirstResponder:[self mainWindow]];
}

- (void)consoleHidden
{
	_animating = NO;
	[[[innerConsole sharedConsole] view] removeFromSuperview];
}

- (void)rotateView:(NSNotification *)notification
{
	self.view.transform = [self viewTransform];
	self.view.frame = [self onscreenFrame];
	
}

- (void)resizeView:(NSNotification *)notification
{
	CGRect frame = [[notification.userInfo valueForKey:UIApplicationStatusBarFrameUserInfoKey] CGRectValue];
	CGRect bounds = [UIScreen mainScreen].bounds;
	switch ([UIApplication sharedApplication].statusBarOrientation)
    {
		case UIInterfaceOrientationPortrait:
			bounds.origin.y += frame.size.height;
			bounds.size.height -= frame.size.height;
			break;
		case UIInterfaceOrientationPortraitUpsideDown:
			bounds.size.height -= frame.size.height;
			break;
		case UIInterfaceOrientationLandscapeLeft:
			bounds.origin.x += frame.size.width;
			bounds.size.width -= frame.size.width;
			break;
		case UIInterfaceOrientationLandscapeRight:
			bounds.size.width -= frame.size.width;
			break;
	}
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.35];
	self.view.frame = bounds;
	[UIView commitAnimations];
}


- (void)logOnMainThread:(NSString *)message
{
    //===>排除:异常error的非法输出符号
    NSString *strAppend;
    @try {
        if (message==nil)
            return;
        
        strAppend = [@"$$$$$$======> " stringByAppendingString:message];
    }
    @catch (NSException *exception) {
        NSLog(@"exception on innerConsole output %@",exception);
    }
    
    
    //===newMsg info append
	[_log_mArr addObject:strAppend];
	if ([_log_mArr count] > _maxLogItems)
	{
		[_log_mArr removeObjectAtIndex:0];
	}
    [[NSUserDefaults standardUserDefaults] setObject:_log_mArr forKey:iConsoleKey];
    if (self.view.superview)
    {
        [self setConsoleText];
    }
}


#pragma mark UIActionSheetDelegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == actionSheet.destructiveButtonIndex)
	{
		[innerConsole clear];
	}
	else if (buttonIndex == 1)//send by mail
	{
        NSString *URLSafeName = [self URLEncodedString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]];
        NSString *URLSafeLog = [self URLEncodedString:[_log_mArr componentsJoinedByString:@"\n"]];
        NSMutableString *URLString = [NSMutableString stringWithFormat:@"mailto:%@?subject=%@%%20Console%%20Log&body=%@",
                                      _logSubmissionEmail ?: @"", URLSafeName, URLSafeLog];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
	}
    else if(buttonIndex == 2)//显示当前VC.view 的结果
    {
        if ([DELEGATE_OF_APP.window.rootViewController isKindOfClass:[UINavigationController class]]) {//navVC
//            UINavigationController *navVC = (UINavigationController *)DELEGATE_OF_APP.window.rootViewController;
//            TREE_View(navVC.topViewController.view);
        }
        else if ([DELEGATE_OF_APP.window.rootViewController isKindOfClass:[UITabBarController  class]])//tabbarVC
        {
//            UITabBarController *tabVC = (UITabBarController *)DELEGATE_OF_APP.window.rootViewController;
//            TREE_View(tabVC.selectedViewController.view);
        }
        else  //elseVC
        {
//            TREE_View(DELEGATE_OF_APP.window.rootViewController.view);
        }
        
    }
    else if(buttonIndex == 3)//dump userPlist
    {
        NSUserDefaults *stanPlist = [NSUserDefaults standardUserDefaults];
        NSDictionary *dicUser = [stanPlist dictionaryRepresentation];
        NSMutableDictionary *mDicUser = [NSMutableDictionary dictionaryWithDictionary:dicUser];
        [mDicUser removeObjectForKey:iConsoleKey];
        [mDicUser removeObjectForKey:@"iConsoleLog"];
        
        DebugLog_Ver2(@"stanUserPlist:%@",mDicUser);
        
    }
    else if(buttonIndex == 4)//====>trackURL action
    {
        self.globalTrackUrl = !_globalTrackUrl;
        
        [innerConsole clear];
        
        DebugLog_Ver2(@"globalTrackUrl will be %d",_globalTrackUrl);
        
    }
    else if(buttonIndex == 5)//====Scroll_UpDown
    {
        _go_upDown = !_go_upDown;
        if (_go_upDown) {
            [self.consoleView setContentOffset:CGPointMake(0, 0) animated:NO];
        }
        DebugLog_Ver2(@"Scroll_UpDown will be %d",_go_upDown);
        

    }
    else if(buttonIndex == 6)//退出console
    {
        [innerConsole hide];
    }
    else if(buttonIndex == actionSheet.cancelButtonIndex)
    {
        
    }
    
    if (buttonIndex != 5) {
        _go_upDown = NO;
    }
}


#pragma mark --memoinfo group
// 获取当前设备可用内存(单位：MB）
- (double)availableMemory
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }

    
    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0;
}

// 获取当前任务所占用的内存（单位：MB）
- (double)usedMemory
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS
        ) {
        return NSNotFound;
    }
    
    return taskInfo.resident_size / 1024.0 / 1024.0;
}

@end

//===2
@implementation iConsoleWindow

- (void)sendEvent:(UIEvent *)event
{
	if ([innerConsole sharedConsole].enabled && event.type == UIEventTypeTouches)
	{
		NSSet *touches = [event allTouches];
		if ([touches count] == (TARGET_IPHONE_SIMULATOR ? [innerConsole sharedConsole].simulatorTouchesToShow: [innerConsole sharedConsole].deviceTouchesToShow))
		{
            BOOL allUp    = YES;
            BOOL allDown  = YES;
            BOOL allLeft  = YES;
            BOOL allRight = YES;
			
			for (UITouch *touch in touches)
			{
				if ([touch locationInView:self].y <= [touch previousLocationInView:self].y)
				{
					allDown = NO;
				}
				if ([touch locationInView:self].y >= [touch previousLocationInView:self].y)
				{
					allUp = NO;
				}
				if ([touch locationInView:self].x <= [touch previousLocationInView:self].x)
				{
					allLeft = NO;
				}
				if ([touch locationInView:self].x >= [touch previousLocationInView:self].x)
				{
					allRight = NO;
				}
			}
			
			switch ([UIApplication sharedApplication].statusBarOrientation)
            {
				case UIInterfaceOrientationPortrait:
                {
					if (allUp)
					{
						[innerConsole show];
					}
					else if (allDown)
					{
						[innerConsole hide];
					}
					break;
                }
				case UIInterfaceOrientationPortraitUpsideDown:
                {
					if (allDown)
					{
						[innerConsole show];
					}
					else if (allUp)
					{
						[innerConsole hide];
					}
					break;
                }
				case UIInterfaceOrientationLandscapeLeft:
                {
					if (allRight)
					{
						[innerConsole show];
					}
					else if (allLeft)
					{
						[innerConsole hide];
					}
					break;
                }
				case UIInterfaceOrientationLandscapeRight:
                {
					if (allLeft)
					{
						[innerConsole show];
					}
					else if (allRight)
					{
						[innerConsole hide];
					}
					break;
                }
			}
		}
	}

    //global catch exception
    @try {
        [super sendEvent:event];
    }
    @catch (NSException *exception) {
        
        
        NSString *exceptionSTinfo = [NSString stringWithFormat:@"%@\n\nStack trace:\n%@)", exception, GTMStackTraceFromException(exception)];
        DebugLog_Ver2(@"exception == %@",exceptionSTinfo);
//        [EAlertView showWithMsg:[NSString stringWithFormat:@"whew...碰上妖怪了，请邮件发送异常信息给开发者EGS(mw@kantai.co)。%@",exceptionSTinfo]
//                          block:^(int btnIndex) {
//                              if (btnIndex==0) {
//                                  NSString *URLSafeName = [[innerConsole sharedConsole] URLEncodedString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]];
//                                  NSString *URLSafeLog = [[innerConsole sharedConsole] URLEncodedString:[[innerConsole sharedConsole].log_mArr componentsJoinedByString:@"\n"]];
//                                  NSMutableString *URLString = [NSMutableString stringWithFormat:@"mailto:%@?subject=%@%%20Console%%20Log&body=%@",
//                                                                [innerConsole sharedConsole].logSubmissionEmail ?: @"", URLSafeName, URLSafeLog];
//                                  
//                                  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
//                              }
//                          }];
    }

}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	
    if ([innerConsole sharedConsole].enabled &&
        (TARGET_IPHONE_SIMULATOR ? [innerConsole sharedConsole].simulatorShakeToShow: [innerConsole sharedConsole].deviceShakeToShow))
    {
        if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake)
        {
            if ([innerConsole sharedConsole].view.superview == nil)
            {
                [innerConsole show];
            }
            else
            {
                [innerConsole hide];
            }
        }
	}
	[super motionEnded:motion withEvent:event];
}

@end
