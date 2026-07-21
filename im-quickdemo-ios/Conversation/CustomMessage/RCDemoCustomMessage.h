//
//  RCDemoCustomMessage.h
//  im-quickdemo-ios
//
//  Created by 于艳平 on 2022/7/30.
//

#import <RongIMLibCore/RongIMLibCore.h>

NS_ASSUME_NONNULL_BEGIN

/// 最小文本自定义消息示例，演示 objectName、持久化策略以及 JSON 编解码。
@interface RCDemoCustomMessage : RCMessageContent <NSCoding>

/// 随消息发送的示例文本内容。
@property (nonatomic, strong) NSString *content;

/// 创建自定义消息内容。调用发送接口前需先在登录页通过 `registerMessageType:` 注册该类型。
+ (instancetype)messageWithContent:(NSString *)content;
@end

NS_ASSUME_NONNULL_END
