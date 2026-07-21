#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 设置页退出登录后发布，AppDelegate 订阅并切回登录页。
FOUNDATION_EXPORT NSNotificationName const RCDemoDidLogoutNotification;

/// 会话页或会话列表未读数变化时发布，TabBar 控制器订阅并刷新角标。
FOUNDATION_EXPORT NSNotificationName const RCDemoUnreadCountDidChangeNotification;

NS_ASSUME_NONNULL_END
