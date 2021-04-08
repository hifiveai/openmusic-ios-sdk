//
//  HFVSlider.m
//  HFPlayer
//
//  Created by 郭亮 on 2021/3/28.
//

#import "HFVSlider.h"

@implementation HFVSlider

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(CGRect)trackRectForBounds:(CGRect)bounds {
    
    CGRect bo = [super trackRectForBounds:bounds];
    bo.size.height = KScale(1.5);
    bo.origin.y = (self.frame.size.height-KScale(1.5))/2;
    return bo;
    //return CGRectMake(0, 0, KScreenWidth, KScale(1.5));
}

@end
