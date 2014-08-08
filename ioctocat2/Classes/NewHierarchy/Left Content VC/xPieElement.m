//
//  xPieElement.m
//  iOctocat
//
//  Created by EGS on 14-8-8.
//
//

#import "xPieElement.h"

@implementation xPieElement


- (id)copyWithZone:(NSZone *)zone
{
    xPieElement *copyElem = [super copyWithZone:zone];
    copyElem.title = self.title;
    
    return copyElem;
}


@end
