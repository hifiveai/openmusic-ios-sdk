//
//  HFOpenMusicPlayer.m
//  HFOpenMusicPlayer
//
//  Created by 郭亮 on 2021/4/6.
//

#import <Foundation/Foundation.h>
#import "HFOpenMusicPlayer.h"
#import "HFOpenApiManager.h"
#import "HFPlayerApiConfiguration.h"
#import "HFPlayerApi.h"


@interface HFOpenMusicPlayer () <HFPlayerDelegate, HFOpenMusicDelegate>


@property(nonatomic ,assign)BOOL   playEnd;

@end

@implementation HFOpenMusicPlayer
-(instancetype _Nonnull )initWithListenType:(HFOpenMusicListenType)type config:(HFOpenMusicPlayerConfiguration *_Nonnull)config{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        //列表
        HFOpenMusic *listView = [[HFOpenMusic alloc] initMusicListViewWithListenType:type showControlbtn:false];
        listView.delegate = self;
        _listView = listView;
        listView.frame = CGRectMake(0, KScreenHeight-KScale(440), KScreenWidth, KScale(440));
        [self addSubview:listView];
        
        //播放器
        _config = config;
        HFPlayerConfiguration *playerConfig = [self changeToPlayerConfig:config];
        HFPlayer *player = [[HFPlayer alloc] initWithConfiguration:playerConfig];
        player.frame = CGRectMake(0, KScreenHeight-KScale(500), KScreenWidth, KScale(50));
        _player = player;
        _player.delegate = self;
        [self addSubview:player];
    }
    return self;
}

-(void)setConfig:(HFOpenMusicPlayerConfiguration *)config {
    _config = config;
    HFPlayerConfiguration *playerConfig = [self changeToPlayerConfig:config];
    _player.config = playerConfig;
}

-(void)addMusicPlayerView {
    if (self) {
      [[HFVKitUtils getCurrentWindow] addSubview:self];
    }
}

-(void)removeMusicPlayerView {
    if (self.superview) {
        [self removeFromSuperview];
    }
}

-(HFPlayerConfiguration *)changeToPlayerConfig:(HFOpenMusicPlayerConfiguration *)config {
    HFPlayerConfiguration *playerConfig = [HFPlayerConfiguration defaultConfiguration];
    playerConfig.autoNext = config.autoNext;
    playerConfig.panTopLimit = config.panTopLimit;
    playerConfig.panBottomLimit = config.panBottomLimit;
    playerConfig.cacheEnable = config.cacheEnable;
    playerConfig.bufferCacheSize = config.bufferCacheSize;
    playerConfig.repeatPlay = config.repeatPlay;
    playerConfig.networkAbilityEable = config.networkAbilityEable;
    playerConfig.rate = config.rate;
    return playerConfig;
}

#pragma mark - Player Delegate
//header
-(void)headerClick {
    [self.listView showMusicSegmentView];
}

//上一首
-(void)previousClick {
    [self.listView previousPlay];
}

//下一首
-(void)nextClick {
    [self.listView nextPlay];
}

//切歌数据上报
-(void)cutSongDuration:(float)duration musicId:(NSString *)musicId {
    [self.listView cutSongDuration:duration musicId:musicId];
}

//播放完毕
-(void)playerPlayToEnd {
    _playEnd = true;
}


#pragma mark - ListView Delegate
-(void)currentPlayChangedMusic:(HFOpenMusicModel *)musicModel detail:(HFOpenMusicDetailInfoModel *)detailModel canCutSong:(BOOL)canCutSong {
    HFPlayerConfiguration *config = _player.config;
    BOOL urlChanged = true;
    if (musicModel && detailModel) {
        //通过改变配置config，控制playerBar显示和播放
        NSArray *coverAry = musicModel.cover;
        if (coverAry && coverAry.count>0) {
            HFOpenMusicCoverModel *coverModel = coverAry[0];
            config.imageUrlString = coverModel.url;
        }
        NSMutableString *text = [[NSMutableString alloc] init];
        [text appendString: musicModel.musicName];
        NSArray *artistAry = musicModel.artist;
        if (artistAry && artistAry.count>0) {
            NSDictionary *artistDic = artistAry[0];
            //[artistDic hfv_objectForKey_Safe:@"name"]
            NSString *name = [artistDic objectForKey:@"name"];
            [text appendString:@"-"];
            [text appendString:name];
        }
        config.songName = text;
        config.canCutSong = canCutSong;
        if ([config.urlString isEqualToString:detailModel.fileUrl]) {
            urlChanged = false;
        }
        config.urlString = detailModel.fileUrl;
        config.musicId = musicModel.musicId;
        _player.config = config;
    } else {
        config.canCutSong = canCutSong;
        config.songName = @"";
        if ([config.urlString isEqualToString:@""]) {
            urlChanged = false;
        }
        config.urlString = @"";
        config.imageUrlString = @"";
        config.canCutSong = false;
        config.musicId = @"";
        _player.config = config;
    }
    if (urlChanged || _playEnd) {
        [_player play];
        _playEnd = false;
    }
}

-(void)canCutSongChanged:(BOOL)canCutSong {
    HFPlayerConfiguration *config = _player.config;
    config.canCutSong = canCutSong;
    _player.config = config;
}

#pragma mark - 事件传递
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *targetView = [super hitTest:point withEvent:event];
    if ([targetView class]==[self class]) {
        //没有点击到子控件，只能自己处理
        //传递到被遮挡的用户页面去
        return nil;
    } else {
        //有子控件，不用考虑遮挡问题
        return targetView;
    }
}


@end
