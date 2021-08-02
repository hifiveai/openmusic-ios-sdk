//
//  HIFPlayerBarView.m
//  HIFPlayer
//
//  Created by 郭亮 on 2020/11/9.
//

#import "HIFPlayerBarView.h"
#import "HFPlayerApi.h"
#import "HFPlayerApiConfiguration.h"
#import "Masonry.h"
#import "HFPlayerModel.h"
#import "HFVSlider.h"


@interface HIFPlayerBarView () <HFPlayerStatusProtocol>

//UI
@property(nonatomic ,assign)BOOL  showBar;
@property(nonatomic ,strong)UIButton  *headImgBtn;
@property(nonatomic ,strong)UILabel   *titleLabel;

@property(nonatomic ,strong)UIButton  *previousBtn;
@property(nonatomic ,strong)UIButton  *playBtn;
@property(nonatomic ,strong)UIButton  *nextBtn;
@property(nonatomic ,strong)UIButton  *shrinkBtn;
@property(nonatomic ,strong)UIImageView                                        *loadingImgView;
@property(nonatomic ,strong)UILabel   *downloadLabel;
@property(nonatomic ,assign)NSInteger majorVersion;
@property(nonatomic ,assign)BOOL  isHeadAnimating;
@property(nonatomic ,copy)NSString*secondName;
@property(nonatomic ,strong)UIProgressView                                     *progressView;
@property(nonatomic ,strong)HFVSlider *slider;


//播放器
@property(nonatomic, strong)HFPlayerApi   *playerApi;
@property(nonatomic, strong)HFPlayerApiConfiguration  *playerConfig;
@property(nonatomic, assign)float currentDuration;
@property(nonatomic, copy)NSString*currentMusicId;

//数据
@property(nonatomic, strong)HFPlayerMusicModel                                 *currentModel;
@property(nonatomic, assign)NSUInteger currentIndex;

@property(nonatomic ,assign)BOOL  seeking;
@property(nonatomic ,assign)BOOL  cutSongEnable;

@end
@implementation HIFPlayerBarView

-(instancetype)initWithConfiguration:(HFPlayerConfiguration *)config {
    if (self = [super init]) {
        [self configUI];
        self.config = config;
        _cutSongEnable = true;
        [self configDefaultData];
        [self configNotification];
    }
    return self;
}
-(void)setConfig:(HFPlayerConfiguration *)config {
    _config = config;
    if (_playerApi) {
        HFPlayerApiConfiguration *apiConfig = [HFPlayerApiConfiguration defaultConfiguration];
        apiConfig.cacheEnable = _config.cacheEnable;
        apiConfig.bufferCacheSize = _config.bufferCacheSize;
        apiConfig.repeatPlay = _config.repeatPlay;
        apiConfig.networkAbilityEable = _config.networkAbilityEable;
        apiConfig.rate = _config.rate;
        _playerApi.config = apiConfig;
    }
    
    //UI显示更新
    if (config.canCutSong) {
        _previousBtn.enabled = true;
        _nextBtn.enabled = true;
    } else {
        _previousBtn.enabled = false;
        _nextBtn.enabled = false;
    }
    _titleLabel.text = config.songName;
    if (![HFVKitUtils isBlankString:config.imageUrlString]) {
       
        [_headImgBtn yy_setImageWithURL:[NSURL URLWithString:config.imageUrlString] forState:UIControlStateNormal placeholder:[HFVKitUtils bundleImageWithName:@"player_defaultHeader"]];
    } else {
        [_headImgBtn setImage:[HFVKitUtils bundleImageWithName:@"player_defaultHeader"] forState:UIControlStateNormal];
    }
    //判断是否关闭播放器
    if ([HFVKitUtils isBlankString:config.urlString]) {
        if (_playerApi) {
            [_playerApi stop];
            _playerApi = nil;
        }
        [self setShowBar:NO];
        _playBtn.enabled = false;
        return;
    } else {
        [self setShowBar:YES];
        _playBtn.enabled = true;
    }
}

-(void)play {
    //把上一首歌曲id和播放时长进行上报
    if (![HFVLibUtils isBlankString:_currentMusicId] && _currentDuration >0) {
        if ([self.delegate respondsToSelector:@selector(cutSongDuration:musicId:)]) {
            [self.delegate cutSongDuration:_currentDuration musicId:_currentMusicId];
        }
    }
    
    _currentDuration = 0;
    _currentMusicId = _config.musicId;
    self.slider.value = 0;
    self.progressView.progress = 0;
    [self startLoadingAnimate];
    [self.playerApi playWithUrlString:_config.urlString];
}

-(void)pause {
    [_playerApi pause];
}

-(void)resume {
    [_playerApi resume];
}

-(void)stop {
    [_playerApi stop];
}

#pragma mark - PrivateMethod
-(void)configDefaultData {
    self.secondName = @"";
    _currentDuration = 0.f;
}

-(void)configUI {
    self.layer.backgroundColor = [[[UIColor blackColor] colorWithAlphaComponent:0.5] CGColor];
    self.layer.cornerRadius = ceil(KScale(25)) ;
    [self addSubview:self.headImgBtn];
    self.headImgBtn.layer.cornerRadius = ceil(KScale(25)) ;
    [self addSubview:self.titleLabel];
 
    [self addSubview:self.previousBtn];
    [self addSubview:self.loadingImgView];
    [self addSubview:self.downloadLabel];
    [self addSubview:self.playBtn];
    [self addSubview:self.nextBtn];
    [self addSubview:self.progressView];
    [self addSubview:self.slider];
    [self addSubview:self.shrinkBtn];
}

-(void)updateChangeSongEnabled:(BOOL)enable {
    self.nextBtn.enabled = enable;
    self.previousBtn.enabled = enable;
}

#pragma mark - 配置view数据
-(void)setCurrentModel:(HFPlayerMusicModel *)currentModel {
    _currentModel = currentModel;
    if (!_currentModel) {
        self.titleLabel.text = @"";
        [self.headImgBtn yy_setImageWithURL:[NSURL URLWithString:@""] forState:UIControlStateNormal options:nil];
        return;
    }
    NSMutableString *text = [[NSMutableString alloc] init];
    [text appendString: currentModel.musicName];
    NSArray *artistAry = currentModel.artist;
    if (artistAry && artistAry.count>0) {
        NSDictionary *artistDic = artistAry[0];
        NSString *name = [artistDic objectForKey:@"name"];
        [text appendString:@"-"];
        [text appendString:name];
    }
    self.titleLabel.text = text;
    NSArray *coverAry = currentModel.cover;
    if (coverAry && coverAry.count>0) {
        HFPlayerMusicCoverModel *coverModel = coverAry[0];
        [self.headImgBtn yy_setImageWithURL:[NSURL URLWithString:coverModel.url] forState:UIControlStateNormal options:nil];
    }
}

-(void)updateSecondSongName:(NSString *)name {
    if (name) {
        self.secondName = name;
        if ([self.titleLabel.text isEqualToString:@""]) {
            self.titleLabel.text = self.secondName;
        }
    }
}

-(void)setShowBar:(BOOL)showBar {
    if (_showBar != showBar && self.superview) {
        CGRect currentFrame = self.frame;
        float rightPadding = showBar?KScale(20):self.superview.frame.size.width-
        KScale(20)-currentFrame.size.height;
        [UIView animateWithDuration:0.7 animations:^{
            for (int i=0; i<self.subviews.count; i++ ) {
                UIView *view = self.subviews[i];
                if (i!=0 ) {
                    view.alpha = showBar?((i==2 || i==3)?0.45:1):0;
                }
            }
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.superview).offset(KScale(20));
                make.right.equalTo(self.superview).offset(-rightPadding);
                make.top.equalTo(self.superview).offset(currentFrame.origin.y);
            }];
            [self.superview layoutIfNeeded];
        }];
        _showBar = showBar;
    }
}

#pragma mark - 动画
//开始歌曲头像旋转动画
-(void)startHeadRotationAnimate {
    if (_isHeadAnimating) {
        return;
    }
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    [self.headImgBtn.layer addAnimation:rotationAnimation forKey:@"headRotationAnimation"];
    _isHeadAnimating = YES;
}

//结束歌曲头像旋转动画
-(void)endHeadRotationAnimate {
    [self.headImgBtn.layer removeAllAnimations];
    _isHeadAnimating = NO;
}

//更新缓冲百分比
-(void)updateDownloadProgress:(int)progress {
    self.downloadLabel.text = [NSString stringWithFormat:@"%i%%",progress];
}

//显示下载缓冲样式
-(void)showDownloading:(BOOL) show {
    if (show) {
        self.playBtn.hidden = YES;
        //初次显示的时候重置进度显示
        self.downloadLabel.text = @"0%";
        self.downloadLabel.hidden = NO;
        self.playBtn.hidden = YES;
        self.loadingImgView.hidden = YES;
        
    } else {
        self.downloadLabel.hidden = YES;
        self.playBtn.hidden = NO;
        self.loadingImgView.hidden = YES;
    }
}

//开始加载动画
-(void)startLoadingAnimate {
    if (!self.loadingImgView.animating) {
        [self.loadingImgView startAnimating];
    }
    self.playBtn.hidden = YES;
    self.downloadLabel.hidden = YES;
    self.loadingImgView.hidden = NO;
}

//关闭加载动画
-(void)stopLoadingAnimate {
    self.playBtn.hidden = NO;
    self.loadingImgView.hidden = YES;
    self.downloadLabel.hidden = YES;
}

- (CAShapeLayer *)buildShapeLayerColor:(UIColor *)color lineWidth:(CGFloat)width  {
    CAShapeLayer *layer = [CAShapeLayer layer];
    //CGRect rect = {2 * 0.5, 29, 30 - 2, 30 - 2};
    // 设置path
    CGPoint center = CGPointMake(KScale(15), KScale(15));  //设置圆心位置
    CGFloat radius = KScale(14);  //设置半径
    CGFloat startA = - M_PI_2;  //圆起点位置
    CGFloat endA = -M_PI_2 + M_PI * 2;  //圆终点位置
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
    //UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    layer.path = path.CGPath;
    // 设置layer
    layer.strokeColor = color.CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = width;
    layer.lineCap = kCALineCapRound;
    return layer;
}

//展开动画
-(void)unfoldAnimation {
    [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionLayoutSubviews animations:^{
        for (int i=0; i<self.subviews.count; i++ ) {
            UIView *view = self.subviews[i];
            view.alpha = 1;
        }
        [self.superview layoutIfNeeded];
    } completion:nil];
    
    [UIView animateWithDuration:0.7 animations:^{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.superview).offset(KScale(20));
            make.right.equalTo(self.superview).offset(-KScale(20));
            make.top.equalTo(self.superview).offset(self.frame.origin.y);
        }];
        [self.superview layoutIfNeeded];
    }];
}

//收起动画
-(void)shrinkAnimation {
    [UIView animateWithDuration:0.5 animations:^{
        for (int i=0; i<self.subviews.count; i++ ) {
            UIView *view = self.subviews[i];
            if (i!=0 && i!=self.subviews.count-1) {
                view.alpha = 0;
            }
        }
        [self.superview layoutIfNeeded];
    }];
    [UIView animateWithDuration:0.7 animations:^{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.superview).offset(KScale(20));
            make.right.equalTo(self.superview).offset(-KScreenWidth+KScale(110));//305
            make.top.equalTo(self.superview).offset(self.frame.origin.y);
        }];
        [self.superview layoutIfNeeded];
    }];
}

#pragma mark - 通知处理
-(void)configNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterPlaygroundNotificationHander) name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //selector:@selector(songListMovedNotificationHander:) name:KNotification_songListMoved
    //  object:nil];
}

-(void)appDidEnterPlaygroundNotificationHander {
    if (_isHeadAnimating) {
        //如果正在播放状态，回到前台后需要重新开始动画
        HFLog(@"header动画ing");
        [self endHeadRotationAnimate];
        [self startHeadRotationAnimate];
    }
}

#pragma mark - Action
-(void)headImgBtnClick:(UIButton *)sender {
    sender.selected = YES;
    if ([self.delegate respondsToSelector:@selector(headerClick)]) {
        [self.delegate headerClick];
    }
}



//上一首
-(void)previousBtnClick:(UIButton *)sender {
    if (!_cutSongEnable) {
        return;
    }
    _cutSongEnable = false;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.cutSongEnable = true;
    });
    if ([self.delegate respondsToSelector:@selector(previousBtnClick:)]) {
        [self.delegate previousBtnClick:sender];
    }
}

//播放/暂停
-(void)playBtnClick:(UIButton *)sender {
    //sender.selected YES:播放  NO:暂停
    if (sender.selected) {
        [_playerApi pause];
    } else {
        [_playerApi resume];
    }
    if ([self.delegate respondsToSelector:@selector(playBtnClick:)]) {
        [self.delegate playBtnClick:sender];
    }
}

//下一首
-(void)nextBtnClick:(UIButton *)sender {
    if (!_cutSongEnable) {
        return;
    }
    _cutSongEnable = false;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.cutSongEnable = true;
    });
    if ([self.delegate respondsToSelector:@selector(nextBtnClick:)]) {
        [self.delegate nextBtnClick:sender];
    }
}

//收缩/展开
-(void)shrinkBtnClick:(UIButton *)sender {
    //sender.selected YES:收起  NO:展开
    sender.selected = !sender.selected;
    if (sender.selected) {
        //收起
        [self shrinkAnimation];
    } else {
        //展开
        [self unfoldAnimation];
    }
    
}

#pragma mark - HFPlayerApiDelegate
/// 播放器状态更新
-(void)playerStatusChanged:(HFPlayerStatus)status {
    switch (status) {
        case HFPlayerStatusInit:
        {
            [self startLoadingAnimate];
        }
        case HFPlayerStatusReadyToPlay:
        {
            
        }
            break;
        case HFPlayerStatusPlaying:
        {
            [self stopLoadingAnimate];
            if (!self.playBtn.selected) {
                self.playBtn.selected = true;
            }
        }
            break;
        case HFPlayerStatusPasue:
        {
            [self endHeadRotationAnimate];
            [self stopLoadingAnimate];
            if (self.playBtn.selected) {
                self.playBtn.selected = NO;
            }
        }
            break;
        case  HFPlayerStatusBufferEmpty:
        {
            [self startLoadingAnimate];
        }
            break;
        case HFPlayerStatusBufferKeepUp:
        {
            [self stopLoadingAnimate];
        }
            break;
        case HFPlayerStatusStoped:
        {
            [self endHeadRotationAnimate];
            self.playBtn.selected = NO;
            self.slider.value = 0.f;
        }
            break;
        case HFPlayerStatusError:
        {
            [self startLoadingAnimate];
        }
        default:
            break;
    }
    
}

/// 播放进度回调
-(void)playerPlayProgress:(float)progress currentDuration:(float)currentDuration totalDuration:(float)totalDuration {
    _currentDuration = currentDuration;
    if (!_seeking) {
        self.slider.value = progress;
    }
}

/// 数据缓冲进度回调
-(void)playerLoadingProgress:(float)progress {
    self.progressView.progress = progress;
}

/// 播放器数据缓冲
-(void)playerLoadingBegin {
    [self startLoadingAnimate];
}

/// 播放器数据缓冲结束，继续播放
-(void)playerLoadingEnd {
    [self stopLoadingAnimate];
}

/// 播放完成回调
-(void)playerPlayToEnd {
    if ([self.delegate respondsToSelector:@selector(playerPlayToEnd)]) {
        [self.delegate playerPlayToEnd];
    }
    _currentDuration = 0;
}

#pragma mark - Slider 拖拽事件
-(void)sliderValueChanged:(HFVSlider *)sender {
    //值改变
    
}

-(void)slidertouchDown:(HFVSlider *)sender {
    //拖动开始
    _seeking = YES;
}

-(void)sliderTouchUpInSide:(HFVSlider *)sender {
    //拖动结束
    _seeking = NO;
    [_playerApi seekToProgress:sender.value];
}


#pragma mark - dealloc
-(void)dealloc {
    HFLog(@"^^^^^^^^^^^^^^^^^dealloc^^^^^^^^^^^^^^^%@",self.class);
}

-(HFPlayerApi *)playerApi {
    if (!_playerApi) {
        HFPlayerApiConfiguration *config = [HFPlayerApiConfiguration defaultConfiguration];
        config.cacheEnable = _config.cacheEnable;
        config.bufferCacheSize = _config.bufferCacheSize;
        config.repeatPlay = _config.repeatPlay;
        config.networkAbilityEable = _config.networkAbilityEable;
        config.rate = _config.rate;
        _playerConfig = config;
        _playerApi = [[HFPlayerApi alloc] initPlayerWtihConfiguration:_playerConfig];
        _currentIndex = 0;
        _playerApi.delegate = self;
    }
    return _playerApi;
}

#pragma mark - UI界面
-(UIButton *)headImgBtn {
    if (!_headImgBtn) {
        _headImgBtn = [[UIButton alloc] init];
        [_headImgBtn setBackgroundImage:[HFVKitUtils bundleImageWithName:@"player_defaultHeader"] forState:UIControlStateNormal];
        _headImgBtn.clipsToBounds = YES;
        _headImgBtn.imageView.contentMode = UIViewContentModeScaleToFill;
        [_headImgBtn addTarget:self action:@selector(headImgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headImgBtn;
}

-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:KScale(12)];
        _titleLabel.alpha = 0;
    }
    return _titleLabel;
}



-(UIButton *)previousBtn {
    if (!_previousBtn) {
        _previousBtn = [[UIButton alloc] init];
        [_previousBtn addTarget:self action:@selector(previousBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_previousBtn setBackgroundImage:[HFVKitUtils bundleImageWithName:@"player_previous"] forState:UIControlStateNormal];
        [_previousBtn setBackgroundImage:[HFVKitUtils bundleImageWithName:@"player_previous_unable"] forState:UIControlStateDisabled];
        _previousBtn.alpha = 0;
        _previousBtn.enabled = false;
    }
    return _previousBtn;
}

-(UIImageView *)loadingImgView {
    if (!_loadingImgView) {
        _loadingImgView = [[UIImageView alloc] init];
        _loadingImgView.hidden = YES;
        _loadingImgView.layer.borderWidth = KScale(1);
        _loadingImgView.layer.borderColor = [[UIColor whiteColor] CGColor];
        _loadingImgView.layer.cornerRadius = KScale(15);
        _loadingImgView.contentMode = UIViewContentModeScaleAspectFit;
        NSMutableArray  *arrayM=[NSMutableArray array];
        for (int i=0; i<31; i++) {
            [arrayM addObject:[HFVKitUtils bundleImageWithName:[NSString stringWithFormat:@"frame-%i",i]]];
            
        }
        //设置动画数组
        [_loadingImgView setAnimationImages:arrayM];
        //设置动画播放次数
        [_loadingImgView setAnimationRepeatCount:floor(MAXFLOAT)];
        //设置动画播放时间
        [_loadingImgView setAnimationDuration:1];
        [_loadingImgView startAnimating];
        _loadingImgView.backgroundColor = [UIColor redColor];
    }
    return _loadingImgView;
}

-(UILabel *)downloadLabel {
    if (!_downloadLabel) {
        _downloadLabel = [[UILabel alloc] init];
        _downloadLabel.hidden = YES;
        _downloadLabel.layer.borderWidth = KScale(1);
        _downloadLabel.layer.borderColor = [[UIColor whiteColor] CGColor];
        _downloadLabel.layer.cornerRadius = KScale(15);
        _downloadLabel.textColor = UIColor.whiteColor;
        _downloadLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:KScale(9)];
        _downloadLabel.textAlignment = NSTextAlignmentCenter;
        _downloadLabel.hidden = YES;
        _downloadLabel.text = @"0%";
    }
    return _downloadLabel;
}

-(UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [[UIButton alloc] init];
        [_playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_playBtn setBackgroundImage:[HFVKitUtils bundleImageWithName:@"player_play"] forState:UIControlStateNormal];
        [_playBtn setBackgroundImage:[HFVKitUtils bundleImageWithName:@"player_pause"] forState:UIControlStateSelected];
        _playBtn.alpha = 0;
        _playBtn.enabled = false;
    }
    return _playBtn;
}

-(UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc] init];
        [_nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_nextBtn setBackgroundImage:[HFVKitUtils bundleImageWithName:@"player_next"] forState:UIControlStateNormal];
        [_nextBtn setBackgroundImage:[HFVKitUtils bundleImageWithName:@"player_next_unable"] forState:UIControlStateDisabled];
        _nextBtn.enabled = false;
        _nextBtn.alpha = 0;
    }
    return _nextBtn;
}

-(UIButton *)shrinkBtn {
    if (!_shrinkBtn) {
        _shrinkBtn = [[UIButton alloc] init];
        [_shrinkBtn addTarget:self action:@selector(shrinkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_shrinkBtn setBackgroundImage:[HFVKitUtils bundleImageWithName:@"player_shrink"] forState:UIControlStateNormal];
        [_shrinkBtn setBackgroundImage:[HFVKitUtils bundleImageWithName:@"player_spread"] forState:UIControlStateSelected];
        _shrinkBtn.alpha = 0;
    }
    return _shrinkBtn;
}

-(UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.trackTintColor = [UIColor.whiteColor colorWithAlphaComponent:0.1];
        _progressView.tintColor = [UIColor.grayColor colorWithAlphaComponent:0.8f];
        _progressView.alpha = 0;
    }
    return _progressView;
}

-(HFVSlider *)slider {
    if (!_slider) {
        _slider = [[HFVSlider alloc] init];
        _slider.backgroundColor = UIColor.clearColor;
        _slider.maximumTrackTintColor = UIColor.clearColor;
        _slider.tintColor = UIColor.whiteColor;
        _slider.alpha = 0;
        _slider.value = 0.0;
        [_slider trackRectForBounds:CGRectMake(0, 0, KScreenWidth, KScale(11.5))];
        [_slider setThumbImage:[HFVKitUtils bundleImageWithName:@"player_slider"] forState:UIControlStateNormal];
        [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_slider addTarget:self action:@selector(slidertouchDown:) forControlEvents:UIControlEventTouchDown];
        [_slider addTarget:self action:@selector(sliderTouchUpInSide:) forControlEvents:UIControlEventTouchUpInside];
        [_slider addTarget:self action:@selector(sliderTouchUpInSide:) forControlEvents:UIControlEventTouchUpOutside];
    }
    return _slider;
}


#pragma mark - Layout
-(void)updateConstraints {
    
    [self.headImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.equalTo( self.mas_height);
    }];
    
    [self.headImgBtn.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.headImgBtn);
    }];
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgBtn.mas_right).offset(KScale(10));
        make.centerY.equalTo(self);
        make.right.equalTo(self.previousBtn.mas_left);
        make.height.mas_equalTo(KScale(16));
    }];
    
    
    [self.shrinkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-KScale(5));
        make.width.mas_equalTo(KScale(20));
        make.height.mas_equalTo(KScale(20));
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.shrinkBtn.mas_left).offset(-KScale(5));
        make.width.mas_equalTo(KScale(30));
        make.height.mas_equalTo(KScale(30));
    }];
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.nextBtn.mas_left).offset(-KScale(10));
        make.width.mas_equalTo(KScale(30));
        make.height.mas_equalTo(KScale(30));
    }];
    
    [self.loadingImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.nextBtn.mas_left).offset(-KScale(10));
        make.width.mas_equalTo(KScale(30));
        make.height.mas_equalTo(KScale(30));
    }];
    
    [self.downloadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.nextBtn.mas_left).offset(-KScale(10));
        make.width.mas_equalTo(KScale(30));
        make.height.mas_equalTo(KScale(30));
    }];
    
    [self.previousBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.nextBtn.mas_left).offset(-KScale(50));
        make.width.mas_equalTo(KScale(30));
        make.height.mas_equalTo(KScale(30));
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-KScale(1.75));
        make.left.equalTo(self).offset(KScale(60));
        make.right.equalTo(self).offset(KScale(-30));
        make.height.mas_equalTo(KScale(1.5));
    }];
    
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.bottom.equalTo(self);
        make.left.equalTo(self).offset(KScale(60));
        make.right.equalTo(self).offset(KScale(-30));
        make.height.mas_equalTo(KScale(5));
        make.centerY.equalTo(self.progressView.mas_centerY);
    }];
    [super updateConstraints];
}

+(BOOL)requiresConstraintBasedLayout {
    return YES;
}

@end
