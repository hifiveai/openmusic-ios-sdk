//  HFVMusicKit
//
//  Created by Pan on 2020/11/4.
//
//  UIColor 分类

#import <UIKit/UIKit.h>

@interface UIColor (PYExtension)
/** 根据16进制字符串返回对应颜色 */
+ (instancetype)py_colorWithHexString:(NSString *)hexString;

/** 根据16进制字符串返回对应颜色 带透明参数 */
+ (instancetype)py_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

@end
