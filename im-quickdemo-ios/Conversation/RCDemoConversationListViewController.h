//
//  RCDemoConversationListViewController.h
//  im-quickdemo-ios
//
//  Created by 于艳平 on 2022/7/11.
//

#import <RongIMKit/RongIMKit.h>
NS_ASSUME_NONNULL_BEGIN

/// Tab 1 的 IMKit 会话列表根页面。
/// 展示已配置的会话类型，点击已有会话进入聊天页；右上角入口可按 conversationType 和 targetId 新建单聊或群聊。
@interface RCDemoConversationListViewController : RCConversationListViewController

@end

NS_ASSUME_NONNULL_END
