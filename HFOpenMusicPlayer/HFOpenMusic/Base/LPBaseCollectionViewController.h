//
//  LPBaseCollectionViewController.h
//  HFVMusicKit
//
//  Created by Pan on 2020/11/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPBaseCollectionViewController : UIViewController

@property (nonatomic, strong)   UICollectionView     *myCollectionView;
@property (nonatomic, strong) LPMJGifHeader  *mjHeaderView;
@property (nonatomic, strong) LPMJGifFooter  *mjFooterView;


-(void)refreshAction;
-(void)loadMoreAction;
-(void)endRefresh;

@end

NS_ASSUME_NONNULL_END
