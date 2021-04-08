//
//  HFVMusicListCell.h
//  HFVMusicKit
//
//  Created by Pan on 2020/11/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol musicCellDelegate <NSObject>

@optional
-(void)deleteMusic:(HFOpenMusicModel *)model;
@end


@interface HFOpenMusicListCell : UITableViewCell


@property (nonatomic, weak) id<musicCellDelegate>  delegate;
@property (nonatomic, assign) BOOL                 showDelete;

-(void)cellReloadData:(HFOpenMusicModel *)item rank:(NSInteger)rank;
-(void)cellReloadPlayingStatus:(BOOL) isPlaying;

@end

NS_ASSUME_NONNULL_END
