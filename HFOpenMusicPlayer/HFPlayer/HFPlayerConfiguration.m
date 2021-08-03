//
//  HFPlayerConfiguration.m
//  HFPlayer
//
//  Created by 郭亮 on 2021/1/15.
//

#import "HFPlayerConfiguration.h"


@implementation HFPlayerConfiguration

+(HFPlayerConfiguration *)defaultConfiguration {
    HFPlayerConfiguration *config = [[HFPlayerConfiguration alloc] init];
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
    self.bufferCacheSize = 270;//270k
    self.repeatPlay = false;
    self.networkAbilityEable = YES;
    self.rate = 1.0;
    self.cacheEnable = true;
    
    self.autoNext = YES;
    self.panTopLimit = 0;
    self.panBottomLimit = 0;
}

-(id)copyWithZone:(NSZone *)zone{
    
    HFPlayerConfiguration * config =  [[[self class] allocWithZone:zone]init];
    
    config.autoNext = self.autoNext;
    config.panTopLimit = self.panTopLimit;
    config.panBottomLimit = self.panBottomLimit;
    config.urlString = self.urlString;
    config.imageUrlString = self.imageUrlString;
    config.songName = self.songName;
    config.canCutSong = self.canCutSong;
    config.musicId = self.musicId;
    
    
    config.cacheEnable = self.cacheEnable;
    config.bufferCacheSize = self.bufferCacheSize;
    config.repeatPlay = self.repeatPlay;
    config.networkAbilityEable = self.networkAbilityEable;
    config.rate = self.rate;
    return config ;
}

-(id)mutableCopyWithZone:(NSZone *)zone{

    HFPlayerConfiguration * config = [[HFPlayerConfiguration alloc]init];
    config.autoNext = self.autoNext;
    config.panTopLimit = self.panTopLimit;
    config.panBottomLimit = self.panBottomLimit;
    config.urlString = self.urlString;
    config.imageUrlString = self.imageUrlString;
    config.songName = self.songName;
    config.canCutSong = self.canCutSong;
    config.musicId = self.musicId;
    
    
    config.cacheEnable = self.cacheEnable;
    config.bufferCacheSize = self.bufferCacheSize;
    config.repeatPlay = self.repeatPlay;
    config.networkAbilityEable = self.networkAbilityEable;
    config.rate = self.rate;
    
    return config;
}

@end
