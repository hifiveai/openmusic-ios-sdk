//
//  HFVSlider.m
//  HFPlayer
//
//  Created by 郭亮 on 2021/3/28.
//

#import "HFVSlider.h"

@implementation HFVSlider

-(CGRect)trackRectForBounds:(CGRect)bounds {
    
    CGRect bo = [super trackRectForBounds:bounds];
    bo.size.height = KScale(1.5);
    bo.origin.y = (self.frame.size.height-KScale(1.5))/2;
    return bo;
}

@end
