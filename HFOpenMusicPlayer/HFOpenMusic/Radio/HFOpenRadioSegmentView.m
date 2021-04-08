//
//  HFOpenRadioSegmentView.m
//  HFOpenMusic
//
//  Created by 郭亮 on 2021/3/22.
//

#import "HFOpenRadioSegmentView.h"
#import "LPSegmentViewController.h"
#import "HFOpenRadioListViewController.h"

@interface HFOpenRadioSegmentView ()

@property (nonatomic, strong) LPSegmentViewController             *segmentVC;
@property (nonatomic, strong) UIButton                            *backButton;

@property (nonatomic, copy) NSArray                               <HFOpenRadioModel *>*dataArray;
@property (nonatomic, strong) NSMutableArray                      *titleArray;
@property (nonatomic, strong) NSMutableArray                      *controllerArray;

@end

@implementation HFOpenRadioSegmentView

- (instancetype)init
{
    NSInteger songListHeight = [HFVGlobalTool shareTool].songListHeight;
    self = [super initWithFrame:CGRectMake(KScreenWidth, KScreenHeight - songListHeight, KScreenWidth, songListHeight)];
    if (self) {

        self.backgroundColor = KColorHex(0x282828);
        self.userInteractionEnabled = true;
        self.layer.masksToBounds = true;
        [self setRadiusWithRadius:KScale(20) corner:UIRectCornerTopLeft | UIRectCornerTopRight];
    }
    return self;
}

-(LPSegmentViewController *)segmentVC {
    if (!_segmentVC) {
        _segmentVC = [[LPSegmentViewController alloc] init];
        _segmentVC.pageViewControllers = self.controllerArray;
        _segmentVC.categoryView.titles = self.titleArray;
        _segmentVC.categoryView.originalIndex = 0;
        _segmentVC.categoryView.cellSpacing = KScale(24);
        _segmentVC.categoryView.titleNomalFont = KFont(14);
        _segmentVC.categoryView.titleSelectedFont = KFont(16);
        _segmentVC.categoryView.titleNormalColor = KColorHex(0x8E8E93);
        _segmentVC.categoryView.titleSelectedColor = KColorHex(0xFFFFFF);
        _segmentVC.categoryView.height = KScale(50);
        _segmentVC.categoryView.leftAndRightMargin = KScale(55);
        _segmentVC.categoryView.rightMargin = KScale(35);
        
    }
    return _segmentVC;
}
-(UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        _backButton.backgroundColor = KColorHex(0x282828);
        [_backButton setImage:[HFVKitUtils bundleImageWithName:@"navigation_back"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(dismissSegmentView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}


-(void)createUI {

//    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [obj removeFromSuperview];
//    }];
    self.segmentVC = nil;
    self.backgroundColor = KColorHex(0x282828);
    [self addSubview:self.segmentVC.view];
    [self addBackBtn];
    for (HFOpenRadioListViewController *listVC in self.controllerArray) {
        [listVC.detailView addRaidoDetailViewToView:self];
    }
    [self.segmentVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
}

-(void)addRaidoStationViewToView:(UIView *)view {
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

-(void)addBackBtn {
    [self addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self.mas_top).offset(KScale(25));
        make.width.height.mas_equalTo(KScale(44));
    }];
}

-(void)requestData {
    __weak typeof(self) weakSelf = self;
    [[HFOpenApiManager shared] channelWithSuccess:^(id  _Nullable response) {
        weakSelf.dataArray = [HFOpenChannelModel mj_objectArrayWithKeyValuesArray:response];
        for (HFOpenChannelModel *model in weakSelf.dataArray) {
            [weakSelf.titleArray addObject:model.groupName];
            HFOpenRadioListViewController *listVC = HFOpenRadioListViewController.new;
            listVC.groupId = model.groupId;
            [weakSelf.controllerArray addObject:listVC];
        }
        [self createUI];
    } fail:^(NSError * _Nullable error) {
        [HFVProgressHud showErrorWithError:error];
        [self addBackBtn];
    }];
}




//MARK: - 事件区域=================
//MARK: - 显示
-(void)showSegmentView {
    self.isShow = true;
    
    [self requestData];
    [self.superview layoutIfNeeded];
    [UIView animateWithDuration:0.15 animations:^{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.superview);
        }];
        [self.superview layoutIfNeeded];
    }];
    
}
//MARK: - 隐藏
-(void)dismissSegmentView {
    self.isShow = false;
    [self.superview layoutIfNeeded];
    [UIView animateWithDuration:0.15 animations:^{
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.width.equalTo(self.superview);
            make.height.mas_equalTo([HFVGlobalTool shareTool].songListHeight);
            make.left.equalTo(self.superview.mas_right);
        }];
        [self.superview layoutIfNeeded];
    }completion:^(BOOL finished) {
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
    }];
}

#pragma mark - 懒加载---数据
-(NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _titleArray;
}

-(NSMutableArray *)controllerArray {
    if (!_controllerArray) {
        _controllerArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _controllerArray;
}

@end
