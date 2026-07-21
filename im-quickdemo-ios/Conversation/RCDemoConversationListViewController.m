//
//  RCDemoConversationListViewController.m
//  im-quickdemo-ios
//
//  Created by 于艳平 on 2022/7/11.
//

#import "RCDemoConversationListViewController.h"
#import "RCDemoPopoverView.h"
#import "RCDemoNewConversationViewController.h"
#import "RCDemoConversationViewController.h"
#import "RCDemoNotifications.h"

@interface RCDemoConversationListViewController ()

@property (nonatomic, strong) UIButton *menuButton;
@end

@implementation RCDemoConversationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"会话列表";
    [self setNavigationItem];
}

- (void)setNavigationItem{
    
    RCButton *menuButton = [RCButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(0, 0, 44, 44);
    [menuButton setImage:[UIImage imageNamed:@"chat_add"] forState:UIControlStateNormal];
    self.menuButton = menuButton;
    [menuButton addTarget:self action:@selector(didClickAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.menuButton];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)didClickAction{
    RCDemoPopoverView *popoverView = [RCDemoPopoverView popoverView];
    popoverView.showShade = YES;
    [popoverView showToView:self.menuButton withActions:[self menuAction]];
}

#pragma mark - Getter && Setter
- (NSArray<RCDemoPopoverAction *> *)menuAction {
    __weak typeof(self) weakSelf = self;
    RCDemoPopoverAction *chatAction = [RCDemoPopoverAction actionWithImage:[UIImage imageNamed:@"chat_message"] title:@"发起聊天" handler:^(RCDemoPopoverAction *action) {
        
        RCDemoNewConversationViewController *newConversationViewController = [[RCDemoNewConversationViewController alloc] init];

        [newConversationViewController setConversationHandler:^(RCConversationType conversationType, NSString *targetId) {
            RCDemoConversationViewController * chatVC = [[RCDemoConversationViewController alloc] init];
            chatVC.conversationType = conversationType;
            chatVC.targetId = targetId;
            chatVC.hidesBottomBarWhenPushed = YES;
            chatVC.enableNewComingMessageIcon = YES;
            chatVC.enableUnreadMessageIcon = YES;
            if (conversationType == ConversationType_GROUP) {
                RCGroup * groupInfo = [[RCIM sharedRCIM] getGroupInfoCache:targetId];
                chatVC.title = groupInfo.groupName;
            } else if (conversationType == ConversationType_PRIVATE) {
                chatVC.displayUserNameInCell = NO;
                chatVC.defaultMessageCount = 20;
                RCUserInfo * userInfo = [[RCIM sharedRCIM] getUserInfoCache:targetId];
                chatVC.title = userInfo.name;
            }
            [weakSelf.navigationController pushViewController:chatVC animated:YES];
        }];
        newConversationViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        newConversationViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [weakSelf presentViewController:newConversationViewController animated:YES completion:nil];
        
    }];
    return @[chatAction];
}

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath {
    RCDemoConversationViewController *vc = [[RCDemoConversationViewController alloc] initWithConversationType:model.conversationType targetId:model.targetId];
    vc.title = model.conversationTitle;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


/// IMKit 收到消息后刷新列表，并通知 TabBar 重新读取未读角标。
- (void)didReceiveMessageNotification:(NSNotification *)notification {
    [super didReceiveMessageNotification:notification];
    [super refreshConversationTableViewIfNeeded];
    [[NSNotificationCenter defaultCenter] postNotificationName:RCDemoUnreadCountDidChangeNotification object:nil];
}

/// IMKit 在收到消息或删除会话后调用；通知仅用于触发 TabBar 重新读取未读数，不直接更新 UI。
- (void)notifyUpdateUnreadMessageCount {
    [[NSNotificationCenter defaultCenter] postNotificationName:RCDemoUnreadCountDidChangeNotification object:nil];
}
@end
