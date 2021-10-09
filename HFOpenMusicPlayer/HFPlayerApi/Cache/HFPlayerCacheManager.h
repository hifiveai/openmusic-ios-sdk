//
//  HFPlayerCacheTool.h
//  HFPlayer
//
//  Created by 郭亮 on 2021/1/12.
//

#import <Foundation/Foundation.h>

@interface HFPlayerCacheManager : NSObject

+(HFPlayerCacheManager *)shared;

/// 根据URL返回缓存路径
/// @params url 播放地址
/// @return 缓存文件路径
-(NSString *)getCachePathWithUrl:(NSURL *)url;

/// 创建缓存文件
/// @params url 播放地址
-(void)creatCacheFileWithUrl:(NSURL *)url;

/// 判断音频资源是否已经缓存
/// @params url 播放地址
/// @return BOOL  YES：已缓存 NO：未缓存
-(BOOL)isExistCacheWithUrl:(NSURL *)url;

/// 删除缓存文件
/// @params url 播放地址
-(void)deleteCacheWithUrl:(NSURL *)url;

/// 获取缓存总大小

/// 清理缓存
-(void)cleanSongCache;

@end


