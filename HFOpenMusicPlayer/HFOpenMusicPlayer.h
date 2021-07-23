//
//  HFOpenMusicPlayer.h
//  HFOpenMusicPlayer
//
//  Created by 郭亮 on 2021/4/6.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

FOUNDATION_EXPORT double HFOpenMusicPlayerVersionNumber;

FOUNDATION_EXPORT const unsigned char HFOpenMusicPlayerVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import "PublicHeader.h"
#import "HFOpenMusicPlayerConfiguration.h"
#import "HFPlayer.h"
#import "HFPlayerApi.h"
#import "HFOpenMusic.h"
#import "HFOpenApiManager.h"
#import "HFOpenEnumHeader.h"


@interface HFOpenMusicPlayer : UIView


@property(nonatomic ,strong)HFPlayer  * _Nonnull player;
@property(nonatomic ,strong)HFOpenMusic  *_Nonnull listView;

///相关配置项
@property(nonatomic ,strong)HFOpenMusicPlayerConfiguration                                * _Nullable config;



/// 初始化
/// @param type BGM音乐播放,音视频作品BGM音乐播放,K歌音乐播放
/// @param config 配置项
-(instancetype _Nonnull )initWithListenType:(HFOpenMusicListenType)type config:(HFOpenMusicPlayerConfiguration *_Nonnull)config;


/// 显示播放界面
-(void)addMusicPlayerView;


/// 关闭播放界面
-(void)removeMusicPlayerView;
@end
