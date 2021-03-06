//  HFVMusicKit
//
//  Created by Pan on 2020/11/4.
//
//  UIView 分类

#import <UIKit/UIKit.h>

@interface UIView (PYExtension)
@property (nonatomic, assign) CGFloat py_x;
@property (nonatomic, assign) CGFloat py_y;
@property (nonatomic, assign) CGFloat py_centerX;
@property (nonatomic, assign) CGFloat py_centerY;
@property (nonatomic, assign) CGFloat py_width;
@property (nonatomic, assign) CGFloat py_height;
@property (nonatomic, assign) CGSize  py_size;
@property (nonatomic, assign) CGPoint py_origin;

/** 设置锚点 */
- (CGPoint)py_setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view;

/** 根据手势触摸点修改相应的锚点，就是沿着触摸点对self做相应的手势操作 */
- (CGPoint)py_setAnchorPointBaseOnGestureRecognizer:(UIGestureRecognizer *)gr;

@end
