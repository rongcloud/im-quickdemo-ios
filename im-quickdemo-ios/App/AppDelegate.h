//
//  AppDelegate.h
//  im-quickdemo-ios
//
//  Created by pengwenxin on 2022/8/29.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

/// Demo 应用入口。
/// 负责创建代码化根界面、注册 APNs、记录推送点击事件，并根据 IM 未读数同步应用角标。
@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>

/// 应用主窗口。工程不使用 Storyboard，由 AppDelegate 显式创建并切换根控制器。
@property (strong, nonatomic) UIWindow *window;
@end
