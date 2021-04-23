//
//  HFPlayerApi.m
//  HFPlayerApi
//
//  Created by 郭亮 on 2021/3/16.
//

#import "HFPlayerApi.h"
#import "HFPlayerCacheManager.h"
#import "HFNetworkReachAbility.h"

//ijk
#import <IJKMediaFramework/IJKMediaFramework.h>
#import <IJKMediaFramework/IJKMediaFramework.h>

@interface HFPlayerApi () <HFReachabilityProtocol>

@property(nonatomic ,assign)HFPlayerStatus                               status;
@property(nonatomic ,strong)HFPlayerApiConfiguration                     *config;

//网络监听
@property(nonatomic, strong) HFNetworkReachAbility                *networkReachAbility;
@property(nonatomic, assign) NetworkStatus                        networkStatus;
@property(nonatomic, assign) NSTimeInterval                       noNetLoadDuration;

//ijk
@property(nonatomic ,strong)IJKFFMoviePlayerController                   *ijkPlayer;
@property(nonatomic ,copy)NSString                                       *currentUrlString;
@property(nonatomic ,strong)NSTimer                                      *timer;//监听播放进度
@property(nonatomic ,strong)NSString                                     *path;//缓存路径

@end

@implementation HFPlayerApi

-(void)setStatus:(HFPlayerStatus)status {
    if (status != _status) {
        _status = status;
        if ([self.delegate respondsToSelector:@selector(playerStatusChanged:)]) {
            [self.delegate playerStatusChanged:status];
        }
    }
}

#pragma mark - 🐒public method🐒

#pragma mark - 初始化
-(instancetype)initPlayerWtihConfiguration:(HFPlayerApiConfiguration *)config {
    if (self = [super init]) {
        _config = config;
    }
    return self;
}

#pragma mark - 播放控制
//开始播放
-(void)playWithUrlString:(NSString *)urlString {
    _currentUrlString = urlString;
    if (_ijkPlayer) {
        [self stop];
    }
    if ([HFVLibUtils isBlankString:urlString]) {
        return;
    }
    NSURL *url = [NSURL URLWithString:urlString];
    _path = [[HFPlayerCacheManager shared] getCachePathWithUrl:url];
    if ([[HFPlayerCacheManager shared] isExistCacheWithUrl:url]) {
        //播放本地
        url = [NSURL URLWithString:_path];
        _ijkPlayer =[[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:nil];
    } else {
        //播放网络
        IJKFFOptions *options = [IJKFFOptions optionsByDefault];
        [options setPlayerOptionIntValue:_config.bufferCacheSize*1024 forKey:@"max-buffer-size"];
        [options setPlayerOptionIntValue:0 forKey:@"infbuf"];
        //缓存路径
        //cache_file_path  parse_cache_map auto_save_map cache_map_path
        if (_config.cacheEnable) {
            NSString *urlString = url.absoluteString;
            url = [NSURL URLWithString:[NSString stringWithFormat:@"ijkio:cache:ffio:%@",urlString]];
            [options setFormatOptionValue:_path forKey:@"cache_file_path"];
        } else {
            NSString *urlString = url.absoluteString;
            url = [NSURL URLWithString:[NSString stringWithFormat:@"ijkio:cache:ffio:%@",urlString]];
            [options setFormatOptionValue:@"tempfile.tmp" forKey:@"cache_file_path"];
        }
        _ijkPlayer =[[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:options];
    }
    [_ijkPlayer setPlaybackRate:_config.rate];
    [self installMovieNotificationObservers];
    [self configTimer];
    self.status = HFPlayerStatusInit;
    [self configDefaultSetting];
    _noNetLoadDuration = 999999999999;
    _networkStatus = ReachableViaWiFi;
    //播放
    [_ijkPlayer prepareToPlay];
}

//暂停播放
-(void)pause {
    if (_ijkPlayer) {
        [_ijkPlayer pause];
    }
}

//恢复播放
-(void)resume {
    if (_ijkPlayer) {
        [_ijkPlayer play];
    }
}

//停止播放
-(void)stop {
    if (_ijkPlayer) {
        [_ijkPlayer stop];
        self.status = HFPlayerStatusStoped;
        [self destroy];
    }
}

//拖动播放（时间）
-(void)seekToDuration:(float)duration {
    if (duration<0) {
        return;
    }
    //[self pause];
    _ijkPlayer.currentPlaybackTime = duration;
    [self resume];
}

//拖动播放（进度）
-(void)seekToProgress:(float)progress {
    float targetSecond = _ijkPlayer.duration*progress;
    [self seekToDuration:targetSecond];
}

//倍数播放
-(void)configPlayRate:(float)rate {
    if (rate<0.0 || rate>2.0) {
        return;
    }
    if (_ijkPlayer) {
        [_ijkPlayer setPlaybackRate:rate];
        _config.rate = rate;
    }
}

//音量控制
-(void)configVolume:(float)volume {
    if (_ijkPlayer) {
        [_ijkPlayer setPlaybackVolume:volume];
    }
}

//销毁播放器
-(void)destroy {
    if (_ijkPlayer) {
        [_ijkPlayer didShutdown];
        //移除观察者
        [self removeMovieNotificationObservers];
        //销毁定时器
        [self destroyTimer];
        //判断缓存文件是否完整
        if ([HFVLibUtils isBlankString:_path]) {
            return;
        }
        NSData *filedata = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:_path] options:NSDataReadingMappedIfSafe error:nil];
        if (filedata.length<_ijkPlayer.monitor.filesize) {
            //不完整就删除
            LPLog(@"数据不完整需要删除");
            if ([[NSFileManager defaultManager] fileExistsAtPath:_path]) {
                [[NSFileManager defaultManager] removeItemAtPath:_path error:nil];
            }
        } else {
            LPLog(@"数据文件完整！！！");
        }
    }
}

#pragma mark - 清除缓存
-(void)clearCache {
    [[HFPlayerCacheManager shared] cleanSongCache];
}

#pragma mark - 🐒private method🐒

#pragma mark - 默认设置
-(void)configDefaultSetting {
    //解决手机静音导致播放器静音
    AVAudioSession *avSession = [AVAudioSession sharedInstance];
    [avSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [avSession setActive:YES error:nil];
    
    self.status = HFPlayerStatusInit;
    
    [self.networkReachAbility startListenNetWorkStatus];
}

#pragma mark - 定时器监听播放/缓冲进度
//配置定时器
-(void)configTimer {
    __weak typeof(self) weakSelf = self;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.3 repeats:true block:^(NSTimer * _Nonnull timer) {
        float totalDuration = weakSelf.ijkPlayer.duration;
        float currentDuration = weakSelf.ijkPlayer.currentPlaybackTime;
        float playProgress = currentDuration/totalDuration;
        float bufferDuration = weakSelf.ijkPlayer.playableDuration;
        float bufferProgress = bufferDuration/totalDuration;
        //NSLog(@"定时器方法执行了buffer:%f,totalDuration:%f,bufferProgress:%ld",bufferProgress,totalDuration,(long)weakSelf.ijkPlayer.bufferingProgress);
        //播放进度
        if ([weakSelf.delegate respondsToSelector:@selector(playerPlayProgress:currentDuration:totalDuration:)]) {
            [weakSelf.delegate playerPlayProgress:playProgress currentDuration:currentDuration totalDuration:totalDuration];
        }
        if (currentDuration>weakSelf.noNetLoadDuration) {
            [weakSelf pause];
        }
        //缓冲进度
        if (weakSelf.networkStatus != NotReachable && [weakSelf.delegate respondsToSelector:@selector(playerLoadingProgress:)]) {
            [weakSelf.delegate playerLoadingProgress:bufferProgress];
        }
    }];
}
//销毁定时器
-(void)destroyTimer {
    if (_timer != nil) {
            [_timer invalidate];
            _timer = nil;
        }
}
#pragma mark - 配置通知
-(void)installMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_ijkPlayer];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_ijkPlayer];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_ijkPlayer];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_ijkPlayer];
}

#pragma mark - 通知回调
- (void)loadStateDidChange:(NSNotification*)notification
{
    //    MPMovieLoadStateUnknown        = 0,
    //    MPMovieLoadStatePlayable       = 1 << 0,
    //    MPMovieLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES
    //    MPMovieLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started

    IJKMPMovieLoadState loadState = _ijkPlayer.loadState;

    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        //缓冲结束
        LPLog(@"loadStateDidChange: IJKMPMovieLoadStatePlaythroughOK: %d\n", (int)loadState);
        if ([self.delegate respondsToSelector:@selector(playerLoadingEnd)]) {
            [self.delegate playerLoadingEnd];
        }
        self.status = HFPlayerStatusBufferKeepUp;
        
    } else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        //遇到缓冲
        LPLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
        if ([self.delegate respondsToSelector:@selector(playerLoadingBegin)]) {
            [self.delegate playerLoadingBegin];
        }
        self.status = HFPlayerStatusBufferEmpty;
    } else {
        LPLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification
{
    //    MPMovieFinishReasonPlaybackEnded,
    //    MPMovieFinishReasonPlaybackError,
    //    MPMovieFinishReasonUserExited
    int reason = [[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];

    switch (reason)
    {
        case IJKMPMovieFinishReasonPlaybackEnded:
            LPLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            //播放完成
            if ([self.delegate respondsToSelector:@selector(playerPlayToEnd)]) {
                [self.delegate playerPlayToEnd];
            }
            if (_config.repeatPlay && ![HFVLibUtils isBlankString:_currentUrlString]) {
                [self playWithUrlString:_currentUrlString];
            }
            break;

        case IJKMPMovieFinishReasonUserExited:
            LPLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;

        case IJKMPMovieFinishReasonPlaybackError:
            LPLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            //_ijkPlayer.duration
            if (_ijkPlayer.duration-_ijkPlayer.currentPlaybackTime<1) {
                if ([self.delegate respondsToSelector:@selector(playerPlayToEnd)]) {
                    [self.delegate playerPlayToEnd];
                }
                if (_config.repeatPlay && ![HFVLibUtils isBlankString:_currentUrlString]) {
                    [self playWithUrlString:_currentUrlString];
                }
            }else {
                self.status = HFPlayerStatusError;
                self.status = HFPlayerStatusPasue;
            }
            break;

        default:
            LPLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{
    LPLog(@"mediaIsPreparedToPlayDidChange\n");
    IJKFFMoviePlayerController *obj = (IJKFFMoviePlayerController *)notification.object;
    if (obj.isPreparedToPlay) {
        self.status = HFPlayerStatusReadyToPlay;
    }
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification
{
    //    MPMoviePlaybackStateStopped,
    //    MPMoviePlaybackStatePlaying,
    //    MPMoviePlaybackStatePaused,
    //    MPMoviePlaybackStateInterrupted,
    //    MPMoviePlaybackStateSeekingForward,
    //    MPMoviePlaybackStateSeekingBackward

    switch (_ijkPlayer.playbackState)
    {
        case IJKMPMoviePlaybackStateStopped: {
            LPLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_ijkPlayer.playbackState);
            self.status = HFPlayerStatusStoped;
            break;
        }
        case IJKMPMoviePlaybackStatePlaying: {
            LPLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_ijkPlayer.playbackState);
            self.status = HFPlayerStatusPlaying;
            break;
        }
        case IJKMPMoviePlaybackStatePaused: {
            LPLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_ijkPlayer.playbackState);
            self.status = HFPlayerStatusPasue;
            break;
        }
        case IJKMPMoviePlaybackStateInterrupted: {
            LPLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_ijkPlayer.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            LPLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_ijkPlayer.playbackState);
            break;
        }
        default: {
            LPLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_ijkPlayer.playbackState);
            break;
        }
    }
}

#pragma mark - 移除通知
-(void)removeMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_ijkPlayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:_ijkPlayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:_ijkPlayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:_ijkPlayer];
}

#pragma mark - 🐠网络监测🐠
-(HFNetworkReachAbility *)networkReachAbility {
    if (!_networkReachAbility) {
        _networkReachAbility = [[HFNetworkReachAbility alloc] init];
        _networkReachAbility.delegate = self;
    }
    return _networkReachAbility;
}

-(void)reachabilityChanged:(NetworkStatus)status {
    LPLog(@"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
    LPLog(@"新的网络状态为：%ld",(long)status);
    LPLog(@"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
    _networkStatus = status;
    switch (status) {
        case NotReachable:
        {
            //断网就停止当前请求，在请求失败回调里面做好记录 _videoLength
            //[self bufferingPause];
            _noNetLoadDuration = _ijkPlayer.playableDuration;
        }
            break;
        case ReachableViaWiFi:
        {
            //网络恢复wifi则恢复缓冲
            if (_config.networkAbilityEable) {
                [self seekToDuration:_ijkPlayer.currentPlaybackTime];
            }
            _noNetLoadDuration = 999999999999;
        }
            break;
        case ReachableViaWWAN:
        {
            //网络恢复移动网络则恢复缓冲
            if (_config.networkAbilityEable) {
                [self seekToDuration:_ijkPlayer.currentPlaybackTime];
            }
            _noNetLoadDuration = 999999999999;
        }
            break;
        default:
            break;
    }
}



#pragma mark 🐠dealloc🐠
-(void)dealloc {
    LPLog(@"-----播放器释放了-----");
    [self stop];
    //判断缓存文件是否完整
    if ([HFVLibUtils isBlankString:_path]) {
        return;
    }
    NSData *filedata = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:_path] options:NSDataReadingMappedIfSafe error:nil];
    if (filedata.length<_ijkPlayer.monitor.filesize) {
        //不完整就删除
        LPLog(@"数据不完整需要删除");
        if ([[NSFileManager defaultManager] fileExistsAtPath:_path]) {
            [[NSFileManager defaultManager] removeItemAtPath:_path error:nil];
        }
    } else {
        LPLog(@"数据文件完整！！！");
    }
}

@end

