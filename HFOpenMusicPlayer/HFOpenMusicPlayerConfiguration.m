//
//  HFOpenMusicPlayerConfiguration.m
//  HFOpenMusicPlayer
//
//  Created by 郭亮 on 2021/4/13.
//

#import "HFOpenMusicPlayerConfiguration.h"

@implementation HFOpenMusicPlayerConfiguration

+(HFOpenMusicPlayerConfiguration *)defaultConfiguration {
    HFOpenMusicPlayerConfiguration *config = [[HFOpenMusicPlayerConfiguration alloc] init];
    [config defaultSetting];
    return config;
}

-(instancetype)init {
    if (self = [super init]) {
        [self defaultSetting];
    }
    return self;
}

-(void)defaultSetting {
    //默认配置
    self.bufferCacheSize = 270*1024;//270kb
    self.advanceBufferCacheSize = _bufferCacheSize/2;
    self.repeatPlay = false;
    self.networkAbilityEable = YES;
    self.rate = 1.0;
    self.bkgLoadingEnable = YES;
    self.autoLoad = YES;
    self.cacheEnable = true;
    
    self.autoNext = YES;
    self.panTopLimit = 0;
    self.panBottomLimit = 0;
}

-(void)setBufferCacheSize:(NSUInteger)bufferCacheSize {
    _bufferCacheSize = bufferCacheSize;
    _advanceBufferCacheSize = bufferCacheSize/2;
}


@end
