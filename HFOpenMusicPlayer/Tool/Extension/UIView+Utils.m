//
//  UIView+Utils.m
//  HFVMusicKit
//
//  Created by Pan on 2020/11/6.
//

#import "UIView+Utils.h"

@implementation UIView (Utils)

- (void)setRadiusWithRadius:(CGFloat)radius corner:(UIRectCorner)corner {
    
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = path.CGPath;
    self.layer.mask = maskLayer;
}

@end
