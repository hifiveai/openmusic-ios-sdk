//
//  HFOpenMusicSegmentView.m
//  HFOpenMusic
//
//  Created by 郭亮 on 2021/3/17.
//

#import "HFOpenMusicSegmentView.h"
#import "LPSegmentViewController.h"
#import "HFOpenCurrentPlayListViewController.h"
#import "HFOpenSeachViewController.h"
#import "HFOpenRadioSegmentView.h"

@interface HFOpenMusicSegmentView ()

@property (nonatomic, strong) LPSegmentViewController *segmentVC;

@property (nonatomic, strong) UIButton  *closeButton;
@property (nonatomic, strong) UIButton  *songSheetBtn;
@property (nonatomic, strong) UIButton  *searchButton;

@property (nonatomic, strong) NSMutableArray  *titleArray;
@property (nonatomic, strong) NSMutableArray  *controllerArray;


@end

@implementation HFOpenMusicSegmentView

static NSString *audioFormat = @"mp3";
static NSString *audioRate = @"320";

-(void)playDataUpload:(float)playDuration musicId:(NSString *)musicId {
    //参数 MusicId  Duration  AudioFormat  AudioRate  Timestamp
    //根据不同计费方式，调用不同上报接口
    //获取13位时间戳
    if (playDuration <= 0) {
        return;
    }
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *timeStr = [NSString stringWithFormat:@"%0.f",time*1000];
    
    switch (_listenType) {
        case 0:
        {
            [[HFOpenApiManager shared] trafficReportListenWithMusicId:(NSString * _Nonnull)musicId duration:[NSString stringWithFormat:@"%0.f",playDuration] timestamp:timeStr audioFormat:audioFormat audioRate:audioRate success:^(id  _Nullable response) {
                HFLog(@"上报成功0");
            } fail:^(NSError * _Nullable error) {
                HFLog(@"上报失败0：%@",error.userInfo);
            }];
        }
            break;
        case 1:
        {
            [[HFOpenApiManager shared] ugcReportListenWithMusicId:(NSString * _Nonnull)musicId duration:[NSString stringWithFormat:@"%0.f",playDuration] timestamp:timeStr audioFormat:audioFormat audioRate:audioRate success:^(id  _Nullable response) {
                HFLog(@"上报成功1");
            } fail:^(NSError * _Nullable error) {
                HFLog(@"上报失败1");
            }];
        }
            break;
        case 2:
        {
            [[HFOpenApiManager shared] kReportListenWithMusicId:(NSString * _Nonnull)musicId duration:[NSString stringWithFormat:@"%0.f",playDuration] timestamp:timeStr audioFormat:audioFormat audioRate:audioRate success:^(id  _Nullable response) {
                HFLog(@"上报成功2");
            } fail:^(NSError * _Nullable error) {
                HFLog(@"上报失败2");
            }];
        }
            break;
        default:
            break;
    }
}

-(instancetype)init {
    self = [super initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, KScale(440))];
    if (self) {
        self.userInteractionEnabled = true;
        self.layer.masksToBounds = true;
        [self setRadiusWithRadius:KScale(20) corner:UIRectCornerTopLeft | UIRectCornerTopRight];
        [self configNotify];
    }
    return self;
}

#pragma mark - 通知  播放曲目控制
-(void)configNotify {
    //添加一首歌至播放列表
    [[NSNotificationCenter defaultCenter] addObserverForName:KNotification_addContentPlay object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSDictionary *dict = note.userInfo;
        HFOpenMusicModel *model = [dict hfv_objectForKey_Safe:@"music"];
        
        if (model && self.controllerArray.count>0) {
            //判断是否已经存在
            HFOpenCurrentPlayListViewController *vc = self.controllerArray[0];
            BOOL exist = false;
            for (int i=0; i<vc.dataArray.count; i++) {
                HFOpenMusicModel *dataModel = vc.dataArray[i];
                if ([dataModel.musicId isEqualToString:model.musicId]) {
                    //已经存在
                    dataModel.isPlaying = true;
                    exist = true;
                    //[self requestDetail:dataModel];
                } else {
                    dataModel.isPlaying = false;
                }
            }
            //不存在,则添加进去。
            model.isPlaying = true;
            if (!exist) {
                [vc.dataArray insertObject:model atIndex:0];
            }
            [vc.myTableView reloadData];
            [self requestDetail:model];
        }
        [self updateHotListPlayingStatusWithModel:model];
    }];
    
    //全部播放至播放列表
    [[NSNotificationCenter defaultCenter] addObserverForName:KNotification_addAllMusicToContentPlay object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSDictionary *dict = note.userInfo;
        NSArray *dataArray = [dict hfv_objectForKey_Safe:@"musicList"];
        if (dataArray && dataArray.count>0) {
            HFOpenCurrentPlayListViewController *vc = self.controllerArray[0];
            vc.dataArray = [NSMutableArray arrayWithArray:dataArray];
            [vc.myTableView reloadData];
            for (int i=0; i<vc.dataArray.count; i++) {
                HFOpenMusicModel *model = vc.dataArray[i];
                if (i==0) {
                    model.isPlaying = true;
                } else {
                    model.isPlaying = false;
                }
            }
            //请求详情
            [self requestDetail:vc.dataArray[0]];
            
            [self updateHotListPlayingStatusWithModel:dataArray[0]];
        }
    }];
    
    //删除当前播放歌曲，需要播放下一首
    [[NSNotificationCenter defaultCenter] addObserverForName:KNotification_deleteCurrentPlay object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSDictionary *dict = note.userInfo;
        HFOpenMusicModel *model = [dict hfv_objectForKey_Safe:@"music"];
        //请求详情
        if (model.musicId) {
            [self requestDetail:model];
            [self updateHotListPlayingStatusWithModel:model];
        } else {
            //播放列表被清空了，需要释放掉播放器
            if ([self.deleagte respondsToSelector:@selector(currentPlayChangedMusic:detail:canCutSong:)]) {
                [self.deleagte currentPlayChangedMusic:nil detail:nil canCutSong:false];
            }
            [self updateHotListPlayingStatusWithModel:nil];
        }
    }];
    
    //删除其他歌曲，需要更新上/下切换按钮状态
    [[NSNotificationCenter defaultCenter] addObserverForName:KNotification_deleteOtherPlay object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        HFOpenCurrentPlayListViewController *vc = self.controllerArray[0];
        if (vc.dataArray.count>1) {
            //可切换
        } else if (vc.dataArray.count == 1) {
            //不可切换
            if ([self.deleagte respondsToSelector:@selector(canCutSongChanged:)]) {
                [self.deleagte canCutSongChanged:false];
            }
        } else {
            //列表为空
            if ([self.deleagte respondsToSelector:@selector(currentPlayChangedMusic:detail:canCutSong:)]) {
                [self.deleagte currentPlayChangedMusic:nil detail:nil canCutSong:false];
            }
        }
    }];
    

    [[NSNotificationCenter defaultCenter] addObserverForName:KNotification_addKSongView object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        HFOpenRadioSegmentView *radioView = [[HFOpenRadioSegmentView alloc] init];
        [radioView addRaidoStationViewToView:self];
        [radioView showSegmentView];
    }];
}

//跟新hot列表播放状态
-(void)updateHotListPlayingStatusWithModel:(HFOpenMusicModel *)model {
    if (self.controllerArray.count>1) {
        HFOpenCurrentPlayListViewController *vc = self.controllerArray[1];
        if (model) {
            for (int i=0; i<vc.dataArray.count; i++) {
                HFOpenMusicModel *dataModel = vc.dataArray[i];
                if ([dataModel.musicId isEqualToString:model.musicId]) {
                    //已经存在
                    dataModel.isPlaying = true;
                } else {
                    dataModel.isPlaying = false;
                }
            }
        } else {
            for (int i=0; i<vc.dataArray.count; i++) {
                HFOpenMusicModel *dataModel = vc.dataArray[i];
                dataModel.isPlaying = false;
            }
        }
        [vc.myTableView reloadData];
    }
}


//切歌操作
-(void)cutSongWithType:(NSUInteger)type {
    HFOpenCurrentPlayListViewController *vc = self.controllerArray[0];
    switch (type) {
        case 0:
        {
           //上一首
            int current = -100;
            for (int i=0; i<vc.dataArray.count; i++) {
                HFOpenMusicModel *model = vc.dataArray[i];
                if (model.isPlaying) {
                    model.isPlaying = false;
                    current = i;
                }
            }
            if (current == -100) {
                return;
            }
            HFOpenMusicModel *preModel;
            if (current == 0) {
                preModel = vc.dataArray.lastObject;
            } else {
                preModel = vc.dataArray[current-1];
            }
            preModel.isPlaying = true;
            [vc.myTableView reloadData];
            if (preModel.musicId) {
                [self requestDetail:preModel];
            }
            [self updateHotListPlayingStatusWithModel:preModel];
        }
            break;
        case 1:
        {
           //下一首
            int current = -100;
            for (int i=0; i<vc.dataArray.count; i++) {
                HFOpenMusicModel *model = vc.dataArray[i];
                if (model.isPlaying) {
                    model.isPlaying = false;
                    current = i;
                }
            }
            if (current == -100) {
                return;
            }
            HFOpenMusicModel *nextModel;
            if (current == vc.dataArray.count-1) {
                nextModel = vc.dataArray.firstObject;
            } else {
                nextModel = vc.dataArray[current+1];
            }
            nextModel.isPlaying = true;
            [vc.myTableView reloadData];
            if (nextModel.musicId) {
                [self requestDetail:nextModel];
            }
            [self updateHotListPlayingStatusWithModel:nextModel];
        }
            break;
        default:
            break;
    }
}

-(void)showMusicSegmentView {
    // 显示
    [self.superview layoutIfNeeded];
    [UIView animateWithDuration:0.2 animations:^{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.superview.mas_bottom).mas_offset(-[HFVGlobalTool shareTool].songListHeight);
        }];
        [self.superview layoutIfNeeded];
    }];
    
}
//MARK: - 隐藏
-(void)dismissView {
    [UIView animateWithDuration:0.2 animations:^{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.superview.mas_bottom);
        }];
        [self.superview layoutIfNeeded];
    }completion:^(BOOL finished) {

    }];
}


-(void)addSegmentViewToView:(UIView *)view {
    [view addSubview:self];
    [self addSubview:self.closeButton];
    self.backgroundColor = KColorHex(0x282828);
    [self addSubview:self.songSheetBtn];
    [self addSubview:self.searchButton];
    [self addSubview:self.segmentVC.view];
    [self sendSubviewToBack:self.segmentVC.view];
    [self.segmentVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.superview.mas_bottom);
        make.left.right.equalTo(self.superview);
        make.height.mas_equalTo([HFVGlobalTool shareTool].songListHeight);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self.mas_top).offset(KScale(25));
        make.width.height.mas_equalTo(KScale(44));
    }];
    
    [self.songSheetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_top).offset(KScale(25));
        make.centerX.equalTo(self.mas_right).offset(KScale(-70));
        make.width.height.mas_equalTo(KScale(30));
    }];
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.songSheetBtn);
        make.centerX.equalTo(self.mas_right).offset(KScale(-30));
        make.width.height.mas_equalTo(KScale(30));
    }];
}

#pragma mark - Action
-(void)searchAction:(UIButton *)btn {
    HFOpenSeachViewController *searchVC = [HFOpenSeachViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchVC];
    nav.modalPresentationStyle = UIModalPresentationCustom;
    
    [self.segmentVC presentViewController:nav animated:YES completion:nil];
}

-(void)songSheetAction:(UIButton *)btn {
    HFOpenRadioSegmentView *radioView = [[HFOpenRadioSegmentView alloc] init];
    [radioView addRaidoStationViewToView:self];
    [radioView showSegmentView];
}

#pragma mark - UI
-(LPSegmentViewController *)segmentVC {
    if (!_segmentVC) {
        _segmentVC = [[LPSegmentViewController alloc] init];
        NSArray *titles = @[@"当前播放", @"热门推荐"];
        NSMutableArray *controllers = [NSMutableArray array];

        for (int i = 0; i < titles.count; i++) {
            HFOpenCurrentPlayListViewController *listVC = HFOpenCurrentPlayListViewController.new;
            if (i==0) {
                listVC.showHeader = false;
            } else {
                listVC.showHeader = true;
            }
            [controllers addObject:listVC];
            self.controllerArray = controllers;
        }
        _segmentVC.pageViewControllers = controllers;
        _segmentVC.categoryView.titles = titles;
        _segmentVC.categoryView.originalIndex = 0;
        _segmentVC.categoryView.cellSpacing = KScale(24);
        _segmentVC.categoryView.titleNomalFont = KFont(14);
        _segmentVC.categoryView.titleSelectedFont = KFont(14);
        _segmentVC.categoryView.titleNormalColor = KColorHex(0x8E8E93);
        _segmentVC.categoryView.titleSelectedColor = KColorHex(0xFFFFFF);
        _segmentVC.categoryView.height = KScale(50);
        _segmentVC.categoryView.leftAndRightMargin = KScale(55);
        _segmentVC.categoryView.rightMargin = KScale(90);
        
    }
    return _segmentVC;
}

-(UIButton *)songSheetBtn {
    if (!_songSheetBtn) {
        _songSheetBtn = [[UIButton alloc] init];
        [_songSheetBtn setImage:[HFVKitUtils bundleImageWithName:@"navigation_songSheetNew"] forState:UIControlStateNormal];
        [_songSheetBtn addTarget:self action:@selector(songSheetAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _songSheetBtn;
}

-(UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [[UIButton alloc] init];
        [_searchButton setImage:[HFVKitUtils bundleImageWithName:@"navigation_searchNew"] forState:UIControlStateNormal];
        [_searchButton addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchButton;
}

-(UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        _closeButton.backgroundColor = KColorHex(0x282828);
        [_closeButton setImage:[HFVKitUtils bundleImageWithName:@"navigation_packUp"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}




-(void)requestDetail:(HFOpenMusicModel *)model {
    //请求歌曲详情，
    //三种计费类型
    switch (_listenType) {
        case 0:
        {
//            [[HFOpenApiManager shared] trafficTrialWithMusicId:model.musicId success:^(id  _Nullable response) {
//                HFOpenCurrentPlayListViewController *vc = self.controllerArray[0];
//                HFOpenMusicDetailInfoModel *detailModel = [HFOpenMusicDetailInfoModel mj_objectWithKeyValues:response];
//                if ([self.deleagte respondsToSelector:@selector(currentPlayChangedMusic:detail:canCutSong:)]) {
//                    [self.deleagte currentPlayChangedMusic:model detail:detailModel canCutSong:vc.dataArray.count>1?true:false];
//                }
//            } fail:^(NSError * _Nullable error) {
//                [HFVProgressHud showErrorWithError:error];
//            }];
            [[HFOpenApiManager shared] trafficHQListenWithMusicId:model.musicId audioFormat:audioFormat audioRate:audioRate success:^(id  _Nullable response) {
                HFOpenCurrentPlayListViewController *vc = self.controllerArray[0];
                HFOpenMusicDetailInfoModel *detailModel = [HFOpenMusicDetailInfoModel mj_objectWithKeyValues:response];
                if ([self.deleagte respondsToSelector:@selector(currentPlayChangedMusic:detail:canCutSong:)]) {
                    [self.deleagte currentPlayChangedMusic:model detail:detailModel canCutSong:vc.dataArray.count>1?true:false];
                }
            } fail:^(NSError * _Nullable error) {
                [HFVProgressHud showErrorWithError:error];
            }];
        }
            break;
        case 1:
        {
//            [[HFOpenApiManager shared] ugcTrialWithMusicId:model.musicId success:^(id  _Nullable response) {
//                HFOpenCurrentPlayListViewController *vc = self.controllerArray[0];
//                HFOpenMusicDetailInfoModel *detailModel = [HFOpenMusicDetailInfoModel mj_objectWithKeyValues:response];
//                if ([self.deleagte respondsToSelector:@selector(currentPlayChangedMusic:detail:canCutSong:)]) {
//                    [self.deleagte currentPlayChangedMusic:model detail:detailModel canCutSong:vc.dataArray.count>1?true:false];
//                }
//            } fail:^(NSError * _Nullable error) {
//                [HFVProgressHud showErrorWithError:error];
//            }];
            
            [[HFOpenApiManager shared] ugcHQListenWithMusicId:model.musicId audioFormat:audioFormat audioRate:audioRate success:^(id  _Nullable response) {
                HFOpenCurrentPlayListViewController *vc = self.controllerArray[0];
                HFOpenMusicDetailInfoModel *detailModel = [HFOpenMusicDetailInfoModel mj_objectWithKeyValues:response];
                if ([self.deleagte respondsToSelector:@selector(currentPlayChangedMusic:detail:canCutSong:)]) {
                    [self.deleagte currentPlayChangedMusic:model detail:detailModel canCutSong:vc.dataArray.count>1?true:false];
                }
            } fail:^(NSError * _Nullable error) {
                [HFVProgressHud showErrorWithError:error];
            }];
        }
            break;
        case 2:
        {
//            [[HFOpenApiManager shared] kTrialWithMusicId:model.musicId success:^(id  _Nullable response) {
//                HFOpenCurrentPlayListViewController *vc = self.controllerArray[0];
//                HFOpenMusicDetailInfoModel *detailModel = [HFOpenMusicDetailInfoModel mj_objectWithKeyValues:response];
//                if ([self.deleagte respondsToSelector:@selector(currentPlayChangedMusic:detail:canCutSong:)]) {
//                    [self.deleagte currentPlayChangedMusic:model detail:detailModel canCutSong:vc.dataArray.count>1?true:false];
//                }
//            } fail:^(NSError * _Nullable error) {
//                [HFVProgressHud showErrorWithError:error];
//            }];
            [[HFOpenApiManager shared] kHQListenWithMusicId:model.musicId audioFormat:audioFormat audioRate:audioRate success:^(id  _Nullable response) {
                HFOpenCurrentPlayListViewController *vc = self.controllerArray[0];
                HFOpenMusicDetailInfoModel *detailModel = [HFOpenMusicDetailInfoModel mj_objectWithKeyValues:response];
                if ([self.deleagte respondsToSelector:@selector(currentPlayChangedMusic:detail:canCutSong:)]) {
                    [self.deleagte currentPlayChangedMusic:model detail:detailModel canCutSong:vc.dataArray.count>1?true:false];
                }
            } fail:^(NSError * _Nullable error) {
                [HFVProgressHud showErrorWithError:error];
            }];
        }
            break;
        default:
            break;
    }
}

@end
