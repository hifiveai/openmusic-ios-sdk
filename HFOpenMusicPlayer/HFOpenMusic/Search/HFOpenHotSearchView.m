//
//  HFOpenHotSearchView.m
//  HFOpenMusic
//
//  Created by 郭亮 on 2021/3/22.
//

#import "HFOpenHotSearchView.h"
#import "HFOpenHotSearchCell.h"

@interface HFOpenHotSearchView() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView                                 *hotList;
@property (nonatomic, strong) LPMJGifHeader                               *mjHeaderView;
//@property (nonatomic, strong) LPMJGifFooter                               *mjFooterView;

@property (nonatomic, copy) NSArray                                       *dataArray;

@end

@implementation HFOpenHotSearchView

-(instancetype)init {
    if (self = [super init]) {
        [self configUI];
    }
    return self;
}

-(void)configUI {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"热搜榜";
    titleLabel.font = KBoldFont(14);
    titleLabel.textColor = UIColor.whiteColor;
    [titleLabel sizeToFit];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.mas_equalTo(KScale(20));
        make.height.mas_equalTo(KScale(20));
    }];
    
    UITableView *hotList = [[UITableView alloc] init];
    _hotList = hotList;
    hotList.mj_header = self.mjHeaderView;
    //hotList.mj_footer = self.mjFooterView;
    [hotList registerClass:[HFOpenHotSearchCell class] forCellReuseIdentifier:@"HFOpenHotSearchCell"];
    hotList.backgroundColor = UIColor.clearColor;
    hotList.delegate = self;
    hotList.dataSource = self;
    hotList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:hotList];
    [hotList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(KScale(10));
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-KScale(30));
    }];
    [self.hotList.mj_header beginRefreshing];
}

#pragma mark - tableview刷新
-(void)refreshAction {
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval oneYear = 3600*24*365;
    NSString *timeStr = [NSString stringWithFormat:@"%0.f",time-oneYear];
    __weak typeof(self) weakSelf = self;
    [[HFOpenApiManager shared] baseHotWithStartTime:timeStr duration:@"365" page:nil pageSize:@"20" success:^(id  _Nullable response) {
        [weakSelf endRefresh];
        weakSelf.dataArray = [HFOpenMusicModel mj_objectArrayWithKeyValuesArray: [response hfv_objectForKey_Safe:@"record"]];
       // if (weakSelf.dataArray && weakSelf.dataArray.count>0) {
            [weakSelf.hotList reloadData];
        //}
    } fail:^(NSError * _Nullable error) {
        [weakSelf endRefresh];
        [HFVProgressHud showErrorWithError:error];
    }];
    
}
//-(void)loadMoreAction {
//
//}

-(void)endRefresh {
    if (_hotList.mj_header) {
        [_hotList.mj_header endRefreshing];
    }
    if (_hotList.mj_footer) {
        [_hotList.mj_footer endRefreshing];
    }
}

#pragma mark - tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HFOpenHotSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HFOpenHotSearchCell"];
    [cell cellReloadData:self.dataArray[indexPath.row] rank:indexPath.row+1];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return KScale(43.5f);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HFOpenMusicModel *model = self.dataArray[indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_addContentPlay
                                                        object:nil
                                                      userInfo:[NSDictionary dictionaryWithObject:model
                                                        forKey:@"music"]];
}

-(LPMJGifHeader *)mjHeaderView {
    if (!_mjHeaderView) {
        _mjHeaderView = [[LPMJGifHeader alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScale(50))];
        [_mjHeaderView setRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    }
    return _mjHeaderView;
}
//-(LPMJGifFooter *)mjFooterView {
//    if (!_mjFooterView) {
//        _mjFooterView = [[LPMJGifFooter alloc] init];
//        [_mjFooterView setRefreshingTarget:self refreshingAction:@selector(loadMoreAction)];
//    }
//    return _mjFooterView;
//}

-(NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSArray alloc] init];
    }
    return _dataArray;
}

@end
