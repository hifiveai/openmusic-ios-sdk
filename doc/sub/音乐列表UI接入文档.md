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

## 添加音乐列表视图
```objc
-(void)addMusicListView;
```
## 移除音乐列表视图
```objc
-(void)removeMusicListView;
```
## 播放上一首
该接口会更新歌曲UI列表并回调歌曲数据
```objc
-(void)previousPlay;
```
## 播放下一首
该接口会更新歌曲UI列表并回调歌曲数据
```objc
-(void)nextPlay;
```
## 列表上移显示
```objc
-(void)showMusicSegmentView;
```
## 列表下移隐藏
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


| 参数 | 描述 | 类型 |
|---|---|---|
| musicModel | 歌曲信息数据 | HFOpenMusicModel |
| detailModel | 歌曲详情数据 | HFOpenMusicDetailInfoModel |
| canCutSong | 上/下切歌按钮能否被点击 | BOOL |

**musicModel**
| 属性 | 描述 | 类型 |
|---|---|---|
| musicId | 音乐id |  NSString |
| musicName | 音乐名 |  NSString |
| albumId | 专辑id |  NSString |
| albumName | 专辑名 |  NSString |
| author | 作词者 |  NSArray |
| composer | 作曲者 |  NSArray |
| arranger | 编曲者 |  NSArray |
| cover | 封面 |  NSArray |
| duration | 时长（秒），此字段可能和播放器读取时长有一定误差 |  NSString |
| auditionBegin | 推荐试听开始时间 |  NSString |
| auditionEnd | 推荐试听结束时间 |  NSString |
| bpm | 每分钟节拍 |  NSString |
| tag | 标签 |  NSArray |
| version | 版本信息 |  NSArray |
| 表演者 | 表演者 |  NSArray |

**detailModel**
| 属性 | 描述 | 类型 |
|---|---|---|
| musicId | 音乐id |  NSString |
| expires | 过期时间 |  NSString |
| fileUrl | 试听地址 |  NSString |
| fileSize | 文件大小 |  NSString |
| waveUrl | 波形图地址 |  NSString |


