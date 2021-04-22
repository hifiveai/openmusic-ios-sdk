//
//  HFPlayerConfiguration.h
//  HFPlayer
//
//  Created by 郭亮 on 2021/1/15.
//

#import <Foundation/Foundation.h>

@interface HFPlayerConfiguration : NSObject

//播放器媒体URL字符串
@property(nonatomic ,strong) NSString                                            *urlString;
//自动播放下一首(默认开启)
@property(nonatomic ,assign) BOOL                                                autoNext;
//拖拽范围，距离顶部距离
@property(nonatomic ,assign) NSUInteger                                          panTopLimit;
//拖拽范围，距离底部距离
@property(nonatomic ,assign) NSUInteger                                          panBottomLimit;
//歌曲图片URL字符串
@property(nonatomic ,copy) NSString                                              *imageUrlString;
//歌曲名字
@property(nonatomic ,copy) NSString                                              *songName;
//是否可以切歌
@property(nonatomic ,assign) BOOL                                                canCutSong;
//musicId
@property(nonatomic ,copy) NSString                                               *musicId;






//----用户对播放器配置----(用户是否允许后台播放，后台网络请求播放，循环播放)
//是否允许客户端缓存(默认关闭)
@property(nonatomic ,assign) BOOL                                                cacheEnable;
//缓冲区大小(默认2M)
@property(nonatomic ,assign) NSUInteger                                          bufferCacheSize;
//是否允许重复播放(默认开启)
@property(nonatomic ,assign) BOOL                                                repeatPlay;
//是否开启网络监测,断线重连播放(默认开启)
@property(nonatomic ,assign) BOOL                                                networkAbilityEable;
//播放速率(默认1.0)
@property(nonatomic ,assign) float                                               rate;



+(HFPlayerConfiguration *)defaultConfiguration;

@end

