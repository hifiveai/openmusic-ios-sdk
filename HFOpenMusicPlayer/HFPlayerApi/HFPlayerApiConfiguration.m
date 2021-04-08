//
//  HFPlayerApiConfiguration.m
//  HFPlayer
//
//  Created by 郭亮 on 2021/1/15.
//

#import "HFPlayerApiConfiguration.h"


@implementation HFPlayerApiConfiguration

+(HFPlayerApiConfiguration *)defaultConfiguration {
    HFPlayerApiConfiguration *config = [[HFPlayerApiConfiguration alloc] init];
    [config defaultSetting];
    return config;
}

-(instancetype)init {
    if (self = [super init]) {
        [self defaultSetting];
    }
    return self;
}

-(void)setBufferCacheSize:(NSUInteger)bufferCacheSize {
    _bufferCacheSize = bufferCacheSize;
    _advanceBufferCacheSize = bufferCacheSize/2;
}

-(void)defaultSetting {
    //默认配置
    self.bufferCacheSize = 1024*270;//270k
    self.advanceBufferCacheSize = _bufferCacheSize/2;
    self.repeatPlay = YES;
    self.networkAbilityEable = YES;
    self.rate = 1.0;
    self.bkgLoadingEnable = YES;
    self.autoLoad = YES;
    
    self.cacheEnable = NO;
}



@end
