//
//  HFPlayerCacheTool.m
//  HFPlayer
//
//  Created by 郭亮 on 2021/1/12.
//

#import "HFPlayerCacheManager.h"

@interface HFPlayerCacheManager ()

//@property(nonatomic, strong)NSString *tempPath;

@end

@implementation HFPlayerCacheManager

static HFPlayerCacheManager *manager = nil;

+(HFPlayerCacheManager *)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[HFPlayerCacheManager alloc] init];
            //创建HFSongs文件夹
            NSString *document = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
            NSString *directoryPath =  [document stringByAppendingPathComponent:@"HFSongs"];
            if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
                [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
        }
    });
    return manager;
}

-(NSString *)getCachePathWithUrl:(NSURL *)url {
    NSString *urlStr = url.absoluteString;
    NSString *fileName = [self getFileNameWithUrlstr:urlStr];
    NSString *document = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePath =  [document stringByAppendingPathComponent:[NSString stringWithFormat:@"HFSongs/%@",fileName]];
    return filePath;
}

-(void)creatCacheFileWithUrl:(NSURL *)url {
    NSString *filePath = [self getCachePathWithUrl:url];
    NSString *document = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *directoryPath =  [document stringByAppendingPathComponent:@"HFSongs"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath]) {
        //存在HFSongs文件夹
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
            [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
        } else {
            [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
        }
    } else {
        //不存在
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    }
    
}

-(void)deleteCacheWithUrl:(NSURL *)url {
    NSString *filePath = [self getCachePathWithUrl:url];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        
    }
}

-(BOOL)isExistCacheWithUrl:(NSURL *)url {
    NSString *filePath = [self getCachePathWithUrl:url];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        //存在该文件
        return YES;
    }
    return NO;
}

//拆分url字符串，得到存储在本地的文件名
-(NSString *)getFileNameWithUrlstr:(NSString *)urlstr {
//    NSArray *subAry = [urlstr componentsSeparatedByString:@"?"];
//    if (subAry && subAry.count>0) {
//        NSString *subStr = subAry.firstObject;
//        NSArray *targetAry = [subStr componentsSeparatedByString:@"/"];
//        if (targetAry && targetAry.count>0) {
//            NSString *targetStr = targetAry.lastObject;
//            return targetStr;
//        }
//        return subStr;
//    }
//    return urlstr;
    NSArray *subAry = [urlstr componentsSeparatedByString:@"?"];
    for (NSString *subStr in subAry) {
        NSArray *targetAry = [subStr componentsSeparatedByString:@"/"];
        for (NSString *targetStr in targetAry) {
            if ([targetStr rangeOfString:@".mp3"].location != NSNotFound) {
                return targetStr;
            }
            if ([targetStr rangeOfString:@".wav"].location != NSNotFound) {
                return targetStr;
            }
        }
    }
    return @"unNnalysis.mp3";
}

-(void)cleanSongCache {
    NSString *document = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *directoryPath =  [document stringByAppendingPathComponent:@"HFSongs"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:directoryPath error:nil];
    }
}

@end
