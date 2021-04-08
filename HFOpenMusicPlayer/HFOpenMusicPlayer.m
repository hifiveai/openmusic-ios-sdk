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
#import "HFOpenMusic.h"
//#import "HFOpenApiManager.h"

@interface HFOpenMusicPlayer () <HFPlayerDele, HFOpenMusicDelegate>

@property(nonatomic ,strong)HFPlayer                                             *player;
@property(nonatomic ,strong)HFOpenMusic                                          *listView;
//@property(nonatomic ,strong)HFPlayerConfiguration                                *config;

@end

@implementation HFOpenMusicPlayer
-(instancetype)initWithListenType:(NSUInteger)type config:(HFPlayerConfiguration *)config {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        
        //列表
        HFOpenMusic *listView = [[HFOpenMusic alloc] initWithListenType:type];
        listView.delegate = self;
        _listView = listView;
        listView.frame = CGRectMake(0, KScreenHeight-KScale(440), KScreenWidth, KScale(440));
        [self addSubview:listView];
        
        //播放器
        _config = config;
        HFPlayer *player = [[HFPlayer alloc] initWithConfiguration:config];
        player.frame = CGRectMake(0, KScreenHeight-KScale(500), KScreenWidth, KScale(50));
        _player = player;
        _player.delegate = self;
        [self addSubview:player];
    }
    return self;
}

#pragma mark - Player Delegate
//header
-(void)headerClick {
    [self.listView showMusicSegmentView];
}

//上一首
-(void)previousPlay {
    [self.listView previousPlay];
}

//下一首
-(void)nextPlay {
    [self.listView nextPlay];
}

//切歌数据上报
-(void)cutSongDuration:(float)duration musicId:(NSString *)musicId{
    [self.listView cutSongDuration:duration musicId:musicId];
}


#pragma mark - ListView Delegate
-(void)currentPlayChangedMusic:(HFOpenMusicModel *)musicModel detail:(HFOpenMusicDetailInfoModel *)detailModel canCutSong:(BOOL)canCutSong {
    HFPlayerConfiguration *config = _player.config;
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
        config.urlString = detailModel.fileUrl;
        config.musicId = musicModel.musicId;
        _player.config = config;
    } else {
        config.songName = @"";
        config.canCutSong = @"";
        config.urlString = @"";
        config.imageUrlString = @"";
        config.canCutSong = false;
        config.musicId = @"";
        _player.config = config;
    }

}

-(void)canCutSongChanged:(BOOL)canCutSong {
    HFPlayerConfiguration *config = _player.config;
    config.canCutSong = canCutSong;
    _player.config = config;
}

@end
