//
//  webTextView.m
//  footballData
//
//  Created by EGS on 14-5-22.
//  Copyright (c) 2014年 www.kantai.co. All rights reserved.
//

#import "webTextView.h"

#define kMSTextViewFont [UIFont fontWithName:@"Helvetica" size:13]

static char *KVOMSTextViewTextDidChange = "KVOMSTViewTextDidChange";
static char *KVOMSTextViewFrameDidChange = "KVOMSTextViewFrameDidChange";

@interface webTextView (PrivateMethods)
- (void)       parseText;
- (NSString *) linkRegex;
- (CGFloat)    fontSize;
- (NSString *) fontName;
- (NSString *) embedHTMLWithFontName:(NSString *)fontName
                                size:(CGFloat)size
                                text:(NSString *)theText;
@end

@implementation webTextView

- (id)initWithFrame:(CGRect)frame :(trigerHandleUrlBlok)blok
{
    self.handleUrlBlok = blok;
    
   return  [self initWithFrame:frame];
}

- (id)init
{
    if ((self = [self initWithFrame:CGRectZero]))
    {
        
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
//    TREE_View(self);
//    [self parseText];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        /**
         *  关键初始话
         */
        self.aWebView = [[UIWebView alloc] initWithFrame:self.bounds];
        self.aWebView.opaque = NO;
        self.aWebView.backgroundColor = [UIColor clearColor];
        self.aWebView.delegate = self;
        [self addSubview:self.aWebView];
        
        self.font = kMSTextViewFont;
        
        for (id subview in self.aWebView.subviews)
        {
            // turn off scrolling in UIWebView
            if ([[subview class] isSubclassOfClass:[UIScrollView class]]) {
                ((UIScrollView *)subview).bounces = NO;
                ((UIScrollView *)subview).scrollEnabled = NO;
            }
            
            // make UIWebView transparent
            if ([subview isKindOfClass:[UIImageView class]])
                ((UIImageView *)subview).hidden = YES;
        }
        
        /*! Using Key-Value Observing/KVO to parse text after changing it */
        [self addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:KVOMSTextViewTextDidChange];
        
        /*! Using Key-Value Observing/KVO to change aWebView frame after changing MSTextView's frame */
        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:KVOMSTextViewFrameDidChange];
    }
    
    return self;
}

-(void)keyReInit_byXib
{
    self.aWebView = [[UIWebView alloc] initWithFrame:self.bounds];
    self.aWebView.opaque = NO;
    self.aWebView.backgroundColor = [UIColor clearColor];
    self.aWebView.delegate = self;
    [self addSubview:self.aWebView];
    
    self.font = kMSTextViewFont;
    
    for (id subview in self.aWebView.subviews)
    {
        // turn off scrolling in UIWebView
        if ([[subview class] isSubclassOfClass:[UIScrollView class]]) {
            ((UIScrollView *)subview).bounces = NO;
            ((UIScrollView *)subview).scrollEnabled = NO;
        }
        
        // make UIWebView transparent
        if ([subview isKindOfClass:[UIImageView class]])
            ((UIImageView *)subview).hidden = YES;
    }
    
    /*! Using Key-Value Observing/KVO to parse text after changing it */
    [self addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:KVOMSTextViewTextDidChange];
    
    /*! Using Key-Value Observing/KVO to change aWebView frame after changing MSTextView's frame */
    [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:KVOMSTextViewFrameDidChange];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if( navigationType == UIWebViewNavigationTypeLinkClicked )
    {
        if (self.handleUrlBlok) {
            self.handleUrlBlok(request.URL);
        }
        
        return NO;
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
#warning  载入文字后  webView reSize
    
    CGRect frame = webView.frame;
    frame.size.height = 1;
    webView.frame = frame;
    
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    
    if (self.frame.size.height < webView.frame.size.height)
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, webView.frame.size.height);
    
//    [self fitContentForWebviewResize];
    
    //egs  add
    {
//        NSString *string = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"body\").offsetHeight;"];
//        CGFloat height = [string floatValue] + 8;
//        CGRect frame = [webView frame];
//        frame.size.height = height;
//        [webView setFrame:frame];
        
        //Store the height in some dictionary and call [self.tableView beginUpdates] and [self.tableView endUpdates]
    }
}

//- (void)fitContentForWebviewResize
//{
//    for (UIView *subview in _aWebView.subviews)
//    {
//        NSLog(@"subview class %@", NSStringFromClass([subview class]));
//        if ([[subview class] isSubclassOfClass: [UIScrollView class]])
//        {
//            for (UIView *subview2 in subview.subviews)
//            {
//                NSLog(@"subview class %@", NSStringFromClass([subview2 class]));
//                if ([[subview2 class] isSubclassOfClass: NSClassFromString(@"UIWebBrowserView")])
//                {
//                    CGRect scrollFrame = subview2.frame;
//                    NSLog(@"%@", NSStringFromCGRect(scrollFrame));
//                    subview2.frame = CGRectMake(0, 0, _aWebView.frame.size.width, _aWebView.frame.size.height);
//                    ((UIScrollView *)subview).contentSize = _aWebView.frame.size;
//                    break;
//                }
//            }
//            CGRect scrollFrame = subview.frame;
//            NSLog(@"%@", NSStringFromCGRect(scrollFrame));
//            break;
//        }
//    }
//}

#pragma mark -
#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"text"])
    {
        //===主要耗时。。。。
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
            
            [self parseText];
            dispatch_async(dispatch_get_main_queue(), ^{ // 2
                
            });
            
        });
    }
    else if ([keyPath isEqualToString:@"frame"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{ // 2
            [self.aWebView setFrame:self.bounds];
            
//            [self.aWebView setScalesPageToFit:NO];
        });
        
    }

}

-(void)keyAction_parseText
{
    [self parseText];
}
-(void)keyAction_frameNew
{
    [self.aWebView setFrame:self.bounds];
}

#pragma mark -
#pragma mark Text Parsing
- (void)parseText
{
    if (_text==nil) 
        return;
    NSMutableString *theText = [NSMutableString stringWithString:_text];
    
//    =======下段为  耗时提取logic
    NSError *error = NULL;
//    NSRegularExpression *detector = [NSRegularExpression regularExpressionWithPattern:[self linkRegex] options:0 error:&error];
//    NSArray *links = [detector matchesInString:theText options:0 range:NSMakeRange(0, theText.length)];
//    NSMutableArray *current = [NSMutableArray arrayWithArray:links];
//    
//    for ( int i = 0; i < [links count]; i++ ) {
//        NSTextCheckingResult *cr = [current objectAtIndex:0];
//        NSString *url = [theText substringWithRange:cr.range];
//        
//        [theText replaceOccurrencesOfString:url
//                                 withString:[NSString stringWithFormat:@"<a href=\"%@\">%@</a>", url, url]
//                                    options:NSLiteralSearch
//                                      range:NSMakeRange(0, theText.length)];
//        
//        current = [NSMutableArray arrayWithArray:[detector matchesInString:theText options:0 range:NSMakeRange(0, theText.length)]];
//        [current removeObjectsInRange:NSMakeRange(0, ( (i+1) * 2 ))];
//    }
//    
//    [theText replaceOccurrencesOfString:@"\n" withString:@"<br />" options:NSLiteralSearch range:NSMakeRange(0, theText.length)];
    
    dispatch_async(dispatch_get_main_queue(), ^{ // 2
        [self.aWebView loadHTMLString:[self embedHTMLWithFontName:[self fontName]
                                                             size:[self fontSize]
                                                             text:theText]
                              baseURL:nil];
        [self.aWebView setFrame:self.bounds];
    });
    
}

#pragma mark -
#pragma mark UIFont

- (CGFloat) fontSize
{
    return [_font pointSize];
}

- (NSString *) fontName
{
    return [_font fontName];
}

#pragma mark -
#pragma mark embedHTML

- (NSString *) embedHTMLWithFontName:(NSString *)fontName
                                size:(CGFloat)size
                                text:(NSString *)theText
{
    NSString *embedHTML = @"\
    <html><head>\
    <style type=\"text/css\">\
    body { background-color:transparent;font-family: \"%@\";font-size: %gpx;color: black; word-wrap: break-word;}\
    a    { text-decoration:none; color:rgba(0,178,255,1); font-weight:bold;}\
    </style>\
    </head><body style=\"margin:0\">\
    %@\
    </body></html>";
    return [NSString stringWithFormat:embedHTML, fontName, size, theText];
}

#pragma mark -
#pragma mark Regex

- (NSString *)linkRegex
{
    return @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    
    //    return @"(http|https|www)[-a-zA-Z0-9@:%_+.~#?&//=]{2,256}.[a-z]{2,4}\b(/[-a-zA-Z0-9@:%_+.~#?&//=]*)?";
}



@end
