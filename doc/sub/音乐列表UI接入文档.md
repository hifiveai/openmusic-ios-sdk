# 《音乐列表UI》接口文档
[TOC]
## 初始化

```objc
-(instancetype)initMusicListViewWithListenType:(HFOpenMusicListenType)type showControlbtn:(BOOL)showControlbtn;
```
| 参数 | 必填 | 描述 | 可选值 |
|---|---|---|---|
| type | 是 | 音乐授权类型 | 详见[音乐授权类型] |
| showControlbtn | 是 | 是否显示控制视图展开/收起的按钮 | true/false |

**音乐授权类型**

| 名称                  | 值      |      |
| --------------------- | ------- | ---- |
| BGM音乐播放           | TYPE_TRAFFIC |      |
| 音视频作品BGM音乐播放 | TYPE_UGC     |      |
| K歌音乐播放           | KTYPE_K      |      |

## 显示音乐列表
```objc
-(void)addMusicListView;
```
## 隐藏音乐列表
```objc
-(void)removeMusicListView;
```
## 播放上一首，更新歌曲UI列表并回调歌曲数据
```objc
-(void)previousPlay;
```
## 播放下一首，更新歌曲UI列表并回调歌曲数据
```objc
-(void)nextPlay;
```
## 上滑显示列表
```objc
-(void)showMusicSegmentView;
```
## 下滑隐藏列表
```objc
-(void)dismissView;
```
## 设置代理
```objc
-(void)viewDidLoad {
    HFOpenMusic *listView = [[HFOpenMusic alloc] initMusicListViewWithListenType:self.musicType showControlbtn:true];
    listView.delegate = self;
    [listView addMusicListView];
}

//代理方法
-(void)currentPlayChangedMusic:(HFOpenMusicModel *)musicModel detail:(HFOpenMusicDetailInfoModel *)detailModel canCutSong:(BOOL)canCutSong {
    //当前播放发生切换回调
}

-(void)canCutSongChanged:(BOOL)canCutSong {
    //上/下切歌按钮能否被点击，需要更新回调
}

```

遵循协议 `HFOpenMusicDelegate`
```objc
-(void)setDelegate:(id<HFOpenMusicDelegate>)delegate;
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
