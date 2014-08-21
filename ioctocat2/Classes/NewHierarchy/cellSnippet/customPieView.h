//
//  customPieView.h
//  iOctocat
//
//  Created by EGS on 14-8-8.
//
//

#import <UIKit/UIKit.h>


#import "PieLayer.h"


//@class PieLayer;
@class PieElement;
typedef void(^tapOnPieBlok)(PieElement* elem);


@interface customPieView : UIView

@property(nonatomic,strong)tapOnPieBlok blok;

@end

@interface customPieView (ex)

@property(nonatomic,readonly,strong) PieLayer *layer;



@end