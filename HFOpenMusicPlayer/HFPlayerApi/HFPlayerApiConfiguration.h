//
//  HFPlayerApiConfiguration.h
//  HFPlayer
//
//  Created by 郭亮 on 2021/1/15.
//

#import <Foundation/Foundation.h>

@interface HFPlayerApiConfiguration : NSObject

//----用户对播放器配置----(用户是否允许后台播放，后台网络请求播放，循环播放)

//是否允许客户端缓存(默认关闭)
@property(nonatomic ,assign)BOOL                       cacheEnable;
//缓冲区大小(默认2M)
@property(nonatomic ,assign)NSUInteger                 bufferCacheSize;
//是否允许重复播放(默认开启)
@property(nonatomic ,assign)BOOL                       repeatPlay;
//是否开启网络监测,断线重连播放(默认开启)
@property(nonatomic ,assign)BOOL                       networkAbilityEable;
//播放速率(默认1.0)
@property(nonatomic ,assign)float                      rate;


+(HFPlayerApiConfiguration *)defaultConfiguration;

@end

