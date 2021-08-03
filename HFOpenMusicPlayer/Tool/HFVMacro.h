//
//  HFVMacro.h
//
//  Created by Pan on 2020/11/3.
//  Copyright © 2019 pan. All rights reserved.
//

#ifndef HFVMacro
#define HFVMacro

#define KPageSize @"10"

#define KStatusHeight [UIApplication sharedApplication].statusBarFrame.size.height

#define KScreenWidth    [[UIScreen mainScreen] bounds].size.width
#define KScreenHeight   [[UIScreen mainScreen] bounds].size.height
#define HFV_STATUS_BAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height
#define HFV_IS_IPAD ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
#define HFV_NAVIGATION_BAR_HEIGHT ((HG_IS_IPAD ? 50 : 44) + HG_STATUS_BAR_HEIGHT)
#define HFV_RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define HFV_ONE_PIXEL (1 / [UIScreen mainScreen].scale)


//#define KBaseScale  KScreenWidth/375.0
#define KBaseScale  KScreenHeight/812.0
#define KScale(x) (x)*KBaseScale
#define KFont(x)     [UIFont systemFontOfSize:(x) * KBaseScale]
#define KBoldFont(x)     [UIFont boldSystemFontOfSize:(x) * KBaseScale]

#define KDismissDelay 1.9

#ifdef __OBJC__
    //RGB 颜色宏
    #define KColorHex(rgbValue) [UIColor \
    colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
    green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
    blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

    //RGB 颜色宏及透明度
    #define KColorHexWithAlpha(rgbValue,a) [UIColor \
    colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
    green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
    blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]
#endif



#define KWeakSelf(x)    __weak __typeof(self) x = self;
#define KStrongSelf(x)    __strong __typeof(weakSelf) strongSelf = weakSelf;


#define KBoundleImageName(x) [UIImage imageNamed:[NSString stringWithFormat:@"HFOpenMusic.bundle/%@", (x)]]



// 日志输出
#ifdef DEBUG
#define HFLog(...) NSLog(__VA_ARGS__)
#else
#define HFLog(...)
#endif


/**
 * 强弱引用转换，用于解决代码块（block）与强引用self之间的循环引用问题
 * 调用方式: `@weakify_self`实现弱引用转换，`@strongify_self`实现强引用转换
 *
 * 示例：
 * @weakify_self
 * [obj block:^{
 * @strongify_self
 * self.property = something;
 * }];
 */
#ifndef    weakify_self
#if __has_feature(objc_arc)
#define weakify_self autoreleasepool{} __weak __typeof__(self) weakSelf = self;
#else
#define weakify_self autoreleasepool{} __block __typeof__(self) blockSelf = self;
#endif
#endif
#ifndef    strongify_self
#if __has_feature(objc_arc)
#define strongify_self try{} @finally{} __typeof__(weakSelf) self = weakSelf;
#else
#define strongify_self try{} @finally{} __typeof__(blockSelf) self = blockSelf;
#endif
#endif
/**
 * 强弱引用转换，用于解决代码块（block）与强引用对象之间的循环引用问题
 * 调用方式: `@weakify(object)`实现弱引用转换，`@strongify(object)`实现强引用转换
 *
 * 示例：
 * @weakify(object)
 * [obj block:^{
 * @strongify(object)
 * strong_object = something;
 * }];
 */
#ifndef    weakify
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#endif
#ifndef    strongify
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) strong##_##object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) strong##_##object = block##_##object;
#endif
#endif



//MARK: - 错误信息
#define KErrorMessage(info)    (info).lenght > 0 ? (error).userInfo[@"msg"] : @"服务器异常"


//MARK: - 通知定义
#define KNotification_addLikeMusic @"KNotification_addLikeMusic"
#define KNotification_addKSongView @"KNotification_addKSongView"
#define KNotification_addContentPlay @"KNotification_addContentPlay"
#define KNotification_deleteCurrentPlay @"KNotification_deleteCurrentPlay"
#define KNotification_deleteOtherPlay @"KNotification_deleteOtherPlay"
#define KNotification_addAllMusicToContentPlay @"KNotification_addAllMusicToContentPlay"
#define KNotification_refreshMusicPlayStatus @"KNotification_refreshMusicPlayStatus"
#define KNotification_songListMoved @"KNotification_songListMoved"
#define KNotification_songUnserviceable @"KNotification_songUnserviceable"
#define KNotification_currentPlayingIndexChanegd @"KNotification_currentPlayingIndexChanegd"


#endif /* HGPersonalCenterMacro_h */
