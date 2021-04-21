//
//  HFPlayerApi.h
//  HFPlayerApi
//
//  Created by 郭亮 on 2021/3/16.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreMedia/CMTime.h>
#import <AVFoundation/AVFoundation.h>
//#import <HFPlayerApi/HFPlayerApiConfiguration.h>
#import "HFPlayerApiConfiguration.h"
//! Project version number for HFPlayerApi.
FOUNDATION_EXPORT double HFPlayerApiVersionNumber;

//! Project version string for HFPlayerApi.
FOUNDATION_EXPORT const unsigned char HFPlayerApiVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <HFPlayerApi/PublicHeader.h>


typedef NS_ENUM(NSInteger, HFPlayerStatus) {
    HFPlayerStatusInit = 2000,
    HFPlayerStatusUnknow = 2001,
    HFPlayerStatusReadyToPlay = 2002,
    HFPlayerStatusPlaying = 2003,
    HFPlayerStatusPasue = 2004,
    HFPlayerStatusBufferEmpty = 2005,
    HFPlayerStatusBufferKeepUp = 2006,
    HFPlayerStatusFailed = 2007,
    HFPlayerStatusFinished = 2008,
    HFPlayerStatusStoped = 2009,
    HFPlayerStatusError = 2010
};



@protocol HFPlayerStatusProtocol <NSObject>

@optional

/// 播放器状态更新回调
/// @params status 播放器当前状态
-(void)playerStatusChanged:(HFPlayerStatus) status;

/// 播放进度回调
/// @params progress 进度
/// @params currentDuration 当前播放时长
/// @params totalDuration 媒体资源总时长
-(void)playerPlayProgress:(float)progress currentDuration:(float)currentDuration totalDuration:(float)totalDuration;

/// 数据缓冲进度回调
/// @params progress 缓冲进度
-(void)playerLoadingProgress:(float)progress;

/// 播放器遇到数据缓冲
-(void)playerLoadingBegin;

/// 播放器数据缓冲结束，继续播放
-(void)playerLoadingEnd;

/// 播放完成回调
-(void)playerPlayToEnd;


@end

@interface HFPlayerApi : NSObject

@property(nonatomic ,weak)id <HFPlayerStatusProtocol>                         delegate;


/// 初始化播放器
/// @params url 音频资源url
/// @params config 播放器配置(可传nil，nil则表示默认配置)
-(instancetype)initPlayerWtihUrl:(NSURL *_Nonnull)url configuration:(HFPlayerApiConfiguration * _Nonnull)config;

/// 切换播放
/// @params url 音频资源url
/// @params config 播放器配置(可传nil，nil则表示保持当前配置)
-(void)replaceCurrentUrlWithUrl:(NSURL *_Nonnull)url configuration:(HFPlayerApiConfiguration * _Nullable )config;

/// 加载媒体资源数据
-(void)loadMediaData;

//设置播放器视图(视频播放需要配置播放器试图，音频不需要调用此方法)
-(void)setPlayerView:(UIView *_Nonnull)view;

/// 开始播放
-(void)play;

/// 暂停播放，可继续播放
-(void)pause;

/// 恢复播放
-(void)resume;

/// 停止播放，不可继续播放。若需再次播放此资源，需要重新初始化播放器加载url进行播放
-(void)stop;

/// 清除缓存
-(void)clearCache;

/// 跳转播放位置（时间）
/// @params duration 播放时间
-(void)seekToDuration:(float)duration;

/// 跳转播放位置（进度）
/// @params progress 播放进度
-(void)seekToProgress:(float)progress;

/// 设置播放速率
/// @params rate 播放速率
-(void)configPlayRate:(float)rate;

/// 音量控制
/// @params volume 音量
-(void)configVolume:(float)volume;

/// 销毁播放器
-(void)destroy;

@end
