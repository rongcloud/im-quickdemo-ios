//
//  AppDelegate.m
//  im-quickdemo-ios
//
//  Created by pengwenxin on 2022/8/29.
//

#import "AppDelegate.h"
#import "RCDemoLoginViewController.h"
#import "RCDemoNotifications.h"
#import <RongIMKit/RongIMKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    application.applicationIconBadgeNumber = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshRootController:)
                                                 name:RCDemoDidLogoutNotification
                                               object:nil];
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.backgroundColor = UIColor.systemBackgroundColor;
    self.window.rootViewController = [self loginNavigationController];
    [self.window makeKeyAndVisible];
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    [self configureIMWithApplication:application launchOptions:launchOptions];
    return YES;
}

- (UINavigationController *)loginNavigationController {
    RCDemoLoginViewController *loginViewController = [[RCDemoLoginViewController alloc] init];
    return [[UINavigationController alloc] initWithRootViewController:loginViewController];
}

- (void)refreshRootController:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.window.rootViewController = [self loginNavigationController];
        [self.window makeKeyAndVisible];
    });
}

- (void)configureIMWithApplication:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveMessageNotification:)
                                                 name:RCKitDispatchMessageNotification
                                               object:nil];
    
    [self registerRemoteNotification:application];
    [self recordLaunchOptions:launchOptions];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    if ([RCCoreClient sharedCoreClient].sdkRunningMode == RCSDKRunningMode_Background ) {
        [self refreshApplicationBadge];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;
}


- (void)didReceiveMessageNotification:(NSNotification *)notification {
    
    NSNumber *left = [notification.userInfo objectForKey:@"left"];
    if ([RCCoreClient sharedCoreClient].sdkRunningMode == RCSDKRunningMode_Background && 0 == left.integerValue) {
        [self refreshApplicationBadge];
    }
}

- (void)refreshApplicationBadge {
    NSArray<NSNumber *> *conversationTypes = @[@(ConversationType_PRIVATE), @(ConversationType_GROUP)];
    [[RCCoreClient sharedCoreClient] getUnreadCount:conversationTypes containBlocked:YES completion:^(int count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].applicationIconBadgeNumber = count;
        });
    }];
}


#pragma mark - private method
- (void)registerRemoteNotification:(UIApplication *)application {
    UNAuthorizationOptions options = UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound;
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError *error) {
        if (error) {
            NSLog(@"请求推送权限失败：%@", error);
            return;
        }
        if (granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [application registerForRemoteNotifications];
            });
        }
    }];
}

- (void)recordLaunchOptions:(NSDictionary *)launchOptions {
    // 冷启动由融云推送触发时，可在此读取 SDK 解析后的推送扩展数据。
    NSDictionary *pushServiceData = [[RCCoreClient sharedCoreClient] getPushExtraFromLaunchOptions:launchOptions];
    if (pushServiceData) {
        NSLog(@"该启动事件包含来自融云的推送服务");
        for (id key in [pushServiceData allKeys]) {
            NSLog(@"%@", pushServiceData[key]);
        }
    } else {
        NSLog(@"该启动事件不包含来自融云的推送服务");
    }
    // 同时保留 APNs 原始 userInfo，方便与 SDK 解析结果对照调试。
    NSDictionary *remoteNotificationUserInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotificationUserInfo) {
        NSLog(@"远程推送原始内容为 %@", remoteNotificationUserInfo);
    }
}
- (void)application:(UIApplication *)application
    didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    [[RCCoreClient sharedCoreClient] setDeviceTokenData:deviceToken];
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"注册远程推送失败：%@", error);
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    [[RCCoreClient sharedCoreClient] recordRemoteNotificationEvent:userInfo];
    NSDictionary *pushServiceData = [[RCCoreClient sharedCoreClient] getPushExtraFromRemoteNotification:userInfo];
    if (pushServiceData) {
        NSLog(@"融云推送扩展：%@", pushServiceData);
    }
    completionHandler(UIBackgroundFetchResultNoData);
}

#pragma mark - UNUserNotificationCenterDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    completionHandler(UNNotificationPresentationOptionBanner | UNNotificationPresentationOptionList |
                      UNNotificationPresentationOptionSound | UNNotificationPresentationOptionBadge);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)(void))completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    [[RCCoreClient sharedCoreClient] recordLocalNotificationResponseEvent:userInfo];
    [[RCCoreClient sharedCoreClient] recordRemoteNotificationEvent:userInfo];
    completionHandler();
}

@end
