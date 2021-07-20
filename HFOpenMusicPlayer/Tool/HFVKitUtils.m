//
//  HFVUtils.m
//  LiveDemo5
//
//  Created by 灏 孙  on 2019/7/19.
//  Copyright © 2019 ZEGO. All rights reserved.
//

#import "HFVKitUtils.h"

@implementation HFVKitUtils

+ (NSBundle *)HFVKitBundle
{
    static NSBundle *HKBundle = nil;
    if (HKBundle == nil) {
        // 这里不使用mainBundle是为了适配pod 1.x和0.x
        HKBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[HFVKitUtils class]] pathForResource:@"MJRefresh" ofType:@"bundle"]];
    }
    return HKBundle;
}

//获取手机当前显示的ViewController
+ (UIViewController*)currentViewController {
    //UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController* vc = [self getCurrentWindow].rootViewController;
    while (1) {
        
        if ([vc isKindOfClass:[UITabBarController class]]) {
            
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}

//iOS获取顶层的控制器
+ (UIViewController *)appRootViewController {
    UIViewController *RootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = RootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

+ (nullable UIViewController *)getViewControllerIn:(UIView *)view {
    UIResponder *responder = view;
    while ((responder = [responder nextResponder])) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
    }
    return nil;
}

+ (CGFloat)screenWidth {
    return [UIScreen mainScreen].bounds.size.width;
}
+ (CGFloat)screenHeight {
    return [UIScreen mainScreen].bounds.size.height;
}
+ (CGFloat)statusHeight {
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}
+ (CGFloat)navHeight {
    return 44 + [self safeAreaTop];
}
+ (CGFloat)tabbarHeight {
    return 49 + [self safeAreaBottom];
}
+ (CGFloat)safeAreaTop {
    if (@available(iOS 11.0, *)) {
        //iOS 12.0以后的非刘海手机top为 20.0
        if ([UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom == 0) {
            return 20.0;
        }
        return [UIApplication sharedApplication].delegate.window.safeAreaInsets.top ? [UIApplication sharedApplication].delegate.window.safeAreaInsets.top : 20.0;
    }
    return 20.0;
}

+ (CGFloat)safeAreaBottom {
    if (@available(iOS 11.0, *)) {
        return [UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom;
    }
    return 0.0;
}


/// 获取当前window
+(UIWindow*)getCurrentWindow {
//    if ([UIApplication sharedApplication].keyWindow) {
//        return [UIApplication sharedApplication].keyWindow;
//    }else{
//        if(@available(iOS 13.0, *)) {
//            NSArray *array =[[[UIApplication sharedApplication] connectedScenes] allObjects];
//            UIWindowScene* windowScene = (UIWindowScene*)array[0];
//            //由于在sdk开发中，引入不了SceneDelegate的头文件，所以需要用kvc获取宿主app的window.
//
//            UIWindow* mainWindow = [windowScene valueForKeyPath:@"delegate.window"];
//            if(mainWindow) {
//                return mainWindow;
//            }else{
//                return [UIApplication sharedApplication].windows.lastObject;
//            }
//        }else{
//            return [UIApplication sharedApplication].keyWindow;
//        }
//    }
    if(@available(iOS 13.0, *)) {
        NSArray *array =[[[UIApplication sharedApplication] connectedScenes] allObjects];
        UIWindowScene* windowScene = (UIWindowScene*)array[0];
            //由于在sdk开发中，引入不了SceneDelegate的头文件，所以需要用kvc获取宿主app的window.

            UIWindow* mainWindow = [windowScene valueForKeyPath:@"delegate.window"];
        if(mainWindow) {
            return mainWindow;
        }else{
            return [UIApplication sharedApplication].windows.lastObject;
        }
    }else{
        return [UIApplication sharedApplication].keyWindow;
        }
}



// MARK:- loazing '.boudle' Image for sdk
/**
 设置图标 通过.boudle文件

 @param name 图标名称
 @return UIImage
 */
//+ (UIImage *)imageWithName:(NSString *)name;
+ (UIImage *)bundleImageWithName:(NSString *)name {
    NSBundle *bundle = [HFVKitUtils resourcesBundleWithName:@"HFOpenMusic.bundle"];
    return [HFVKitUtils imageInBundle:bundle withName:name];
}

+ (UIImage *)imageInBundle:(NSBundle *)bundle withName:(NSString *)name {
    if (bundle && name) {
        if ([UIImage respondsToSelector:@selector(imageNamed:inBundle:compatibleWithTraitCollection:)]) {
            return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
        } else {
            NSString *imagePath = [[bundle resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", name]];
            return [UIImage imageWithContentsOfFile:imagePath];
        }
    }
    return nil;
}
+ (NSBundle *)resourcesBundleWithName:(NSString *)bundleName {
    NSBundle *bundle = [NSBundle bundleWithPath: [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:bundleName]];
    if (!bundle) {
        // 动态framework的bundle资源是打包在framework里面的，所以无法通过mainBundle拿到资源，只能通过其他方法来获取bundle资源。
        NSBundle *frameworkBundle = [NSBundle bundleForClass:[self class]];
        NSDictionary *bundleData = [HFVKitUtils parseBundleName:bundleName];
        if (bundleData) {
            bundle = [NSBundle bundleWithPath:[frameworkBundle pathForResource:[bundleData objectForKey:@"name"] ofType:[bundleData objectForKey:@"type"]]];
        }
    }
    return bundle;
}
+ (NSDictionary *)parseBundleName:(NSString *)bundleName {
    NSArray *bundleData = [bundleName componentsSeparatedByString:@"."];
    if (bundleData.count == 2) {
        return @{@"name":bundleData[0], @"type":bundleData[1]};
    }
    return nil;
}


/// 获取错误信息
+ (NSString *)getErrorMessage:(NSDictionary *)info {
    
    NSString *errorString = @"";
    
    if ([[info allKeys] containsObject:@"msg"]) {
        errorString = [info valueForKey:@"msg"];
    }
//    if (errorString.length <= 0) {
//        errorString = @"服务器异常";
//    }
    return errorString;
}
+ (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (![string isKindOfClass:[NSString class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

@end


