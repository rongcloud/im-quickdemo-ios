#import "RCDemoIMLibCoreFeatureExecutor+Internal.h"

@interface RCDemoIMLibCoreFeatureExecutor (MessageOperationPrivate)
- (void)recallMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)deleteRemoteMessages:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)clearRemoteHistory:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)deleteLocalMessages:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)clearLocalHistoryBeforeTime:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)clearConversationMessages:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)setMessageSentStatus:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)setMessageReceivedStatus:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)batchInsertMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)insertMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)setDuplicateCheck:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
@end

@implementation RCDemoIMLibCoreFeatureExecutor (MessageOperation)

- (void)executeMessageOperationFeature:(RCDemoIMLibCoreFeature *)feature
                             parameters:(NSDictionary<NSString *, id> *)parameters
                             completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    switch (feature.action) {
        case RCDemoIMLibCoreFeatureActionRecallMessage: [self recallMessage:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionDeleteRemoteMessages: [self deleteRemoteMessages:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionClearRemoteHistory: [self clearRemoteHistory:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionDeleteLocalMessages: [self deleteLocalMessages:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionClearLocalHistoryBeforeTime: [self clearLocalHistoryBeforeTime:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionClearConversationMessages: [self clearConversationMessages:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionSetMessageSentStatus: [self setMessageSentStatus:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionSetMessageReceivedStatus: [self setMessageReceivedStatus:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionBatchInsertMessage: [self batchInsertMessage:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionInsertMessage: [self insertMessage:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionSetDuplicateCheck: [self setDuplicateCheck:parameters completion:completion]; break;
        default: completion(@"未知消息操作功能。", NO); break;
    }
}

/// 撤回消息
/// 公开头文件：RCCoreClient.h、RCChannelClient.h
/// SDK API：-getMessage:completion:、-recallMessage:success:error:、-recallUltraGroupMessage:isDelete:success:error:
- (void)recallMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    long messageId = [parameters[@"messageId"] longLongValue];
    [RCCoreClient.sharedCoreClient getMessage:messageId completion:^(RCMessage *message) {
        if (!message) {
            completion(@"没有找到对应的本地 RCMessage，请确认 messageId。", NO);
            return;
        }
        if (message.conversationType == ConversationType_ULTRAGROUP) {
            [RCChannelClient.sharedChannelManager recallUltraGroupMessage:message
                                                                 isDelete:NO
                                                                  success:^(long recalledMessageId) {
                completion([NSString stringWithFormat:@"撤回成功\nmessageId: %ld", recalledMessageId], YES);
            } error:^(RCErrorCode errorCode) {
                completion([self errorResult:errorCode], NO);
            }];
            return;
        }
        [RCCoreClient.sharedCoreClient recallMessage:message success:^(long recalledMessageId) {
            completion([NSString stringWithFormat:@"撤回成功\nmessageId: %ld", recalledMessageId], YES);
        } error:^(RCErrorCode errorCode) {
            completion([self errorResult:errorCode], NO);
        }];
    }];
}

/// 按消息删除远端历史
/// 公开头文件：RCCoreClient.h、RCChannelClient.h
/// SDK API：-getMessageByUId:completion:、-deleteRemoteMessage:targetId:messages:success:error:
- (void)deleteRemoteMessages:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    NSArray<NSString *> *messageUIds = [self stringList:parameters[@"messageUIdList"]];
    [self messagesForUIds:messageUIds completion:^(NSArray<RCMessage *> *messages) {
        if (messages.count != messageUIds.count) {
            completion([NSString stringWithFormat:@"仅找到 %lu/%lu 条本地 RCMessage，请检查 messageUIdList。",
                        (unsigned long)messages.count, (unsigned long)messageUIds.count], NO);
            return;
        }
        NSString *targetId = [self string:parameters key:@"targetId"];
        NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
        if ([self conversationType:parameters] == ConversationType_ULTRAGROUP || channelId) {
            [RCChannelClient.sharedChannelManager deleteRemoteMessage:[self conversationType:parameters]
                                                              targetId:targetId
                                                             channelId:channelId
                                                              messages:messages
                                                               success:^{ completion(@"远端消息删除成功。", YES); }
                                                                 error:^(RCErrorCode status) { completion([self errorResult:status], NO); }];
            return;
        }
        [RCCoreClient.sharedCoreClient deleteRemoteMessage:[self conversationType:parameters]
                                                   targetId:targetId
                                                   messages:messages
                                                    success:^{ completion(@"远端消息删除成功。", YES); }
                                                      error:^(RCErrorCode status) { completion([self errorResult:status], NO); }];
    }];
}

/// 按时间删除远端历史
/// 公开头文件：RCCoreClient.h、RCChannelClient.h
/// SDK API：-clearRemoteHistoryMessages:targetId:recordTime:success:error:，频道版增加 channelId
- (void)clearRemoteHistory:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    NSString *targetId = [self string:parameters key:@"targetId"];
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    long long recordTime = [parameters[@"timestamp"] longLongValue];
    if ([self conversationType:parameters] == ConversationType_ULTRAGROUP || channelId) {
        [RCChannelClient.sharedChannelManager clearRemoteHistoryMessages:[self conversationType:parameters]
                                                                 targetId:targetId
                                                                channelId:channelId
                                                               recordTime:recordTime
                                                                  success:^{ completion(@"远端历史消息清除成功。", YES); }
                                                                    error:^(RCErrorCode status) { completion([self errorResult:status], NO); }];
        return;
    }
    [RCCoreClient.sharedCoreClient clearRemoteHistoryMessages:[self conversationType:parameters]
                                                      targetId:targetId
                                                    recordTime:recordTime
                                                       success:^{ completion(@"远端历史消息清除成功。", YES); }
                                                         error:^(RCErrorCode status) { completion([self errorResult:status], NO); }];
}

/// 删除本地消息
/// 公开头文件：RCCoreClient.h
/// SDK API：-deleteMessages:completion:
- (void)deleteLocalMessages:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    NSArray<NSNumber *> *messageIds = [self numberList:parameters[@"messageIdList"] defaultValues:@[]];
    if (messageIds.count == 0) {
        completion(@"messageIdList 不能为空。", NO);
        return;
    }
    [RCCoreClient.sharedCoreClient deleteMessages:messageIds completion:^(BOOL ret) {
        completion(ret ? @"本地消息删除成功。" : @"本地消息删除失败。", ret);
    }];
}

/// 删除时间戳前的本地消息
/// 公开头文件：RCCoreClient.h、RCChannelClient.h
/// SDK API：-clearHistoryMessages:targetId:recordTime:clearRemote:success:error:，频道版增加 channelId
- (void)clearLocalHistoryBeforeTime:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    NSString *targetId = [self string:parameters key:@"targetId"];
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    long long recordTime = [parameters[@"timestamp"] longLongValue];
    if ([self conversationType:parameters] == ConversationType_ULTRAGROUP || channelId) {
        [RCChannelClient.sharedChannelManager clearHistoryMessages:[self conversationType:parameters]
                                                           targetId:targetId
                                                          channelId:channelId
                                                         recordTime:recordTime
                                                        clearRemote:NO
                                                            success:^{ completion(@"本地历史消息清除成功。", YES); }
                                                              error:^(RCErrorCode status) { completion([self errorResult:status], NO); }];
        return;
    }
    [RCCoreClient.sharedCoreClient clearHistoryMessages:[self conversationType:parameters]
                                                targetId:targetId
                                              recordTime:recordTime
                                             clearRemote:NO
                                                 success:^{ completion(@"本地历史消息清除成功。", YES); }
                                                   error:^(RCErrorCode status) { completion([self errorResult:status], NO); }];
}

/// 清空会话本地历史
/// 公开头文件：RCCoreClient.h、RCChannelClient.h
/// SDK API：-clearMessages:targetId:completion:，频道版增加 channelId
- (void)clearConversationMessages:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    NSString *targetId = [self string:parameters key:@"targetId"];
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    if ([self conversationType:parameters] == ConversationType_ULTRAGROUP || channelId) {
        [RCChannelClient.sharedChannelManager clearMessages:[self conversationType:parameters]
                                                    targetId:targetId
                                                   channelId:channelId
                                                  completion:^(BOOL result) {
            completion(result ? @"会话本地历史清空成功。" : @"会话本地历史清空失败。", result);
        }];
        return;
    }
    [RCCoreClient.sharedCoreClient clearMessages:[self conversationType:parameters]
                                         targetId:targetId
                                       completion:^(BOOL ret) {
        completion(ret ? @"会话本地历史清空成功。" : @"会话本地历史清空失败。", ret);
    }];
}

/// 设置消息发送状态
/// 公开头文件：RCCoreClient.h
/// SDK API：-setMessageSentStatus:sentStatus:completion:
- (void)setMessageSentStatus:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    [RCCoreClient.sharedCoreClient setMessageSentStatus:[parameters[@"messageId"] longLongValue]
                                             sentStatus:(RCSentStatus)[parameters[@"sentStatus"] integerValue]
                                             completion:^(BOOL ret) {
        completion(ret ? @"消息发送状态设置成功。" : @"消息发送状态设置失败。", ret);
    }];
}

/// 设置消息接收状态
/// 公开头文件：RCCoreClient.h
/// SDK API：-setMessageReceivedStatus:receivedStatusInfo:completion:
- (void)setMessageReceivedStatus:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    [RCCoreClient.sharedCoreClient setMessageReceivedStatus:[parameters[@"messageId"] longLongValue]
                                         receivedStatusInfo:[self receivedStatusInfo:parameters]
                                                 completion:^(BOOL ret) {
        completion(ret ? @"消息接收状态设置成功。" : @"消息接收状态设置失败。", ret);
    }];
}

/// 本地批量插入 RCMessage
/// 公开头文件：RCMessage.h、RCCoreClient.h
/// SDK API：-initWithType:targetId:channelId:direction:content:、-batchInsertMessage:checkDuplicate:completion:
- (void)batchInsertMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    if ([self conversationType:parameters] == ConversationType_ULTRAGROUP || [self string:parameters key:@"channelId"].length > 0) {
        completion(@"batchInsertMessage:checkDuplicate:completion: 不支持超级群或频道消息。", NO);
        return;
    }
    RCMessageDirection direction = [[self string:parameters key:@"direction"] caseInsensitiveCompare:@"incoming"] == NSOrderedSame
        ? MessageDirection_RECEIVE : MessageDirection_SEND;
    RCMessage *message = [[RCMessage alloc] initWithType:[self conversationType:parameters]
                                                targetId:[self string:parameters key:@"targetId"]
                                               channelId:[self nilIfEmpty:[self string:parameters key:@"channelId"]]
                                               direction:direction
                                                 content:[RCTextMessage messageWithContent:[self string:parameters key:@"content"]]];
    message.senderUserId = [self string:parameters key:@"userId"];
    message.sentTime = [parameters[@"timestamp"] longLongValue];
    message.messageUId = [self nilIfEmpty:[self string:parameters key:@"messageUId"]];
    if (direction == MessageDirection_RECEIVE) {
        message.receivedStatusInfo = [[RCReceivedStatusInfo alloc] initWithReceivedStatus:0];
    } else {
        message.sentStatus = SentStatus_SENT;
    }
    [RCCoreClient.sharedCoreClient batchInsertMessage:@[message]
                                       checkDuplicate:[parameters[@"checkDuplicate"] boolValue]
                                           completion:^(BOOL ret) {
        completion(ret ? @"RCMessage 插入成功。" : @"RCMessage 插入失败。", ret);
    }];
}

/// 本地插入消息
/// 公开头文件：RCCoreClient.h、RCChannelClient.h
/// SDK API：-insertOutgoingMessage:targetId:sentStatus:content:sentTime:completion: / -insertIncomingMessage:targetId:senderUserId:receivedStatusInfo:content:sentTime:completion:
- (void)insertMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    NSString *targetId = [self string:parameters key:@"targetId"];
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    RCTextMessage *content = [RCTextMessage messageWithContent:[self string:parameters key:@"content"]];
    long long sentTime = [parameters[@"timestamp"] longLongValue];
    BOOL incoming = [[self string:parameters key:@"direction"] caseInsensitiveCompare:@"incoming"] == NSOrderedSame;
    if (([self conversationType:parameters] == ConversationType_ULTRAGROUP || channelId) && incoming) {
        [RCChannelClient.sharedChannelManager insertIncomingMessage:[self conversationType:parameters]
                                                            targetId:targetId
                                                           channelId:channelId
                                                        senderUserId:[self string:parameters key:@"userId"]
                                                  receivedStatusInfo:[[RCReceivedStatusInfo alloc] initWithReceivedStatus:0]
                                                             content:content
                                                            sentTime:sentTime
                                                          completion:^(RCMessage *message) {
            completion([self messageResult:message], message != nil);
        }];
        return;
    }
    if ([self conversationType:parameters] == ConversationType_ULTRAGROUP || channelId) {
        [RCChannelClient.sharedChannelManager insertOutgoingMessage:[self conversationType:parameters]
                                                            targetId:targetId
                                                           channelId:channelId
                                                 canIncludeExpansion:NO
                                                          sentStatus:SentStatus_SENT
                                                             content:content
                                                            sentTime:sentTime
                                                          completion:^(RCMessage *message) {
            completion([self messageResult:message], message != nil);
        }];
        return;
    }
    if (incoming) {
        [RCCoreClient.sharedCoreClient insertIncomingMessage:[self conversationType:parameters]
                                                    targetId:targetId
                                                senderUserId:[self string:parameters key:@"userId"]
                                          receivedStatusInfo:[[RCReceivedStatusInfo alloc] initWithReceivedStatus:0]
                                                     content:content
                                                    sentTime:sentTime
                                                  completion:^(RCMessage *message) {
            completion([self messageResult:message], message != nil);
        }];
        return;
    }
    [RCCoreClient.sharedCoreClient insertOutgoingMessage:[self conversationType:parameters]
                                                targetId:targetId
                                              sentStatus:SentStatus_SENT
                                                 content:content
                                                sentTime:sentTime
                                              completion:^(RCMessage *message) {
        completion([self messageResult:message], message != nil);
    }];
}

/// 设置消息排重开关
/// 公开头文件：RCCoreClient.h
/// SDK API：-setCheckDuplicateMessage:
/// 前置条件：该接口应在 SDK 初始化后、连接前调用。
- (void)setDuplicateCheck:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    BOOL enabled = [parameters[@"checkDuplicate"] boolValue];
    [RCCoreClient.sharedCoreClient setCheckDuplicateMessage:enabled];
    completion([NSString stringWithFormat:@"消息排重已设置为 %@。", enabled ? @"开启" : @"关闭"], YES);
}

@end

