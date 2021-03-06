//
//  LPBaseListViewController.m
//  HFVMusicKit
//
//  Created by Pan on 2020/11/12.
//

//MARK: - 列表基类控制器（自带tableView）
#import "LPBaseListViewController.h"

@interface LPBaseListViewController ()

@end

@implementation LPBaseListViewController


-(UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStylePlain];
        _myTableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        _myTableView.tableFooterView = UIView.new;
        _myTableView.mj_header = self.mjHeaderView;
        _myTableView.mj_footer = self.mjFooterView;
        _myTableView.separatorInset = UIEdgeInsetsMake(0, KScale(15), 0, 0);
        _myTableView.separatorColor = [UIColor.whiteColor colorWithAlphaComponent:0.1];
        _myTableView.backgroundColor = KColorHex(0x282828);
    }
    return  _myTableView;
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
        _mjFooterView = [[LPMJGifFooter alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScale(50))];
        //_mjFooterView.backgroundColor = UIColor.redColor;
        [_mjFooterView setRefreshingTarget:self refreshingAction:@selector(loadMoreAction)];
    }
    return _mjFooterView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void)refreshAction {
    
}
-(void)loadMoreAction {
    
}

-(void)endRefresh {
    
    if (self.myTableView.mj_header) {
        [self.myTableView.mj_header endRefreshing];
    }
    if (self.myTableView.mj_footer) {
        [self.myTableView.mj_footer endRefreshing];
    }
}

@end
