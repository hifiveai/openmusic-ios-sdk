//
//  HFSourceDownLoader.h
//  HFPlayer
//
//  Created by 郭亮 on 2021/1/12.
//

#import <Foundation/Foundation.h>
#import "HFPlayerApiConfiguration.h"

@protocol HFSourceDownLoaderDelegate <NSObject>

@optional

-(void)didReceiveVideoLength:(NSUInteger)ideoLength mimeType:(NSString *)mimeType;
-(void)didReceiveDataWithCachePath:(NSString *)path;
-(void)downLoadCompleteWithError:(NSError *)error;
-(BOOL)needBufferingResumeCurrentPlayOffset:(NSUInteger) offset;

@end

@interface HFSourceDownLoader : NSObject

@property(nonatomic ,weak)id <HFSourceDownLoaderDelegate>     delegate;
@property (nonatomic, strong, readonly) NSURL                 *url;
@property (nonatomic, assign, readonly) NSUInteger            offset;
@property (nonatomic, assign, readonly) NSUInteger            videoLength;
@property (nonatomic, assign, readonly) NSUInteger            downLoadingOffset;


@property (nonatomic, strong, readonly) NSFileHandle          *fileHandle;
@property (nonatomic, strong, readonly) NSString              *tempPath;
@property (nonatomic, strong, readonly) NSString              *mimeType;

@property(nonatomic ,strong)HFPlayerApiConfiguration             *config;


/// 初始化
/// @params max 允许缓冲的最大size，缓冲数据量超过最大值则需要暂停数据缓冲。传 0 表示不做限制，默认为0；
/// @params min  允许最小的缓冲size，当缓冲数据量小于这个值则需要重新发起数据请求。传 0 表示max*5/6，默认为0；
-(instancetype)initWithMaxBufferLoadingSize:(NSUInteger) max MinBufferLoadingSize:(NSUInteger) min;

/// 开始一个资源下载
/// @params url 资源路径
/// @params offset 起始位置
/// @params length 请求数据量
-(void)startDownloadWithUrl:(NSURL *)url offset:(NSUInteger)offset requestLength:(NSUInteger)length;

/// 取消一个下载
//-(void)cancelRequestLength:(NSUInteger)requestLength requestOffset:(NSUInteger)requestOffset;

/// 从指定位置开始下载
/// @params offset 指定位置
-(void)seekDownloadWithOffset:(NSUInteger)offset requestLength:(NSUInteger)length isResume:(BOOL)isResume;

-(void)destory;

-(void)cleanNotCompleteSongCache;

@end

