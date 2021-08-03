//
//  HFOpenHotSearchCell.h
//  HFOpenMusic
//
//  Created by 郭亮 on 2021/3/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HFOpenHotSearchCell : UITableViewCell

-(void)cellReloadData:(HFOpenMusicModel *)model rank:(NSInteger)rank;

@end

NS_ASSUME_NONNULL_END
