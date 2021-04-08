//
//  HFOpenCurrentPlayListViewController.h
//  HFOpenMusic
//
//  Created by 郭亮 on 2021/3/17.
//

#import "LPBaseListViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HFOpenCurrentPlayListViewController : LPBaseListViewController

@property (nonatomic, strong)NSMutableArray                               <HFOpenMusicModel *>*dataArray;
@property (nonatomic, assign)BOOL                                         showHeader;

@end

NS_ASSUME_NONNULL_END
