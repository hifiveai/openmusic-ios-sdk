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
    //最小270kb
    if (bufferCacheSize < 270) {
        _bufferCacheSize = 270;
    } else {
        _bufferCacheSize = bufferCacheSize;
    }
}

-(void)defaultSetting {
    //默认配置
    self.bufferCacheSize = 270;//270kb
    self.repeatPlay = false;
    self.networkAbilityEable = YES;
    self.rate = 1.0;
    self.cacheEnable = NO;
}



@end
