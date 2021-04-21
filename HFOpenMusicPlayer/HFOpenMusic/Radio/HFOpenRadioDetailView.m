//
//  HFOpenRadioDetailView.m
//  HFOpenMusic
//
//  Created by 郭亮 on 2021/3/22.
//

#import "HFOpenRadioDetailView.h"
#import "HFOpenRadioDetailHeader.h"
#import "HFOpenSearchResultCell.h"

@interface HFOpenRadioDetailView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton  *backButton;
@property (nonatomic, strong) HFOpenRadioDetailHeader *headerView;
@property (nonatomic, strong) UITableView  *myTableView;
@property (nonatomic, strong) LPMJGifHeader  *mjHeaderView;
@property (nonatomic, strong) LPMJGifFooter  *mjFooterView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSUInteger     page;

@property (nonatomic, strong) HFOpenChannelSheetModel *sheetModel;//歌单模型

@end

@implementation HFOpenRadioDetailView

- (instancetype)init
{
    NSInteger songListGeight = [HFVGlobalTool shareTool].songListHeight;
    self = [super initWithFrame:CGRectMake(KScreenWidth, KScreenHeight - songListGeight, KScreenWidth, songListGeight)];
    if (self) {

        //self.backgroundColor = KColorHex(0x282828);
        self.userInteractionEnabled = true;
        self.layer.masksToBounds = true;
        [self setRadiusWithRadius:KScale(20) corner:UIRectCornerTopLeft | UIRectCornerTopRight];
        
        [self createUI];
    }
    return self;
}


-(UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        [_backButton setImage:[HFVKitUtils bundleImageWithName:@"navigation_back"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
-(HFOpenRadioDetailHeader *)headerView {
    if (!_headerView) {
        _headerView = [[HFOpenRadioDetailHeader alloc] init];
    }
    return _headerView;
}
-(UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.showsHorizontalScrollIndicator = false;
        _myTableView.backgroundColor = KColorHex(0x282828);
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //_myTableView.backgroundColor = UIColor.greenColor;
        _myTableView.mj_header = self.mjHeaderView;
    }
    return _myTableView;
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
-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void)createUI {
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
   
    [self addSubview:self.headerView];
    [self addSubview:self.myTableView];
    [self addSubview:self.backButton];

    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(KScale(160));
    }];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.bottom);
        make.left.right.bottom.equalTo(self);
    }];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self.mas_top).offset(KScale(25));
        make.width.height.mas_equalTo(KScale(35));
    }];
}

-(void)addRaidoDetailViewToView:(UIView *)view {
    if (self.superview == nil) {
        [view addSubview:self];

        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.width.equalTo(view);
            make.height.mas_equalTo([HFVGlobalTool shareTool].songListHeight);
            make.left.equalTo(view.mas_right);
        }];
        [self.superview layoutIfNeeded];
    }
}

//MARK: - 数据请求
-(void)refreshAction {
    _page = 1;
    [self.dataArray removeAllObjects];
    [self.myTableView reloadData];
    [self loadData];
}

-(void)loadMoreAction {
    _page++;
    [self loadData];
}

-(void)loadData {
    __weak typeof(self) weakSelf = self;
    [[HFOpenApiManager shared] sheetMusicWithSheetId:self.sheetModel.sheetId language:@"0" page:[NSString stringWithFormat:@"%lu",(unsigned long)weakSelf.page] pageSize:@"10" success:^(id  _Nullable response) {
        [self endRefresh];
        NSArray *tempArray = [HFOpenMusicModel mj_objectArrayWithKeyValuesArray:[response hfv_objectForKey_Safe:@"record"]];
        [weakSelf.dataArray addObjectsFromArray:tempArray];
        HFOpenMetaModel *metaModel = [HFOpenMetaModel mj_objectWithKeyValues:[response hfv_objectForKey_Safe:@"meta"]];
        if (self.dataArray && self.dataArray.count>0) {
            if (metaModel.currentPage*10 >= metaModel.totalCount) {
                self.myTableView.mj_footer = nil;
            }else {
                self.myTableView.mj_footer = self.mjFooterView;
            }
        }
        [self.myTableView reloadData];
    } fail:^(NSError * _Nullable error) {
        [HFVProgressHud showErrorWithError:error];
        [self endRefresh];
        weakSelf.page--;
    }];
}

-(void)endRefresh {
    if (self.myTableView.mj_header) {
        [self.myTableView.mj_header endRefreshing];
    }
    if (self.myTableView.mj_footer) {
        [self.myTableView.mj_footer endRefreshing];
    }
}

//MARK: - 代理=====
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return KScale(57);
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return KScale(44);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.userInteractionEnabled = true;
    UIButton *allPlayBtn = [[UIButton alloc] init];
    [allPlayBtn setImage:KBoundleImageName(@"music_allPlay") forState:UIControlStateNormal];
    allPlayBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [allPlayBtn setTitle:[NSString stringWithFormat:@" 全部播放（%ld）", self.dataArray.count] forState:UIControlStateNormal];
    [allPlayBtn setTitleColor:KColorHex(0xFFFFFF) forState:UIControlStateNormal];
    allPlayBtn.titleLabel.font = KFont(14);
    [allPlayBtn addTarget:self action:@selector(playAllMusicAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:allPlayBtn];
    [allPlayBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KScale(15));
        make.left.mas_equalTo(KScale(20));
        make.height.mas_equalTo(KScale(24));
    }];
    view.backgroundColor = KColorHex(0x282828);
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HFOpenSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[HFOpenSearchResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    [cell cellReloadData:self.dataArray[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    if ([[HFVMusicUIManager shareManager] musicIsPlaying:self.dataArray[indexPath.row]]) {
    //        return;
    //    }
    HFOpenMusicModel *model = self.dataArray[indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_addContentPlay
                                                        object:nil
                                                      userInfo:[NSDictionary dictionaryWithObject:model
                                                        forKey:@"music"]];
}

//MARK: - 事件区域=================
-(void)playAllMusicAction:(UIButton *)sender {
    if (self.dataArray.count > 0) {
        [HFVProgressHud showSuccessWithStatus:@"加入播放列表成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_addAllMusicToContentPlay
          object:nil
        userInfo:[NSDictionary dictionaryWithObject:self.dataArray forKey:@"musicList"]];
    }
}
//MARK: - 显示
-(void)showView:(HFOpenChannelSheetModel *)model {
    self.sheetModel = model;
    [self.dataArray removeAllObjects];
    [self.myTableView.mj_header beginRefreshing];
    [self createUI];
    [self.headerView reloadData:model];
    [self.myTableView reloadData];
    [UIView animateWithDuration:0.15 animations:^{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.superview);
        }];
        [self.superview layoutIfNeeded];
    }];
}

//MARK: - 隐藏
-(void)dismissView {
    [UIView animateWithDuration:0.15 animations:^{
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.width.equalTo(self.superview);
            make.height.mas_equalTo([HFVGlobalTool shareTool].songListHeight);
            make.left.equalTo(self.superview.mas_right);
        }];
        [self.superview layoutIfNeeded];
    }completion:^(BOOL finished) {
//        [self removeFromSuperview];
    }];
}


@end
