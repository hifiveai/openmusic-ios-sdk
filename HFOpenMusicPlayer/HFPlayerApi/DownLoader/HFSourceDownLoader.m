//
//  HFSourceDownLoader.m
//  HFPlayer
//
//  Created by 郭亮 on 2021/1/12.
//

#import "HFSourceDownLoader.h"
#import "HFPlayerCacheManager.h"
#import "HFNetworkReachAbility.h"

typedef NS_ENUM (NSUInteger ,PLAYER_LOADSTATUES){
    PLAYER_LOADSTATUES_LOADING = 1001,//正在缓冲加载数据
    PLAYER_LOADSTATUES_LOADPAUSE = 1002,//暂停缓冲数据
    PLAYER_LOADSTATUES_PLAYING = 1003,//缓冲加载了足够数据，player开始播放了
    PLAYER_LOADSTATUES_COMPLETE = 1004
};

@interface HFSourceDownLoader () <NSURLSessionDataDelegate , HFReachabilityProtocol>

@property (nonatomic, strong) NSURLSession                        *session;
@property (nonatomic, strong) NSURLSessionDataTask                *task;

@property (nonatomic, strong) NSURL                               *url;//请求地址
@property (nonatomic, assign) NSUInteger                          offset;//请求发起的range偏移
@property (nonatomic, assign) NSUInteger                          requestLength;//当前请求总长度
@property (nonatomic, assign) NSUInteger                          downLoadingOffset;//已经下载的数据偏移
@property (nonatomic, assign) NSUInteger                          currentPlayingOffset;//当前播放的的数据偏移
@property (nonatomic, assign) NSUInteger                          currentLoadingOffset;//当前缓冲的数据偏移
@property (nonatomic, assign) NSUInteger                          videoLength;
@property (nonatomic, strong) NSString                            *mimeType;
//@property (nonatomic, strong) BOOL                                isSeeking;

//文件缓存
@property (nonatomic, strong) NSFileHandle                        *fileHandle;
@property (nonatomic, strong) NSString                            *tempPath;

//缓冲区大小
@property (nonatomic, assign) NSUInteger                          maxBufferLoadingSize;
@property (nonatomic, assign) NSUInteger                          minBufferLoadingSize;
@property (nonatomic, assign) PLAYER_LOADSTATUES                  loadStatues;//当前缓冲状态


//网络监听
@property(nonatomic, strong) HFNetworkReachAbility                *networkReachAbility;
@property(nonatomic, assign) NetworkStatus                        networkStatus;


@property(nonatomic, assign) float                                playerRate;
@property(nonatomic, assign) BOOL                                 isSeeking;



@property(nonatomic, assign) BOOL                                 isDataMax;


@end

@implementation HFSourceDownLoader

-(instancetype)initWithMaxBufferLoadingSize:(NSUInteger)max MinBufferLoadingSize:(NSUInteger)min {
    if (self = [super init]) {
        self.maxBufferLoadingSize = max;
        self.minBufferLoadingSize = min;
        _loadStatues = PLAYER_LOADSTATUES_PLAYING;
        _networkStatus = ReachableViaWiFi;
        [self configNotificationObserver];
        [self.networkReachAbility startListenNetWorkStatus];
    }
    return self;
}

#pragma mark - 🐠下载🐠
-(void)startDownloadWithUrl:(NSURL *)url offset:(NSUInteger)offset requestLength:(NSUInteger)length{
    if (!url) {
        return;
    }
    _url = url;
    _offset = offset;
    //判断此次请求的url是否有缓存，有缓存则删除
    [[HFPlayerCacheManager shared] creatCacheFileWithUrl:url];
    _tempPath = [[HFPlayerCacheManager shared] getCachePathWithUrl:url];
    
    //开始请求
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    _session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:mainQueue];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
    NSUInteger requestLength = MIN(length, _maxBufferLoadingSize);
    if (requestLength == length) {
        //没有加载最大数据数据量
        _isDataMax = NO;
    } else {
        _isDataMax = YES;
    }
    //设置请求分片区域
    NSLog(@"开始请求的header数据长度requestLength---%lu",requestLength);
    [request addValue:[NSString stringWithFormat:@"bytes=%ld-%ld",(unsigned long)offset, (unsigned long)_maxBufferLoadingSize] forHTTPHeaderField:@"Range"];
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request];
    _task = task;
    [_task resume];
}

-(void)seekDownloadWithOffset:(NSUInteger)offset requestLength:(NSUInteger)length isResume:(BOOL)isResume{
    [_task cancel];
    if (!_url) {
        return;
    }
    _isSeeking = YES;
    _loadStatues = PLAYER_LOADSTATUES_LOADING;
    NSLog(@"seek缓冲了！！！目标target:%lu,当前状态:%lu",(unsigned long)offset,_loadStatues);
    //从暂停处的位置，设置range，开始请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
    NSUInteger requestLength;
    if (isResume) {
        requestLength = MIN(length, (_maxBufferLoadingSize-_minBufferLoadingSize));
    } else {
        [[HFPlayerCacheManager shared] creatCacheFileWithUrl:_url];
        _tempPath = [[HFPlayerCacheManager shared] getCachePathWithUrl:_url];
        requestLength = MIN(length, _maxBufferLoadingSize);
        _offset = offset;
        _downLoadingOffset = 0;
    }
    NSLog(@"seek请求的header数据长度requestLength---%lu",requestLength);
    if ((_offset+requestLength) <= (_currentPlayingOffset+_maxBufferLoadingSize)) {
        //没有加载最大数据数据量
        _isDataMax = NO;
    } else {
        _isDataMax = YES;
    }
    //设置请求分片区域
    [request addValue:[NSString stringWithFormat:@"bytes=%ld-%ld",(unsigned long)offset, (unsigned long)(requestLength+offset-1)] forHTTPHeaderField:@"Range"];
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request];
    _task = task;
    [_task resume];
}

-(void)resumeDownloadWithOffset:(NSUInteger)offset requestLength:(NSUInteger)length isResume:(BOOL)isResume{
    
}

#pragma mark - 🐠NSURLSessionDataDelegate🐠
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    //1.处理response
    //2.通过代理传出去，把数据返给resourceLoader
    NSLog(@"收到response！！");
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    NSDictionary *dic = (NSDictionary *)[httpResponse allHeaderFields] ;
    NSString *content = [dic valueForKey:@"Content-Range"];
    NSArray *array = [content componentsSeparatedByString:@"/"];
    NSString *length = array.lastObject;
    NSUInteger videoLength;
    if ([length integerValue] == 0) {
        videoLength = (NSUInteger)httpResponse.expectedContentLength;
    } else {
        videoLength = [length integerValue];
    }
    self.videoLength = videoLength;
    NSLog(@"总文件大小%lu",(unsigned long)videoLength);
    self.mimeType = response.MIMEType;
    if (self.mimeType && self.mimeType.length==0) {
        self.mimeType = @"video/mp4";
    }
    if ([self.delegate respondsToSelector:@selector(didReceiveVideoLength:mimeType:)]) {
        [self.delegate didReceiveVideoLength:videoLength mimeType:_mimeType];
    }
    self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:_tempPath];
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    if (_task == dataTask) {
        
        //拼接数据
        NSLog(@"接收到数据了--大小：%lu",data.length);
        //1.更新相关offset
        _downLoadingOffset += data.length;
        
        //2.写入数据到文件
        [self.fileHandle seekToEndOfFile];
        [self.fileHandle writeData:data];
        //如果文件下载完整了，发出缓存完成的通知
        NSLog(@"XXXXXXXXXXX_downLoadingOffset:%lu,_videoLength:%lu",_downLoadingOffset,_videoLength);
        if (_config.cacheEnable && _downLoadingOffset>=_videoLength) {
            NSLog(@"XXXXXX我已经发出了通知了的哟");
            [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_cacheCompleted object:nil userInfo:@{@"path":_tempPath}];
        }
        //3.代理
        if ([self.delegate respondsToSelector:@selector(didReceiveDataWithCachePath:)]) {
            [self.delegate didReceiveDataWithCachePath: _tempPath];
        }
    } else {
        NSLog(@"不一样的task");
    }
}

-(void)dataLoadComplete {
    //if (_isSeeking) {
        NSLog(@"发出了数据下载请求完成了的通知");
        
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_singleDataLoadComplete object:nil userInfo:@{@"isDataMax":@(_isDataMax)}];
    
 //       _isSeeking = false;
//    } else {
//
//    }
}

- (void)  URLSession:(NSURLSession *)session
                task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    if (!error) {
        NSLog(@"这个请求完成了哟@@@@@@@@@@@@@@@@@@@@@@，下载开始位置:%lu,下载好的数据:%lu",_offset,_downLoadingOffset);
        _loadStatues = PLAYER_LOADSTATUES_COMPLETE;
        //[self performSelector:@selector(dataLoadComplete) withObject:nil afterDelay:0.5];
        [self dataLoadComplete];
    } else {
        NSLog(@"%@",error);
        //下载出错
        //1.主动取消的错误不做处理
        if (error.code == -999) {
            //cancelled
            return;
        }
        //2.安全链问题需要重新请求播放地址

        //3.其他问题再有网络的情况下再次请求数据
        if (_networkStatus == NotReachable) {
            return;
        }
        if (_config.autoLoad) {
            [self bufferingResume];
        }
    }
    if ([self.delegate respondsToSelector:@selector(downLoadCompleteWithError:)]) {
        [self.delegate downLoadCompleteWithError:error];
    }
}

#pragma mark - 🐠通知🐠
-(void)configNotificationObserver {
    //播放进度通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerUpdateProgress:) name:KNotification_playProgress object:nil];
    //缓冲进度通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadingUpdateProgress:) name:KNotification_loadingProgress object:nil];
    //数据量不足，需要继续加载 通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bufferingResume) name:KNotification_needMoreData object:nil];
}

//播放进度更新
-(void)playerUpdateProgress:(NSNotification *)notifi {
    NSDictionary *userInfo = notifi.userInfo;
    float progress = [[userInfo hfv_objectForKey_Safe:@"progress"] floatValue];
    _currentPlayingOffset = _videoLength*progress;
    NSLog(@"---播放进度跟新了--%lu",_currentPlayingOffset);
    //1.当maxBufferLoadingSize没有限制，则不用判断
    //2.当缓冲数据不够时，并且当前是暂停缓冲状态，则需要从新开启请求进行缓冲数据
    //3.根据minBufferLoadingSize来进行判断，minBufferLoadingSize=0（未设置）就默认为max的3/4
    if ( _maxBufferLoadingSize != 0 &&
        (_downLoadingOffset+_offset)<(_minBufferLoadingSize+_currentPlayingOffset) &&
        (_currentLoadingOffset)<(_minBufferLoadingSize+_currentPlayingOffset) &&
        (_loadStatues == PLAYER_LOADSTATUES_LOADPAUSE || _loadStatues == PLAYER_LOADSTATUES_COMPLETE) &&
        _config.autoLoad == true
        ) {
        NSLog(@"满足继续缓冲条件了%lu",(unsigned long)_loadStatues);
        [self bufferingResume];
    }
}

//缓冲进度更新
-(void)loadingUpdateProgress:(NSNotification *)notifi {
    NSDictionary *userInfo = notifi.userInfo;
    float progress = [[userInfo hfv_objectForKey_Safe:@"progress"] floatValue];
    NSLog(@"缓冲更新了：%f",progress);
    if (!isnan(progress)) {
        _currentLoadingOffset = _videoLength*progress;
    }
}

#pragma mark - 🐠缓冲控制🐠
//暂停缓冲
-(void)bufferingPause {
    _loadStatues = PLAYER_LOADSTATUES_LOADPAUSE;
    [self.task cancel];
}

//继续缓冲
-(void)bufferingResume {
    if (_config.autoLoad) {
        _loadStatues = PLAYER_LOADSTATUES_LOADING;
        NSLog(@"继续缓冲startOffset：%lu,dataLoadingOffset:%lu,_currentLoadingOffset:%lu,_currentPlayingOffset:%lu",(unsigned long)_offset,_downLoadingOffset+_offset,_currentLoadingOffset,_currentPlayingOffset);

        if ([self.delegate respondsToSelector:@selector(needBufferingResumeCurrentPlayOffset:)]) {
//            BOOL result = [self.delegate needBufferingResumeCurrentPlayOffset:_currentPlayingOffset];
            BOOL result = [self.delegate needBufferingResumeCurrentPlayOffset:_downLoadingOffset+_offset];
            if (!result) {
                _loadStatues = PLAYER_LOADSTATUES_LOADPAUSE;
            }
        }
    }
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
    _networkStatus = status;
    switch (status) {
        case NotReachable:
        {
            //断网就停止当前请求，在请求失败回调里面做好记录 _videoLength
            [self bufferingPause];
        }
            break;
        case ReachableViaWiFi:
        {
            //网络恢复wifi则恢复缓冲
            if ( _maxBufferLoadingSize != 0 &&
                (_downLoadingOffset+_offset)<(_minBufferLoadingSize+_currentPlayingOffset) &&
                (_currentLoadingOffset)<(_minBufferLoadingSize+_currentPlayingOffset) &&
                (_loadStatues == PLAYER_LOADSTATUES_LOADPAUSE || _loadStatues == PLAYER_LOADSTATUES_COMPLETE) &&
                _config.autoLoad == true
                ) {
                NSLog(@"满足继续缓冲条件了%lu",(unsigned long)_loadStatues);
                [self bufferingResume];
            }
        }
            break;
        case ReachableViaWWAN:
        {
            //网络恢复移动网络则恢复缓冲
            if ( _maxBufferLoadingSize != 0 &&
                (_downLoadingOffset+_offset)<(_minBufferLoadingSize+_currentPlayingOffset) &&
                (_currentLoadingOffset)<(_minBufferLoadingSize+_currentPlayingOffset) &&
                (_loadStatues == PLAYER_LOADSTATUES_LOADPAUSE || _loadStatues == PLAYER_LOADSTATUES_COMPLETE) &&
                _config.autoLoad == true
                ) {
                NSLog(@"满足继续缓冲条件了%lu",(unsigned long)_loadStatues);
                [self bufferingResume];
            }
        }
            break;
        default:
            break;
    }
}

-(void)destory {
    //finishTasksAndInvalidate
    [self.session invalidateAndCancel];
    self.session = nil;
}

#pragma 🐠dealloc🐠
-(void)dealloc {
    if (!_config.cacheEnable) {
        [[HFPlayerCacheManager shared] deleteCacheWithUrl: _url];
    }else {
        //判断文件是否完整
        //NSData *filedata = [NSData dataWithContentsOfURL:_url options:NSDataReadingMappedIfSafe error:nil];
        NSString *localPath = [[HFPlayerCacheManager shared] getCachePathWithUrl:_url];
        NSData *filedata = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:localPath] options:NSDataReadingMappedIfSafe error:nil];
        if (filedata.length<_videoLength) {
            //不完整就删除
            NSLog(@"数据不完整需要删除");
            [[HFPlayerCacheManager shared] deleteCacheWithUrl: _url];
        } else {
            NSLog(@"数据文件完整！！！");
        }
    }
    NSLog(@"yyyyyyyyyyyyyyyyyyyyy----下载器释放了");
}

-(void)cleanNotCompleteSongCache {
    if (!_config.cacheEnable) {
        [[HFPlayerCacheManager shared] deleteCacheWithUrl: _url];
    }else {
        //判断文件是否完整
        //NSData *filedata = [NSData dataWithContentsOfURL:_url options:NSDataReadingMappedIfSafe error:nil];
        NSString *localPath = [[HFPlayerCacheManager shared] getCachePathWithUrl:_url];
        NSData *filedata = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:localPath] options:NSDataReadingMappedIfSafe error:nil];
        if (filedata.length<_videoLength) {
            //不完整就删除
            NSLog(@"数据不完整需要删除");
            [[HFPlayerCacheManager shared] deleteCacheWithUrl: _url];
        } else {
            NSLog(@"数据文件完整！！！");
        }
    }
}

@end
