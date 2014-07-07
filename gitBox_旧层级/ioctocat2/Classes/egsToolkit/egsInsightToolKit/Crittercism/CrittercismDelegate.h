//
//  CrittercismDelegate.h
//  Crittercism-iOS
//
//  Created by Sean Hermany on 10/19/12.
//  Copyright (c) 2012 Crittercism. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CrittercismDelegate <NSObject>

@optional
- (void)crittercismDidClose;
- (void)crittercismDidCrashOnLastLoad;
@end
