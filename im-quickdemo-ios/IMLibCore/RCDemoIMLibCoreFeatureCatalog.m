#import "RCDemoIMLibCoreFeatureCatalog.h"
#import "RCDemoIMLibCoreFeature.h"

#define RCFeature(ACTION, TITLE, API, ...) [RCDemoIMLibCoreFeature featureWithAction:ACTION title:TITLE api:API parameterKeys:__VA_ARGS__ dangerous:NO note:@""]
#define RCDangerousFeature(ACTION, TITLE, API, ...) [RCDemoIMLibCoreFeature featureWithAction:ACTION title:TITLE api:API parameterKeys:__VA_ARGS__ dangerous:YES note:@"该操作会修改或删除数据，执行前需要确认。"]

@implementation RCDemoIMLibCoreFeatureCatalog

+ (NSArray<RCDemoIMLibCoreFeatureGroup *> *)allGroups {
    return @[
        [RCDemoIMLibCoreFeatureGroup groupWithTitle:@"会话管理" features:[self conversationFeatures]],
        [RCDemoIMLibCoreFeatureGroup groupWithTitle:@"消息发送 - 消息类型" features:[self messageSendFeatures]],
        [RCDemoIMLibCoreFeatureGroup groupWithTitle:@"消息操作" features:[self messageOperationFeatures]],
        [RCDemoIMLibCoreFeatureGroup groupWithTitle:@"消息接收与历史" features:[self messageHistoryFeatures]],
    ];
}

+ (NSArray<RCDemoIMLibCoreFeature *> *)conversationFeatures {
    return @[
        RCFeature(RCDemoIMLibCoreFeatureActionGetConversationList, @"获取会话列表", @"getConversationList:completion:", @[@"conversationTypeList"]),
        RCFeature(RCDemoIMLibCoreFeatureActionGetConversationListPage, @"分页获取会话列表", @"RCCoreClient getConversationList:count:startTime:completion:；超级群使用 RCChannelClient getConversationList:channelId:count:startTime:completion:", @[@"conversationTypeList", @"channelId", @"count", @"timestamp"]),
        RCFeature(RCDemoIMLibCoreFeatureActionGetConversationListForAllChannelsPage, @"分页获取会话列表（全部 channel）", @"getConversationListForAllChannel:count:startTime:completion:", @[@"conversationTypeList", @"count", @"timestamp"]),
        RCFeature(RCDemoIMLibCoreFeatureActionGetConversationListForChannel, @"获取全部会话列表（指定 channel）", @"getConversationList:channelId:completion:", @[@"conversationTypeList", @"channelId"]),
        RCFeature(RCDemoIMLibCoreFeatureActionGetConversationListForAllChannels, @"获取全部会话列表（全部 channel）", @"getConversationListForAllChannel:completion:", @[@"conversationTypeList"]),
        RCDangerousFeature(RCDemoIMLibCoreFeatureActionRemoveConversation, @"删除会话", @"removeConversation:targetId:isDeleteRemote:success:error:", @[@"conversationType", @"targetId", @"channelId", @"clearRemote"]),
        RCDangerousFeature(RCDemoIMLibCoreFeatureActionSetConversationTop, @"设置会话置顶", @"setConversationToTop:targetId:isTop:completion:", @[@"conversationType", @"targetId", @"channelId", @"isTop"]),
        RCFeature(RCDemoIMLibCoreFeatureActionGetTopConversationList, @"获取置顶会话列表", @"getTopConversationList:completion:", @[@"conversationTypeList", @"channelId"]),
        RCFeature(RCDemoIMLibCoreFeatureActionSetLegacyNotificationStatus, @"免打扰（旧，已废弃）", @"setConversationNotificationStatus:targetId:isBlocked:success:error:", @[@"conversationType", @"targetId", @"isBlocked"]),
        RCFeature(RCDemoIMLibCoreFeatureActionSetNotificationLevel, @"免打扰级别（新）", @"setConversationNotificationLevel:targetId:level:success:error:", @[@"conversationType", @"targetId", @"channelId", @"notificationLevel"]),
        RCFeature(RCDemoIMLibCoreFeatureActionGetLegacyNotificationStatus, @"获取免打扰状态（旧）", @"getConversationNotificationStatus:targetId:success:error:", @[@"conversationType", @"targetId", @"channelId"]),
        RCFeature(RCDemoIMLibCoreFeatureActionGetNotificationLevel, @"获取免打扰状态（新）", @"getConversationNotificationLevel:targetId:success:error:", @[@"conversationType", @"targetId", @"channelId"]),
        RCFeature(RCDemoIMLibCoreFeatureActionGetBlockedConversationList, @"获取免打扰会话列表", @"getBlockedConversationList:completion:", @[@"conversationTypeList", @"channelId"]),
        RCFeature(RCDemoIMLibCoreFeatureActionGetUnreadConversationList, @"获取未读会话列表", @"getUnreadConversationList:completion:", @[@"conversationTypeList"]),
        RCFeature(RCDemoIMLibCoreFeatureActionSaveDraft, @"设置会话草稿", @"saveTextMessageDraft:targetId:content:completion:", @[@"conversationType", @"targetId", @"channelId", @"content"]),
        RCFeature(RCDemoIMLibCoreFeatureActionGetDraft, @"获取会话草稿", @"getTextMessageDraft:targetId:completion:", @[@"conversationType", @"targetId", @"channelId"]),
        RCDangerousFeature(RCDemoIMLibCoreFeatureActionClearDraft, @"清除会话草稿", @"clearTextMessageDraft:targetId:completion:", @[@"conversationType", @"targetId", @"channelId"]),
        RCFeature(RCDemoIMLibCoreFeatureActionGetConversationUnreadCount, @"获取指定会话未读数", @"getUnreadCount:targetId:completion:", @[@"conversationType", @"targetId", @"channelId"]),
        RCFeature(RCDemoIMLibCoreFeatureActionGetTotalUnreadCount, @"获取会话未读总数", @"getTotalUnreadCountWith:", @[@"channelId"]),
        RCDangerousFeature(RCDemoIMLibCoreFeatureActionClearConversationUnread, @"清除单会话未读数", @"clearMessagesUnreadStatus:targetId:completion:", @[@"conversationType", @"targetId", @"channelId"]),
        RCDangerousFeature(RCDemoIMLibCoreFeatureActionClearConversationUnreadByTime, @"按时间戳清除未读数", @"clearMessagesUnreadStatus:targetId:time:completion:", @[@"conversationType", @"targetId", @"channelId", @"timestamp"]),
        RCFeature(RCDemoIMLibCoreFeatureActionGetUnreadCountByLevels, @"按免打扰级别获取未读数", @"getUnreadCount:levels:success:error:", @[@"conversationTypeList", @"notificationLevelList"]),
        RCFeature(RCDemoIMLibCoreFeatureActionGetMentionedUnreadCountByLevels, @"按免打扰级别获取 @ 未读数", @"getUnreadMentionedCount:levels:success:error:", @[@"conversationTypeList", @"notificationLevelList"]),
        RCFeature(RCDemoIMLibCoreFeatureActionGetConversationMentionedCount, @"群会话 @ 未读数", @"RCConversation.mentionedCount / hasUnreadMentioned", @[@"targetId", @"channelId"]),
    ];
}

+ (NSArray<RCDemoIMLibCoreFeature *> *)messageSendFeatures {
    NSArray *base = @[@"conversationType", @"targetId", @"channelId", @"content", @"pushContent", @"pushData"];
    return @[
        RCFeature(RCDemoIMLibCoreFeatureActionSendTextMessage, @"发送文本消息", @"RCTextMessage.messageWithContent: + sendMessage:targetId:content:pushContent:pushData:option:attached:success:error:", base),
        RCFeature(RCDemoIMLibCoreFeatureActionSendMentionedMessage, @"发送 @ 消息", @"RCMentionedInfo.initWithMentionedType:userIdList:mentionedContent: + sendMessage:targetId:content:pushContent:pushData:option:attached:success:error:", [base arrayByAddingObjectsFromArray:@[@"userIdList"]]),
        RCFeature(RCDemoIMLibCoreFeatureActionSendRemoteImageMessage, @"发送图片消息（本地已上传）", @"RCImageMessage.messageWithImageURI: + sendMessage:targetId:content:pushContent:pushData:option:attached:success:error:", [base arrayByAddingObjectsFromArray:@[@"remoteUrl", @"localPath"]]),
        RCFeature(RCDemoIMLibCoreFeatureActionSendLocalImageMessage, @"发送图片消息（SDK 上传）", @"RCImageMessage.messageWithImageURI: + sendMediaMessage:targetId:content:pushContent:pushData:attached:progress:success:error:cancel:", [base arrayByAddingObjectsFromArray:@[@"localPath"]]),
        RCFeature(RCDemoIMLibCoreFeatureActionSendGIFMessage, @"发送 GIF 消息", @"RCGIFMessage.messageWithGIFURI:width:height: + sendMediaMessage:targetId:content:pushContent:pushData:attached:progress:success:error:cancel:", [base arrayByAddingObjectsFromArray:@[@"localPath", @"width", @"height"]]),
        RCFeature(RCDemoIMLibCoreFeatureActionSendVoiceMessage, @"发送语音消息", @"RCVoiceMessage.messageWithAudio:duration: + sendMessage:targetId:content:pushContent:pushData:option:attached:success:error:", [base arrayByAddingObjectsFromArray:@[@"localPath", @"duration"]]),
        RCFeature(RCDemoIMLibCoreFeatureActionSendHQVoiceMessage, @"发送高清语音（SDK 上传）", @"RCHQVoiceMessage.messageWithPath:duration: + sendMediaMessage:targetId:content:pushContent:pushData:attached:progress:success:error:cancel:", [base arrayByAddingObjectsFromArray:@[@"localPath", @"duration"]]),
        RCFeature(RCDemoIMLibCoreFeatureActionSendRemoteFileMessage, @"发送文件消息（已上传）", @"RCFileMessage.messageWithFile: + sendMessage:targetId:content:pushContent:pushData:option:attached:success:error:", [base arrayByAddingObjectsFromArray:@[@"localPath", @"remoteUrl"]]),
        RCFeature(RCDemoIMLibCoreFeatureActionSendLocalFileMessage, @"发送文件消息（SDK 上传）", @"RCFileMessage.messageWithFile: + sendMediaMessage:targetId:content:pushContent:pushData:attached:progress:success:error:cancel:", [base arrayByAddingObjectsFromArray:@[@"localPath"]]),
        RCFeature(RCDemoIMLibCoreFeatureActionSendRemoteSightMessage, @"发送短视频（已上传）", @"RCSightMessage.messageWithLocalPath:thumbnail:duration: + sendMessage:targetId:content:pushContent:pushData:option:attached:success:error:", [base arrayByAddingObjectsFromArray:@[@"localPath", @"remoteUrl", @"duration"]]),
        RCFeature(RCDemoIMLibCoreFeatureActionSendLocalSightMessage, @"发送短视频（SDK 上传）", @"RCSightMessage.messageWithLocalPath:thumbnail:duration: + sendMediaMessage:targetId:content:pushContent:pushData:attached:progress:success:error:cancel:", [base arrayByAddingObjectsFromArray:@[@"localPath", @"duration"]]),
        RCFeature(RCDemoIMLibCoreFeatureActionSendRichContentMessage, @"发送富文本消息", @"RCRichContentMessage.messageWithTitle:digest:imageURL:url:extra: + sendMessage:targetId:content:pushContent:pushData:option:attached:success:error:", [base arrayByAddingObjectsFromArray:@[@"title", @"imageUrl", @"remoteUrl"]]),
        RCFeature(RCDemoIMLibCoreFeatureActionSendCombineMessage, @"发送合并消息（SDK 上传）", @"RCCombineMessage.messageWithSummaryList:nameList:conversationType:content: + sendMediaMessage:targetId:content:pushContent:pushData:attached:progress:success:error:cancel:", [base arrayByAddingObjectsFromArray:@[@"summaryList", @"nameList", @"localPath"]]),
        RCFeature(RCDemoIMLibCoreFeatureActionSendReferenceMessage, @"发送引用消息", @"getMessageByUId:completion: + RCReferenceMessage + sendMessage:targetId:content:pushContent:pushData:option:attached:success:error:", [base arrayByAddingObjectsFromArray:@[@"messageUId", @"userId"]]),
        RCFeature(RCDemoIMLibCoreFeatureActionSendDirectionalMessage, @"定向消息", @"sendDirectionalMessage:targetId:toUserIdList:content:pushContent:pushData:option:attached:success:error:", [base arrayByAddingObjectsFromArray:@[@"userIdList"]]),
        RCFeature(RCDemoIMLibCoreFeatureActionSendCustomMessage, @"发送自定义消息", @"RCDemoCustomMessage.messageWithContent: + sendMessage:targetId:content:pushContent:pushData:option:attached:success:error:", base),
        RCFeature(RCDemoIMLibCoreFeatureActionRegisterCustomMessage, @"注册自定义消息类型", @"registerMessageType:", @[]),
    ];
}

+ (NSArray<RCDemoIMLibCoreFeature *> *)messageOperationFeatures {
    return @[
        RCDangerousFeature(RCDemoIMLibCoreFeatureActionRecallMessage, @"撤回消息", @"recallMessage:success:error:", @[@"messageId"]),
        RCDangerousFeature(RCDemoIMLibCoreFeatureActionDeleteRemoteMessages, @"按消息删除历史（远端）", @"deleteRemoteMessage:targetId:messages:success:error:", @[@"conversationType", @"targetId", @"channelId", @"messageUIdList"]),
        RCDangerousFeature(RCDemoIMLibCoreFeatureActionClearRemoteHistory, @"按时间删除历史（远端）", @"clearRemoteHistoryMessages:targetId:recordTime:success:error: / 频道版增加 channelId", @[@"conversationType", @"targetId", @"channelId", @"timestamp"]),
        RCDangerousFeature(RCDemoIMLibCoreFeatureActionDeleteLocalMessages, @"删除本地消息（按消息）", @"deleteMessages:completion:", @[@"messageIdList"]),
        RCDangerousFeature(RCDemoIMLibCoreFeatureActionClearLocalHistoryBeforeTime, @"删除时间戳前本地消息", @"clearHistoryMessages:targetId:recordTime:clearRemote:success:error: / 频道版增加 channelId", @[@"conversationType", @"targetId", @"channelId", @"timestamp"]),
        RCDangerousFeature(RCDemoIMLibCoreFeatureActionClearConversationMessages, @"清空会话本地历史", @"clearMessages:targetId:completion:", @[@"conversationType", @"targetId", @"channelId"]),
        RCFeature(RCDemoIMLibCoreFeatureActionSetMessageSentStatus, @"设置消息发送状态", @"setMessageSentStatus:sentStatus:completion:", @[@"messageId", @"sentStatus"]),
        RCFeature(RCDemoIMLibCoreFeatureActionSetMessageReceivedStatus, @"设置消息接收状态", @"setMessageReceivedStatus:receivedStatusInfo:completion:", @[@"messageId", @"isRead", @"isListened", @"isDownloaded"]),
        RCFeature(RCDemoIMLibCoreFeatureActionBatchInsertMessage, @"本地插入消息（BaseMessage）", @"RCMessage.initWithType:targetId:channelId:direction:content: + batchInsertMessage:checkDuplicate:completion:", @[@"conversationType", @"targetId", @"channelId", @"content", @"direction", @"userId", @"messageUId", @"timestamp", @"checkDuplicate"]),
        RCFeature(RCDemoIMLibCoreFeatureActionInsertMessage, @"本地插入消息", @"insertOutgoingMessage:targetId:sentStatus:content:sentTime:completion: / insertIncomingMessage:targetId:senderUserId:receivedStatusInfo:content:sentTime:completion:", @[@"conversationType", @"targetId", @"channelId", @"content", @"direction", @"timestamp", @"userId"]),
        RCFeature(RCDemoIMLibCoreFeatureActionSetDuplicateCheck, @"消息排重开关", @"setCheckDuplicateMessage:", @[@"checkDuplicate"]),
    ];
}

+ (NSArray<RCDemoIMLibCoreFeature *> *)messageHistoryFeatures {
    return @[
        RCFeature(RCDemoIMLibCoreFeatureActionListenReceiveMessage, @"消息接收监听", @"addReceiveMessageDelegate: / removeReceiveMessageDelegate:", @[@"listenEnabled"]),
        RCFeature(RCDemoIMLibCoreFeatureActionGetLocalHistory, @"获取本地历史消息", @"getHistoryMessages:targetId:objectName:baseMessageId:isForward:count:completion: / 频道版增加 channelId", @[@"conversationType", @"targetId", @"channelId", @"count", @"baseMessageId", @"order"]),
        RCFeature(RCDemoIMLibCoreFeatureActionGetRemoteHistory, @"获取远端历史消息", @"getRemoteHistoryMessages:targetId:option:success:error: / 频道版增加 channelId", @[@"conversationType", @"targetId", @"channelId", @"count", @"timestamp", @"order", @"includeLocalExistMessage"]),
        RCFeature(RCDemoIMLibCoreFeatureActionGetFirstUnreadMessage, @"获取第一条未读消息", @"getFirstUnreadMessage:targetId:completion:", @[@"conversationType", @"targetId", @"channelId"]),
        RCFeature(RCDemoIMLibCoreFeatureActionGetHistoryByMessageTypes, @"获取指定类型历史消息", @"getHistoryMessages:targetId:objectNames:sentTime:isForward:count:completion:", @[@"conversationType", @"targetId", @"channelId", @"objectNameList", @"count", @"timestamp", @"order"]),
        RCFeature(RCDemoIMLibCoreFeatureActionGetMessage, @"获取本地消息（按 UId）", @"getMessageByUId:completion:", @[@"messageUId"]),
        RCFeature(RCDemoIMLibCoreFeatureActionGetMessageCount, @"获取会话消息总数", @"getMessageCount:targetId:completion:", @[@"conversationType", @"targetId", @"channelId"]),
        RCFeature(RCDemoIMLibCoreFeatureActionGetUnreadMentionedMessages, @"获取未读 @ 消息列表", @"getUnreadMentionedMessages:targetId:channelId:completion:", @[@"conversationType", @"targetId", @"channelId"]),
        RCDangerousFeature(RCDemoIMLibCoreFeatureActionSetReadBeforeTime, @"设置指定时间前已读", @"clearMessagesUnreadStatus:targetId:time:completion:", @[@"conversationType", @"targetId", @"channelId", @"timestamp"]),
    ];
}

@end

