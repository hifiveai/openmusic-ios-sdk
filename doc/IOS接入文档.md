



###一. 项目说明

####该项目是接入了 HIFIVE API的客户端Demo,包括播放器,播放列表等相关UI.

项目具体代码在HFOpenMusicPlayer文件夹下,接入的Demo名称是HFOpenMusicPlayerDemo.


- 工程系统库依赖:
   1. libc++.tbd
   2. libbz2.1.0.tbd

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

    [[HFOpenApiManager shared] registerAppWithAppId:@"appId" 
    serverCode:@"serverCode" 
    clientId:@"clientId" 
    version:@"version" 
    success:^(id  _Nullable response) {
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


2. 登录    
    登录后才可以操作,用户名必填
    ```objc
     [[HFOpenApiManager shared] baseLoginWithNickname:@"userName" 
        gender:nil 
        birthday:nil 
        location:nil 
        education:nil 
        profession:nil 
        isOrganization:false 
        reserve:nil 
        favoriteSinger:nil 
        favoriteGenre:nil 
     success:^(id  _Nullable response) {
         NSLog(@"登录成功");
         [self configUiType0];
     } fail:^(NSError * _Nullable error) {
         NSLog(@"!!!");
     }];
    ```
    
| 参数           | 必填 | 描述                                        | 可选值             | 示例                   |      |
| -------------- | ---- | ------------------------------------------- | ------------------ | ---------------------- | ---- |
| nickname       | 是   | 昵称                                        | -                  | -                      |      |
| gender         | 否   | 性别，默认0                                 | 0:未知,1:男,2:女   | -                      |      |
| birthday       | 否   | 出生日期，10位秒级时间戳                    | -                  | 1594639058             |      |
| location       | 否   | 经纬度信息，纬度在前                        | -                  | 30.779164,103.94547    |      |
| education      | 否   | 所受教育水平                                | 详见[教育水平定义] | 0                      |      |
| profession     | 否   | 职业                                        | 详见[用户职业定义] | 0                      |      |
| isOrganization | 否   | 是否属于组织机构类型用户（to B），默认false | true/false         | false                  |      |
| reserve        | 否   | json字符串，保留字段用于扩展用户其他信息    | -                  | {"language":"English"} |      |
| favoriteSinger | 否   | 喜欢的歌手名，多个用英文逗号隔开            | -                  | Queen,The Beatles      |      |
| favoriteGenre  | 否   | 喜欢的音乐流派Id，多个用英文逗号拼接        | -                  | 7,8,10                 |      |
| success | 否 | 成功 | - | - | |
| fail | 否 | 失败 | - | - | |

**教育水平定义**

| 名称       | 枚举值 | 说明   |      |
| ---------- | ------ | ------ | ---- |
| 未采集     | 0      | 默认值 |      |
| 小学       | 1      | -      |      |
| 初中       | 2      | -      |      |
| 高中       | 3      | -      |      |
| 大学       | 4      | -      |      |
| 硕士及以上 | 5      | -      |      |

**用户职业定义**

| 名称                                             | 枚举值 | 说明   |      |
| ------------------------------------------------ | ------ | ------ | ---- |
| 未采集                                           | 0      | 默认值 |      |
| 政府部门/企事业/公司管理人员                     | 1      | -      |      |
| 私营业主                                         | 2      | -      |      |
| 专业技术人员（教师、医生、工程技术人员、作家等） | 3      | -      |      |
| 企业/公司职员                                    | 4      | -      |      |
| 党政机关事业单位员工                             | 5      | -      |      |
| 第三产业服务人员                                 | 6      | -      |      |
| 学生                                             | 7      | -      |      |
| 军人                                             | 8      | -      |      |
| 失业、自由工作者、离退休人员                     | 9      | -      |      |
| 其他                                             | 10     | -      |      |

**音乐流派定义**

| 名称   | 枚举值 | 说明   |      |
| ------ | ------ | ------ | ---- |
| 未采集 | 0      | 默认值 |      |
| 中国风 | 1      | -      |      |
| 拉丁   | 2      | -      |      |
| 嘻哈   | 3      | -      |      |
| 爵士   | 4      | -      |      |
| 乡村   | 5      | -      |      |
| 流行   | 6      | -      |      |
| 布鲁斯 | 7      | -      |      |
| 民谣   | 8      | -      |      |
| 摇滚   | 9      | -      |      |
| 轻音乐 | 10     | -      |      |
| 管弦乐 | 11     | -      |      |
| 电子   | 12     | -      |      |
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
   使用 HFOpenMusicPlayer 类
    ```objc
    -(instancetype _Nonnull )initWithListenType:(HFOpenMusicListenType)type config:(HFOpenMusicPlayerConfiguration *_Nonnull)config;
    ```
    音乐授权类型

    | 名称                  | 值      |     
    | --------------------- | ------- | 
    | BGM音乐播放           | TYPE_TRAFFIC |    
    | 音视频作品BGM音乐播放 | TYPE_UGC     |     
    | K歌音乐播放           | KTYPE_K      |    

    ```objc
    HFOpenMusicPlayer *playerView = [[HFOpenMusicPlayer alloc] initWithListenType:TYPE_TRAFFIC config:config];
    //显示播放器
    [playerView addMusicPlayerView];
    //显示播放列表
    [playerView.listView showMusicSegmentView];
    ```

5. 更多接口
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
