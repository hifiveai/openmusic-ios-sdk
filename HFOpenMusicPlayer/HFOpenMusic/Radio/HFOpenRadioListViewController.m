//
//  HFOpenRadioListControllerViewController.m
//  HFOpenMusic
//
//  Created by 郭亮 on 2021/3/22.
//

#import "HFOpenRadioListViewController.h"
#import "HFOpenRadioCollectionViewCell.h"


@interface HFOpenRadioListViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger  page;
@property (nonatomic, strong) UIView *noDataView;
@property (nonatomic, strong) UIImageView *noDataImageView;


@end

@implementation HFOpenRadioListViewController
static NSInteger pageSize = 10;

-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
-(HFOpenRadioDetailView *)detailView {
    if (!_detailView) {
        _detailView = [[HFOpenRadioDetailView alloc] init];
        //_detailView.sheets = self.sheets;
    }
    return _detailView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   self.automaticallyAdjustsScrollViewInsets = NO;
   
    [self createUI];
    [self.myCollectionView.mj_header beginRefreshing];
 
  
}

-(void)createUI {
    self.view.backgroundColor = KColorHex(0x282828);
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(KScale(105), KScale(145));
    layout.minimumLineSpacing = KScale(10);
    layout.minimumInteritemSpacing = KScale(10);
    layout.sectionInset = UIEdgeInsetsMake(KScale(20), KScale(20), KScale(20), KScale(20));
    self.myCollectionView.collectionViewLayout = layout;
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    self.myCollectionView.backgroundColor = KColorHex(0x282828);
 
    [self.myCollectionView registerClass:[HFOpenRadioCollectionViewCell class] forCellWithReuseIdentifier: @"cell"];
    
    [self.view addSubview:self.myCollectionView];
    [self.myCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.myCollectionView addSubview:self.noDataView];
    [self.noDataView addSubview:self.noDataImageView];
    self.noDataView.clipsToBounds = YES;
    self.noDataView.hidden = YES;
    [self.noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
    }];
}

-(void)showNoDataView {
    //显示数据缺省图
    self.noDataImageView.frame = CGRectMake(KScreenWidth/2-KScale(100), self.noDataView.frame.size.height/2-KScale(75), KScale(200), KScale(150));
    if (self.noDataView.frame.size.height == 0) {
        self.noDataView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height);
        [self.myCollectionView setContentOffset:CGPointMake(0, -self.view.frame.size.height)];
    }
}

-(void)hiddenNoDataView {
    //隐藏数据缺省图
    if (self.noDataView.frame.size.height>0) {
        self.noDataView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0);
        [self.myCollectionView setContentOffset:CGPointMake(0, 0)];
    }
}

//MARK: - 网络请求
-(void)refreshAction {
    [self.dataArray removeAllObjects];
    [self.myCollectionView reloadData];
    self.page = 1;
    [self requestData];
}
-(void)loadMoreAction {
    self.page += 1;
    [self requestData];
}

-(void)requestData {
    //__weak typeof(self) weakSelf = self;
    [[HFOpenApiManager shared] channelSheetWithGroupId:self.groupId language:nil recoNum:nil page:@"1" pageSize:[NSString stringWithFormat:@"%lu",(unsigned long)pageSize] success:^(id  _Nullable response) {
        [self endRefresh];
       
        NSDictionary *dict = response;
        HFOpenMetaModel *metaModel = [HFOpenMetaModel mj_objectWithKeyValues:[dict hfv_objectForKey_Safe:@"meta"]];
        self.dataArray = [HFOpenChannelSheetModel mj_objectArrayWithKeyValuesArray:[dict hfv_objectForKey_Safe:@"record"]];
        [self.myCollectionView reloadData];
        if (self.dataArray && self.dataArray.count>0) {
            for (HFOpenChannelSheetModel *model in self.dataArray) {
                NSArray *tags = model.tag;
                NSMutableArray *tagModels = [NSMutableArray arrayWithCapacity:0];
                for (NSDictionary *dic in tags) {
                    HFOpenChannelSheetTagModel *tagModel = [HFOpenChannelSheetTagModel mj_objectWithKeyValues: dic];
                    [tagModels addObject:tagModel];
                }
                model.tag = [tagModels copy];
            }
            
            if (metaModel.currentPage*pageSize >= metaModel.totalCount) {
                self.myCollectionView.mj_footer = nil;
            }else {
                self.myCollectionView.mj_footer = self.mjFooterView;
            }
            [self hiddenNoDataView];
        } else {
            [self showNoDataView];
        }
    } fail:^(NSError * _Nullable error) {
        [self endRefresh];
        [HFVProgressHud showErrorWithError:error];
        //[self showNoDataView];
    }];
    
}


//MARK: - 代理
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}
-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HFOpenRadioCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[HFOpenRadioCollectionViewCell alloc] init];
    }
    [cell cellReloadData:self.dataArray[indexPath.row]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.detailView showView:self.dataArray[indexPath.row]];
}



-(UIView *)noDataView {
    if (!_noDataView) {
        _noDataView = [[UIView alloc] init];
    }
    return _noDataView;
}

-(UIImageView *)noDataImageView {
    if (!_noDataImageView) {
        _noDataImageView = [[UIImageView alloc] init];
        _noDataImageView.image = [HFVKitUtils bundleImageWithName:@"music_listNoData"];
    }
    return _noDataImageView;
}



@end
