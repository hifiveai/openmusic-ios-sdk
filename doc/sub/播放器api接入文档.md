# 《播放器API》接口文档

[TOC]

## 初始化

```objc
-(instancetype)initPlayerWtihConfiguration:(HFPlayerApiConfiguration * _Nonnull)config;
```
接口参数

| 参数 | 必填 | 描述 | 可选值 |
|---|---|---|---|
| config | 是 | 播放器配置 | 详见[配置] |

### 播放器配置

创建默认配置
```objc
HFPlayerApiConfiguration *configuration = [HFPlayerApiConfiguration defaultConfiguration];
//用户可根据需要修改配置
configuration.bufferCacheSize = 500;
configuration.cacheEnable = true;
```
| 配置项 | 描述 | 默认值 | 类型 |
|---|---|---|---|
| cacheEnable | 是否允许客户端缓存 | 默认关闭 | BOOL |
| bufferCacheSize | 缓冲区大小 | 默认270（单位：kb，最小配置270kb） | NSUInteger |
| repeatPlay | 是否允许重复播放 | 默认关闭 | BOOL |
| networkAbilityEable | 是否开启网络监测,断线重连播放 | 默认开启 | BOOL |
| rate | 播放速率 | 默认1.0 | float |

## 播放音频
```objc
-(void)playWithUrlString:(NSString *_Nonnull)urlString;
```

- 接口参数
  
  | 参数 | 必填 | 描述 | 可选值 |
  |---|---|---|---|
  | urlString | 是 | 音频资源地址字符串，支持网络和本地地址 | |


## 播放器暂停
可继续播放
```objc
-(void)pause;
```

## 播放器继续播放
```objc
-(void)resume;
```

## 播放器停止播放
不可继续播放。若需再次播放此资源，需要调用播放音频方法传入url进行播放
```objc
-(void)stop;
```
## 销毁播放器
```objc
-(void)destroy;
````
## 清除缓存
```objc
-(void)clearCache;
```

## 设置播放位置
按时间
```objc
-(void)seekToDuration:(float)Duration;
```

- 接口参数
| 参数 | 必填 | 描述 |
|---|---|---|
| Duration | 是 | 要跳转到的时间，秒 |

按播放进度
```objc
-(void)seekToProgress:(float)progress;
```
- 接口参数
| 参数 | 必填 | 描述 |
|---|---|---|
| progress | 是 | 播放进度（百分比） |

## 设置播放速率
```objc
-(void)configPlayRate:(float)rate;
```

- 接口参数
| 参数 | 必填 | 描述 |
|---|---|---|
| rate | 是 | 播放速率 0.0～2.0，0.0代表暂停播放，2.0代表两倍速播放 |

## 设置音量
```objc
-(void)configVolume:(float)volume;
```

- 接口参数
| 参数 | 必填 | 描述 |
|---|---|---|
| volume | 是 | 音量  0.0～1.0，0.0代表播放器静音, 1.0 代表播放器音量最大 |

## 设置播放器回调
遵循协议 `<HFPlayerStatusProtocol>`
```objc
-(void)viewDidLoad {
    HFPlayerApi *player = [[HFPlayerApi alloc] initPlayerWtihUrl:[NSURL URLWithString:@"xxx"] configuration:[HFPlayerApiConfiguration defaultConfiguration]];
    player.delegate = self;
}


-(void)playerStatusChanged:(HFPlayerStatus)status {
    /// 播放器状态更新回调
}

-(void)playerPlayProgress:(float)progress currentDuration:(float)currentDuration totalDuration:(float)totalDuration {
    /// 播放进度回调
}

-(void)playerLoadingProgress:(float)progress {
    /// 数据缓冲进度回调
}

-(void)playerLoadingBegin {
    /// 播放器遇到数据缓冲
}

-(void)playerLoadingEnd {
    /// 播放器数据缓冲结束，继续播放
}

-(void)playerPlayToEnd {
    /// 播放完成回调
}

```

## 播放器状态码

| 状态 | 状态码 | 状态描述 |
|----------|:--------|:-------- |
| HFPlayerStatusInit | 2030 | 初始化 |
| HFPlayerStatusUnknow | 2031 | 未知状态 |
| HFPlayerStatusLoading | 2032 | 加载状态 |
| HFPlayerStatusReadyToPlay | 2033 | 准备就绪可以播放 |
| HFPlayerStatusPlaying | 2034 | 播放中 |
| HFPlayerStatusPasue | 2035 | 播放暂停 |
| HFPlayerStatusBufferEmpty | 2036 | 播放遇到缓冲 |
| HFPlayerStatusBufferKeepUp | 2037 | 缓冲结束 |
| HFPlayerStatusFailed | 2038 | 播放失败 |
| HFPlayerStatusFinished | 2039 | 播放完成 |
| HFPlayerStatusStoped | 2040 | 播放停止 |

