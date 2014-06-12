//
//  UIView+treeStruct.m
//  testNav
//
//  Created by Engels on 13-11-7.
//  Copyright (c) 2013年 smartscreen. All rights reserved.
//

#import "UIView+treeStruct.h"

@implementation UIView (treeStruct)


+ (void)dumpView:(UIView *)view atIndent:(int)indent into:(NSMutableString *)outstring {
    for (int i = 0; i < indent; i++)
        [outstring appendString:@"--"];
    
    NSString *viewDesc = [[view class] description];
    
    [outstring appendFormat:@"[%2d] %@ - %@\n", indent, viewDesc, NSStringFromCGRect([view frame])];
    
    if ([viewDesc isEqualToString:@"UIWebView"]
        || [viewDesc isEqualToString:@"_UIWebViewScrollView"])//过滤:webView
        return;
    
    for (UIView *subview in [view subviews])
    {
        if ([subview respondsToSelector:@selector(prepareForReuse)]) {
            continue;//note: notDump cellView
        }
        [self dumpView:subview atIndent:indent + 1 into:outstring];
    }

}

+ (NSString *)treeViewStruct: (UIView *)view {
    NSMutableString *outstring = [[NSMutableString alloc] initWithString:@"\n"];
    [self dumpView:view atIndent:0 into:outstring];
    
    DebugLog_Ver2(@"%@",outstring);
    return outstring;
}

+ (UIView *)treeViewGet:(id)viewType
                       :(UIView *)fatView
{
    for (UIView *subview1 in [fatView subviews]) {
        if ([subview1 isKindOfClass:[viewType class]])
            return subview1;
        
        if ([subview1 subviews]!=0)
            for (UIView *subview2 in [subview1 subviews]) {
                if ([subview2 isKindOfClass:[viewType class]])
                    return subview2;
                
                if ([subview2 subviews]!=0)
                    for (UIView *subview3 in [subview2 subviews]) {
                        if ([subview3 isKindOfClass:[viewType class]])
                            return subview3;
                    }
            }
            
        
    }
    return nil;
}
@end
