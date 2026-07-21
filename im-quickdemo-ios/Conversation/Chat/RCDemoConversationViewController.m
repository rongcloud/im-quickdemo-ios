//
//  RCDemoConversationViewController.m
//  im-quickdemo-ios
//
//  Created by pengwenxin on 2022/7/27.
//

#import "RCDemoConversationViewController.h"
#import "RCDemoCustomMessage.h"
#import "RCDemoCustomMessageCell.h"
#import "RCDemoCustomMediaMessage.h"
#import "RCDemoCustomMediaMessageCell.h"
#import "RCDemoMessageConstants.h"
#import "RCDemoNotifications.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <SVProgressHUD/SVProgressHUD.h>

static NSInteger const RCDemoCustomMessagePluginTag = 20080;
static NSInteger const RCDemoCustomMediaMessagePluginTag = 20090;
static NSString * const RCDemoMediaMessageImageName = @"demo_media_message";
static NSString * const RCDemoMediaMessageFileName = @"RCDemoMediaMessageTest.png";

@interface RCDemoConversationViewController ()<RCMessageExpansionDelegate>

@end

@implementation RCDemoConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.chatSessionInputBarControl.pluginBoardView insertItem:[UIImage imageNamed:@"customMessage"]
                                                highlightedImage:[UIImage imageNamed:@"customMessage"]
                                                           title:@"自定义消息"
                                                             tag:RCDemoCustomMessagePluginTag];
    [self.chatSessionInputBarControl.pluginBoardView insertItem:[UIImage imageNamed:@"customMediaMessage"]
                                                highlightedImage:[UIImage imageNamed:@"customMediaMessage"]
                                                           title:@"自定义媒体消息"
                                                             tag:RCDemoCustomMediaMessagePluginTag];
    [RCCoreClient sharedCoreClient].messageExpansionDelegate = self;
}

/// IMKit 创建会话页面时调用此入口，将自定义消息内容映射到对应的展示 Cell。
- (void)registerCustomCellsAndMessages {
    [super registerCustomCellsAndMessages];
    [self registerClass:[RCDemoCustomMessageCell class] forMessageClass:[RCDemoCustomMessage class]];
    [self registerClass:[RCDemoCustomMediaMessageCell class] forMessageClass:[RCDemoCustomMediaMessage class]];
}

#pragma mark - Plugin Board

- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag {
    if (tag == RCDemoCustomMessagePluginTag) {
        [self sendDemoCustomMessage];
    } else if (tag == RCDemoCustomMediaMessagePluginTag) {
        [self sendDemoCustomMediaMessage];
    } else {
        [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
    }
}

- (void)sendDemoCustomMessage {
    RCDemoCustomMessage *message = [RCDemoCustomMessage messageWithContent:@"自定义消息\n点击自定义消息更新消息扩展"];
    RCMessage *sdkMessage = [[RCMessage alloc] initWithType:self.conversationType
                                                   targetId:self.targetId
                                                  direction:MessageDirection_SEND
                                                    content:message];
    sdkMessage.canIncludeExpansion = YES;
    sdkMessage.expansionDic = @{@"count" : @"0"};

    // successBlock 和 errorBlock 会返回 SDK 最终写入的消息对象，便于核对 messageId、messageUId 和错误码。
    [[RCIM sharedRCIM] sendMessage:sdkMessage
                      pushContent:@"自定义消息"
                          pushData:nil
                      successBlock:^(RCMessage *successMessage) {
        NSString *result = [NSString stringWithFormat:@"自定义消息发送成功\nmessageId: %ld\nmessageUId: %@",
                            (long)successMessage.messageId,
                            successMessage.messageUId ?: @"<empty>"];
        [self showSDKResult:result success:YES];
    } errorBlock:^(RCErrorCode errorCode, RCMessage *errorMessage) {
        NSString *result = [NSString stringWithFormat:@"自定义消息发送失败\nerrorCode: %ld\nmessageId: %ld",
                            (long)errorCode,
                            (long)errorMessage.messageId];
        [self showSDKResult:result success:NO];
    }];
}

- (void)sendDemoCustomMediaMessage {
    NSError *fileError = nil;
    NSString *filePath = [self prepareDemoMediaFile:&fileError];
    if (filePath.length == 0) {
        NSString *result = [NSString stringWithFormat:@"测试图片准备失败：%@",
                            fileError.localizedDescription ?: @"资源不存在"];
        [self showSDKResult:result success:NO];
        return;
    }

    RCDemoCustomMediaMessage *message = [RCDemoCustomMediaMessage messageWithLocalPath:filePath];

    // 媒体消息必须提供可读取的本地文件路径。progress、success、error、cancel 分别展示上传进度和最终结果。
    [[RCIM sharedRCIM] sendMediaMessage:self.conversationType
                              targetId:self.targetId
                               content:message
                           pushContent:@"自定义媒体消息"
                               pushData:nil
                               progress:^(int progress, long messageId) {
        NSString *status = [NSString stringWithFormat:@"媒体消息上传中：%d%%\nmessageId: %ld", progress, messageId];
        NSLog(@"[RCDemo] %@", status);
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showProgress:progress / 100.0 status:status];
        });
    } success:^(long messageId) {
        NSString *result = [NSString stringWithFormat:@"自定义媒体消息发送成功\nmessageId: %ld", messageId];
        [self showSDKResult:result success:YES];
    } error:^(RCErrorCode errorCode, long messageId) {
        NSString *result = [NSString stringWithFormat:@"自定义媒体消息发送失败\nerrorCode: %ld\nmessageId: %ld",
                            (long)errorCode,
                            messageId];
        [self showSDKResult:result success:NO];
    } cancel:^(long messageId) {
        NSString *result = [NSString stringWithFormat:@"自定义媒体消息已取消\nmessageId: %ld", messageId];
        [self showSDKResult:result success:NO];
    }];
}

/// Asset Catalog 资源没有直接文件路径，因此发送前将测试图片写入临时目录供媒体上传接口读取。
- (nullable NSString *)prepareDemoMediaFile:(NSError **)error {
    UIImage *image = [UIImage imageNamed:RCDemoMediaMessageImageName];
    NSData *imageData = image ? UIImagePNGRepresentation(image) : nil;
    if (imageData.length == 0) {
        if (error) {
            *error = [NSError errorWithDomain:@"com.rongcloud.im-quickdemo.media"
                                         code:1
                                     userInfo:@{NSLocalizedDescriptionKey : @"Assets.xcassets 中缺少 demo_media_message"}];
        }
        return nil;
    }

    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:RCDemoMediaMessageFileName];
    if (![imageData writeToFile:filePath options:NSDataWritingAtomic error:error]) {
        return nil;
    }
    return filePath;
}

- (void)showSDKResult:(NSString *)result success:(BOOL)success {
    NSLog(@"[RCDemo] %@", result);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (success) {
            [SVProgressHUD showSuccessWithStatus:result];
        } else {
            [SVProgressHUD showErrorWithStatus:result];
        }
    });
}

#pragma mark - Message Expansion

- (void)didTapMessageCell:(RCMessageModel *)model {
    if ([model.objectName isEqualToString:RCDemoCustomMessageTypeIdentifier]) {
        NSDictionary *dict = model.expansionDic;
        NSInteger value = 0;
        if ([dict.allKeys containsObject:@"count"]) {
            NSString *v = dict[@"count"];
            value = v.integerValue;
        }
        NSDictionary *updatedExpansion = @{@"count":[NSString stringWithFormat:@"%ld", value + 1]};
        [[RCCoreClient sharedCoreClient] updateMessageExpansion:updatedExpansion messageUId:model.messageUId success:^{
            model.expansionDic = updatedExpansion;
            [self showSDKResult:[NSString stringWithFormat:@"消息扩展更新成功\ncount: %ld", value + 1] success:YES];
            NSUInteger row = [self.conversationDataRepository indexOfObject:model];
            if (row == NSNotFound) {
                return;
            }
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:row inSection:0];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.conversationMessageCollectionView reloadItemsAtIndexPaths:@[indexPath]];
            });
        } error:^(RCErrorCode status) {
            NSString *result = [NSString stringWithFormat:@"消息扩展更新失败\nerrorCode: %ld", (long)status];
            [self showSDKResult:result success:NO];
        }];
    }
}

/// 其他端更新消息扩展后刷新对应消息 Cell；该回调可能不在主线程。
- (void)messageExpansionDidUpdate:(NSDictionary<NSString *,NSString *> *)expansionDic message:(RCMessage *)message {
    for (int i = 0; i < self.conversationDataRepository.count; i++) {
        RCMessageModel *model = self.conversationDataRepository[i];
        if ([model.messageUId isEqualToString:message.messageUId]) {
            model.expansionDic = expansionDic;
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.conversationMessageCollectionView reloadItemsAtIndexPaths:@[indexPath]];
            });
            break;
        }
    }
}

- (void)messageExpansionDidRemove:(NSArray<NSString *> *)keyArray
                          message:(RCMessage *)message {
    NSLog(@"[RCDemo] 消息扩展已删除，messageUId: %@, keys: %@", message.messageUId, keyArray);
}

#pragma mark - Keyboard Manager

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

- (void)notifyUpdateUnreadMessageCount {
    [[NSNotificationCenter defaultCenter] postNotificationName:RCDemoUnreadCountDidChangeNotification object:nil];
}

@end
