# 《音乐列表UI》接口文档
[TOC]
## 初始化UI视图
```objc
-(instancetype)initWithListenType:(HFOpenMusicListenType) type;
```
| 参数 | 必填 | 描述 | 可选值 |
|---|---|---|---|
| type | 是 | 音乐授权类型 | 详见[音乐授权类型] |

**音乐授权类型**

| 名称                  | 值      |      |
| --------------------- | ------- | ---- |
| BGM音乐播放           | TYPE_TRAFFIC |      |
| 音视频作品BGM音乐播放 | TYPE_UGC     |      |
| K歌音乐播放           | KTYPE_K      |      |

## 设置代理
遵循协议 `HFOpenMusicDelegate`
```objc
-(void)setDelegate:(id<HFOpenMusicDelegate>)delegate;
```
## 上一首
```objc
-(void)previousPlay;
```

## 下一曲
```objc
-(void)nextPlay;
```
## 显示音乐列表
```objc
-(void)showMusicSegmentView;
```

## 关闭音乐列表
```objc
-(void)dismissView;
```
## 当前播放发生切换回调
```objc
-(void)currentPlayChangedMusic:(HFOpenMusicModel *)musicModel detail:(HFOpenMusicDetailInfoModel *)detailModel canCutSong:(BOOL)canCutSong;
```
| 参数 | 描述 |
|---|---|
| musicModel | 歌曲信息数据 |
| detailModel | 歌曲详情数据 |
| canCutSong | 上/下切歌按钮能否被点击 |


## 上/下切歌按钮能否被点击，需要更新回调
```objc
-(void)canCutSongChanged:(BOOL)canCutSong;
```
| 参数 | 描述 |
|---|---|
| canCutSong | 上/下切歌按钮能否被点击 |
