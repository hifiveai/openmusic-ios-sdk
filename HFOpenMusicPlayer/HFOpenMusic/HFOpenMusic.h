//
//  HFOpenMusic.h
//  HFOpenMusic
//
//  Created by 郭亮 on 2021/3/17.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <HFOpenMusicPlayer/HFOpenModel.h>
#import <HFOpenMusicPlayer/HFOpenEnumHeader.h>


@protocol HFOpenMusicDelegate <NSObject>

@optional

-(void)currentPlayChangedMusic:(HFOpenMusicModel *)musicModel detail:(HFOpenMusicDetailInfoModel *)detailModel canCutSong:(BOOL)canCutSong;
-(void)canCutSongChanged:(BOOL)canCutSong;
@end

@interface HFOpenMusic : UIView

@property(nonatomic ,weak)id <HFOpenMusicDelegate> delegate;

-(instancetype)initMusicListViewWithListenType:(HFOpenMusicListenType) type showControlbtn:(BOOL)showControlbtn;
-(void)addMusicListView;
-(void)removeMusicListView;
-(void)previousPlay;
-(void)nextPlay;
-(void)cutSongDuration:(float)duration musicId:(NSString *)musicId;
-(void)showMusicSegmentView;
-(void)dismissView;
@end
