//
//  HFPlayer.m
//  HFPlayer
//
//  Created by 郭亮 on 2021/3/16.
//

#import <Foundation/Foundation.h>
#import "HFPlayer.h"
#import "HIFPlayerBarView.h"

@interface HFPlayer () <HFPlayerViewDelegate>

@property(nonatomic ,strong)HIFPlayerBarView                             *barView;

@end

@implementation HFPlayer


-(instancetype)initWithConfiguration:(HFPlayerConfiguration *)config {
    if (self = [super init]) {
        _config = config;
        [self configUI];
        [self configGestureRecognizer];
    }
    return self;
}

-(void)setConfig:(HFPlayerConfiguration *)config {
    _barView.config = [config copy];
    _config = config;
}

-(void)configUI {
    self.frame = CGRectMake(0, KScreenHeight-KScale(440+50+10), KScreenWidth, KScale(50));
    _barView = [[HIFPlayerBarView alloc] initWithConfiguration:[_config copy]];
    _barView.delegate = self;
    [self addSubview: _barView];
    [_barView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self).offset(15);
//        make.right.mas_equalTo(self).offset(-15);
//        make.top.bottom.mas_equalTo(self);
        make.left.equalTo(self).offset(KScale(20));
        make.right.equalTo(self).offset(-KScreenWidth+KScale(70));//20 305
//        make.bottom.equalTo(self).offset(-[HFVGlobalTool shareTool].songListHeight-KScale(30));
//        make.height.mas_equalTo(KScale(50));
        make.top.bottom.mas_equalTo(self);
    }];
}

-(void)configGestureRecognizer {
    //拖拽手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPlayerBar:)];
    [self addGestureRecognizer:pan];
}

#pragma mark - 拖拽手势
-(void)panPlayerBar:(UIPanGestureRecognizer *)recognizer {
        
    CGPoint translation = [recognizer translationInView:self.superview];
    CGPoint newCenter = CGPointMake(recognizer.view.center.x ,
                                    recognizer.view.center.y + translation.y);
    //判断用户传过来的topLimit和bottomLimit
    NSUInteger topLimit = _config.panTopLimit;
    NSUInteger bottomLimit = _config.panBottomLimit;
    //能滑动最大高度（根据歌曲列表是否显示）
    float maxHeight = self.superview.bounds.size.height;
    if (topLimit<(maxHeight-bottomLimit) &&
        topLimit>self.frame.size.height/2 &&
        bottomLimit>=0
        ) {
        newCenter.y = MAX(topLimit+self.frame.size.height/2, newCenter.y);
        newCenter.y = MIN((maxHeight-bottomLimit)- recognizer.view.frame.size.height/2, newCenter.y);
    } else{
        newCenter.y = MAX(self.frame.size.height/2, newCenter.y);
        newCenter.y = MIN(maxHeight - recognizer.view.frame.size.height/2, newCenter.y);
    }
    recognizer.view.center = newCenter;
    [recognizer setTranslation:CGPointZero inView:self];
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(newCenter.x-recognizer.view.frame.size.width/2);
        make.top.mas_equalTo(newCenter.y-recognizer.view.frame.size.height/2);
        make.width.mas_equalTo(recognizer.view.frame.size.width);
        make.height.mas_equalTo(recognizer.view.frame.size.height);
    }];
}

#pragma mark - HFPlayerViewDelegate
-(void)headerClick {
    if ([self.delegate respondsToSelector:@selector(headerClick)]) {
        [self.delegate headerClick];
    }
}

-(void)previousBtnClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(previousPlay)]) {
        [self.delegate previousPlay];
    }
}

-(void)nextBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(nextPlay)]) {
        [self.delegate nextPlay];
    }
}

-(void)playBtnClick:(UIButton *)sender {
    
}

-(void)playerPlayToEnd {
    if (self.config.autoNext) {
        if ([self.delegate respondsToSelector:@selector(nextPlay)]) {
            [self.delegate nextPlay];
        }
    }
    if ([self.delegate respondsToSelector:@selector(playerPlayToEnd)]) {
        [self.delegate playerPlayToEnd];
    }
}

-(void)cutSongDuration:(float)duration musicId:(NSString *)musicId {
    if ([self.delegate respondsToSelector:@selector(cutSongDuration:musicId:)]) {
        [self.delegate cutSongDuration:duration musicId:musicId];
    }
}

@end
