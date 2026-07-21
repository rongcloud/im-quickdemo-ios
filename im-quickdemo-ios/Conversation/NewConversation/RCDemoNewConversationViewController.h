//
//  RCDemoNewConversationViewController.h
//  im-quickdemo-ios
//
//  Created by pengwenxin on 2022/7/27.
//

#import <UIKit/UIKit.h>
#import <RongIMLibCore/RongIMLibCore.h>

NS_ASSUME_NONNULL_BEGIN

/// 新建会话参数输入页。
/// 仅收集单聊或群聊类型及 targetId，不直接调用发送接口；确认后由会话列表创建 IMKit 聊天页面。
@interface RCDemoNewConversationViewController : UIViewController

/// 参数校验通过后回传会话类型和目标 ID。
@property (nonatomic, copy) void (^conversationHandler)(RCConversationType conversationType, NSString *targetId);

@end

NS_ASSUME_NONNULL_END
