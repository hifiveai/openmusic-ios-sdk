//
//  HFCurrentPlayListViewController.m
//  HFOpenMusic
//
//  Created by 郭亮 on 2021/3/17.
//

#import "HFOpenCurrentPlayListViewController.h"
#import "HFOpenMusicListCell.h"
#import "HFVMusicListPlaceholder.h"


@interface HFOpenCurrentPlayListViewController () <UITableViewDelegate ,UITableViewDataSource ,placeholderViewDelegate, musicCellDelegate>

@property (nonatomic, assign) NSInteger                                    currentIndex;
@property (nonatomic, strong) HFVMusicListPlaceholder                      *placeholderView;//无数据时显示
@property (nonatomic, assign) NSUInteger                                   page;


@end

@implementation HFOpenCurrentPlayListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self.myTableView.mj_header beginRefreshing];
}

//-(void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self.myTableView.mj_header beginRefreshing];
//}
//
//-(void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    [self.myTableView.mj_header beginRefreshing];
//}

-(void)refreshAction {
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *timeStr = [NSString stringWithFormat:@"%0.f",time*1000];
    [self.dataArray removeAllObjects];
    _page = 1;
    __weak typeof(self) weakSelf = self;
    [[HFOpenApiManager shared] baseHotWithStartTime:timeStr duration:@"365" page:[NSString stringWithFormat:@"%lu",(unsigned long)_page] pageSize:@"20" success:^(id  _Nullable response) {
        [weakSelf endRefresh];
        weakSelf.dataArray = [HFOpenMusicModel mj_objectArrayWithKeyValuesArray: [response hfv_objectForKey_Safe:@"record"]];
       // if (weakSelf.dataArray && weakSelf.dataArray.count>0) {
            //判断有无更多数据
            HFOpenMetaModel *metaModel = [HFOpenMetaModel mj_objectWithKeyValues:[response hfv_objectForKey_Safe:@"meta"]];
            if (metaModel.currentPage*20 >= metaModel.totalCount) {
                self.myTableView.mj_footer = nil;
            }else {
                self.myTableView.mj_footer = self.mjFooterView;
            }
//        } else {
//            self.myTableView.mj_footer = nil;
//        }
        [weakSelf.myTableView reloadData];
        
    } fail:^(NSError * _Nullable error) {
        [weakSelf endRefresh];
        [HFVProgressHud showErrorWithError:error];
    }];
}

-(void)loadMoreAction {
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *timeStr = [NSString stringWithFormat:@"%0.f",time*10];
    _page++;
    __weak typeof(self) weakSelf = self;
    [[HFOpenApiManager shared] baseHotWithStartTime:timeStr duration:@"365" page:[NSString stringWithFormat:@"%lu",(unsigned long)_page] pageSize:@"20" success:^(id  _Nullable response) {
        [weakSelf endRefresh];
        NSArray *models = [HFOpenMusicModel mj_objectArrayWithKeyValuesArray: [response hfv_objectForKey_Safe:@"record"]];
        [weakSelf.dataArray addObjectsFromArray:models];

        //if (weakSelf.dataArray && weakSelf.dataArray.count>0) {
            //判断有无更多数据
            HFOpenMetaModel *metaModel = [HFOpenMetaModel mj_objectWithKeyValues:[response hfv_objectForKey_Safe:@"meta"]];
            if (metaModel.currentPage*20 >= metaModel.totalCount) {
                self.myTableView.mj_footer = nil;
            }else {
                self.myTableView.mj_footer = self.mjFooterView;
            }
        [weakSelf.myTableView reloadData];
        //}
    } fail:^(NSError * _Nullable error) {
        [weakSelf endRefresh];
        [HFVProgressHud showErrorWithError:error];
    }];
}

-(void)configUI {
    self.myTableView.backgroundColor = KColorHex(0x282828);
    self.myTableView.separatorInset = UIEdgeInsetsMake(0, KScale(15), 0, 0);
    self.myTableView.separatorColor = [UIColor.whiteColor colorWithAlphaComponent:0.1];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    //self.myTableView.tableFooterView = UIView.new;
    // 当前播放无刷新
    if (!_showHeader) {
        self.myTableView.mj_header = nil;
        self.myTableView.mj_footer = nil;
    }
    
    [self.view addSubview:self.myTableView];
    [self.view addSubview:self.placeholderView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - Action
-(void)playAllMusicAction {
   //歌曲全部播放
    if (self.dataArray.count > 0) {
        [HFVProgressHud showSuccessWithStatus:@"加入播放列表成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_addAllMusicToContentPlay
          object:nil
        userInfo:[NSDictionary dictionaryWithObject:self.dataArray forKey:@"musicList"]];
    }
}

//MARK: - 表格代理
// 代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count > 0 || _showHeader) {
        self.placeholderView.hidden = true;
    }else {
        self.placeholderView.hidden = false;
    }
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return KScale(42);//58
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (!self.showHeader) {
        return nil;
    }
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = KColorHex(0x282828);
    view.userInteractionEnabled = true;
    UIButton *allPlayBtn = [[UIButton alloc] init];
    [allPlayBtn setImage:[HFVKitUtils bundleImageWithName:@"music_allPlay"] forState:UIControlStateNormal];
    allPlayBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [allPlayBtn setTitle:[NSString stringWithFormat:@" 全部播放（%ld）", self.dataArray.count] forState:UIControlStateNormal];
    [allPlayBtn setTitleColor:KColorHex(0xFFFFFF) forState:UIControlStateNormal];
    allPlayBtn.titleLabel.font = KFont(14);
    [allPlayBtn addTarget:self action:@selector(playAllMusicAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:allPlayBtn];
    [allPlayBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KScale(15));
        make.left.mas_equalTo(KScale(20));
        make.height.mas_equalTo(KScale(24));
    }];
//    UIButton *deleteBtn = [[UIButton alloc] init];
//    [deleteBtn setBackgroundImage:[HFVKitUtils bundleImageWithName:@"search_clearHistory"] forState:UIControlStateNormal];
//    deleteBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    [deleteBtn addTarget:self action:@selector(deleteAllAction) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:deleteBtn];
//    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.mas_equalTo(KScale(15));
//        make.right.equalTo(view.right).offset(-15);
//        make.centerY.equalTo(view);
//    }];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return _showHeader? KScale(44):0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    HFOpenMusicListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[HFOpenMusicListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.delegate = self;
    cell.showDelete = !_showHeader;
    [cell cellReloadData:self.dataArray[indexPath.row] rank:indexPath.row + 1];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HFOpenMusicModel *model = self.dataArray[indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_addContentPlay
                                                        object:nil
                                                      userInfo:[NSDictionary dictionaryWithObject:model
                                                        forKey:@"music"]];
}

#pragma mark - MusicListCell Delegate
-(void)deleteMusic:(HFOpenMusicModel *)model {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
    @weakify_self;
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确认删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify_self;
            if ([self.dataArray containsObject:model]) {
                if (model.isPlaying) {
                    //删除正在播放的歌曲
                    NSInteger index = [self.dataArray indexOfObject:model];
                    [self.dataArray removeObject:model];
                    HFOpenMusicModel *nextModel;
                    if (self.dataArray.count == 0) {
                        //最后一首歌被删除了
                        nextModel = [[HFOpenMusicModel alloc] init];
                    } else {
                        if (index < self.dataArray.count) {
                            nextModel = self.dataArray[index];
                        } else {
                            nextModel = self.dataArray[0];
                        }
                    }
                    
                    nextModel.isPlaying = true;
                    //需要发出通知，播放下一首
                    [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_deleteCurrentPlay
                                                                        object:nil
                                                                      userInfo:[NSDictionary dictionaryWithObject:nextModel
                                                                        forKey:@"music"]];
                } else {
                    //删除其他歌曲，移除即可不用做其他处理。
                    [self.dataArray removeObject:model];
                    [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_deleteOtherPlay
                                                                        object:nil
                                                                      userInfo:nil];
                }
                [self.myTableView reloadData];
            }
        }];

        NSMutableAttributedString *alertMsgStr = [[NSMutableAttributedString alloc] initWithString:@"确定将所选音乐从列表中移除？"];
        [alertMsgStr addAttribute:NSFontAttributeName value:KFont(12) range:NSMakeRange(0, alertMsgStr.length)];
        [alertMsgStr addAttribute:NSForegroundColorAttributeName value:KColorHex(0x999999) range:NSMakeRange(0, alertMsgStr.length)];
        [alert setValue:alertMsgStr forKey:@"attributedMessage"];
        [cancle setValue:KColorHex(0x000000) forKey:@"titleTextColor"];
        [sure setValue:KColorHex(0xD34747) forKey:@"titleTextColor"];

        [alert addAction:sure];
        [alert addAction:cancle];
        [self presentViewController:alert animated:true completion:nil];
}

//MARK: - placeholder代理
-(void)addMusic {
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_addKSongView object:nil];
}



-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

-(HFVMusicListPlaceholder *)placeholderView {
    if (!_placeholderView) {
        _placeholderView = [[HFVMusicListPlaceholder alloc] init];
        _placeholderView.delegate = self;
    }
    return _placeholderView;
}

@end
