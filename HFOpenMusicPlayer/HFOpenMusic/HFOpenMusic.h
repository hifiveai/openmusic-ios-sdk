//
//  HFOpenMusic.h
//  HFOpenMusic
//
//  Created by 郭亮 on 2021/3/17.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HFOpenModel.h"

typedef NS_ENUM(NSInteger, HFOpenMusicListenType) {
    TYPE_TRAFFIC = 0,
    TYPE_UGC = 1,
    TYPE_K = 2
};

//! Project version number for HFOpenMusic.
FOUNDATION_EXPORT double HFOpenMusicVersionNumber;

//! Project version string for HFOpenMusic.
FOUNDATION_EXPORT const unsigned char HFOpenMusicVersionString[];

@protocol HFOpenMusicDelegate <NSObject>

@optional

-(void)currentPlayChangedMusic:(HFOpenMusicModel *)musicModel detail:(HFOpenMusicDetailInfoModel *)detailModel canCutSong:(BOOL)canCutSong;
-(void)canCutSongChanged:(BOOL)canCutSong;
@end

@interface HFOpenMusic : UIView

@property(nonatomic ,weak)id <HFOpenMusicDelegate> delegate;

-(instancetype)initWithListenType:(HFOpenMusicListenType) type;
-(void)previousPlay;
-(void)nextPlay;
-(void)cutSongDuration:(float)duration musicId:(NSString *)musicId;
-(void)showMusicSegmentView;
@end
