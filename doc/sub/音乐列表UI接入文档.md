# 《音乐列表UI》接口文档
[TOC]
## 初始化及显示UI视图
<font color='#FF0000'>只初始化不显示UI。</font>

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
<font color='#FF0000'>新增接口，没有就加代码实例。</font>


## 隐藏音乐列表
```objc
-(void)removeMusicListView;
```

## 设置代理
<font color='#FF0000'>放代码实例，注释说明即可（状态更新回调等都在代码里注释说明），如java的</font>

```java
HFOpenMusic.getInstance()
                .setPlayListen(new HFPlayMusicListener() {
                    @Override
                    public void onPlayMusic(MusicRecord musicDetail, String url) {
                        //播放音乐回调
                    }

                    @Override
                    public void onStop() {
                        //播放停止回调
                        HFPlayer.getInstance().stopPlay();
                    }

                    @Override
                    public void onCloseOpenMusic() {
                        //。。。
                    }
                })
                .showOpenMusic(MainActivity.this);
```

遵循协议 `HFOpenMusicDelegate`
```objc
-(void)setDelegate:(id<HFOpenMusicDelegate>)delegate;
```


## 当前播放发生切换回调
<font color='#FF0000'>与《设置代理》整合</font>
```objc
-(void)currentPlayChangedMusic:(HFOpenMusicModel *)musicModel detail:(HFOpenMusicDetailInfoModel *)detailModel canCutSong:(BOOL)canCutSong;
```
| 参数 | 描述 |
|---|---|
| musicModel | 歌曲信息数据 |
| detailModel | 歌曲详情数据 |
| canCutSong | 上/下切歌按钮能否被点击 |


## 上/下切歌按钮能否被点击，需要更新回调
<font color='#FF0000'>与《设置代理》整合</font>


```objc
-(void)canCutSongChanged:(BOOL)canCutSong;
```
| 参数 | 描述 |
|---|---|
| canCutSong | 上/下切歌按钮能否被点击 |
