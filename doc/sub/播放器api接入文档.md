#### 初始化
遵循协议 `<HFPlayerStatusProtocol>`

```objc
HFPlayerApiConfiguration *configuration = [HFPlayerApiConfiguration defaultConfiguration];
HFPlayerApi *playerApi = [[HFPlayerApi alloc] initPlayerWtihUrl:[NSURL URLWithString:_songUrl] configuration:configuration];
playerApi.delegate = self;
```

#### 初始化播放器
```objc
-(instancetype)initPlayerWtihUrl:(NSURL *_Nonnull)url 
                   configuration:(HFPlayerConfiguration * _Nonnull)config;
```
- 接口参数
  
| 参数 | 必填 | 描述 | 可选值 |
|---|---|---|---|
| url | 是 | 音频资源地址，支持网络和本地地址 | |
| config | 是 | 播放器配置 | 详见[配置] |

**配置**

- 创建默认配置
```objc
HFPlayerApiConfiguration *configuration = [HFPlayerApiConfiguration defaultConfiguration];
```
| 配置项 | 描述 | 默认值 |
|---|---|---|
| cacheEnable | 是否允许客户端缓存 | 默认关闭 |
| bufferCacheSize | 缓冲区大小 | 默认270kb（最小配置270kb） |
| advanceBufferCacheSize | 预缓冲区大小 | 默认为缓冲区大小的1/2 |
| repeatPlay | 是否允许重复播放 | 默认开启 |
| networkAbilityEable | 是否开启网络监测,断线重连播放 | 默认开启 |
| rate | 播放速率 | 默认1.0 |
| autoLoad | 播放器自动缓冲数据 | 默认开启 |

#### 切换播放音频资源地址
```objc
-(void)replaceCurrentUrlWithUrl:(NSURL *_Nonnull)url 
                  configuration:(HFPlayerConfiguration * _Nullable )config;
```

- 接口参数
  
  | 参数 | 必填 | 描述 | 可选值 |
  |---|---|---|---|
  | url | 是 | 音频资源地址，支持网络和本地地址 | |
  | config | 是 | 播放器配置 | 详见[配置] |

#### 手动加载媒体资源数据
在config配置里面将自动加载数据（autoLoad）设置为false时，需要调用此接口来加载数据
```objc
-(void)loadMediaData;
```

#### 播放器播放
```objc
-(void)play;
```

#### 暂停播放
可继续播放
```objc
-(void)pause;
```

#### 恢复播放
```objc
-(void)resume;
```

#### 停止播放
不可继续播放。若需再次播放此资源，需要重新初始化播放器加载url进行播放
```objc
-(void)stop;
```

#### 清除缓存
```objc
-(void)clearCache;
```

#### 跳转播放位置
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

#### 设置播放速率
```objc
-(void)configPlayRate:(float)rate;
```

- 接口参数
| 参数 | 必填 | 描述 |
|---|---|---|
| rate | 是 | 播放速率 0.0～2.0，0.0代表暂停播放，2.0代表两倍速播放 |

#### 音量控制
```objc
-(void)configVolume:(float)volume;
```

- 接口参数
| 参数 | 必填 | 描述 |
|---|---|---|
| volume | 是 | 音量  0.0～1.0，0.0代表播放器静音, 1.0 代表播放器音量最大 |

#### 销毁播放器
```objc
-(void)destroy;
````

#### 播放器状态更新回调

```objc
-(void)pllayerStatusChanged:(HFPlayerStatus) status;
```

- 回调参数
  
| 参数 | 描述 |
|---|---|
| status | 播放器状态 |

#### 播放进度回调

```objc
-(void)playerPlayProgress:(float)progress currentDuration:(float)currentDuration totalDuration:(float)totalDuration;
```

- 回调参数
  
| 参数 | 描述 |
|---|---|
| progress | 当前播放进度 |
| currentDuration | 当前播放时长，秒 |
| totalDuration | 资源总播放时长 ，秒|

#### 数据缓冲进度回调

```objc
-(void)playerLoadingProgress:(float)progress timeRange:(CMTimeRange) timeRange;
```

- 回调参数

| 参数 | 描述 |
|---|---|
| progress | 当前缓冲进度 |
| timeRange | 本次缓冲时间段 |

#### 播放器遇到缓冲

```objc
-(void)playerLoadingBegin;
```

#### 播放器缓冲结束

```objc
-(void)playerLoadingEnd;
```

#### 播放器播放完毕

```objc
-(void)playerPlayToEnd;
```

#### 播放资源Token过期
用户可在此回调中进行重新获取新的资源地址，播放等处理
```objc
-(void)sourceAccessTokenDisabled;
```

#### 播放器状态码

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

