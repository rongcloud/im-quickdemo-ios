//
//  RCDemoCustomMediaMessage.h
//  im-quickdemo-ios
//
//  Created by 于艳平 on 2022/7/31.
//

#import <RongIMLibCore/RongIMLibCore.h>

NS_ASSUME_NONNULL_BEGIN

/// 图片型自定义媒体消息示例。
/// 本地文件由 SDK 上传，消息体中携带缩略图和上传完成后的远端地址。
@interface RCDemoCustomMediaMessage : RCMediaMessageContent <NSCoding>

/// 用于会话 Cell 展示的缩略图。
@property (nonatomic, strong) UIImage *thumbnailImage;

/// 使用可读取的本地文件路径创建媒体消息；调用前需注册消息类型并保证文件仍然存在。
+ (instancetype)messageWithLocalPath:(NSString *)localPath;

@end

NS_ASSUME_NONNULL_END
