# 《播放器UI》接口文档
[TOC]
## 初始化SDK
```objc
-(instancetype)initWithConfiguration:(HFPlayerConfiguration *)config;
```
| 参数 | 必填 | 描述 | 可选值 |
|---|---|---|---|
| config | 是 | 配置 | 详见[配置] |

### 配置

- 创建默认配置
```objc
HFPlayerConfiguration *config = [HFPlayerConfiguration defaultConfiguration];
```
| 配置项 | 描述 | 默认值 | 类型 |
|---|---|---|---|
| urlString | 播放器媒体URL字符串 | - | NSString |
| songName | 歌曲名字 | - | NSString |
| imageUrlString | 歌曲图片URL字符串 | - | NSString |
| canCutSong | 切歌按钮是否可用 | - | BOOL |
| autoNext | 自动播放下一首 | 默认开启 | BOOL |
| panTopLimit | 播放器视图可拖拽范围，距离顶部距离 | 0 | NSUInteger |
| panBottomLimit | 播放器视图可拖拽范围，距离底部距离 | 0 | NSUInteger |
| cacheEnable | 是否允许客户端缓存 | 默认关闭 | BOOL | 
| bufferCacheSize | 缓冲区大小 | 默认270kb（最小配置270kb） | NSUInteger |
| repeatPlay | 是否允许重复播放 | 默认关闭 | BOOL |
| networkAbilityEable | 是否开启网络监测,断线重连播放 | 默认开启 |
| rate | 播放速率 | 默认1.0 | float |

## 显示播放器
```objc
-(void)addPlayerView;
```

## 移除播放器
```objc
-(void)removePlayerView;
```

## 切换歌曲信息等设置
```objc
-(void)setConfig:(HFPlayerConfiguration *)config;
```

## 播放歌曲
```objc
-(void)play;
```

## 暂停播放音乐
```objc
-(void)pause;
```

## 展开播放器
```objc
-(void)unfoldPlayerBar;
```

## 折叠播放器
```objc
-(void)shrinkPlayerBar;
```

## 设置代理
遵循协议`HFPlayerDelegate`
```objc
-(void)viewDidLoad {
HFPlayerConfiguration *config = [HFPlayerConfiguration defaultConfiguration];
config.urlString = @"http://xxxxxx";
config.songName = @"xxx";
HFPlayer *playerView = [[HFPlayer alloc] initWithConfiguration:config];
playerView.delegate = self;
[playerView addPlayerView];
}

-(void)previousClick {
  //上一曲点击
}

-(void)nextClick {
  //下一曲按钮点击
}

-(void)headerClick {
  //头像点击
}

```

### 上一曲按钮点击回调
```objc
-(void)previousClick;
```
### 下一曲按钮点击回调
```objc
-(void)nextClick;
```
### 头像点击回调
```objc
-(void)headerClick;
```


