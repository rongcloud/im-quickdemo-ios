//
//  RCDemoTabBarController.m
//  im-quickdemo-ios
//
//  Created by 于艳平 on 2022/7/11.
//

#import "RCDemoTabBarController.h"
#import "RCDemoConversationListViewController.h"
#import "RCDemoSettingsViewController.h"
#import "RCDemoIMLibCoreViewController.h"
#import "RCDemoNotifications.h"
#import "RCDemoConfiguration.h"
#import <RongIMKit/RongIMKit.h>

@interface RCDemoTabBarController ()

@end

@implementation RCDemoTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureDefaultConversationTypes];
    [self configureViewControllers];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateConversationBadge)
                                                 name:RCDemoUnreadCountDidChangeNotification
                                               object:nil];
}

- (void)configureDefaultConversationTypes {
    RCDemoConfiguration *configuration = [RCDemoConfiguration shared];
    if (configuration.displayConversationTypeArray.count == 0) {
        configuration.displayConversationTypeArray = @[
            @(ConversationType_PRIVATE),
            @(ConversationType_GROUP),
            @(ConversationType_SYSTEM)
        ];
    }
    if (configuration.collectionConversationTypeArray.count == 0) {
        configuration.collectionConversationTypeArray = @[@(ConversationType_SYSTEM)];
    }
}

- (void)configureViewControllers {
    RCDemoConfiguration *configuration = [RCDemoConfiguration shared];
    RCDemoConversationListViewController *conversationListViewController =
        [[RCDemoConversationListViewController alloc] initWithDisplayConversationTypes:configuration.displayConversationTypeArray
                                                             collectionConversationType:configuration.collectionConversationTypeArray];
    UINavigationController *conversationNavigationController =
        [[UINavigationController alloc] initWithRootViewController:conversationListViewController];
    conversationNavigationController.tabBarItem = [self tabBarItemWithTitle:@"会话"
                                                                  imageName:@"tabbar_chat"
                                                          selectedImageName:@"tabbar_chat_selected"];

    RCDemoIMLibCoreViewController *imLibCoreViewController = [[RCDemoIMLibCoreViewController alloc] init];
    UINavigationController *imLibCoreNavigationController =
        [[UINavigationController alloc] initWithRootViewController:imLibCoreViewController];
    imLibCoreNavigationController.tabBarItem = [self tabBarItemWithTitle:@"IMLibCore"
                                                               imageName:@"tabbar_imlibcore"
                                                       selectedImageName:@"tabbar_imlibcore_selected"];

    RCDemoSettingsViewController *settingsViewController = [[RCDemoSettingsViewController alloc] init];
    UINavigationController *settingsNavigationController =
        [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    settingsNavigationController.tabBarItem = [self tabBarItemWithTitle:@"设置"
                                                              imageName:@"tabbar_settings"
                                                      selectedImageName:@"tabbar_settings_selected"];

    self.viewControllers = @[
        conversationNavigationController,
        imLibCoreNavigationController,
        settingsNavigationController
    ];
}

- (UITabBarItem *)tabBarItemWithTitle:(NSString *)title
                            imageName:(NSString *)imageName
                    selectedImageName:(NSString *)selectedImageName {
    UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return [[UITabBarItem alloc] initWithTitle:title image:image selectedImage:selectedImage];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)updateConversationBadge {
    NSArray<NSNumber *> *conversationTypes = [RCDemoConfiguration shared].displayConversationTypeArray;
    [[RCCoreClient sharedCoreClient] getUnreadCount:conversationTypes containBlocked:YES completion:^(int count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UITabBarItem *conversationTabBarItem = self.tabBar.items.firstObject;
            conversationTabBarItem.badgeValue = count > 0 ? (count < 100 ? @(count).stringValue : @"99+") : nil;
        });
    }];
}
@end
