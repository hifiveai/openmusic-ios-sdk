# 《通用API》接口文档
[TOC]

## SDK初始化

导入`#import <HFOpenApi/HFOpenApi.h>`,调用如下API进行SDK初始化操作，clientId为用户唯一标识（公司自有的用户ID），请在获取到用户ID之后调用

```objc 
    [[HFOpenApiManager shared] registerAppWithAppId:@"appId" serverCode:@"serverCode" clientId:@"clientId" version:@"version" success:^(id  _Nullable response) {
        //注册成功
    } fail:^(NSError * _Nullable error) {
        //注册失败
    }];
```
- 请求参数
| 参数 | 必填 | 描述 |
|---|---|---|
| appId | 是 | 开放平台申请appId |
| serverCode | 是 | 开放平台申请serverCode |
| clientId | 是 | 用户唯一标识（公司自有的用户ID） |
| version | 是 | 操作的 API 的版本，如：V4.1.1 |
| success | 否 | 成功 |
| fail | 否 | 失败 |

## 配置HFOpenApi请求错误处理
遵循协议  HFOpenApiErrorProtocol
设置代理 
```objc
[HFOpenApiManager shared].delegate = self;

```
回调方法
```objc
-(void)onServerErrorCode:(int)errorCode info:(NSDictionary *)info {
    NSLog(@"%@",[info description]);
}

-(void)onSendRequestErrorCode:(HFAPISDK_CODE)errorCode info:(NSDictionary *)info {
    NSLog(@"%@",[info description]);
}
```

## 电台列表

```objc

-(void)channelWithSuccess:(void (^_Nullable)(id  _Nullable response))success
                     fail:(void (^_Nullable)(NSError * _Nullable error))fail;

```

- 请求参数
| 参数 | 必填 | 描述 |
|---|---|---|
| success | 否 | 成功 |
| fail | 否 | 失败 |

## 电台获取歌单列表

```objc

-(void)channelSheetWithGroupId:(NSString *_Nullable)groupId
                      language:(NSString *_Nullable)language
                       recoNum:(NSString *_Nullable)recoNum
                          page:(NSString *_Nullable)page
                      pageSize:(NSString *_Nullable)pageSize
                       success:(void (^_Nullable)(id  _Nullable response))success
                          fail:(void (^_Nullable)(NSError * _Nullable error))fail;

```

- 请求参数
| 参数 | 必填 | 描述 | 可选值 |
|---|---|---|---|
| groupId | 否 | 电台id | - |
| language | 否 | 语言版本 | 0-中文,1-英文 |
| recoNum | 否 | 推荐音乐数 | 0～10 |
| page | 否 | 当前页码，默认为1  |  大于0的整数 |
| pageSize | 否 | 每页显示条数，默认为10  | 1～100 |
| success | 否 | 成功 | - |
| fail | 否 | 失败 | - |

## 歌单获取音乐列表

```objc

-(void)sheetMusicWithSheetId:(NSString *_Nonnull)sheetId
                    language:(NSString *_Nullable)language
                        page:(NSString *_Nullable)page
                    pageSize:(NSString *_Nullable)pageSize
                     success:(void (^_Nullable)(id  _Nullable response))success
                        fail:(void (^_Nullable)(NSError * _Nullable error))fail;

```

- 请求参数
| 参数 | 必填 | 描述 | 可选值 |
|---|---|---|---|
| sheetId | 是 | 歌单id | - |
| language | 否 | 语言版本，英文版本数据可能空 | 0-中文,1-英文 |
| page | 否 | 当前页码，默认为1 | 大于0的整数 |
| pageSize | 否 | 每页显示条数，默认为10 | 1～100 |
| success | 否 | 成功 | - |
| fail | 否 | 失败 | - |

## 组合搜索

```objc

-(void)searchMusicWithTagIds:(NSString *_Nullable)tagIds
               priceFromCent:(NSString *_Nullable)priceFromCent
                 priceToCent:(NSString *_Nullable)priceToCent
                     bpmFrom:(NSString *_Nullable)bpmFrom
                       bpmTo:(NSString *_Nullable)bpmTo
                durationFrom:(NSString *_Nullable)durationFrom
                  durationTo:(NSString *_Nullable)durationTo
                     keyword:(NSString *_Nullable)keyword
                    language:(NSString *_Nullable)language
                 searchFiled:(NSString *_Nullable)searchFiled
                 searchSmart:(NSString *_Nullable)searchSmart
                        page:(NSString *_Nullable)page
                    pageSize:(NSString *_Nullable)pageSize
                     success:(void (^_Nullable)(id  _Nullable response))success
                        fail:(void (^_Nullable)(NSError * _Nullable error))fail;

```

- 请求参数
| 参数 | 必填 | 描述 | 可选值 |
|---|---|---|---|
| tagIds | 否 | 标签Id，多个Id以“,”拼接 | - |
| priceFromCent | 否 | 价格区间的最低值，单位分 | - |
| priceToCent | 否 | 价格区间的最高值，单位分 | - |
| bpmFrom | 否 | BPM区间的最低值 | - |
| bpmTo | 否 | BPM区间的最高值 | - |
| durationFrom | 否 | 时长区间的最低值,单位秒 | - |
| durationTo | 否 | 时长区间的最高值,单位秒 | - |
| keyword | 否 | 搜索关键词，搜索条件歌名、专辑名、艺人名、标签名 | - |
| language | 否 | 语言版本，英文版本数据可能空, 0-中文,1-英文 | - |
| searchFiled | 否 | Keywords参数指定搜索条件，不传时默认搜索条件歌名、专辑名、艺人名、标签名 | - |
| searchSmart | 否 | 是否启用分词｜0/1 |
| page | 否 | 当前页码，默认为1 | 大于0的整数 |
| pageSize | 否 | 每页显示条数，默认为10 | 1~100 |
| success | 否 | 成功 | - |
| fail | 否 | 失败 | - |

## 音乐配置信息

```objc

-(void)musicConfigWithSuccess:(void (^_Nullable)(id  _Nullable response))success
                         fail:(void (^_Nullable)(NSError * _Nullable error))fail;

```

- 请求参数
| 参数 | 必填 | 描述 |
|---|---|---|
| success | 否 | 成功 |
| fail | 否 | 失败 |

## 登录获取token

>在接口行为采集、猜你喜欢和单笔付费场景等接口中使用。（7200秒无操作则token自动失效，token不参与签名计算)

```objc

-(void)baseLoginWithNickname:(NSString *_Nullable)nickname
                      gender:(NSString *_Nullable)gender
                    birthday:(NSString *_Nullable)birthday
                    location:(NSString *_Nullable)location
                   education:(NSString *_Nullable)education
                  profession:(NSString *_Nullable)profession
              isOrganization:(BOOL)isOrganization
                     reserve:(NSString *_Nullable)reserve
              favoriteSinger:(NSString *_Nullable)favoriteSinger
               favoriteGenre:(NSString *_Nullable)favoriteGenre
                     success:(void (^_Nullable)(id  _Nullable response))success
                        fail:(void (^_Nullable)(NSError * _Nullable error))fail;

```
- 请求参数
| 参数           | 必填 | 描述                                        | 可选值             | 示例                   |      |
| -------------- | ---- | ------------------------------------------- | ------------------ | ---------------------- | ---- |
| nickname       | 否   | 昵称                                        | -                  | -                      |      |
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


## 行为采集

```objc

-(void)baseReportWithAction:(NSString *_Nonnull)action
                   targetId:(NSString *_Nonnull)targetId
                    content:(NSString *_Nullable)content
                   location:(NSString *_Nullable)location
                    success:(void (^_Nullable)(id  _Nullable response))success
                       fail:(void (^_Nullable)(NSError * _Nullable error))fail;

```
- 请求参数
| 参数     | 必填 | 描述                           | 可选值                             | 示例                |                                                         |
| -------- | ---- | ------------------------------ | ---------------------------------- | ------------------- | ------------------------------------------------------- |
| action   | 是   | 枚举定义用户行为               | 详见[用户行为定义]                 | -                   | 1001                                                    |
| targetId | 是   | 行为操作的对象（音乐或分类id） | -                                  | B75C80A41E3A        |                                                         |
| content  | 否   | 根据action传入格式             | 详见[用户行为定义]和[行为内容定义] | -                   | {"point":"15","duration":"52","musicId":"B7B610A7537A"} |
| location | 否   | 经纬度信息，纬度在前           | -                                  | 30.779164,103.94547 |                                                         |
| success | 否 | 成功 | - | - | |
| fail | 否 | 失败 | - | - | |

### 用户行为定义

| 行为         | 枚举值 | TargetId     | Content                |      |
| ------------ | ------ | ------------ | ---------------------- | ---- |
| 播放音乐     | 1000   | 音乐id       | point/duration         |      |
| 手动切歌     | 1001   | 被切换音乐id | point/duration/musicId |      |
| 暂停音乐     | 1002   | 音乐id       | point/duration         |      |
| 进度拖动     | 1003   | 音乐id       | from/to/duration       |      |
| 收藏音乐     | 1004   | 音乐id       | 空                     |      |
| 收藏标签     | 1005   | 标签id       | 空                     |      |
| 切换标签     | 1006   | 被切换标签id | tagId                  |      |
| 取消收藏音乐 | 1007   | 音乐id       | 空                     |      |
| 取消收藏标签 | 1008   | 标签id       | 空                     |      |
| 播放结束     | 1009   | 音乐id       | 空                     |      |
| 下载音乐     | 1010   | 音乐id       | 空                     |      |

### 行为内容定义

>行为内容采用json字符串保存，根据行为不同其参数不同。例如：播放音乐时content字段为point/duration，代表json包含point和duration这2个字段，字段具体含义如下：

| 参数     | 类型   | 说明                                       |      |
| -------- | ------ | ------------------------------------------ | ---- |
| point    | Int    | 当前播放时长(秒)                           |      |
| duration | Int    | 总时长(秒)                                 |      |
| musicId  | String | 切换音乐后的音乐id                         |      |
| tagId    | String | 切换标签后的标签id                         |      |
| from     | Int    | 用于变化的操作，该值代表进度变化前的值(秒) |      |
| to       | Int    | 用于变化的操作，该值代表进度变化后的值(秒) |      |


## 猜你喜欢

> 注意：此接口需先调用BaseLogin接口获取token

```objc

-(void)baseFavoriteWithPage:(NSString *_Nullable)page
                   pageSize:(NSString *_Nullable)pageSize
                    success:(void (^_Nullable)(id  _Nullable response))success
                       fail:(void (^_Nullable)(NSError * _Nullable error))fail;

```
- 请求参数
| 参数     | 必填 | 描述                   | 可选值      |      |
| -------- | ---- | ---------------------- | ----------- | ---- |
| page     | 否   | 当前页码，默认为1      | 大于0的整数 |      |
| pageSize | 否   | 每页显示条数，默认为10 | 1～100      |      |
| success | 否 | 成功 | - | - |
| fail | 否 | 失败 | - | - |

## 热门推荐

```objc

-(void)baseHotWithStartTime:(NSString * _Nonnull)startTime
                   duration:(NSString * _Nonnull)duration
                       page:(NSString *_Nullable)page
                   pageSize:(NSString *_Nullable)pageSize
                    success:(void (^_Nullable)(id  _Nullable response))success
                       fail:(void (^_Nullable)(NSError * _Nullable error))fail;

```
- 请求参数
| 参数      | 必填 | 描述                    | 可选值      |      |
| --------- | ---- | ----------------------- | ----------- | ---- |
| startTime | 是   | 10位秒级时间戳          | -           |      |
| duration  | 是   | 距离StartTime过去的天数 | 1～365      |      |
| page      | 否   | 当前页码，默认为1       | 大于0的整数 |      |
| pageSize  | 否   | 每页显示条数，默认为10  | 1～100      |      |
| success | 否 | 成功 | - | - |
| fail | 否 | 失败 | - | - |

## BGM音乐播放-歌曲试听

```objc

-(void)trafficTrialWithMusicId:(NSString *_Nonnull)musicId
                       success:(void (^_Nullable)(id  _Nullable response))success
                          fail:(void (^_Nullable)(NSError * _Nullable error))fail;
                          
```
- 请求参数
| 参数 | 必填 | 描述 |
|---|---|---|
| musicId | 是 | 音乐id |
| success | 否 | 成功 |
| fail | 否 | 失败 |

## BGM音乐播放-获取音乐HQ播放信息

```objc

-(void)trafficHQListenWithMusicId:(NSString *_Nonnull)musicId
                      audioFormat:(NSString *_Nullable)audioFormat
                        audioRate:(NSString *_Nullable)audioRate
                          success:(void (^_Nullable)(id  _Nullable response))success
                             fail:(void (^_Nullable)(NSError * _Nullable error))fail;
                                
```

- 请求参数
| 参数        | 必填 | 描述                              | 可选值    |      |
| ----------- | ---- | --------------------------------- | --------- | ---- |
| musicId     | 是   | 音乐id                            | -         |      |
| audioFormat | 否   | 文件编码,默认mp3                  | mp3 / aac |      |
| audioRate   | 否   | 音质，音乐播放时的比特率，默认320 | 320 / 128 |      |
| success | 否 | 成功 | - |   |
| fail | 否 | 失败 | - |   |

## 音视频作品BGM音乐播放-歌曲试听

```objc

-(void)ugcTrialWithMusicId:(NSString *_Nonnull)musicId
                   success:(void (^_Nullable)(id  _Nullable response))success
                      fail:(void (^_Nullable)(NSError * _Nullable error))fail;

```
- 请求参数
| 参数 | 必填 | 描述 |
|---|---|---|
| musicId | 是 | 音乐id |
| success | 否 | 成功 |
| fail | 否 | 失败 |

## 音视频作品BGM音乐播放-获取音乐HQ播放信息

```objc

-(void)ugcHQListenWithMusicId:(NSString *_Nonnull)musicId
                audioFormat:(NSString *_Nullable)audioFormat
                  audioRate:(NSString *_Nullable)audioRate
                    success:(void (^_Nullable)(id  _Nullable response))success
                       fail:(void (^_Nullable)(NSError * _Nullable error))fail;

```
- 请求参数
| 参数        | 必填 | 描述                              | 可选值    |      |
| ----------- | ---- | --------------------------------- | --------- | ---- |
| musicId     | 是   | 音乐id                            | -         |      |
| audioFormat | 否   | 文件编码,默认mp3                  | mp3 / aac |      |
| audioRate   | 否   | 音质，音乐播放时的比特率，默认320 | 320 / 128 |      |
| success | 否 | 成功 | - |   |
| fail | 否 | 失败 | - |   |

## K歌音乐播放-歌曲试听

```objc

-(void)kTrialWithMusicId:(NSString *_Nonnull)musicId
                 success:(void (^_Nullable)(id  _Nullable response))success
                    fail:(void (^_Nullable)(NSError * _Nullable error))fail;

```
- 请求参数
| 参数 | 必填 | 描述 |
|---|---|---|
| musicId | 是 | 音乐id |
| success | 否 | 成功 |
| fail | 否 | 失败 |

## K歌音乐播放-获取音乐HQ播放信息

```objc

-(void)kHQListenWithMusicId:(NSString *_Nonnull)musicId
              audioFormat:(NSString *_Nullable)audioFormat
                audioRate:(NSString *_Nullable)audioRate
                  success:(void (^_Nullable)(id  _Nullable response))success
                     fail:(void (^_Nullable)(NSError * _Nullable error))fail;

```
- 请求参数
| 参数        | 必填 | 描述                              | 可选值    |      |
| ----------- | ---- | --------------------------------- | --------- | ---- |
| musicId     | 是   | 音乐id                            | -         |      |
| audioFormat | 否   | 文件编码,默认mp3                  | mp3 / aac |      |
| audioRate   | 否   | 音质，音乐播放时的比特率，默认320 | 320 / 128 |      |
| success | 否 | 成功 | - |   |
| fail | 否 | 失败 | - |   |

## 音乐售卖-歌曲试听

```objc

-(void)orderTrialWithMusicId:(NSString *_Nonnull)musicId
                     success:(void (^_Nullable)(id  _Nullable response))success
                        fail:(void (^_Nullable)(NSError * _Nullable error))fail;

```
- 请求参数

| 参数 | 必填 | 描述 |
|---|---|---|
| musicId | 是 | 音乐id |
| success | 否 | 成功 |
| fail | 否 | 失败 |

## 音乐售卖-购买音乐

```objc

-(void)orderMusicWithSubject:(NSString *_Nonnull)subject
                     orderId:(NSString *_Nonnull)orderId
                    deadline:(NSString *_Nonnull)deadline
                       music:(NSString *_Nonnull)music
                    language:(NSString *_Nullable)language
                 audioFormat:(NSString *_Nullable)audioFormat
                   audioRate:(NSString *_Nullable)audioRate
                    totalFee:(NSString *_Nonnull)totalFee
                      remark:(NSString *_Nullable)remark
                      workId:(NSString *_Nullable)workId
                     success:(void (^_Nullable)(id  _Nullable response))success
                        fail:(void (^_Nullable)(NSError * _Nullable error))fail;

```

- 请求参数
| 参数        | 必填 | 描述                                                         | 可选值        |      |
| ----------- | ---- | ------------------------------------------------------------ | ------------- | ---- |
| subject     | 是   | 商品描述                                                     | -             |      |
| orderId     | 是   | 公司自己生成的订单id                                         | -             |      |
| deadline    | 是   | 作品授权时长，以天为单位，0代表永久授权                      | -             |      |
| music       | 是   | 购买详情，encode转化后的json字符串 （musicId->音乐id；price->音乐单价，单位分；num->购买数量） | -             |      |
| language    | 否   | 标签、歌单名、歌名语言版本                                   | 0-中文,1-英文 |      |
| audioFormat | 否   | 文件编码,默认mp3                                             | mp3 / aac     |      |
| audioRate   | 否   | 音质，音乐播放时的比特率，默认320                            | 320 / 128     |      |
| totalFee    | 是   | 售出总价，单位：分                                           | -             |      |
| remark      | 否   | 备注，最多不超过255字符                                      | -             |      |
| workId      | 否   | 公司自己生成的作品id,多个以“,”拼接                           | -             |      |
| success | 否 | 成功 | - |     |
| fail | 否 | 失败 | - |     |

## 音乐售卖-查询订单

```objc

-(void)orderDetailWithOrderId:(NSString *_Nonnull)orderId
                      success:(void (^_Nullable)(id  _Nullable response))success
                         fail:(void (^_Nullable)(NSError * _Nullable error))fail;

```

- 请求参数
| 参数 | 必填 | 描述 | 可选值 |      |
|---|---|---|---|---|
| orderId | 是 | 公司自己生成的订单id | -     |      |
| success | 否 | 成功 | -     |      |
| fail | 否 | 失败 | -     |      |

## 音乐售卖-下载授权书

```objc

-(void)orderAuthorizationWithCompanyName:(NSString *_Nonnull)companyName
                             projectName:(NSString *_Nonnull)projectName
                                   brand:(NSString *_Nonnull)brand
                                  period:(NSString *_Nonnull)period
                                    area:(NSString *_Nonnull)area
                                orderIds:(NSString *_Nonnull)orderIds
                                 success:(void (^_Nullable)(id  _Nullable response))success
                                    fail:(void (^_Nullable)(NSError * _Nullable error))fail;

```

- 请求参数
| 参数        | 必填 | 描述                                                | 可选值                                      |      |
| ----------- | ---- | --------------------------------------------------- | ------------------------------------------- | ---- |
| companyName | 是   | 公司名称                                            | -                                           |      |
| projectName | 是   | 项目名称                                            | -                                           |      |
| brand       | 是   | 项目品牌                                            | -                                           |      |
| period      | 是   | 授权期限（0:半年、1:1年、2:2年、3:3年、4:随片永久） | （0:半年、1:1年、2:2年、3:3年、4:随片永久） |      |
| area        | 是   | 授权地区（0:中国大陆、1:大中华、2:全球）            | （0:中国大陆、1:大中华、2:全球）            |      |
| orderIds    | 是   | 授权订单ID列表，多个ID用","隔开                     | -                                           |      |
| success | 否 | 成功 | - |      |
| fail | 否 | 失败 | - |     |

## 发布作品
```objc

-(void)orderPublishWithOrderId:(NSString *_Nonnull)orderId
                       workId:(NSString *_Nonnull)workId
                      success:(void (^_Nullable)(id  _Nullable response))success
                         fail:(void (^_Nullable)(NSError * _Nullable error))fail;

```
- 请求参数

| 参数 | 必填 | 描述 |
|---|---|---|
| orderId | 是 | 公司自己生成的订单id |
| workId | 是 | 公司自己生成的作品id,多个以“,”拼接 |
| success | 否 | 成功 |
| fail | 否 | 失败 |

## BGM音乐数据上报
```objc

-(void)trafficReportListenWithMusicId:(NSString *_Nonnull)musicId
                             duration:(NSString *_Nonnull)duration
                            timestamp:(NSString *_Nonnull)timestamp
                          audioFormat:(NSString *_Nonnull)audioFormat
                            audioRate:(NSString *_Nonnull)audioRate
                              success:(void (^_Nullable)(id  _Nullable response))success
                                 fail:(void (^_Nullable)(NSError * _Nullable error))fail;

```
- 请求参数
| 参数        | 必填 | 描述                             | 可选值    |      |
| ----------- | ---- | -------------------------------- | --------- | ---- |
| musicId     | 是   | 音乐id                           | -         |      |
| duration    | 是   | 当前音频播放持续时长             | -         |      |
| timestamp   | 是   | 播放完成的时间，13位毫秒级时间戳 | -         |      |
| audioFormat | 是   | 当前播放音频的文件编码           | mp3 / aac |      |
| audioRate   | 是   | 当前播放音频的比特率             | 320 / 128 |      |
| success | 否 | 成功 | - |     |
| fail | 否 | 失败 | - |     |

## 音视频音乐数据上报
```objc

-(void)ugcReportListenWithMusicId:(NSString *_Nonnull)musicId
                         duration:(NSString *_Nonnull)duration
                        timestamp:(NSString *_Nonnull)timestamp
                      audioFormat:(NSString *_Nonnull)audioFormat
                        audioRate:(NSString *_Nonnull)audioRate
                          success:(void (^_Nullable)(id  _Nullable response))success
                             fail:(void (^_Nullable)(NSError * _Nullable error))fail;

```
- 请求参数
| 参数        | 必填 | 描述                             | 可选值    |      |
| ----------- | ---- | -------------------------------- | --------- | ---- |
| musicId     | 是   | 音乐id                           | -         |      |
| duration    | 是   | 当前音频播放持续时长             | -         |      |
| timestamp   | 是   | 播放完成的时间，13位毫秒级时间戳 | -         |      |
| audioFormat | 是   | 当前播放音频的文件编码           | mp3 / aac |      |
| audioRate   | 是   | 当前播放音频的比特率             | 320 / 128 |      |
| success | 否 | 成功 | - |     |
| fail | 否 | 失败 | - |     |

## K歌音乐数据上报
```objc

-(void)kReportListenWithMusicId:(NSString *_Nonnull)musicId
                       duration:(NSString *_Nonnull)duration
                      timestamp:(NSString *_Nonnull)timestamp
                    audioFormat:(NSString *_Nonnull)audioFormat
                      audioRate:(NSString *_Nonnull)audioRate
                        success:(void (^_Nullable)(id  _Nullable response))success
                           fail:(void (^_Nullable)(NSError * _Nullable error))fail;

```
- 请求参数
| 参数        | 必填 | 描述                             | 可选值    |      |
| ----------- | ---- | -------------------------------- | --------- | ---- |
| musicId     | 是   | 音乐id                           | -         |      |
| duration    | 是   | 当前音频播放持续时长             | -         |      |
| timestamp   | 是   | 播放完成的时间，13位毫秒级时间戳 | -         |      |
| audioFormat | 是   | 当前播放音频的文件编码           | mp3 / aac |      |
| audioRate   | 是   | 当前播放音频的比特率             | 320 / 128 |      |
| success | 否 | 成功 | - |     |
| fail | 否 | 失败 | - |     |

# API状态码

**API错误码**

| code  | 说明                                   |
| ----- | :------------------------------------- |
| 400   | 参数缺失                               |
| 401   | 签名错误                               |
| 402   | ip地址不在白名单内                     |
| 403   | AppId不存在或App状态异常               |
| 404   | 找不到请求记录                         |
| 405   | 您的服务暂未开通，请检查接口的授权状态 |
| 406   | 登录过期，请重新登录                   |
| 407   | 接口授权已过期                         |
| 408   | 订单授权已过期                         |
| 412   | 请不要重复请求接口                     |
| 413   | 签名已过期                             |
| 414   | 位置信息不正确                         |
| 415   | 产品不存在                             |
| 416   | 订单号重复                             |
| 417   | 订单不存在                             |
| 418   | 不存在可取消的订单                     |
| 419   | 取消订单失败                           |
| 420   | 会员专享                               |
| 421   | 存在未支付的订单                       |
| 422   | 找不到服务模块，请检查url是否正确      |
| 423   | 已达到今天调用上限                     |
| 500   | 系统繁忙，请稍后重试                   |
| 503   | 非法参数                               |
| 504   | 当前排队人数过多，请稍后再试           |
| 10200 | 成功                                   |

**SDK错误码**
| 错误码 | 错误描述 | 解决方案 |
|----------|:--------|:-------- |
| HFVSDK_CODE_NoRegister | 未初始化SDK | 初始化 |
| HFVSDK_CODE_NoLogin | 未登录 | 登录 |
| HFVSDK_CODE_NoParameter | 参数不全 | 必选参数缺失 |
| HFVSDK_CODE_ParameterError | 参数字符格式错误 | 检查上传参数 |
| HFVSDK_CODE_JsonError | 响应不数据不是json | 反馈官方技术支持 |
| HFVSDK_CODE_NoNetwork | 无网络连接 | 检查网络 |
| HFVSDK_CODE_RequestTimeOut | 请求超时 | 稍后重试 |

