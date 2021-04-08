//
//  HFOpenSeachViewController.m
//  HFOpenMusic
//
//  Created by 郭亮 on 2021/3/18.
//

#import "HFOpenSeachViewController.h"
#import "HFOpenSearchResultCell.h"
#import "LPSearchHistoryView.h"
#import "HFAlertView.h"
#import "HFOpenHotSearchView.h"

#define searchMargin 10 // 默认边距

@interface HFOpenSeachViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, searchHistoryDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, weak) UISearchBar *searchBar;
@property (nonatomic, strong) LPSearchHistoryView *historyView;
@property (nonatomic, strong) HFOpenHotSearchView *hotSearchView;

// 是否为无搜索结果的推荐内容
@property (nonatomic, assign) BOOL  isRecommand;

@end

@implementation HFOpenSeachViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

-(void)configUI {
    self.view.backgroundColor = KColorHex(0x282828);
    self.navigationController.navigationBar.translucent=NO;
    [self.navigationController.navigationBar setBarTintColor:KColorHex(0x282828)];
    
    [self.view addSubview:self.historyView];
    [self.view addSubview:self.hotSearchView];
    [self.historyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(KScale(10));
    }];
    [self.hotSearchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.historyView.mas_bottom).offset(KScale(14));
        make.left.right.bottom.equalTo(self.view);
    }];

    self.myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.backgroundColor = KColorHex(0x282828);
    self.myTableView.hidden = true;
    self.myTableView.showsVerticalScrollIndicator = NO;
    self.myTableView.mj_header = self.mjHeaderView;
    self.myTableView.mj_footer = self.mjFooterView;
    [self.myTableView registerClass:[HFOpenSearchResultCell class] forCellReuseIdentifier:@"HFOpenSearchResultCell"];
    [self.view addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(KScale(10));
       }];
    
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, KScale(38), KScale(30))];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:KColorHex(0xFFFFFF) forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = KFont(14);
    [cancleBtn addTarget:self action:@selector(cancelDidClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancleBtn];

    
    // 创建搜索框
    UIView *titleView = [[UIView alloc] init];
    titleView.py_x = searchMargin * 0.5;
    titleView.py_y = 7;
    titleView.py_width = self.view.py_width - 64 - titleView.py_x * 2;
    titleView.py_height = 30;
    UISearchBar *searchVeiw = [[UISearchBar alloc] initWithFrame:titleView.bounds];
    UITextField *searchField = [searchVeiw valueForKey:@"searchField"];
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[HFVKitUtils bundleImageWithName:@"searchBarNew"]];
    imageview.frame = CGRectMake(0, 0, KScale(16), KScale(16));
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScale(16), KScale(16))];
    [view addSubview:imageview];
    searchField.leftView = view;
    
    searchField.textColor = [UIColor whiteColor];
    searchVeiw.py_width -= searchMargin * 1.5;
    searchVeiw.placeholder = @"搜索歌曲名/歌手";
    searchVeiw.layer.masksToBounds = true;
    searchVeiw.layer.cornerRadius = self.searchBar.py_height / 2.0;
    searchVeiw.delegate = self;
    [titleView addSubview:searchVeiw];
    self.searchBar = searchVeiw;
    self.navigationItem.titleView = titleView;
}

-(void)viewWillAppear:(BOOL)animated {
    [self.searchBar becomeFirstResponder];
}

-(void)requestData {
    __weak typeof(self) weakSelf = self;
    [[HFOpenApiManager shared] searchMusicWithTagIds:nil priceFromCent:nil priceToCent:nil bpmFrom:nil bpmTo:nil durationFrom:nil durationTo:nil keyword:self.searchBar.text language:nil searchFiled:nil
                                         searchSmart:nil page:[NSString stringWithFormat:@"%lu",(unsigned long)weakSelf.page] pageSize:@"20" success:^(id  _Nullable response) {
        [weakSelf endRefresh];
        NSArray *musicArray = [HFOpenMusicModel mj_objectArrayWithKeyValuesArray: [response hfv_objectForKey_Safe:@"record"]];
        if (musicArray && musicArray.count>0) {
            HFOpenMetaModel *metaModel = [HFOpenMetaModel mj_objectWithKeyValues:[response hfv_objectForKey_Safe:@"meta"]];
            weakSelf.isRecommand = NO;
            [weakSelf.dataArray addObjectsFromArray:musicArray];
            [weakSelf.myTableView reloadData];
            if (metaModel.currentPage*20 >= metaModel.totalCount) {
                self.myTableView.mj_footer = nil;
            }else {
                self.myTableView.mj_footer = self.mjFooterView;
            }
        } else {
            weakSelf.isRecommand = YES;
            //没有数据，调用-猜你喜欢-接口
            [[HFOpenApiManager shared] baseFavoriteWithPage:[NSString stringWithFormat:@"%lu",(unsigned long)weakSelf.page] pageSize:@"20" success:^(id  _Nullable response) {
                NSArray *favoriteArray = [HFOpenMusicModel mj_objectArrayWithKeyValuesArray: [response hfv_objectForKey_Safe:@"record"]];
                if (favoriteArray && favoriteArray.count>0) {
                    [weakSelf.dataArray addObjectsFromArray:favoriteArray];
                    NSLog(@"%@",weakSelf.dataArray);
                    NSLog(@"---%@",[NSThread currentThread]);
                    [weakSelf.myTableView reloadData];
                    HFOpenMetaModel *metaModel = [HFOpenMetaModel mj_objectWithKeyValues:[response hfv_objectForKey_Safe:@"meta"]];
                    if (metaModel.currentPage*20 >= metaModel.totalCount) {
                        self.myTableView.mj_footer = nil;
                    }else {
                        self.myTableView.mj_footer = self.mjFooterView;
                    }
                    
                }
            } fail:^(NSError * _Nullable error) {
                NSLog(@"adsddddllllllll");
                [HFVProgressHud showErrorWithError:error];
                weakSelf.page--;
            }];
        }
    } fail:^(NSError * _Nullable error) {
        [weakSelf endRefresh];
        weakSelf.page--;
        [HFVProgressHud showErrorWithError:error];
    }];
}

-(void)refreshAction {
    [self.dataArray removeAllObjects];
    [self.myTableView reloadData];
    _page = 1;
    [self requestData];
}

-(void)loadMoreAction {
    _page++;
    [self requestData];
}

-(void)endRefresh {
    if (self.myTableView.mj_header) {
        [self.myTableView.mj_header endRefreshing];
    }
    if (self.myTableView.mj_footer) {
        [self.myTableView.mj_footer endRefreshing];
    }
}


#pragma mark - Action
-(void)cancelDidClick {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] init];
    if (self.isRecommand) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [HFVKitUtils bundleImageWithName:@"search_placeholderNew"];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = 0;
        titleLabel.text = [NSString stringWithFormat:@"未找到与\“%@\”相关内容，向您推荐", self.searchBar.text];
        titleLabel.textColor = KColorHex(0x666666);
        titleLabel.font = KFont(11);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [header addSubview:imageView];
        [header addSubview:titleLabel];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KScale(10));
            make.centerX.equalTo(header);
            make.size.mas_equalTo(CGSizeMake(KScale(134), KScale(100)));
        }];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_bottom).offset(KScale(5));
            make.left.mas_equalTo(KScale(20));
            make.right.mas_equalTo(-KScale(20));
        }];
    }
    return header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.isRecommand) {
        return KScale(140);
    }
    return 0.01;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return KScale(44);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     HFOpenSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HFOpenSearchResultCell"];
    [cell cellReloadData:self.dataArray[indexPath.row]];
   return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HFOpenMusicModel *model = self.dataArray[indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_addContentPlay
                                                        object:nil
                                                      userInfo:[NSDictionary dictionaryWithObject:model
                                                        forKey:@"music"]];
}

#pragma mark - SearchBar Delegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (searchBar.text.length <= 0) {
        return;
    }
    self.myTableView.hidden = false;
    [self.searchBar resignFirstResponder];
    [self.historyView addSearchText:searchBar.text];
    [self.myTableView.mj_header beginRefreshing];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.historyView requestHistoryData];
    self.myTableView.hidden = true;
    if (searchBar.text.length>50) {
        //限制只能输入50字符
        [HFVProgressHud showInfoWithStatus:@"只能输入50个字符"];
        searchBar.text = [searchBar.text substringToIndex:[searchBar.text length] - 1];
        return;
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.searchBar resignFirstResponder];
}

#pragma mark - Histroy Delegate
-(void)historySelectedTag:(NSString *)searchString {
    if (searchString.length <= 0) {
        return;
    }
    self.myTableView.hidden = false;
    [self.searchBar resignFirstResponder];
    [self.historyView addSearchText:searchString];
    self.searchBar.text = searchString;
    //调接口
    [self.myTableView.mj_header beginRefreshing];
}

#pragma mark - 懒加载
-(LPSearchHistoryView *)historyView {
    if (!_historyView) {
        _historyView = [[LPSearchHistoryView alloc] init];
        _historyView.delegate = self;
    }
    return _historyView;
}

-(HFOpenHotSearchView *)hotSearchView {
    if (!_hotSearchView) {
        _hotSearchView = [[HFOpenHotSearchView alloc] init];
    }
    return _hotSearchView;
}

-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}
@end
