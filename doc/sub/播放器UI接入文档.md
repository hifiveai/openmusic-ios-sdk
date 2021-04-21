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
| 配置项 | 描述 | 默认值 |
|---|---|---|
| urlString | 播放器媒体URL字符串 | - |
| songName | 歌曲名字 | - |
| imageUrlString | 歌曲图片URL字符串 | - |
| canCutSong | 切歌按钮是否可用 | - |
| autoNext | 自动播放下一首 | 默认开启 |
| panTopLimit | 播放器视图可拖拽范围，距离顶部距离 | 0 |
| panBottomLimit | 播放器视图可拖拽范围，距离底部距离 | 0 |
| cacheEnable | 是否允许客户端缓存 | 默认关闭 |
| bufferCacheSize | 缓冲区大小 | 默认270kb（最小配置270kb） |
| advanceBufferCacheSize | 预缓冲区大小 | 默认为缓冲区大小的1/2 |
| repeatPlay | 是否允许重复播放 | 默认关闭 |
| networkAbilityEable | 是否开启网络监测,断线重连播放 | 默认开启 |
| rate | 播放速率 | 默认1.0 |
| autoLoad | 播放器自动缓冲数据 | 默认开启 |

## 显示播放器
<font color='#FF0000'>新加接口，不需要每次调用初始化并显示</font>

## 移除播放器
```objc
-(void)removePlayerView;
```


## 播放歌曲
<font color='#FF0000'>新加接口，可以设置url、标题、封面</font>

## 停止播放音乐
<font color='#FF0000'>新加接口</font>

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
-(void)setDelegate:(id<HFPlayerDelegate>)delegate
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


