### 一. 项目说明

#### 该项目是接入了 HIFIVE API的客户端Demo,包括播放器,播放列表等相关UI.

1. 配置依赖库

项目具体代码在HFOpenMusicPlayer文件夹下,接入的Demo名称是HFOpenMusicPlayerDemo.


- 工程系统库依赖:
   1. libc++.tbd
   2. libbz2.1.0.tbd
 
- 播放器依赖库(可选择下载):

下载地址:[IJKMediaFramework](https://hifive-open-sdk.s3.cn-northwest-1.amazonaws.com.cn/ios/IJKMediaFramework)
放入HFOpenMusicPlayer/IJKMediaFramework.framework/文件夹 

或自行下载播放器源码 [ijkplayer](https://github.com/Bilibili/ijkplayer)

- 依赖的第三方库:

pod 'MJExtension'
pod 'Masonry'
pod 'YYWebImage'
pod 'MJRefresh'
pod 'FLAnimatedImage'
pod 'SVProgressHUD'

2. 运行项目

执行pod install ,打开.xcworkspace工程。

### 二、接口说明


1. 初始化

    调用如下API进行初始化操作，clientId为用户唯一标识（公司自有的用户ID），请在获取到用户ID之后调用

    ```objc 

    [[HFOpenApiManager shared] registerAppWithAppId:@"appId" serverCode:@"serverCode" clientId:@"clientId" version:@"version" success:^(id  _Nullable response) {
        //注册成功
    } fail:^(NSError * _Nullable error) {
        //注册失败
    }];

    ```
    | 参数 | 必填 | 描述 |
    |---|---|---|
    | appId | 是 | 开放平台申请appId |
    | serverCode | 是 | 开放平台申请serverCode |
    | clientId | 是 | 用户唯一标识（公司自有的用户ID） |
    | version | 是 | 操作的 API 的版本，如：V4.1.1 |


2. 音乐授权类型

    | 名称                  | 值      |     
    | --------------------- | ------- | 
    | BGM音乐播放           | TYPE_TRAFFIC |    
    | 音视频作品BGM音乐播放 | TYPE_UGC     |     
    | K歌音乐播放           | KTYPE_K      |      

3. 配置

- 创建默认配置
    ```objc
    HFOpenMusicPlayerConfiguration *config = [HFOpenMusicPlayerConfiguration defaultConfiguration];
    ```
    | 配置项 | 描述 | 默认值 | 类型 |
    |---|---|---|---|
    | autoNext | 自动播放下一首 | 默认开启 | BOOL |
    | panTopLimit | 播放器视图可拖拽范围，距离顶部距离 | 0 | NSUInteger |
    | panBottomLimit | 播放器视图可拖拽范围，距离底部距离 | 0 | NSUInteger |
    | cacheEnable | 是否允许客户端缓存 | 默认关闭 | BOOL |
    | bufferCacheSize | 缓冲区大小 | 默认270 (单位kb)，最小配置270kb | NSUInteger |
    | repeatPlay | 是否允许重复播放 | 默认关闭 | BOOL |
    | networkAbilityEable | 是否开启网络监测,断线重连播放 | 默认开启 | BOOL |
    | rate | 播放速率 | 默认1.0 | float |


    ```objc
    //获取默认配置
    HFOpenMusicPlayerConfiguration *config = [HFOpenMusicPlayerConfiguration defaultConfiguration];
    //用户可通过自己需求在默认配置上进行个性化配置
    config.networkAbilityEable = true;
    config.cacheEnable = true;
    config.bufferCacheSize = 350;
    config.panTopLimit = 100;
    config.panBottomLimit = 50;
    ```
4. 展示视图
    ```objc
    -(void)addMusicPlayerView;
    ```


    ```objc
    HFOpenMusicPlayer *playerView = [[HFOpenMusicPlayer alloc] initWithListenType:TYPE_TRAFFIC config:config];
    //显示播放器
    [playerView addMusicPlayerView];
    //显示播放列表
    [playerView.listView showMusicSegmentView];
    ```

4. 更多接口
    可查看DOC文件夹里面的文档



### 三、API状态码

错误码

| 错误码 | 错误描述 | 解决方案 |
|----------|:--------|:-------- |
| HFVSDK_CODE_NoRegister | 未初始化 | 初始化 |
| HFVSDK_CODE_NoLogin | 未登录 | 登录 |
| HFVSDK_CODE_NoParameter | 参数不全 | 必选参数缺失 |
| HFVSDK_CODE_ParameterError | 参数字符格式错误 | 检查上传参数 |
| HFVSDK_CODE_JsonError | 响应不数据不是json | 反馈官方技术支持 |
| HFVSDK_CODE_NoNetwork | 无网络连接 | 检查网络 |
| HFVSDK_CODE_RequestTimeOut | 请求超时 | 稍后重试 |

成功响应码

| 响应码 | 描述 |
|----------|:--------|
| 10200 | success |
