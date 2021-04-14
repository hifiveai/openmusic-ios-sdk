//
//  HFOpenMusicPlayerConfiguration.h
//  HFOpenMusicPlayer
//
//  Created by 郭亮 on 2021/4/13.
//

#import <Foundation/Foundation.h>

@interface HFOpenMusicPlayerConfiguration : NSObject

//自动播放下一首(默认开启)
@property(nonatomic ,assign) BOOL                                                autoNext;
//拖拽范围，距离顶部距离
@property(nonatomic ,assign) NSUInteger                                          panTopLimit;
//拖拽范围，距离底部距离
@property(nonatomic ,assign) NSUInteger                                          panBottomLimit;

//----用户对播放器配置----(用户是否允许后台播放，后台网络请求播放，循环播放)
//是否允许客户端缓存(默认关闭)
@property(nonatomic ,assign) BOOL                                                cacheEnable;
//缓冲区大小(默认2M)
@property(nonatomic ,assign) NSUInteger                                          bufferCacheSize;
//预缓冲区大小
@property(nonatomic ,assign) NSUInteger                                          advanceBufferCacheSize;
//是否允许重复播放(默认开启)
@property(nonatomic ,assign) BOOL                                                repeatPlay;
//是否开启网络监测,断线重连播放(默认开启)
@property(nonatomic ,assign) BOOL                                                networkAbilityEable;
//播放速率(默认1.0)
@property(nonatomic ,assign) float                                               rate;
//是否允许后台缓冲数据(默认开启)
@property(nonatomic ,assign) BOOL                                                bkgLoadingEnable;
//播放器自动缓冲数据(默认开启)
@property(nonatomic ,assign) BOOL                                                autoLoad;



+(HFOpenMusicPlayerConfiguration *)defaultConfiguration;

@end


