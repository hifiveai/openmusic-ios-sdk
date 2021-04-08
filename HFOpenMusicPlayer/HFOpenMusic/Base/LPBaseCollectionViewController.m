//
//  LPBaseCollectionViewController.m
//  HFVMusicKit
//
//  Created by Pan on 2020/11/18.
//

#import "LPBaseCollectionViewController.h"

@interface LPBaseCollectionViewController ()

@end

@implementation LPBaseCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(UICollectionView *)myCollectionView {
    if (!_myCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) collectionViewLayout:layout];
        _myCollectionView.backgroundColor = UIColor.whiteColor;
        _myCollectionView.mj_header = self.mjHeaderView;
        _myCollectionView.mj_footer = self.mjFooterView;
    }
    return _myCollectionView;
}

-(LPMJGifHeader *)mjHeaderView {
    if (!_mjHeaderView) {
        _mjHeaderView = [[LPMJGifHeader alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScale(50))];
        [_mjHeaderView setRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    }
    return _mjHeaderView;
}
-(LPMJGifFooter *)mjFooterView {
    if (!_mjFooterView) {
        _mjFooterView = [[LPMJGifFooter alloc] init];
        [_mjFooterView setRefreshingTarget:self refreshingAction:@selector(loadMoreAction)];
    }
    return _mjFooterView;
}


-(void)refreshAction {
    
}
-(void)loadMoreAction {
    
}

-(void)endRefresh {
    
    if (self.myCollectionView.mj_header) {
        [self.myCollectionView.mj_header endRefreshing];
    }
    if (self.myCollectionView.mj_footer) {
        [self.myCollectionView.mj_footer endRefreshing];
    }
}


@end
