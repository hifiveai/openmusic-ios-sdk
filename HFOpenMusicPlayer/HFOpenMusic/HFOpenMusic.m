//
//  HFOpenMusic.m
//  HFOpenMusic
//
//  Created by 郭亮 on 2021/3/17.
//

#import <Foundation/Foundation.h>
#import "HFOpenMusic.h"
#import "HFOpenMusicSegmentView.h"
#import <SVProgressHUD/SVProgressHUD.h>
@interface HFOpenMusic () <HFOpenMusicPlayDelegate ,HFPlayerDelegate>

@property(nonatomic ,strong)HFPlayer *player;
@property(nonatomic ,assign)HFOpenMusicListenType  listenType;
@property(nonatomic ,strong)HFOpenMusicSegmentView *segment;
@property(nonatomic ,strong)UIButton *showBtn;

@end


@implementation HFOpenMusic

-(instancetype)initMusicListViewWithListenType:(HFOpenMusicListenType)type showControlbtn:(BOOL)showControlbtn {
    if (self = [super init]) {
        _listenType = type;
        [self configUI];
        if (showControlbtn) {
            [self addShowButton];
        }
    }
    return self;
}

-(void)addMusicListView {
    if (self) {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
}

-(void)removeMusicListView {
    if (self.superview) {
        [self removeFromSuperview];
    }
}

-(void)configUI {
  
    //440
    self.frame = CGRectMake(0,0,KScreenWidth,KScreenHeight);
    
    //列表
    HFOpenMusicSegmentView *segment = [[HFOpenMusicSegmentView alloc] init];
    segment.deleagte = self;
    segment.listenType = _listenType;
    [segment addSegmentViewToView:self];
    _segment = segment;
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
}

-(void)addShowButton {
    //向上移动按钮
    UIButton *showBtn = [[UIButton alloc] init];
    [showBtn setBackgroundImage:[HFVKitUtils bundleImageWithName:@"player_defaultHeader"] forState:UIControlStateNormal];
    showBtn.layer.cornerRadius = KScale(25);
    [showBtn addTarget:self action:@selector(showMusicSegmentView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:showBtn];
    [showBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(KScale(20));
        make.top.equalTo(self).offset(KScreenHeight-KScale(500));
        make.width.height.mas_equalTo(KScale(50));
    }];
    //拖拽手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panShowBtn:)];
    [showBtn addGestureRecognizer:pan];
    self.showBtn = showBtn;
}

#pragma mark - 拖拽手势
-(void)panShowBtn:(UIPanGestureRecognizer *)recognizer {
        
    CGPoint translation = [recognizer translationInView:self.superview];
    CGPoint newCenter = CGPointMake(recognizer.view.center.x ,
                                    recognizer.view.center.y + translation.y);
    //判断用户传过来的topLimit和bottomLimit
    NSUInteger topLimit = 44;
    NSUInteger bottomLimit = 0;
    //能滑动最大高度（根据歌曲列表是否显示）
    float maxHeight = self.bounds.size.height;
    if (topLimit<(maxHeight-bottomLimit) &&
        topLimit>_showBtn.frame.size.height/2 &&
        bottomLimit>=0
        ) {
        newCenter.y = MAX(topLimit+_showBtn.frame.size.height/2, newCenter.y);
        newCenter.y = MIN((maxHeight-bottomLimit)- recognizer.view.frame.size.height/2, newCenter.y);
    } else{
        newCenter.y = MAX(_showBtn.frame.size.height/2, newCenter.y);
        newCenter.y = MIN(maxHeight - recognizer.view.frame.size.height/2, newCenter.y);
    }
    recognizer.view.center = newCenter;
    [recognizer setTranslation:CGPointZero inView:_showBtn];
    [self.showBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(newCenter.x-recognizer.view.frame.size.width/2);
        make.top.mas_equalTo(newCenter.y-recognizer.view.frame.size.height/2);
        make.width.mas_equalTo(recognizer.view.frame.size.width);
        make.height.mas_equalTo(recognizer.view.frame.size.height);
    }];
}


-(void)showMusicSegmentView {
    [self.segment showMusicSegmentView];
}

-(void)dismissView {
    [self.segment dismissView];
}
#pragma mark - Segment Delegate
//播放的歌曲发生改变
-(void)currentPlayChangedMusic:(HFOpenMusicModel *)musicModel detail:(HFOpenMusicDetailInfoModel *)detailModel canCutSong:(BOOL)canCutSong {
    if ([self.delegate respondsToSelector:@selector(currentPlayChangedMusic:detail:canCutSong:)]) {
        [self.delegate currentPlayChangedMusic:musicModel detail:detailModel canCutSong:canCutSong];
    }
}

-(void)canCutSongChanged:(BOOL)canCutSong {
    if ([self.delegate respondsToSelector:@selector(canCutSongChanged:)]) {
        [self.delegate canCutSongChanged:canCutSong];
    }
}


#pragma mark - HFPlayerDelegate
-(void)previousPlay {
    [self.segment cutSongWithType:0];
    
}

-(void)nextPlay {
    [self.segment cutSongWithType:1];
}

-(void)cutSongDuration:(float)duration musicId:(NSString *)musicId{
    [self.segment playDataUpload:duration musicId:musicId];
}

#pragma mark - 事件传递
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {

    UIView *targetView = [super hitTest:point withEvent:event];
    if ([targetView class]==[self class]) {
        //没有子控件，只能自己处理
        //传递到被遮挡的用户页面去
        return nil;
    } else {
        //有子控件，不用考虑遮挡问题
        return targetView;
    }
}


#pragma mark - dealloc
-(void)dealloc {
    //[_player.config removeObserver:self forKeyPath:@"currentPlayIndex"];
}
@end
