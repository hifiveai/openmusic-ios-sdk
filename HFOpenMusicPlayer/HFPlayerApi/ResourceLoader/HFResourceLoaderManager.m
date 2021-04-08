//
//  HFResourceLoaderManager.m
//  HFPlayer
//
//  Created by 郭亮 on 2021/1/11.
//

#import "HFResourceLoaderManager.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "HFSourceDownLoader.h"
#import "HFPlayerCacheManager.h"


static NSString *kCacheScheme = @"_HFCachePlayer_";

@interface HFResourceLoaderManager () <HFSourceDownLoaderDelegate, AVAssetResourceLoaderDelegate>


@property(nonatomic, strong)NSMutableArray <AVAssetResourceLoadingRequest *>      *loadingRequestAry;
@property(nonatomic, strong)HFSourceDownLoader                                    *downLoader;
@property(nonatomic, copy)NSString                                                *filePath;
@property(nonatomic, assign)NSUInteger                                            seekingLocation;


@end


@implementation HFResourceLoaderManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(void)cleanNotCompleteSongCache {
    [self.downLoader cleanNotCompleteSongCache];
}

-(AVPlayerItem *)playerItemWithURL:(NSURL *)url {
    NSURL *assetURL;
    if (!url) {
        assetURL = nil;
    } else {
        assetURL = [NSURL URLWithString:[kCacheScheme stringByAppendingString:[url absoluteString]]];
    }
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:assetURL options:nil];
    //设置代理，数据接管
    [urlAsset.resourceLoader setDelegate:self queue:dispatch_get_main_queue()];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:urlAsset];
    if ([playerItem respondsToSelector:@selector(setCanUseNetworkResourcesForLiveStreamingWhilePaused:)]) {
        playerItem.canUseNetworkResourcesForLiveStreamingWhilePaused = YES;
    }
    return playerItem;
}

- (NSURL *)getSchemeVideoURL:(NSURL *)url
{
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:NO];
    components.scheme = @"streaming";
    return [components URL];
}


//处理播放器的请求数组loadingRequestAry，已经完成的请求从数组中移除
//当请求到了新的数据或者收到了新的request，需要更新loadingRequestAry
- (void)processPendingRequests {
    NSMutableArray *requestsCompleted = [NSMutableArray array];  //请求完成的数组
    NSLog(@"请求数组的数量:%lu,当前线程:%@",(unsigned long)_loadingRequestAry.count,[NSThread currentThread]);
    //遍历loadingRequestAry数组
    for (AVAssetResourceLoadingRequest *loadingRequest in self.loadingRequestAry)
    {
        [self fillInContentInformation:loadingRequest]; //对每次请求加上长度，文件类型等信息
        BOOL didRespondCompletely = [self respondWithDataForRequest:loadingRequest.dataRequest]; //判断此次请求的数据是否处理完全
        if (didRespondCompletely) {
            //如果完整，把此次请求放进请求完成的数组
            [requestsCompleted addObject:loadingRequest];
            [loadingRequest finishLoading];
            NSRange range = NSMakeRange((NSUInteger)loadingRequest.dataRequest.currentOffset, NSUIntegerMax);
            NSLog(@"--已经完成的请求的range:%lu,length:%lu",range.location,loadingRequest.dataRequest.requestedLength);
        }
    }
    //在所有请求的数组中移除已经完成的
    [self.loadingRequestAry removeObjectsInArray:requestsCompleted];
}

//填充response信息到loadingRequest的contentInformationRequest
//(AVAssetResourceLoadingContentInformationRequest *)contentInformationRequest
- (void)fillInContentInformation:(AVAssetResourceLoadingRequest *) loadingRequest
{
    NSString *mimeType = self.downLoader.mimeType;
    CFStringRef contentType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)(mimeType), NULL);
    loadingRequest.contentInformationRequest.byteRangeAccessSupported = YES;
    loadingRequest.contentInformationRequest.contentType = CFBridgingRelease(contentType);
    loadingRequest.contentInformationRequest.contentLength = self.downLoader.videoLength;//self.downLoader.videoLength
}

//判断请求数据是否完整，填充data到loadingRequest的dataRequest
- (BOOL)respondWithDataForRequest:(AVAssetResourceLoadingDataRequest *)dataRequest
{
    NSLog(@"⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️");
    NSData *filedata = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:_filePath] options:NSDataReadingMappedIfSafe error:nil];
    NSUInteger startOffset = dataRequest.requestedOffset;
    if (dataRequest.currentOffset != 0) {
        startOffset = dataRequest.currentOffset;
    }
    if ((self.downLoader.offset + filedata.length) < startOffset)
    {
        NSLog(@"EEEE--请求current位置:%lu,请求数据长度:%lu,请求开始位置:%lld,文件大小:%lu,下载器开始位置:%lu",startOffset,dataRequest.requestedLength,dataRequest.requestedOffset,filedata.length,self.downLoader.offset);
        return NO;
    }
    if (startOffset < self.downLoader.offset) {
        NSLog(@"eeee--请求current位置:%lu,请求数据长度:%lu,请求开始位置:%lu,下载器开始位置:%lu",startOffset,dataRequest.requestedLength,dataRequest.requestedOffset,self.downLoader.offset);
        return NO;
    }
    NSUInteger unreadBytes = filedata.length - ((NSInteger)startOffset - self.downLoader.offset);
    NSUInteger numberOfBytesToRespondWith = MIN((NSUInteger)dataRequest.requestedLength, unreadBytes) ;
    if (((NSUInteger)startOffset- self.downLoader.offset + (NSUInteger)numberOfBytesToRespondWith) <= filedata.length) {
        NSLog(@"已经下载好的文件大小:%lu,下载器开始位置:%lu,请求current位置:%lu,请求数据长度:%lu,请求开始位置:%lu",(unsigned long)filedata.length,self.downLoader.offset,startOffset,dataRequest.requestedLength,dataRequest.requestedOffset);
        [dataRequest respondWithData:[filedata subdataWithRange:NSMakeRange((NSUInteger)startOffset - self.downLoader.offset, (NSUInteger)numberOfBytesToRespondWith)]];
    } else {
        NSLog(@"jjjj---daxiao:%lu,downloaderOffset:%lu,startOffset:%lu",(unsigned long)filedata.length,self.downLoader.offset,startOffset);
    }
    //NSUInteger endOffset = startOffset + dataRequest.requestedLength;
    NSUInteger endOffset = dataRequest.requestedOffset + dataRequest.requestedLength;
    BOOL didRespondFully = (self.downLoader.offset + filedata.length) >= endOffset;
    return didRespondFully;
}

#pragma mark - 🐠AVAssetResourceLoaderDelegate🐠
-(BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest {
    [self.loadingRequestAry addObject:loadingRequest];
    NSRange range = NSMakeRange((NSUInteger)loadingRequest.dataRequest.currentOffset, NSUIntegerMax);
    NSLog(@"🐠🐠SeekPlayercurrentOffset:%lu,length:%lu,requestOffset:%lu,当前线程：%@",(NSUInteger)loadingRequest.dataRequest.currentOffset,(NSUInteger)loadingRequest.dataRequest.requestedLength,(NSUInteger)loadingRequest.dataRequest.requestedOffset,[NSThread currentThread]);
        if (_seeking && _requestRecord) {
            _seekingLocation = range.location;
            _requestRecord = NO;
        }
        [self performSelector:@selector(resetSeeking) withObject:nil afterDelay:0.5];
        [self handleLoadingRequest:loadingRequest];
    return YES;
}

-(void)resetSeeking {
    _seeking = NO;
}

-(void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    NSRange range = NSMakeRange((NSUInteger)loadingRequest.dataRequest.currentOffset, NSUIntegerMax);
    NSLog(@"--取消的请求range--%lu,requestOffset:%lu,requestLength:%lu",(unsigned long)range.location,(unsigned long)loadingRequest.dataRequest.requestedOffset,loadingRequest.dataRequest.requestedLength);
    [self.loadingRequestAry removeObject:loadingRequest];
}

-(void)handleLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    if (self.downLoader.downLoadingOffset > 0) {
        [self processPendingRequests];
    }
    NSRange range = NSMakeRange((NSUInteger)loadingRequest.dataRequest.currentOffset, NSUIntegerMax);
    NSURL *realUrl = loadingRequest.request.URL;
    NSString *urlStr = [realUrl absoluteString];
    if ([urlStr hasPrefix:kCacheScheme]) {
        NSString *realStr = [urlStr stringByReplacingOccurrencesOfString:kCacheScheme withString:@""];
        realUrl = [NSURL URLWithString:realStr];
    }
    //创建下载器
    if (!self.downLoader) {
        self.downLoader = [[HFSourceDownLoader alloc] initWithMaxBufferLoadingSize:_config.bufferCacheSize
                                                              MinBufferLoadingSize:_config.advanceBufferCacheSize];
        self.downLoader.delegate = self;
        self.downLoader.config = _config;
        [self.downLoader startDownloadWithUrl:realUrl offset:0 requestLength:loadingRequest.dataRequest.requestedLength];
    } else {
        NSLog(@"1----downLoaderOffset:%lu,downLoadingOffset:%lu,range.location:%lu",self.downLoader.offset,self.downLoader.downLoadingOffset,range.location);
        // 如果新的rang的起始位置比当前缓存的位置还大300k，则重新按照range请求数据//+300*1024
        if (self.downLoader.offset + self.downLoader.downLoadingOffset < range.location+3 ||
            // 如果往回拖也重新请求
            range.location < self.downLoader.offset) {
            NSLog(@"2");
            if (!_seeking) {
                NSLog(@"3");
                return;
            }
            if (_seeking) {
                NSLog(@"4");
                if (_seekingLocation < range.location) {
                    NSLog(@"5");
                    return;
                }
            }
            [self.downLoader seekDownloadWithOffset:range.location requestLength:loadingRequest.dataRequest.requestedLength isResume:NO];
        }
    }
}

#pragma mark - 🐠DownLoaderDelegate🐠
//收到Response
-(void)didReceiveVideoLength:(NSUInteger)ideoLength mimeType:(NSString *)mimeType {
    
}

//收到Data
-(void)didReceiveDataWithCachePath:(NSString *)path {
    _filePath = path;
    [self processPendingRequests];
}

//下载完毕
-(void)downLoadCompleteWithError:(NSError *)error {
    if (!error) {
        //NSLog(@"下载完成，路径：%@",self.filePath);
    } else {
        //NSLog(@"下载出错，错误：%@",error);
    }
}

//需要继续下载数据
-(BOOL)needBufferingResumeCurrentPlayOffset:(NSUInteger)offset {
    //在请求数组中，寻找最近的请求，并发起请求
    AVAssetResourceLoadingRequest *targetRequest;
    NSLog(@"请求数组的数量:%i",self.loadingRequestAry.count);
    for (AVAssetResourceLoadingRequest *loadingRequest in self.loadingRequestAry) {
        if (offset <= loadingRequest.dataRequest.currentOffset) {
            if (targetRequest) {
                if (targetRequest.dataRequest.currentOffset>loadingRequest.dataRequest.currentOffset) {
                    targetRequest = loadingRequest;
                }
            } else {
                targetRequest = loadingRequest;
            }
        }
    }
    if (targetRequest) {
        NSLog(@"继续缓冲找到了目标请求%lld",targetRequest.dataRequest.currentOffset);
        [self.downLoader seekDownloadWithOffset:targetRequest.dataRequest.currentOffset requestLength:targetRequest.dataRequest.requestedLength isResume:YES];
        return YES;
    } else {
        NSLog(@"数组里面找不到合适的请求");
        NSLog(@"offset:%lu",offset);
        for (AVAssetResourceLoadingRequest *loadingRequest in self.loadingRequestAry) {
            NSLog(@"currentOffset:%lld,requestLength:%lld,requestOffset:%lld",loadingRequest.dataRequest.currentOffset,loadingRequest.dataRequest.requestedLength,loadingRequest.dataRequest.requestedOffset);
        }
        return NO;
    }
}

#pragma mark - 🐠懒加载🐠
-(NSMutableArray<AVAssetResourceLoadingRequest *> *)loadingRequestAry {
    if (!_loadingRequestAry) {
        _loadingRequestAry = [NSMutableArray arrayWithCapacity:0];
    }
    return _loadingRequestAry;
}

-(void)dealloc {
    NSLog(@"resourceLoader释放了");
    [_downLoader destory];
    
}

@end
