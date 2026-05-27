# 工程简介：im-quickdemo-ios

## 1. Demo 类型

这是一个基于 **融云（RongCloud）即时通讯 SDK** 的 **iOS IM 快速体验 Demo**，用于演示融云 IM SDK 的核心能力。属于融云官方提供的开源示例工程。

## 2. 核心依赖（Podfile）

| 依赖库 | 版本 | 用途 |
|---|---|---|
| `RongCloudOpenSource/IMKit` | 5.38.0 | 融云 IM 核心 UI 套件 |
| `RongCloudOpenSource/Sight` | 5.38.0 | 短视频/小视频功能 |
| `RongCloudOpenSource/LocationKit` | 5.38.0 | 位置消息功能 |
| `IQKeyboardManager` | 6.5.11 | 键盘管理 |
| `SVProgressHUD` | - | 加载/提示弹窗 |
| `SDWebImage` | 5.11.1 | 图片加载 |
| `AFNetworking` | - | 网络请求 |
| `Masonry` | 1.1.0 | 自动布局 |

## 3. 登录需要输入的参数

**必须参数（登录页）：**

| 参数 | 类型 | 说明 |
|---|---|---|
| `appKey` | `NSString` | 融云开发者平台创建应用后获取的 App Key |
| `token` | `NSString` | 从你自己的服务器端获取的用户身份令牌（Token） |

**可选配置（配置页）：**

| 参数 | 类型 | 说明 |
|---|---|---|
| `naviServer` | `NSString` | 自定义导航服务器地址（私有化部署时使用） |
| `fileServer` | `NSString` | 自定义文件服务器地址（私有化部署时使用） |
| `displayConversationTypeArray` | `NSArray` | 会话列表中显示的会话类型（单聊/群聊/系统） |
| `collectionConversationTypeArray` | `NSArray` | 聚合会话列表中显示的会话类型 |

## 4. 主要功能模块

| 模块 | 说明 |
|---|---|
| **登录** | 输入 appKey + token，初始化并连接融云 IM |
| **会话列表** | 展示单聊、群聊、系统会话列表 |
| **聊天界面** | 文本/图片/语音/位置/视频/自定义消息等收发 |
| **自定义消息** | 演示如何注册和使用自定义消息类型 |
| **聊天室** | 聊天室相关功能演示 |
| **我的** | 显示当前登录用户信息、退出登录 |
| **推送支持** | APNs 远程推送集成示例 |

## 5. 运行前准备

1. **Xcode 清除缓存**：`Shift + Cmd + K`
2. **执行 pod install**：
   ```bash
   pod install
   ```
3. **使用 `.xcworkspace` 打开工程**，不要用 `.xcodeproj`

## 6. 核心代码入口

- **SDK 初始化**：`LoginVC.m:73` — `[[RCIM sharedRCIM] initWithAppKey:]`
- **连接服务器**：`LoginVC.m:83` — `[[RCIM sharedRCIM] connectWithToken:...]`
- **推送配置**：`AppDelegate.m` — APNs deviceToken 注册与上报
- **全局配置**：`AppGlobalConfig.m` — appKey/token/userId 持久化存储

## 7. 备注

- 运行前需要自行准备 appKey 和 token
- 如需使用，需：
  1. 在 [融云开发者控制台](https://developer.rongcloud.cn/) 注册并创建应用，获取自己的 `appKey`
  2. 在自己的 App Server 上实现 [Token 获取接口](https://doc.rongcloud.cn/imserver/serverapi/user/register.html)
  3. 将获取到的 appKey 和 token 填入登录页
