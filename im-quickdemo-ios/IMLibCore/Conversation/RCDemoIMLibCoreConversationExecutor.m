#import "RCDemoIMLibCoreFeatureExecutor+Internal.h"

@interface RCDemoIMLibCoreFeatureExecutor (ConversationPrivate)
- (void)getConversationList:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)getConversationListPage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)getConversationListForAllChannelsPage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)getConversationListForChannel:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)getConversationListForAllChannels:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)removeConversation:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)setConversationTop:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)getTopConversationList:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)setLegacyNotificationStatus:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)setNotificationLevel:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)getLegacyNotificationStatus:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)getNotificationLevel:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)getBlockedConversationList:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)getUnreadConversationList:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)saveDraft:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)getDraft:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)clearDraft:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)getConversationUnreadCount:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)getTotalUnreadCount:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)clearConversationUnread:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)clearConversationUnreadByTime:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)getUnreadCountByLevels:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)getMentionedUnreadCountByLevels:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)getConversationMentionedCount:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
@end

@implementation RCDemoIMLibCoreFeatureExecutor (Conversation)

- (void)executeConversationFeature:(RCDemoIMLibCoreFeature *)feature
                         parameters:(NSDictionary<NSString *,id> *)parameters
                         completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    switch (feature.action) {
        case RCDemoIMLibCoreFeatureActionGetConversationList: [self getConversationList:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionGetConversationListPage: [self getConversationListPage:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionGetConversationListForAllChannelsPage: [self getConversationListForAllChannelsPage:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionGetConversationListForChannel: [self getConversationListForChannel:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionGetConversationListForAllChannels: [self getConversationListForAllChannels:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionRemoveConversation: [self removeConversation:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionSetConversationTop: [self setConversationTop:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionGetTopConversationList: [self getTopConversationList:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionSetLegacyNotificationStatus: [self setLegacyNotificationStatus:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionSetNotificationLevel: [self setNotificationLevel:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionGetLegacyNotificationStatus: [self getLegacyNotificationStatus:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionGetNotificationLevel: [self getNotificationLevel:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionGetBlockedConversationList: [self getBlockedConversationList:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionGetUnreadConversationList: [self getUnreadConversationList:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionSaveDraft: [self saveDraft:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionGetDraft: [self getDraft:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionClearDraft: [self clearDraft:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionGetConversationUnreadCount: [self getConversationUnreadCount:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionGetTotalUnreadCount: [self getTotalUnreadCount:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionClearConversationUnread: [self clearConversationUnread:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionClearConversationUnreadByTime: [self clearConversationUnreadByTime:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionGetUnreadCountByLevels: [self getUnreadCountByLevels:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionGetMentionedUnreadCountByLevels: [self getMentionedUnreadCountByLevels:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionGetConversationMentionedCount: [self getConversationMentionedCount:parameters completion:completion]; break;
        default: completion(@"未知会话管理功能。", NO); break;
    }
}

/// 获取会话列表
/// 公开头文件：RCCoreClient.h
/// SDK API：-getConversationList:completion:
- (void)getConversationList:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    [RCCoreClient.sharedCoreClient getConversationList:[self numberList:parameters[@"conversationTypeList"] defaultValues:@[@1, @3]]
                                             completion:^(NSArray<RCConversation *> *conversationList) {
        completion([self conversationListResult:conversationList], YES);
    }];
}

/// 分页获取会话列表
/// 公开头文件：RCCoreClient.h、RCChannelClient.h
/// SDK API：普通会话使用 -getConversationList:count:startTime:completion:；超级群使用 -getConversationList:channelId:count:startTime:completion:
- (void)getConversationListPage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    NSArray<NSNumber *> *conversationTypes = [self numberList:parameters[@"conversationTypeList"] defaultValues:@[@1, @3]];
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    int count = MAX(1, [parameters[@"count"] intValue]);
    long long startTime = [parameters[@"timestamp"] longLongValue];
    if (channelId || [conversationTypes containsObject:@(ConversationType_ULTRAGROUP)]) {
        [RCChannelClient.sharedChannelManager getConversationList:conversationTypes
                                                            channelId:channelId
                                                                count:count
                                                            startTime:startTime
                                                           completion:^(NSArray<RCConversation *> *conversationList) {
            completion([self conversationListResult:conversationList], YES);
        }];
        return;
    }
    [RCCoreClient.sharedCoreClient getConversationList:conversationTypes
                                                 count:count
                                             startTime:startTime
                                           completion:^(NSArray<RCConversation *> *conversationList) {
        completion([self conversationListResult:conversationList], YES);
    }];
}

/// 分页获取全部频道的会话列表
/// 公开头文件：RCChannelClient.h
/// SDK API：-getConversationListForAllChannel:count:startTime:completion:
- (void)getConversationListForAllChannelsPage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    [RCChannelClient.sharedChannelManager getConversationListForAllChannel:[self numberList:parameters[@"conversationTypeList"] defaultValues:@[@1, @3]]
                                                                      count:MAX(1, [parameters[@"count"] intValue])
                                                                  startTime:[parameters[@"timestamp"] longLongValue]
                                                                 completion:^(NSArray<RCConversation *> *conversationList) {
        completion([self conversationListResult:conversationList], YES);
    }];
}

/// 获取指定频道的全部会话列表
/// 公开头文件：RCChannelClient.h
/// SDK API：-getConversationList:channelId:completion:
- (void)getConversationListForChannel:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    [RCChannelClient.sharedChannelManager getConversationList:[self numberList:parameters[@"conversationTypeList"] defaultValues:@[@1, @3]]
                                                    channelId:[self nilIfEmpty:[self string:parameters key:@"channelId"]]
                                                   completion:^(NSArray<RCConversation *> *conversationList) {
        completion([self conversationListResult:conversationList], YES);
    }];
}

/// 获取全部频道的会话列表
/// 公开头文件：RCChannelClient.h
/// SDK API：-getConversationListForAllChannel:completion:
- (void)getConversationListForAllChannels:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    [RCChannelClient.sharedChannelManager getConversationListForAllChannel:[self numberList:parameters[@"conversationTypeList"] defaultValues:@[@1, @3]]
                                                                 completion:^(NSArray<RCConversation *> *conversationList) {
        completion([self conversationListResult:conversationList], YES);
    }];
}

/// 删除会话
/// 公开头文件：RCCoreClient.h、RCChannelClient.h
/// SDK API：-removeConversation:targetId:isDeleteRemote:success:error:
- (void)removeConversation:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    NSString *targetId = [self string:parameters key:@"targetId"];
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    if ([self conversationType:parameters] == ConversationType_ULTRAGROUP || channelId) {
        [RCChannelClient.sharedChannelManager removeConversation:[self conversationType:parameters]
                                                        targetId:targetId
                                                       channelId:channelId
                                                      completion:^(BOOL result) {
            completion([NSString stringWithFormat:@"删除会话 result: %@", result ? @"YES" : @"NO"], result);
        }];
        return;
    }
    [RCCoreClient.sharedCoreClient removeConversation:[self conversationType:parameters]
                                             targetId:targetId
                                       isDeleteRemote:[parameters[@"clearRemote"] boolValue]
                                              success:^{ completion(@"删除会话成功。", YES); }
                                                error:^(RCErrorCode errorCode) { completion([self errorResult:errorCode], NO); }];
}

/// 设置会话置顶
/// 公开头文件：RCCoreClient.h、RCChannelClient.h
/// SDK API：-setConversationToTop:targetId:isTop:completion:
- (void)setConversationTop:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    NSString *targetId = [self string:parameters key:@"targetId"];
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    void (^resultBlock)(BOOL) = ^(BOOL result) {
        completion([NSString stringWithFormat:@"设置置顶 result: %@", result ? @"YES" : @"NO"], result);
    };
    if ([self conversationType:parameters] == ConversationType_ULTRAGROUP || channelId) {
        [RCChannelClient.sharedChannelManager setConversationToTop:[self conversationType:parameters]
                                                          targetId:targetId
                                                         channelId:channelId
                                                             isTop:[parameters[@"isTop"] boolValue]
                                                        completion:resultBlock];
    } else {
        [RCCoreClient.sharedCoreClient setConversationToTop:[self conversationType:parameters]
                                                    targetId:targetId
                                                       isTop:[parameters[@"isTop"] boolValue]
                                                  completion:resultBlock];
    }
}

/// 获取置顶会话列表
/// 公开头文件：RCCoreClient.h、RCChannelClient.h
/// SDK API：-getTopConversationList:completion:
- (void)getTopConversationList:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    NSArray<NSNumber *> *types = [self numberList:parameters[@"conversationTypeList"] defaultValues:@[@1, @3]];
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    if (channelId || [types containsObject:@(ConversationType_ULTRAGROUP)]) {
        [RCChannelClient.sharedChannelManager getTopConversationList:types channelId:channelId completion:^(NSArray<RCConversation *> *conversationList) {
            completion([self conversationListResult:conversationList], YES);
        }];
    } else {
        [RCCoreClient.sharedCoreClient getTopConversationList:types completion:^(NSArray<RCConversation *> *conversationList) {
            completion([self conversationListResult:conversationList], YES);
        }];
    }
}

/// 设置旧版会话免打扰状态
/// 公开头文件：RCCoreClient+Deprecated.h
/// SDK API：-setConversationNotificationStatus:targetId:isBlocked:success:error:
- (void)setLegacyNotificationStatus:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [RCCoreClient.sharedCoreClient setConversationNotificationStatus:[self conversationType:parameters]
                                                             targetId:[self string:parameters key:@"targetId"]
                                                            isBlocked:[parameters[@"isBlocked"] boolValue]
                                                               success:^(RCConversationNotificationStatus status) {
        completion([NSString stringWithFormat:@"notificationStatus: %ld", (long)status], YES);
    } error:^(RCErrorCode status) {
        completion([self errorResult:status], NO);
    }];
#pragma clang diagnostic pop
}

/// 设置会话通知级别
/// 公开头文件：RCChannelClient.h
/// SDK API：-setConversationNotificationLevel:targetId:level:success:error:
- (void)setNotificationLevel:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    NSString *targetId = [self string:parameters key:@"targetId"];
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    RCPushNotificationLevel level = (RCPushNotificationLevel)[parameters[@"notificationLevel"] integerValue];
    if ([self conversationType:parameters] == ConversationType_ULTRAGROUP || channelId) {
        [RCChannelClient.sharedChannelManager setConversationChannelNotificationLevel:[self conversationType:parameters]
                                                                              targetId:targetId
                                                                             channelId:channelId
                                                                                 level:level
                                                                               success:^{ completion(@"通知级别设置成功。", YES); }
                                                                                 error:^(RCErrorCode status) { completion([self errorResult:status], NO); }];
    } else {
        [RCChannelClient.sharedChannelManager setConversationNotificationLevel:[self conversationType:parameters]
                                                                       targetId:targetId
                                                                          level:level
                                                                        success:^{ completion(@"通知级别设置成功。", YES); }
                                                                          error:^(RCErrorCode status) { completion([self errorResult:status], NO); }];
    }
}

/// 获取旧版会话免打扰状态
/// 公开头文件：RCCoreClient.h、RCChannelClient.h
/// SDK API：-getConversationNotificationStatus:targetId:success:error:
- (void)getLegacyNotificationStatus:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    NSString *targetId = [self string:parameters key:@"targetId"];
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    void (^success)(RCConversationNotificationStatus) = ^(RCConversationNotificationStatus status) {
        completion([NSString stringWithFormat:@"notificationStatus: %ld", (long)status], YES);
    };
    void (^error)(RCErrorCode) = ^(RCErrorCode status) { completion([self errorResult:status], NO); };
    if ([self conversationType:parameters] == ConversationType_ULTRAGROUP || channelId) {
        [RCChannelClient.sharedChannelManager getConversationNotificationStatus:[self conversationType:parameters]
                                                                        targetId:targetId
                                                                       channelId:channelId
                                                                         success:success
                                                                           error:error];
    } else {
        [RCCoreClient.sharedCoreClient getConversationNotificationStatus:[self conversationType:parameters]
                                                                  targetId:targetId
                                                                   success:success
                                                                     error:error];
    }
}

/// 获取会话通知级别
/// 公开头文件：RCChannelClient.h
/// SDK API：-getConversationNotificationLevel:targetId:success:error:
- (void)getNotificationLevel:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    NSString *targetId = [self string:parameters key:@"targetId"];
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    void (^success)(RCPushNotificationLevel) = ^(RCPushNotificationLevel level) {
        completion([NSString stringWithFormat:@"notificationLevel: %ld", (long)level], YES);
    };
    void (^error)(RCErrorCode) = ^(RCErrorCode status) { completion([self errorResult:status], NO); };
    if ([self conversationType:parameters] == ConversationType_ULTRAGROUP || channelId) {
        [RCChannelClient.sharedChannelManager getConversationChannelNotificationLevel:[self conversationType:parameters]
                                                                              targetId:targetId
                                                                             channelId:channelId
                                                                               success:success
                                                                                 error:error];
    } else {
        [RCChannelClient.sharedChannelManager getConversationNotificationLevel:[self conversationType:parameters]
                                                                       targetId:targetId
                                                                        success:success
                                                                          error:error];
    }
}

/// 获取免打扰会话列表
/// 公开头文件：RCCoreClient.h、RCChannelClient.h
/// SDK API：-getBlockedConversationList:completion:
- (void)getBlockedConversationList:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    NSArray<NSNumber *> *types = [self numberList:parameters[@"conversationTypeList"] defaultValues:@[@1, @3]];
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    if (channelId || [types containsObject:@(ConversationType_ULTRAGROUP)]) {
        [RCChannelClient.sharedChannelManager getBlockedConversationList:types channelId:channelId completion:^(NSArray<RCConversation *> *conversationList) {
            completion([self conversationListResult:conversationList], YES);
        }];
    } else {
        [RCCoreClient.sharedCoreClient getBlockedConversationList:types completion:^(NSArray<RCConversation *> *conversationList) {
            completion([self conversationListResult:conversationList], YES);
        }];
    }
}

/// 获取未读会话列表
/// 公开头文件：RCCoreClient.h
/// SDK API：-getUnreadConversationList:completion:
- (void)getUnreadConversationList:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    [RCCoreClient.sharedCoreClient getUnreadConversationList:[self numberList:parameters[@"conversationTypeList"] defaultValues:@[@1, @3]]
                                                   completion:^(NSArray<RCConversation *> *conversationList) {
        completion([self conversationListResult:conversationList], YES);
    }];
}

/// 保存会话草稿
/// 公开头文件：RCCoreClient.h、RCChannelClient.h
/// SDK API：-saveTextMessageDraft:targetId:content:completion:
- (void)saveDraft:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    NSString *targetId = [self string:parameters key:@"targetId"];
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    void (^resultBlock)(BOOL) = ^(BOOL result) { completion([NSString stringWithFormat:@"保存草稿 result: %@", result ? @"YES" : @"NO"], result); };
    if ([self conversationType:parameters] == ConversationType_ULTRAGROUP || channelId) {
        [RCChannelClient.sharedChannelManager saveTextMessageDraft:[self conversationType:parameters]
                                                          targetId:targetId
                                                         channelId:channelId
                                                           content:[self string:parameters key:@"content"]
                                                        completion:resultBlock];
    } else {
        [RCCoreClient.sharedCoreClient saveTextMessageDraft:[self conversationType:parameters]
                                                   targetId:targetId
                                                    content:[self string:parameters key:@"content"]
                                                 completion:resultBlock];
    }
}

/// 获取会话草稿
/// 公开头文件：RCCoreClient.h、RCChannelClient.h
/// SDK API：-getTextMessageDraft:targetId:completion:
- (void)getDraft:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    NSString *targetId = [self string:parameters key:@"targetId"];
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    void (^resultBlock)(NSString *) = ^(NSString *draft) { completion([NSString stringWithFormat:@"draft: %@", draft ?: @"<nil>"], YES); };
    if ([self conversationType:parameters] == ConversationType_ULTRAGROUP || channelId) {
        [RCChannelClient.sharedChannelManager getTextMessageDraft:[self conversationType:parameters] targetId:targetId channelId:channelId completion:resultBlock];
    } else {
        [RCCoreClient.sharedCoreClient getTextMessageDraft:[self conversationType:parameters] targetId:targetId completion:resultBlock];
    }
}

/// 清除会话草稿
/// 公开头文件：RCCoreClient.h、RCChannelClient.h
/// SDK API：-clearTextMessageDraft:targetId:completion:
- (void)clearDraft:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    NSString *targetId = [self string:parameters key:@"targetId"];
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    void (^resultBlock)(BOOL) = ^(BOOL result) { completion([NSString stringWithFormat:@"清除草稿 result: %@", result ? @"YES" : @"NO"], result); };
    if ([self conversationType:parameters] == ConversationType_ULTRAGROUP || channelId) {
        [RCChannelClient.sharedChannelManager clearTextMessageDraft:[self conversationType:parameters] targetId:targetId channelId:channelId completion:resultBlock];
    } else {
        [RCCoreClient.sharedCoreClient clearTextMessageDraft:[self conversationType:parameters] targetId:targetId completion:resultBlock];
    }
}

/// 获取指定会话未读数
/// 公开头文件：RCCoreClient.h、RCChannelClient.h
/// SDK API：-getUnreadCount:targetId:completion:
- (void)getConversationUnreadCount:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    NSString *targetId = [self string:parameters key:@"targetId"];
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    void (^resultBlock)(int) = ^(int count) { completion([NSString stringWithFormat:@"unreadCount: %d", count], count >= 0); };
    if ([self conversationType:parameters] == ConversationType_ULTRAGROUP || channelId) {
        [RCChannelClient.sharedChannelManager getUnreadCount:[self conversationType:parameters] targetId:targetId channelId:channelId completion:resultBlock];
    } else {
        [RCCoreClient.sharedCoreClient getUnreadCount:[self conversationType:parameters] targetId:targetId completion:resultBlock];
    }
}

/// 获取会话未读总数
/// 公开头文件：RCCoreClient.h、RCChannelClient.h
/// SDK API：-getTotalUnreadCountWith:
- (void)getTotalUnreadCount:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    if (channelId) {
        [RCChannelClient.sharedChannelManager getTotalUnreadCountWithChannelId:channelId completion:^(int count) {
            completion([NSString stringWithFormat:@"totalUnreadCount: %d", count], YES);
        }];
    } else {
        [RCCoreClient.sharedCoreClient getTotalUnreadCountWith:^(int count) {
            completion([NSString stringWithFormat:@"totalUnreadCount: %d", count], YES);
        }];
    }
}

/// 清除单会话未读数
/// 公开头文件：RCCoreClient.h、RCChannelClient.h
/// SDK API：-clearMessagesUnreadStatus:targetId:completion:
- (void)clearConversationUnread:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    NSString *targetId = [self string:parameters key:@"targetId"];
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    void (^resultBlock)(BOOL) = ^(BOOL result) { completion([NSString stringWithFormat:@"清除未读 result: %@", result ? @"YES" : @"NO"], result); };
    if ([self conversationType:parameters] == ConversationType_ULTRAGROUP || channelId) {
        [RCChannelClient.sharedChannelManager clearMessagesUnreadStatus:[self conversationType:parameters] targetId:targetId channelId:channelId completion:resultBlock];
    } else {
        [RCCoreClient.sharedCoreClient clearMessagesUnreadStatus:[self conversationType:parameters] targetId:targetId completion:resultBlock];
    }
}

/// 按时间戳清除未读数
/// 公开头文件：RCCoreClient.h、RCChannelClient.h
/// SDK API：-clearMessagesUnreadStatus:targetId:time:completion:
- (void)clearConversationUnreadByTime:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    NSString *targetId = [self string:parameters key:@"targetId"];
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    void (^resultBlock)(BOOL) = ^(BOOL result) { completion([NSString stringWithFormat:@"按时间清除未读 result: %@", result ? @"YES" : @"NO"], result); };
    if ([self conversationType:parameters] == ConversationType_ULTRAGROUP || channelId) {
        [RCChannelClient.sharedChannelManager clearMessagesUnreadStatus:[self conversationType:parameters]
                                                               targetId:targetId
                                                              channelId:channelId
                                                                   time:[parameters[@"timestamp"] longLongValue]
                                                             completion:resultBlock];
    } else {
        [RCCoreClient.sharedCoreClient clearMessagesUnreadStatus:[self conversationType:parameters]
                                                        targetId:targetId
                                                            time:[parameters[@"timestamp"] longLongValue]
                                                      completion:resultBlock];
    }
}

/// 按通知级别获取未读数
/// 公开头文件：RCChannelClient.h
/// SDK API：-getUnreadCount:levels:success:error:
- (void)getUnreadCountByLevels:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    [RCChannelClient.sharedChannelManager getUnreadCount:[self numberList:parameters[@"conversationTypeList"] defaultValues:@[@1, @3]]
                                                   levels:[self numberList:parameters[@"notificationLevelList"] defaultValues:@[@0]]
                                                  success:^(NSInteger count) {
        completion([NSString stringWithFormat:@"unreadCount: %ld", (long)count], YES);
    } error:^(RCErrorCode status) {
        completion([self errorResult:status], NO);
    }];
}

/// 按通知级别获取 @ 未读数
/// 公开头文件：RCChannelClient.h
/// SDK API：-getUnreadMentionedCount:levels:success:error:
- (void)getMentionedUnreadCountByLevels:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    [RCChannelClient.sharedChannelManager getUnreadMentionedCount:[self numberList:parameters[@"conversationTypeList"] defaultValues:@[@3]]
                                                            levels:[self numberList:parameters[@"notificationLevelList"] defaultValues:@[@0]]
                                                           success:^(NSInteger count) {
        completion([NSString stringWithFormat:@"mentionedUnreadCount: %ld", (long)count], YES);
    } error:^(RCErrorCode status) {
        completion([self errorResult:status], NO);
    }];
}

/// 获取群会话 @ 未读数
/// 公开头文件：RCCoreClient.h、RCChannelClient.h、RCConversation.h
/// SDK API：-getConversation:targetId:completion:
- (void)getConversationMentionedCount:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    NSString *targetId = [self string:parameters key:@"targetId"];
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    void (^resultBlock)(RCConversation *) = ^(RCConversation *conversation) {
        if (!conversation) {
            completion(@"未找到群会话。", NO);
            return;
        }
        completion([NSString stringWithFormat:@"mentionedCount: %d\nhasUnreadMentioned: %@",
                    conversation.mentionedCount,
                    conversation.hasUnreadMentioned ? @"YES" : @"NO"], YES);
    };
    if (channelId) {
        [RCChannelClient.sharedChannelManager getConversation:ConversationType_GROUP targetId:targetId channelId:channelId completion:resultBlock];
    } else {
        [RCCoreClient.sharedCoreClient getConversation:ConversationType_GROUP targetId:targetId completion:resultBlock];
    }
}

@end

