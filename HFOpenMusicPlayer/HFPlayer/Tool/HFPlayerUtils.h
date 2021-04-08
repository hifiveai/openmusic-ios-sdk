//
//  HFVUtils.h
//  LiveDemo5
//
//  Created by 灏 孙  on 2019/7/19.
//  Copyright © 2019 ZEGO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HFPlayerUtils : NSObject

+ (NSBundle *)HFVKitBundle;

//获取手机当前显示的ViewController
+ (UIViewController*)currentViewController;
//iOS获取顶层的控制器
+ (UIViewController *)appRootViewController;
// view所在的VC
+ (nullable UIViewController *)getViewControllerIn:(UIView *)view ;

+ (CGFloat)screenWidth;
+ (CGFloat)screenHeight;
+ (CGFloat)statusHeight;
+ (CGFloat)navHeight;
+ (CGFloat)tabbarHeight;
+ (CGFloat)safeAreaTop;
+ (CGFloat)safeAreaBottom;
/// 获取当前window
+(UIWindow*)getCurrentWindow;

/**
设置图标 通过.boudle文件
@param name 图标名称
@return UIImage
*/
+ (UIImage *)bundleImageWithName:(NSString *)name;

/// 获取错误信息
+ (NSString *)getErrorMessage:(NSDictionary *)info;


+ (BOOL)isBlankString:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
