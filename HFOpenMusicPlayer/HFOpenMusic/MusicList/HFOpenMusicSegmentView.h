//
//  HFOpenMusicSegmentView.h
//  HFOpenMusic
//
//  Created by 郭亮 on 2021/3/17.
//

#import <UIKit/UIKit.h>

@protocol HFOpenMusicPlayDelegate <NSObject>

@optional
-(void)currentPlayChangedMusic:(HFOpenMusicModel *)musicModel detail:(HFOpenMusicDetailInfoModel *)detailModel canCutSong:(BOOL) canCutSong;
-(void)canCutSongChanged:(BOOL) canCutSong;

@end

@interface HFOpenMusicSegmentView : UIView

@property(nonatomic ,weak)id <HFOpenMusicPlayDelegate>                         deleagte;
@property(nonatomic ,assign) NSInteger                                         listenType;

-(void)showMusicSegmentView;
-(void)addSegmentViewToView:(UIView *)view;
-(void)cutSongWithType:(NSUInteger)type;
-(void)playDataUpload:(float)playDuration musicId:(NSString *)musicId ;

@end


