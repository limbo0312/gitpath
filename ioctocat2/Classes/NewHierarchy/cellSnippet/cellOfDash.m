//
//  cellOfDash.m
//  iOctocat
//
//  Created by EGS on 14-8-8.
//
//

#import "cellOfDash.h"

#import "customPieView.h"
#import "xPieElement.h"


@implementation cellOfDash
{
    BOOL showPercent;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//==========key  method
//===生成图表   合成dataVisual
//
-(void)forceDataChart_skillInsight
{
    for(int year = 2009; year <= 2014; year++){
        
        xPieElement* elem = [xPieElement pieElementWithValue:(5+arc4random()%8)
                                                         color:RamFlatColor];
        
        
        elem.title = [NSString stringWithFormat:@"%d year", year];
        
        [self.pieView.layer addValues:@[elem] animated:NO];
    }
    
    //mutch easier do this with array outside
    showPercent = NO;
    self.pieView.layer.transformTitleBlock = ^(PieElement* elem, float percent){
        
        return [(xPieElement *)elem title];
    };
    
    
    self.pieView.layer.showTitles = ShowTitlesAlways;
    
}
-(void)forceDataChart_codeDesireInsight
{
    
    
}
-(void)forceDataChart_pushCountInsight
{
    
    
}


@end
