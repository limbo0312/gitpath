//
//  UITableViewCell+xibCell.m
//  netWorkModule
//
//  Created by EGS on 13-8-8.
//  Copyright (c) 2013年 EGS. All rights reserved.
//

#import "UITableViewCell+xibCell.h"

@implementation UITableViewCell (xibCell)


+ (id)xibCell{
    NSArray *cellArr = [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:nil options:nil];
    for (id object in cellArr) {
        if ([object isKindOfClass:[self class]]) {
            return object;
        }
    }
    return nil;
}

+ (id)xibCell_2pos{
    NSArray *cellArr = [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:nil options:nil];
    
    if ([cellArr count]>=2) {
        id object = [cellArr objectAtIndex:1];
        
        if ([object isKindOfClass:[self class]])
            return object;
    }
    
    return nil;
}

+ (id)xibCell_3pos{
    NSArray *cellArr = [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:nil options:nil];
    
    if ([cellArr count]>=3) {
        id object = [cellArr objectAtIndex:2];
        
        if ([object isKindOfClass:[self class]])
            return object;
    }
    
    return nil;
}

+ (id)xibCell_4pos{
    NSArray *cellArr = [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:nil options:nil];
    
    if ([cellArr count]>=4) {
        id object = [cellArr objectAtIndex:3];
        
        if ([object isKindOfClass:[self class]])
            return object;
    }
    
    return nil;
}
+ (id)xibCell_5pos{
    NSArray *cellArr = [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:nil options:nil];
    
    if ([cellArr count]>=5) {
        id object = [cellArr objectAtIndex:4];
        
        if ([object isKindOfClass:[self class]])
            return object;
    }
    
    return nil;
}

@end
