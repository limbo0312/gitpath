//
//  UIView+helper.m
//  egsFramework
//
//  Created by Engels on 14-4-19.
//  Copyright (c) 2014年 EGS. All rights reserved.
//

#import "UIView+helper.h"

@implementation UIView (helper)

#pragma mark - CGRect & CGSize
- (CGPoint)origin {
    return self.frame.origin;
}

- (float)width {
    return self.frame.size.width;
}

- (float)height {
    return self.frame.size.height;
}

- (float)xOrigin {
    return self.frame.origin.x;
}

- (float)yOrigin {
    return self.frame.origin.y;
}

@end
