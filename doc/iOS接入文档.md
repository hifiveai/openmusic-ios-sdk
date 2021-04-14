

# iOS SDK 接入指南

**修订记录** 

|    日期    | 版本 | 说明       |  作者  |
| :--------: | :--: | ---------- | :----: |
| 2021-04-13 | 4.1.1  | 初版 | 郭亮 |



[TOC]
## 一、SDK集成

### 系统支持

iOS9.0以上

### 运行环境

建议使用Xcode10.0以上版本进行编译。

### 集成SDK

目前仅提供静态库接入方案，手动集成：
- 下载解压并拖拽HFOpenApi.framework文件到Xcode工程内(请勾选`Copy items if needed`选项)

- 在 Xcode 中，选择：项目 `TARGETS` -> `General` -> `Frameworks`,`Libraries,and Embedded Content` 中，确保 HFOpenApi.framework，Embed 设置为 `Do Not Embed`。

- 用pod导入依赖的第三方库，创建或修改Podfile文件，添加  
  pod 'MJExtension'  
  pod 'Masonry'  
  pod 'YYWebImage' 
  pod 'MJRefresh'  
  pod 'FLAnimatedImage'  
  执行pod install  

- 在TARGETS->Build Settings->Other Linker Flags中添加-ObjC。

- 在TARGETS->Build Settings->Architctures->Excluded Architctures,添加Any iOS Simulator SDK，设置为arm64。

## 二、接口说明

<font color='#FF0000'>SDK有五种场景接入方式，开发者可以选其中一种方式接入。</font>

### 接入方式一（带播放器UI和音乐列表UI）
如下图例子：
![Alt text](https://k3-images-test.oss-cn-beijing.aliyuncs.com/M2.png)
[接口文档](./sub/播放器和音乐列表接入文档.html?target="_blank")

### 接入方式二（只有播放器UI）
如下图例子：
![Alt text](https://k3-images-test.oss-cn-beijing.aliyuncs.com/M3.png)
[接口文档](./sub/播放器UI接入文档.html)

### 接入方式三（只有音乐列表UI）
如下图例子：
![Alt text](https://k3-images-test.oss-cn-beijing.aliyuncs.com/M4.png)
[接口文档](./sub/音乐列表UI接入文档.html)

### 接入方式四（只有全api接口，无UI）
[接口文档](./sub/通用api接入文档.html)

### 接入方式五（只有播放器api接口，无UI）
[接口文档](./sub/播放器api接入文档.html)

## 三、API状态码

SDK错误码

| 错误码 | 错误描述 | 解决方案 |
|----------|:--------|:-------- |
| HFVSDK_CODE_NoRegister | 未初始化SDK | 初始化 |
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
