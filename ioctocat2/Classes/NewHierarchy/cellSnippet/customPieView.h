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

@interface customPieView : UIView

@end

@interface customPieView (ex)
@property(nonatomic,readonly,strong) PieLayer *layer;
@end