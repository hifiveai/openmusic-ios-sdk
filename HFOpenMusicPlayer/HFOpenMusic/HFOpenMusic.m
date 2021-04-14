//
//  HFOpenMusic.m
//  HFOpenMusic
//
//  Created by 郭亮 on 2021/3/17.
//

#import <Foundation/Foundation.h>
#import "HFOpenMusic.h"
#import "HFOpenMusicSegmentView.h"

@interface HFOpenMusic () <HFOpenMusicPlayDelegate ,HFPlayerDelegate>

@property(nonatomic ,strong)HFPlayer                                          *player;
@property(nonatomic ,assign)HFOpenMusicListenType                             listenType;
@property(nonatomic ,strong)HFOpenMusicSegmentView                            *segment;


@end


@implementation HFOpenMusic

-(instancetype)initWithListenType:(HFOpenMusicListenType)type {
    if (self = [super init]) {
        _listenType = type;
        [self configUI];
    }
    return self;
}

-(void)configUI {
    //静默登录
    [[HFOpenApiManager shared] baseLoginWithNickname:nil gender:nil birthday:nil location:nil education:nil profession:nil isOrganization:false reserve:nil favoriteSinger:nil favoriteGenre:nil success:^(id  _Nullable response) {
        
    } fail:^(NSError * _Nullable error) {
        
    }];
    //440

    //列表
    HFOpenMusicSegmentView *segment = [[HFOpenMusicSegmentView alloc] init];
    segment.deleagte = self;
    segment.listenType = _listenType;
    [segment addSegmentViewToView:self];
    _segment = segment;
    [HFSVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
}

-(void)showMusicSegmentView {
    [self.segment showMusicSegmentView];
}

-(void)dismissView {
    [self.segment dismissView];
}
#pragma mark - Segment Delegate
//播放的歌曲发生改变
-(void)currentPlayChangedMusic:(HFOpenMusicModel *)musicModel detail:(HFOpenMusicDetailInfoModel *)detailModel canCutSong:(BOOL)canCutSong {
    if ([self.delegate respondsToSelector:@selector(currentPlayChangedMusic:detail:canCutSong:)]) {
        [self.delegate currentPlayChangedMusic:musicModel detail:detailModel canCutSong:canCutSong];
    }
}

-(void)canCutSongChanged:(BOOL)canCutSong {
    if ([self.delegate respondsToSelector:@selector(canCutSongChanged:)]) {
        [self.delegate canCutSongChanged:canCutSong];
    }
}


#pragma mark - HFPlayerDelegate
-(void)previousPlay {
    [self.segment cutSongWithType:0];
    
}

-(void)nextPlay {
    [self.segment cutSongWithType:1];
}

-(void)cutSongDuration:(float)duration musicId:(NSString *)musicId{
    [self.segment playDataUpload:duration musicId:musicId];
}

#pragma mark - dealloc
-(void)dealloc {
    //[_player.config removeObserver:self forKeyPath:@"currentPlayIndex"];
}
@end
