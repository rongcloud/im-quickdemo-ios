# RongCloud IM iOS Quick Demo

这是一个用于体验、调试和验证 RongCloud IM iOS SDK 的示例工程。工程提供 SDK 初始化与连接、IMKit 会话、自定义消息、推送配置和独立设置等示例。

## 环境要求

- Xcode 16 或更高版本
- iOS 15.6 或更高版本
- CocoaPods 1.16 或更高版本

安装依赖并打开工程：

```bash
pod install
open im-quickdemo-ios.xcworkspace
```

请使用 `.xcworkspace`，不要直接打开 `.xcodeproj`。

## 登录参数

| 参数 | 是否必填 | 说明 |
|---|---:|---|
| `appKey` | 是 | 从融云开发者平台创建应用后获取 |
| `token` | 是 | 从 App Server 获取的用户身份令牌 |
| `naviServer` | 否 | 私有云导航服务器地址 |
| `fileServer` | 否 | 私有云文件服务器地址 |

App Key 会保存到 `UserDefaults`，Token 仅保存在当前进程内。Demo 不包含默认 App Key 或 Token，也不会把 Token 明文持久化。

## 目录结构

```text
im-quickdemo-ios/
├── App/                         App 生命周期、登录、初始化和全局配置
│   ├── Authentication/          SDK 初始化与连接
│   └── Configuration/           服务器和会话类型配置
├── Conversation/                Tab 1：IMKit 会话能力
│   ├── Chat/                    会话页面
│   ├── CustomMessage/           自定义消息与 Cell
│   └── NewConversation/         新建会话及其弹出组件
├── IMLibCore/                   Tab 2：IMLibCore 功能页面
├── Settings/                    Tab 3：推送、免打扰等独立设置功能
├── Core/
│   ├── Configuration/           Demo 配置和本地持久化
│   └── IM/                      IM 数据源、消息标识常量
├── UI/Components/               跨 Tab 复用的通用 UI
├── Assets.xcassets/
├── Info.plist
└── main.m
```

目录使用真实文件夹，并与 Xcode 工程分组保持一致。

三个 Tab 与目录一一对应：

| Tab | 根控制器 | 目录 | SDK 层级 |
|---|---|---|---|
| 会话 | `RCDemoConversationListViewController` | `Conversation/` | IMKit |
| IMLibCore | `RCDemoIMLibCoreViewController` | `IMLibCore/` | IMLibCore |
| 设置 | `RCDemoSettingsViewController` | `Settings/` | 独立设置接口 |

## SDK API 索引

| 验证目标 | 关键 API | 示例文件 |
|---|---|---|
| 初始化 SDK | `initWithAppKey:option:` | `App/Authentication/RCDemoLoginViewController.m` |
| 连接 IM | `connectWithToken:dbOpened:success:error:` | `App/Authentication/RCDemoLoginViewController.m` |
| 注册自定义消息 | `registerMessageType:` | `App/Authentication/RCDemoLoginViewController.m` |
| 设置用户、群组数据源 | `userInfoDataSource`、`groupInfoDataSource` | 实现：`Core/IM/RCDemoIMDataSource.m`；绑定：`App/Authentication/RCDemoLoginViewController.m` |
| 配置会话列表类型 | `initWithDisplayConversationTypes:collectionConversationType:` | `App/RCDemoTabBarController.m` |
| 获取未读数 | `getUnreadCount:containBlocked:completion:` | `App/AppDelegate.m`、`App/RCDemoTabBarController.m` |
| 新建单聊、群聊 | `RCConversationType`、`targetId` | `Conversation/NewConversation/RCDemoNewConversationViewController.m` |
| 打开已有会话（含系统会话） | `initWithConversationType:targetId:` | `Conversation/RCDemoConversationListViewController.m` |
| 发送自定义消息 | `sendMessage:pushContent:pushData:successBlock:errorBlock:` | `Conversation/Chat/RCDemoConversationViewController.m` |
| 发送自定义媒体消息 | `sendMediaMessage:targetId:content:pushContent:pushData:progress:success:error:cancel:` | `Conversation/Chat/RCDemoConversationViewController.m` |
| 自定义消息编解码 | `encode`、`decodeWithData:`、`getObjectName` | `Conversation/CustomMessage/` |
| 推送语言 | `setPushLanguageCode:success:error:` | `Settings/RCDemoSettingsViewController.m` |
| 全局免打扰 | `setNotificationQuietHoursLevel:spanMins:level:success:error:` | `Settings/RCDemoSettingsViewController.m` |
| 推送内容显示 | `updateShowPushContentStatus:success:error:` | `Settings/RCDemoSettingsViewController.m` |
| APNs Token 上报 | `setDeviceTokenData:` | `App/AppDelegate.m` |
| 私有云服务器配置 | `RCInitOption.naviServer`、`fileServer` | 保存：`App/Configuration/RCDemoServerConfigurationViewController.m`；应用：`App/Authentication/RCDemoLoginViewController.m` |

自定义媒体消息使用 `Assets.xcassets/demo_media_message.imageset` 中的测试图片。发送时，Demo 将图片写入临时目录，并把本地文件路径传给媒体消息上传接口。

## 主要依赖

| 依赖 | 版本 | 用途 |
|---|---:|---|
| `RongCloudIM` | 5.42.0 | IMKit、IMLib、IMLibCore 及扩展能力 |
| `IQKeyboardManager` | 6.5.11 | 键盘管理 |
| `SVProgressHUD` | 2.2.5 | 操作结果提示 |
| `SDWebImage` | 5.11.1 | 网络图片加载 |
| `Masonry` | 1.1.0 | 现有局部页面布局 |

## 运行说明

- Debug 构建默认开启 RongCloud verbose 日志，入口在 `RCDemoLoginViewController.m`。
- 登录失败会在页面恢复登录按钮，并展示 `RCConnectErrorCode`。
- 自定义消息发送结果、媒体上传进度和错误码会显示在页面中，并同步输出到 Xcode 控制台。
