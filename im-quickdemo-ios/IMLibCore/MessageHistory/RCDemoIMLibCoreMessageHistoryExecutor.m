#import "RCDemoIMLibCoreFeatureExecutor+Internal.h"

@interface RCDemoIMLibCoreFeatureExecutor (MessageHistoryPrivate)
- (void)listenReceiveMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)getLocalHistory:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)getRemoteHistory:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)getFirstUnreadMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)getHistoryByMessageTypes:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)getMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)getMessageCount:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)getUnreadMentionedMessages:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)setReadBeforeTime:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
@end

@implementation RCDemoIMLibCoreFeatureExecutor (MessageHistory)

- (void)executeMessageHistoryFeature:(RCDemoIMLibCoreFeature *)feature
                           parameters:(NSDictionary<NSString *, id> *)parameters
                           completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    switch (feature.action) {
        case RCDemoIMLibCoreFeatureActionListenReceiveMessage: [self listenReceiveMessage:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionGetLocalHistory: [self getLocalHistory:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionGetRemoteHistory: [self getRemoteHistory:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionGetFirstUnreadMessage: [self getFirstUnreadMessage:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionGetHistoryByMessageTypes: [self getHistoryByMessageTypes:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionGetMessage: [self getMessage:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionGetMessageCount: [self getMessageCount:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionGetUnreadMentionedMessages: [self getUnreadMentionedMessages:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionSetReadBeforeTime: [self setReadBeforeTime:parameters completion:completion]; break;
        default: completion(@"未知消息接收与历史功能。", NO); break;
    }
}

/// 消息接收监听
/// 公开头文件：RCCoreClient.h、RCIMClientProtocol.h
/// SDK API：-addReceiveMessageDelegate:、-removeReceiveMessageDelegate:
- (void)listenReceiveMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    BOOL enabled = [parameters[@"listenEnabled"] boolValue];
    if (enabled) {
        self.eventCompletion = completion;
        if (!self.receiveMessageListening) {
            [RCCoreClient.sharedCoreClient addReceiveMessageDelegate:self];
            self.receiveMessageListening = YES;
        }
        completion(@"消息接收监听已开启。后续消息会持续显示在本页结果区和控制台。", YES);
        return;
    }
    if (self.receiveMessageListening) {
        [RCCoreClient.sharedCoreClient removeReceiveMessageDelegate:self];
        self.receiveMessageListening = NO;
    }
    self.eventCompletion = nil;
    completion(@"消息接收监听已关闭。", YES);
}

- (void)onReceived:(RCMessage *)message
              left:(int)nLeft
            object:(id)object
           offline:(BOOL)offline
        hasPackage:(BOOL)hasPackage {
    [self emitEvent:[NSString stringWithFormat:@"收到消息\n%@\nleft: %d\noffline: %@\nhasPackage: %@",
                     [self messageResult:message], nLeft, offline ? @"YES" : @"NO", hasPackage ? @"YES" : @"NO"]];
}

- (void)onOfflineMessageSyncCompleted {
    [self emitEvent:@"离线消息同步完成。"];
}

/// 获取本地历史消息
/// 公开头文件：RCCoreClient.h、RCChannelClient.h
/// SDK API：-getHistoryMessages:targetId:objectName:baseMessageId:isForward:count:completion:，频道版增加 channelId
- (void)getLocalHistory:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    NSString *targetId = [self string:parameters key:@"targetId"];
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    long baseMessageId = [parameters[@"baseMessageId"] longLongValue];
    BOOL isForward = [parameters[@"order"] integerValue] == 1;
    int count = MIN(100, MAX(1, [parameters[@"count"] intValue]));
    if ([self conversationType:parameters] == ConversationType_ULTRAGROUP || channelId) {
        [RCChannelClient.sharedChannelManager getHistoryMessages:[self conversationType:parameters]
                                                         targetId:targetId
                                                        channelId:channelId
                                                       objectName:nil
                                                    baseMessageId:baseMessageId
                                                        isForward:isForward
                                                            count:count
                                                       completion:^(NSArray<RCMessage *> *messages) {
            completion([self messageListResult:messages ?: @[]], YES);
        }];
        return;
    }
    [RCCoreClient.sharedCoreClient getHistoryMessages:[self conversationType:parameters]
                                              targetId:targetId
                                            objectName:nil
                                         baseMessageId:baseMessageId
                                             isForward:isForward
                                                 count:count
                                            completion:^(NSArray<RCMessage *> *messages) {
        completion([self messageListResult:messages ?: @[]], YES);
    }];
}

/// 获取远端历史消息
/// 公开头文件：RCCoreClient.h、RCChannelClient.h、RCRemoteHistoryMsgOption.h
/// SDK API：-getRemoteHistoryMessages:targetId:option:success:error:，频道版增加 channelId
- (void)getRemoteHistory:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    RCRemoteHistoryMsgOption *option = [[RCRemoteHistoryMsgOption alloc] init];
    option.recordTime = [parameters[@"timestamp"] longLongValue];
    option.count = MIN(100, MAX(2, [parameters[@"count"] integerValue]));
    option.order = (RCRemoteHistoryOrder)[parameters[@"order"] integerValue];
    option.includeLocalExistMessage = [parameters[@"includeLocalExistMessage"] boolValue];
    NSString *targetId = [self string:parameters key:@"targetId"];
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    if ([self conversationType:parameters] == ConversationType_ULTRAGROUP || channelId) {
        [RCChannelClient.sharedChannelManager getRemoteHistoryMessages:[self conversationType:parameters]
                                                               targetId:targetId
                                                              channelId:channelId
                                                                 option:option
                                                                success:^(NSArray<RCMessage *> *messages, BOOL isRemaining) {
            completion([NSString stringWithFormat:@"isRemaining: %@\n%@", isRemaining ? @"YES" : @"NO", [self messageListResult:messages]], YES);
        } error:^(RCErrorCode status) {
            completion([self errorResult:status], NO);
        }];
        return;
    }
    [RCCoreClient.sharedCoreClient getRemoteHistoryMessages:[self conversationType:parameters]
                                                    targetId:targetId
                                                      option:option
                                                     success:^(NSArray<RCMessage *> *messages, BOOL isRemaining) {
        completion([NSString stringWithFormat:@"isRemaining: %@\n%@", isRemaining ? @"YES" : @"NO", [self messageListResult:messages]], YES);
    } error:^(RCErrorCode status) {
        completion([self errorResult:status], NO);
    }];
}

/// 获取第一条未读消息
/// 公开头文件：RCCoreClient.h、RCChannelClient.h
/// SDK API：-getFirstUnreadMessage:targetId:completion:，频道版增加 channelId
- (void)getFirstUnreadMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    NSString *targetId = [self string:parameters key:@"targetId"];
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    if ([self conversationType:parameters] == ConversationType_ULTRAGROUP || channelId) {
        [RCChannelClient.sharedChannelManager getFirstUnreadMessage:[self conversationType:parameters]
                                                            targetId:targetId
                                                           channelId:channelId
                                                          completion:^(RCMessage *message) {
            completion([self messageResult:message], message != nil);
        }];
        return;
    }
    [RCCoreClient.sharedCoreClient getFirstUnreadMessage:[self conversationType:parameters]
                                                targetId:targetId
                                              completion:^(RCMessage *message) {
        completion([self messageResult:message], message != nil);
    }];
}

/// 获取指定类型的本地历史消息
/// 公开头文件：RCCoreClient.h、RCChannelClient.h
/// SDK API：-getHistoryMessages:targetId:objectNames:sentTime:isForward:count:completion:，频道版增加 channelId
- (void)getHistoryByMessageTypes:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    NSArray<NSString *> *objectNames = [self stringList:parameters[@"objectNameList"]];
    if (objectNames.count == 0) {
        completion(@"objectNameList 不能为空。", NO);
        return;
    }
    NSString *targetId = [self string:parameters key:@"targetId"];
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    long long sentTime = [parameters[@"timestamp"] longLongValue];
    BOOL isForward = [parameters[@"order"] integerValue] == 1;
    int count = MIN(100, MAX(1, [parameters[@"count"] intValue]));
    if ([self conversationType:parameters] == ConversationType_ULTRAGROUP || channelId) {
        [RCChannelClient.sharedChannelManager getHistoryMessages:[self conversationType:parameters]
                                                         targetId:targetId
                                                        channelId:channelId
                                                      objectNames:objectNames
                                                         sentTime:sentTime
                                                        isForward:isForward
                                                            count:count
                                                       completion:^(NSArray<RCMessage *> *messages) {
            completion([self messageListResult:messages ?: @[]], YES);
        }];
        return;
    }
    [RCCoreClient.sharedCoreClient getHistoryMessages:[self conversationType:parameters]
                                              targetId:targetId
                                           objectNames:objectNames
                                              sentTime:sentTime
                                             isForward:isForward
                                                 count:count
                                            completion:^(NSArray<RCMessage *> *messages) {
        completion([self messageListResult:messages ?: @[]], YES);
    }];
}

/// 按 messageUId 获取本地消息
/// 公开头文件：RCCoreClient.h
/// SDK API：-getMessageByUId:completion:
- (void)getMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    [RCCoreClient.sharedCoreClient getMessageByUId:[self string:parameters key:@"messageUId"]
                                        completion:^(RCMessage *message) {
        completion([self messageResult:message], message != nil);
    }];
}

/// 获取会话消息总数
/// 公开头文件：RCCoreClient.h、RCChannelClient.h
/// SDK API：-getMessageCount:targetId:completion:，频道版增加 channelId
- (void)getMessageCount:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    NSString *targetId = [self string:parameters key:@"targetId"];
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    if ([self conversationType:parameters] == ConversationType_ULTRAGROUP || channelId) {
        [RCChannelClient.sharedChannelManager getMessageCount:[self conversationType:parameters]
                                                      targetId:targetId
                                                     channelId:channelId
                                                    completion:^(int num) {
            completion([NSString stringWithFormat:@"messageCount: %d", num], num >= 0);
        }];
        return;
    }
    [RCCoreClient.sharedCoreClient getMessageCount:[self conversationType:parameters]
                                           targetId:targetId
                                         completion:^(int count) {
        completion([NSString stringWithFormat:@"messageCount: %d", count], count >= 0);
    }];
}

/// 获取未读 @ 消息列表
/// 公开头文件：RCCoreClient.h、RCChannelClient.h
/// SDK API：-getUnreadMentionedMessages:targetId:completion:，频道版增加 channelId
- (void)getUnreadMentionedMessages:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    NSString *targetId = [self string:parameters key:@"targetId"];
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    if ([self conversationType:parameters] == ConversationType_ULTRAGROUP || channelId) {
        [RCChannelClient.sharedChannelManager getUnreadMentionedMessages:[self conversationType:parameters]
                                                                 targetId:targetId
                                                                channelId:channelId
                                                               completion:^(NSArray<RCMessage *> *messages) {
            completion([self messageListResult:messages ?: @[]], YES);
        }];
        return;
    }
    [RCCoreClient.sharedCoreClient getUnreadMentionedMessages:[self conversationType:parameters]
                                                      targetId:targetId
                                                    completion:^(NSArray<RCMessage *> *messages) {
        completion([self messageListResult:messages ?: @[]], YES);
    }];
}

/// 设置指定时间前的消息为已读
/// 公开头文件：RCCoreClient.h、RCChannelClient.h
/// SDK API：-clearMessagesUnreadStatus:targetId:time:completion:，频道版增加 channelId
- (void)setReadBeforeTime:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    NSString *targetId = [self string:parameters key:@"targetId"];
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    long long timestamp = [parameters[@"timestamp"] longLongValue];
    if ([self conversationType:parameters] == ConversationType_ULTRAGROUP || channelId) {
        [RCChannelClient.sharedChannelManager clearMessagesUnreadStatus:[self conversationType:parameters]
                                                                targetId:targetId
                                                               channelId:channelId
                                                                    time:timestamp
                                                              completion:^(BOOL result) {
            completion(result ? @"指定时间前的消息已设为已读。" : @"设置已读失败。", result);
        }];
        return;
    }
    [RCCoreClient.sharedCoreClient clearMessagesUnreadStatus:[self conversationType:parameters]
                                                     targetId:targetId
                                                          time:timestamp
                                                    completion:^(BOOL ret) {
        completion(ret ? @"指定时间前的消息已设为已读。" : @"设置已读失败。", ret);
    }];
}

@end

