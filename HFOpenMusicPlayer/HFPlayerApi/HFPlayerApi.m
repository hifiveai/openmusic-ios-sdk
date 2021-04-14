//
//  HFPlayerApi.m
//  HFPlayerApi
//
//  Created by 郭亮 on 2021/3/16.
//

#import "HFPlayerApi.h"
#import "HFResourceLoaderManager.h"
#import "HFPlayerCacheManager.h"

@interface HFPlayerApi ()

@property(nonatomic ,assign)HFPlayerStatus                              status;
@property(nonatomic ,strong)HFPlayerApiConfiguration                    *config;

//----播放器----
//url
@property(nonatomic ,strong)NSURL                                       *url;
//播放器
@property(nonatomic ,strong)AVPlayer                                    *hfPlayer;
//播放器观察者
@property(nonatomic ,strong)id                                          playerObserver;
//歌曲总时长
@property(nonatomic ,assign)float                                       totalSeconds;

//----缓存----
@property(nonatomic ,strong)HFResourceLoaderManager                     *resourceLoaderManager;

@property(nonatomic ,assign)float                                       currentSeekProgress;

@property(nonatomic ,assign)float                                       currentPlayProgress;

@property(nonatomic ,assign)float                                       currentLoadProgress;

@property(nonatomic ,assign)BOOL                                        isPlaying;

@end

@implementation HFPlayerApi

#pragma mark - 🐠初始化播放🐠
-(void)setStatus:(HFPlayerStatus)status {
    if (status != _status) {
        _status = status;
        if ([self.delegate respondsToSelector:@selector(playerStatusChanged:)]) {
            [self.delegate playerStatusChanged:status];
        }
    }
}

-(instancetype)initPlayerWtihUrl:(NSURL *)url configuration:(HFPlayerApiConfiguration *)config {
    if (self = [super init]) {
        [self configDefaultSetting];
        self.config = config?config:[HFPlayerApiConfiguration defaultConfiguration];
        //初始化播放器
        AVPlayerItem *playerItem;
        if (!self.hfPlayer) {
            self.status = HFPlayerStatusLoading;
            [self.resourceLoaderManager cleanNotCompleteSongCache];
            if ([[HFPlayerCacheManager shared] isExistCacheWithUrl:url]) {
                //有缓存，播放本地
                NSString *localPath = [[HFPlayerCacheManager shared] getCachePathWithUrl:url];
                NSURL *url = [NSURL fileURLWithPath:localPath];
                playerItem = [AVPlayerItem playerItemWithURL:url];
            } else {
                //无缓存，需要请求
                HFResourceLoaderManager *resourceLoaderManager = [HFResourceLoaderManager new];
                resourceLoaderManager.config = _config;
                self.resourceLoaderManager = resourceLoaderManager;
                playerItem = [resourceLoaderManager playerItemWithURL:url];
            }
            self.url = url;
            self.hfPlayer = [AVPlayer playerWithPlayerItem:playerItem];
            if (@available(iOS 10.0, *)) {
            [_hfPlayer setAutomaticallyWaitsToMinimizeStalling:false]; // 禁止缓冲完成再播放
            }
            //播放进度监听
            [self configPlayerObserve];
            //kvo监听
            [self configKVO:playerItem];
            //通知
            [self configNotification:playerItem];
            [self configNotification];
        }
    }
    return self;
}

-(void)replaceCurrentUrlWithUrl:(NSURL *)url configuration:(HFPlayerApiConfiguration *)config {
    LPLog(@"-----playerApiReplaceUrl:%@-----",url.absoluteString);
    [self.resourceLoaderManager cleanNotCompleteSongCache];
    if (self.hfPlayer) {
        self.status = HFPlayerStatusLoading;
        AVPlayerItem *playerItem;
        if (config) {
            _config = config;
        }
        //移除KVO监听
        [self removeKvo];
        //移除通知
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.hfPlayer.currentItem];
        
        if ([[HFPlayerCacheManager shared] isExistCacheWithUrl:url]) {
            //有缓存，播放本地
            LPLog(@"-----replaceHasCache-----");
            NSString *localPath = [[HFPlayerCacheManager shared] getCachePathWithUrl:url];
            NSURL *url = [NSURL fileURLWithPath:localPath];
            playerItem = [AVPlayerItem playerItemWithURL:url];
            [self.hfPlayer replaceCurrentItemWithPlayerItem:playerItem];
        } else {
            //无缓存，需要请求
            LPLog(@"-----replaceNoCache-----");
            HFResourceLoaderManager *resourceLoaderManager = [HFResourceLoaderManager new];
            resourceLoaderManager.config = _config;
            self.resourceLoaderManager = resourceLoaderManager;
            playerItem = [resourceLoaderManager playerItemWithURL:url];
            [self.hfPlayer replaceCurrentItemWithPlayerItem:playerItem];
        }
        //kvo监听
        [self configKVO:playerItem];
        //通知
        [self configNotification:playerItem];
    }
}

//默认设置
-(void)configDefaultSetting {
    //解决手机静音导致播放器静音
    AVAudioSession *avSession = [AVAudioSession sharedInstance];
    [avSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [avSession setActive:YES error:nil];
    
    self.status = HFPlayerStatusInit;
}

-(void)setPlayerView:(UIView *)view {
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.hfPlayer];
    layer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 250);
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [view.layer addSublayer:layer];
}

#pragma mark - 🐠播放控制🐠
//开始播放
-(void)play {
    if (self.hfPlayer) {
        if (self.status == HFPlayerStatusUnknow || self.status == HFPlayerStatusFailed) {
            return;
        }
        [self.hfPlayer play];
        [self.hfPlayer setRate:_config.rate];
        self.status = HFPlayerStatusPlaying;
    }
}

//暂停播放
-(void)pause {
    if (self.hfPlayer) {
        [self.hfPlayer pause];
        self.status = HFPlayerStatusPasue;
    }
}

//恢复播放
-(void)resume {
    if (self.hfPlayer) {
        [self.hfPlayer play];
    }
}

//停止播放
-(void)stop {
    if (self.hfPlayer) {
        [self.hfPlayer pause];
        self.status = HFPlayerStatusStoped;
        [self destroy];
    }
}

//拖动播放（时间）
-(void)seekToDuration:(float)duration {
    if (duration<0) {
        return;
    }
    if (self.status == HFPlayerStatusFailed) {
        return;
    }
    [self pause];
    _resourceLoaderManager.seeking = YES;
    _resourceLoaderManager.requestRecord = YES;
    __weak typeof(self) weakSelf = self;
    //CMTimeMakeWithSeconds(duration, NSEC_PER_SEC)
    //进入缓冲状态
    self.status = HFPlayerStatusBufferEmpty;
    if ([self.delegate respondsToSelector:@selector(playerLoadingBegin)]) {
        [self.delegate playerLoadingBegin];
    }
    int timescale = _hfPlayer.currentItem.duration.timescale;
    [self.hfPlayer.currentItem seekToTime:CMTimeMake(duration*timescale, timescale) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
        if (finished) {
            [weakSelf play];
        }
    }];
}

//拖动播放（进度）
-(void)seekToProgress:(float)progress {
    _currentSeekProgress = progress;
    float targetSecond = _totalSeconds*progress;
    [self seekToDuration:targetSecond];
}

//倍数播放
-(void)configPlayRate:(float)rate {
    if (rate<0.0 || rate>2.0) {
        return;
    }
    if (_hfPlayer) {
        [_hfPlayer setRate:rate];
        _config.rate = rate;
    }
}

//音量控制
-(void)configVolume:(float)volume {
    if (_hfPlayer) {
        [_hfPlayer setVolume:volume];
    }
}

#pragma mark - 加载媒体资源数据
-(void)loadMediaData {
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_needMoreData object:nil];
}

#pragma mark - 🐠缓存相关🐠
//清除缓存
-(void)clearCache {
    [[HFPlayerCacheManager shared] cleanSongCache];
}

#pragma mark - 🐠销毁播放器🐠
-(void)destroy {
    if (self.hfPlayer) {
        //移除观察者
        [self.hfPlayer removeTimeObserver:_playerObserver];
        //移除kvo
        [self removeKvo];
        //移除通知
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.hfPlayer.currentItem];
        self.hfPlayer = nil;
    }
}

#pragma mark - 🐠播放器进度监听🐠
//播放器进度监听
-(void)configPlayerObserve {
    __weak typeof(self) weakSelf = self;
    _playerObserver = [self.hfPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 16.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        if (!weakSelf.isPlaying) {
            weakSelf.isPlaying = YES;
        }
        float current = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds(weakSelf.hfPlayer.currentItem.duration);
        float progress = current/total;
        weakSelf.totalSeconds = total;
        weakSelf.currentPlayProgress = progress;
        if ([weakSelf.delegate respondsToSelector:@selector(playerPlayProgress:currentDuration:totalDuration:)]) {
            [weakSelf.delegate playerPlayProgress:progress currentDuration:current totalDuration:total];
        }
        //通知Downloader播放进度
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_playProgress object:nil userInfo:@{@"progress": [NSString stringWithFormat:@"%f",progress]}];
    }];
}

#pragma mark - 🐠播放器KVO监听🐠
-(void)configKVO:(AVPlayerItem *)playerItem {
    //播放器状态监听
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //缓冲进度监听
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    //播放缓冲
    [playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
}

//KVO回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    AVPlayerItem *playerItem=object;
    if ([keyPath isEqualToString:@"status"]) {
        switch (playerItem.status) {
            case AVPlayerItemStatusUnknown:
                LPLog(@"未知状态，此时不能播放");
                self.status = HFPlayerStatusUnknow;
                break;
            case AVPlayerItemStatusReadyToPlay:
                LPLog(@"准备完毕，可以播放");
                self.status = HFPlayerStatusReadyToPlay;
                //[self.hfPlayer play];
                break;
            case AVPlayerItemStatusFailed:
                LPLog(@"加载失败，网络或者服务器出现问题");
                self.status = HFPlayerStatusFailed;
                break;
            default:
                break;
        }
    } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
        if (playerItem.isPlaybackBufferEmpty) {
            //缓冲ing
            LPLog(@"playbackBufferEmpty");
            self.status = HFPlayerStatusBufferEmpty;
            if ([self.delegate respondsToSelector:@selector(playerLoadingBegin)]) {
                [self.delegate playerLoadingBegin];
            }
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        //文件缓冲进度
        CMTimeRange timeRange = [playerItem.loadedTimeRanges.firstObject CMTimeRangeValue];//本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        float progressF = totalBuffer/CMTimeGetSeconds(playerItem.duration);
        self.currentLoadProgress = progressF;
        if (self.currentLoadProgress>self.currentPlayProgress) {
            self.status = HFPlayerStatusBufferKeepUp;
            if ([self.delegate respondsToSelector:@selector(playerLoadingEnd)]) {
                [self.delegate playerLoadingEnd];
            }
        }
        //向上取整数 ceil
        if (!isnan(progressF)) {
            if ([self.delegate respondsToSelector:@selector(playerLoadingProgress:timeRange:)]) {
                [self.delegate playerLoadingProgress:progressF timeRange:timeRange];
            }
            NSNumber *testNumber = [NSDecimalNumber numberWithFloat:progressF];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_loadingProgress object:nil userInfo:@{@"progress":testNumber}];
        }
    }
}

//KVO移除
-(void)removeKvo {
    [self.hfPlayer.currentItem removeObserver:self forKeyPath:@"status"];
    [self.hfPlayer.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.hfPlayer.currentItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
}

#pragma mark - 🐠通知🐠
-(void)configNotification:(AVPlayerItem *)playerItem {
    //播放完成监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoadCompelete:) name:KNotification_singleDataLoadComplete object:nil];
}

//通知回调
-(void)dataLoadCompelete:(NSNotification *)notif {
    _isPlaying = NO;
    NSLog(@"LLLLLLLLLL");
    [self performSelector:@selector(dataHandler:) withObject:notif.userInfo afterDelay:0.1];
    NSDictionary *info = notif.userInfo;
}

-(void)dataHandler:(id) object {
    BOOL isDataMax = [(NSDictionary *)object hfv_objectForKey_Safe:@"isDataMax"];
    NSLog(@"%i",_status);
    NSLog(@"tttttt");
    if (!_isPlaying) {
        NSLog(@"ggggggggg");
        if (_currentSeekProgress < 0.0001) {
            return;
        }
        if (isDataMax) {
            NSLog(@"加载完成之后还是不能播放");
            _currentSeekProgress += 0.0001;
            [self seekToProgress:_currentSeekProgress];
        } else {
            NSLog(@"数据量不够，还需要继续加载");
            [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_needMoreData object:nil];
        }
    }
}

- (void)playbackFinished:(NSNotification *)notif {
    LPLog(@"-----播放完成了-----");
    self.status = HFPlayerStatusFinished;
    //播放完成
    if (_config.repeatPlay) {
        //循环播放
        if (_url) {
            NSLog(@"循环播放");
            [self replaceCurrentUrlWithUrl:_url configuration:nil];
            [self play];
        }
    }
    if ([self.delegate respondsToSelector:@selector(playerPlayToEnd)]) {
        [self.delegate playerPlayToEnd];
    }
}

//配置通知
-(void)configNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cacheDidCompleted:) name:KNotification_cacheCompleted object:nil];
}

-(void)cacheDidCompleted:(NSNotification *)notif {
    NSDictionary *userInfo = notif.userInfo;
    NSString *path = [userInfo hfv_objectForKey_Safe:@"path"];
    if (path) {
        if ([self.delegate respondsToSelector:@selector(playerCachedidCompleteWithPath:)]) {
            [self.delegate playerCachedidCompleteWithPath:path];
        }
    }
}

#pragma mark 🐠dealloc🐠
-(void)dealloc {
    LPLog(@"-----播放器释放了-----");
}

@end







//    else if ([keyPath isEqualToString:@"timeControlStatus"]) {
//        AVPlayer *player = object;
//                    switch (player.timeControlStatus) {
//                        case AVPlayerTimeControlStatusPaused:
//                        {
//                            NSLog(@"kjkjkjseek,,,1111");
//                            self.status = HFPlayerStatusPasue;
//                        }
//                            break;
//                        case AVPlayerTimeControlStatusWaitingToPlayAtSpecifiedRate:
//                        {
//                            NSLog(@"kjkjkjseek,,,2222");
//                            self.status = HFPlayerStatusBufferEmpty;
//                        }
//                            break;
//                        case AVPlayerTimeControlStatusPlaying:
//                        {
//                            self.status = HFPlayerStatusPlaying;
//                            NSLog(@"kjkjkjseek,,,3333");
//                        }
//                            break;
//                        default:
//                            break;
//                    }
//    }
