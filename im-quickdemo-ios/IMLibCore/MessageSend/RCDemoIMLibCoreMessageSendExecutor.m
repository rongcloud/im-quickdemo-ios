#import "RCDemoIMLibCoreFeatureExecutor+Internal.h"
#import "RCDemoCustomMessage.h"

@interface RCDemoIMLibCoreFeatureExecutor (MessageSendPrivate)
- (void)sendTextMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)sendMentionedMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)sendRemoteImageMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)sendLocalImageMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)sendGIFMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)sendVoiceMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)sendHQVoiceMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)sendRemoteFileMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)sendLocalFileMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)sendRemoteSightMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)sendLocalSightMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)sendRichContentMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)sendCombineMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)sendReferenceMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)sendDirectionalMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)sendCustomMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (void)registerCustomMessage:(RCDemoIMLibCoreExecutionCompletion)completion;
@end

@implementation RCDemoIMLibCoreFeatureExecutor (MessageSend)

/// 取消当前正在发送的媒体消息
/// 公开头文件：RCCoreClient.h
/// SDK API：-cancelSendMediaMessage:
- (void)cancelCurrentMediaMessageWithCompletion:(RCDemoIMLibCoreExecutionCompletion)completion {
    if (self.currentMediaMessageId <= 0) {
        completion(@"当前没有可取消的媒体消息。", NO);
        return;
    }
    long messageId = self.currentMediaMessageId;
    BOOL cancelled = [RCCoreClient.sharedCoreClient cancelSendMediaMessage:messageId];
    if (cancelled) self.currentMediaMessageId = 0;
    completion([NSString stringWithFormat:@"cancelSendMediaMessage(%ld): %@", messageId, cancelled ? @"YES" : @"NO"], cancelled);
}

- (void)executeMessageSendFeature:(RCDemoIMLibCoreFeature *)feature
                        parameters:(NSDictionary<NSString *, id> *)parameters
                        completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    switch (feature.action) {
        case RCDemoIMLibCoreFeatureActionSendTextMessage: [self sendTextMessage:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionSendMentionedMessage: [self sendMentionedMessage:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionSendRemoteImageMessage: [self sendRemoteImageMessage:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionSendLocalImageMessage: [self sendLocalImageMessage:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionSendGIFMessage: [self sendGIFMessage:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionSendVoiceMessage: [self sendVoiceMessage:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionSendHQVoiceMessage: [self sendHQVoiceMessage:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionSendRemoteFileMessage: [self sendRemoteFileMessage:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionSendLocalFileMessage: [self sendLocalFileMessage:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionSendRemoteSightMessage: [self sendRemoteSightMessage:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionSendLocalSightMessage: [self sendLocalSightMessage:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionSendRichContentMessage: [self sendRichContentMessage:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionSendCombineMessage: [self sendCombineMessage:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionSendReferenceMessage: [self sendReferenceMessage:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionSendDirectionalMessage: [self sendDirectionalMessage:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionSendCustomMessage: [self sendCustomMessage:parameters completion:completion]; break;
        case RCDemoIMLibCoreFeatureActionRegisterCustomMessage: [self registerCustomMessage:completion]; break;
        default: completion(@"未知消息发送功能。", NO); break;
    }
}

/// 发送文本消息
/// 公开头文件：RCTextMessage.h、RCCoreClient.h、RCChannelClient.h
/// SDK API：+messageWithContent:、-sendMessage:targetId:content:pushContent:pushData:option:attached:success:error:
- (void)sendTextMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    RCTextMessage *content = [RCTextMessage messageWithContent:[self string:parameters key:@"content"]];
    NSString *targetId = [self string:parameters key:@"targetId"];
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    __block RCMessage *attachedMessage;
    if ([self conversationType:parameters] == ConversationType_ULTRAGROUP || channelId) {
        [RCChannelClient.sharedChannelManager sendMessage:[self conversationType:parameters]
                                                  targetId:targetId
                                                 channelId:channelId
                                                   content:content
                                               pushContent:[self nilIfEmpty:[self string:parameters key:@"pushContent"]]
                                                  pushData:[self nilIfEmpty:[self string:parameters key:@"pushData"]]
                                                    option:nil
                                               attached:^(RCMessage *message) { attachedMessage = message; self.currentMediaMessageId = message.messageId; }
                                                   success:^(long messageId) {
            completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self messageResult:attachedMessage]], YES);
        } error:^(RCErrorCode errorCode, long messageId) {
            completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self errorResult:errorCode]], NO);
        }];
        return;
    }
    [RCCoreClient.sharedCoreClient sendMessage:[self conversationType:parameters]
                                       targetId:targetId
                                        content:content
                                    pushContent:[self nilIfEmpty:[self string:parameters key:@"pushContent"]]
                                       pushData:[self nilIfEmpty:[self string:parameters key:@"pushData"]]
                                         option:nil
                                               attached:^(RCMessage *message) { attachedMessage = message; self.currentMediaMessageId = message.messageId; }
                                        success:^(long messageId) {
        completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self messageResult:attachedMessage]], YES);
    } error:^(RCErrorCode errorCode, long messageId) {
        completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self errorResult:errorCode]], NO);
    }];
}

/// 发送 @ 消息
/// 公开头文件：RCTextMessage.h、RCMentionedInfo.h、RCCoreClient.h、RCChannelClient.h
/// SDK API：-initWithMentionedType:userIdList:mentionedContent:、-sendMessage:targetId:content:pushContent:pushData:option:attached:success:error:
- (void)sendMentionedMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    NSArray<NSString *> *userIds = [self stringList:parameters[@"userIdList"]];
    if (userIds.count == 0) {
        completion(@"userIdList 不能为空。", NO);
        return;
    }
    RCTextMessage *content = [RCTextMessage messageWithContent:[self string:parameters key:@"content"]];
    content.mentionedInfo = [[RCMentionedInfo alloc] initWithMentionedType:RC_Mentioned_Users
                                                               userIdList:userIds
                                                         mentionedContent:[self nilIfEmpty:[self string:parameters key:@"pushContent"]]];
    NSString *targetId = [self string:parameters key:@"targetId"];
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    __block RCMessage *attachedMessage;
    if ([self conversationType:parameters] == ConversationType_ULTRAGROUP || channelId) {
        [RCChannelClient.sharedChannelManager sendMessage:[self conversationType:parameters]
                                                  targetId:targetId
                                                 channelId:channelId
                                                   content:content
                                               pushContent:[self nilIfEmpty:[self string:parameters key:@"pushContent"]]
                                                  pushData:[self nilIfEmpty:[self string:parameters key:@"pushData"]]
                                                    option:nil
                                               attached:^(RCMessage *message) { attachedMessage = message; self.currentMediaMessageId = message.messageId; }
                                                   success:^(long messageId) {
            completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self messageResult:attachedMessage]], YES);
        } error:^(RCErrorCode errorCode, long messageId) {
            completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self errorResult:errorCode]], NO);
        }];
        return;
    }
    [RCCoreClient.sharedCoreClient sendMessage:[self conversationType:parameters]
                                       targetId:targetId
                                        content:content
                                    pushContent:[self nilIfEmpty:[self string:parameters key:@"pushContent"]]
                                       pushData:[self nilIfEmpty:[self string:parameters key:@"pushData"]]
                                         option:nil
                                               attached:^(RCMessage *message) { attachedMessage = message; self.currentMediaMessageId = message.messageId; }
                                        success:^(long messageId) {
        completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self messageResult:attachedMessage]], YES);
    } error:^(RCErrorCode errorCode, long messageId) {
        completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self errorResult:errorCode]], NO);
    }];
}

/// 发送已上传的图片消息
/// 公开头文件：RCImageMessage.h、RCMediaMessageContent.h、RCCoreClient.h、RCChannelClient.h
/// SDK API：+messageWithImageURI:、RCMediaMessageContent.remoteUrl、-sendMessage:targetId:content:pushContent:pushData:option:attached:success:error:
- (void)sendRemoteImageMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    RCImageMessage *content = [RCImageMessage messageWithImageURI:[self string:parameters key:@"localPath"]];
    content.remoteUrl = [self string:parameters key:@"remoteUrl"];
    if (!content) {
        completion(@"RCImageMessage 创建失败，请检查 localPath。", NO);
        return;
    }
    NSString *targetId = [self string:parameters key:@"targetId"];
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    __block RCMessage *attachedMessage;
    if ([self conversationType:parameters] == ConversationType_ULTRAGROUP || channelId) {
        [RCChannelClient.sharedChannelManager sendMessage:[self conversationType:parameters] targetId:targetId channelId:channelId content:content
                                               pushContent:[self nilIfEmpty:[self string:parameters key:@"pushContent"]]
                                                  pushData:[self nilIfEmpty:[self string:parameters key:@"pushData"]] option:nil
                                               attached:^(RCMessage *message) { attachedMessage = message; self.currentMediaMessageId = message.messageId; }
                                                   success:^(long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self messageResult:attachedMessage]], YES); }
                                                     error:^(RCErrorCode errorCode, long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self errorResult:errorCode]], NO); }];
        return;
    }
    [RCCoreClient.sharedCoreClient sendMessage:[self conversationType:parameters] targetId:targetId content:content
                                    pushContent:[self nilIfEmpty:[self string:parameters key:@"pushContent"]]
                                       pushData:[self nilIfEmpty:[self string:parameters key:@"pushData"]] option:nil
                                               attached:^(RCMessage *message) { attachedMessage = message; self.currentMediaMessageId = message.messageId; }
                                        success:^(long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self messageResult:attachedMessage]], YES); }
                                          error:^(RCErrorCode errorCode, long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self errorResult:errorCode]], NO); }];
}

/// 发送由 SDK 上传的图片消息
/// 公开头文件：RCImageMessage.h、RCCoreClient.h、RCChannelClient.h
/// SDK API：+messageWithImageURI:、-sendMediaMessage:targetId:content:pushContent:pushData:attached:progress:success:error:cancel:
- (void)sendLocalImageMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    RCImageMessage *content = [RCImageMessage messageWithImageURI:[self string:parameters key:@"localPath"]];
    if (!content) {
        completion(@"RCImageMessage 创建失败，请检查 localPath。", NO);
        return;
    }
    NSString *targetId = [self string:parameters key:@"targetId"];
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    __block RCMessage *attachedMessage;
    if ([self conversationType:parameters] == ConversationType_ULTRAGROUP || channelId) {
        [RCChannelClient.sharedChannelManager sendMediaMessage:[self conversationType:parameters] targetId:targetId channelId:channelId content:content
                                                    pushContent:[self nilIfEmpty:[self string:parameters key:@"pushContent"]]
                                                       pushData:[self nilIfEmpty:[self string:parameters key:@"pushData"]]
                                               attached:^(RCMessage *message) { attachedMessage = message; self.currentMediaMessageId = message.messageId; }
                                                       progress:^(int progress, long messageId) { completion([NSString stringWithFormat:@"PROGRESS:上传进度 %d%%\nmessageId: %ld", progress, messageId], YES); }
                                                        success:^(long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self messageResult:attachedMessage]], YES); }
                                                          error:^(RCErrorCode errorCode, long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self errorResult:errorCode]], NO); }
                                                         cancel:^(long messageId) { completion([NSString stringWithFormat:@"媒体消息已取消\nmessageId: %ld", messageId], NO); }];
        return;
    }
    [RCCoreClient.sharedCoreClient sendMediaMessage:[self conversationType:parameters] targetId:targetId content:content
                                         pushContent:[self nilIfEmpty:[self string:parameters key:@"pushContent"]]
                                            pushData:[self nilIfEmpty:[self string:parameters key:@"pushData"]]
                                            attached:^(RCMessage *message) { attachedMessage = message; self.currentMediaMessageId = message.messageId; }
                                            progress:^(int progress, long messageId) { completion([NSString stringWithFormat:@"PROGRESS:上传进度 %d%%\nmessageId: %ld", progress, messageId], YES); }
                                             success:^(long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self messageResult:attachedMessage]], YES); }
                                               error:^(RCErrorCode errorCode, long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self errorResult:errorCode]], NO); }
                                              cancel:^(long messageId) { completion([NSString stringWithFormat:@"媒体消息已取消\nmessageId: %ld", messageId], NO); }];
}

/// 发送 GIF 消息
/// 公开头文件：RCGIFMessage.h、RCCoreClient.h、RCChannelClient.h
/// SDK API：+messageWithGIFURI:width:height:、-sendMediaMessage:targetId:content:pushContent:pushData:attached:progress:success:error:cancel:
- (void)sendGIFMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    RCGIFMessage *content = [RCGIFMessage messageWithGIFURI:[self string:parameters key:@"localPath"]
                                                      width:[parameters[@"width"] longLongValue]
                                                     height:[parameters[@"height"] longLongValue]];
    NSString *targetId = [self string:parameters key:@"targetId"];
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    __block RCMessage *attachedMessage;
    if ([self conversationType:parameters] == ConversationType_ULTRAGROUP || channelId) {
        [RCChannelClient.sharedChannelManager sendMediaMessage:[self conversationType:parameters] targetId:targetId channelId:channelId content:content
                                                    pushContent:[self nilIfEmpty:[self string:parameters key:@"pushContent"]] pushData:[self nilIfEmpty:[self string:parameters key:@"pushData"]]
                                            attached:^(RCMessage *message) { attachedMessage = message; self.currentMediaMessageId = message.messageId; }
                                                       progress:^(int progress, long messageId) { completion([NSString stringWithFormat:@"PROGRESS:上传进度 %d%%\nmessageId: %ld", progress, messageId], YES); }
                                                        success:^(long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self messageResult:attachedMessage]], YES); }
                                                          error:^(RCErrorCode errorCode, long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self errorResult:errorCode]], NO); }
                                                         cancel:^(long messageId) { completion([NSString stringWithFormat:@"媒体消息已取消\nmessageId: %ld", messageId], NO); }];
        return;
    }
    [RCCoreClient.sharedCoreClient sendMediaMessage:[self conversationType:parameters] targetId:targetId content:content
                                         pushContent:[self nilIfEmpty:[self string:parameters key:@"pushContent"]] pushData:[self nilIfEmpty:[self string:parameters key:@"pushData"]]
                                            attached:^(RCMessage *message) { attachedMessage = message; self.currentMediaMessageId = message.messageId; }
                                            progress:^(int progress, long messageId) { completion([NSString stringWithFormat:@"PROGRESS:上传进度 %d%%\nmessageId: %ld", progress, messageId], YES); }
                                             success:^(long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self messageResult:attachedMessage]], YES); }
                                               error:^(RCErrorCode errorCode, long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self errorResult:errorCode]], NO); }
                                              cancel:^(long messageId) { completion([NSString stringWithFormat:@"媒体消息已取消\nmessageId: %ld", messageId], NO); }];
}

/// 发送普通语音消息
/// 公开头文件：RCVoiceMessage.h、RCCoreClient.h、RCChannelClient.h
/// SDK API：+messageWithAudio:duration:、-sendMessage:targetId:content:pushContent:pushData:option:attached:success:error:
- (void)sendVoiceMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    NSData *audioData = [NSData dataWithContentsOfFile:[self string:parameters key:@"localPath"]];
    if (!audioData) {
        completion(@"无法读取 localPath 指向的 WAV 文件。", NO);
        return;
    }
    RCVoiceMessage *content = [RCVoiceMessage messageWithAudio:audioData duration:[parameters[@"duration"] longLongValue]];
    NSString *targetId = [self string:parameters key:@"targetId"];
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    __block RCMessage *attachedMessage;
    if ([self conversationType:parameters] == ConversationType_ULTRAGROUP || channelId) {
        [RCChannelClient.sharedChannelManager sendMessage:[self conversationType:parameters] targetId:targetId channelId:channelId content:content
                                               pushContent:[self nilIfEmpty:[self string:parameters key:@"pushContent"]] pushData:[self nilIfEmpty:[self string:parameters key:@"pushData"]] option:nil
                                               attached:^(RCMessage *message) { attachedMessage = message; self.currentMediaMessageId = message.messageId; }
                                                   success:^(long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self messageResult:attachedMessage]], YES); }
                                                     error:^(RCErrorCode errorCode, long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self errorResult:errorCode]], NO); }];
        return;
    }
    [RCCoreClient.sharedCoreClient sendMessage:[self conversationType:parameters] targetId:targetId content:content
                                    pushContent:[self nilIfEmpty:[self string:parameters key:@"pushContent"]] pushData:[self nilIfEmpty:[self string:parameters key:@"pushData"]] option:nil
                                            attached:^(RCMessage *message) { attachedMessage = message; self.currentMediaMessageId = message.messageId; }
                                        success:^(long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self messageResult:attachedMessage]], YES); }
                                          error:^(RCErrorCode errorCode, long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self errorResult:errorCode]], NO); }];
}

/// 发送高清语音消息
/// 公开头文件：RCHQVoiceMessage.h、RCCoreClient.h、RCChannelClient.h
/// SDK API：+messageWithPath:duration:、-sendMediaMessage:targetId:content:pushContent:pushData:attached:progress:success:error:cancel:
- (void)sendHQVoiceMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    RCHQVoiceMessage *content = [RCHQVoiceMessage messageWithPath:[self string:parameters key:@"localPath"] duration:[parameters[@"duration"] longLongValue]];
    NSString *targetId = [self string:parameters key:@"targetId"];
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    __block RCMessage *attachedMessage;
    if ([self conversationType:parameters] == ConversationType_ULTRAGROUP || channelId) {
        [RCChannelClient.sharedChannelManager sendMediaMessage:[self conversationType:parameters] targetId:targetId channelId:channelId content:content
                                                    pushContent:[self nilIfEmpty:[self string:parameters key:@"pushContent"]] pushData:[self nilIfEmpty:[self string:parameters key:@"pushData"]]
                                               attached:^(RCMessage *message) { attachedMessage = message; self.currentMediaMessageId = message.messageId; }
                                                       progress:^(int progress, long messageId) { completion([NSString stringWithFormat:@"PROGRESS:上传进度 %d%%\nmessageId: %ld", progress, messageId], YES); }
                                                        success:^(long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self messageResult:attachedMessage]], YES); }
                                                          error:^(RCErrorCode errorCode, long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self errorResult:errorCode]], NO); }
                                                         cancel:^(long messageId) { completion([NSString stringWithFormat:@"媒体消息已取消\nmessageId: %ld", messageId], NO); }];
        return;
    }
    [RCCoreClient.sharedCoreClient sendMediaMessage:[self conversationType:parameters] targetId:targetId content:content
                                         pushContent:[self nilIfEmpty:[self string:parameters key:@"pushContent"]] pushData:[self nilIfEmpty:[self string:parameters key:@"pushData"]]
                                            attached:^(RCMessage *message) { attachedMessage = message; self.currentMediaMessageId = message.messageId; }
                                            progress:^(int progress, long messageId) { completion([NSString stringWithFormat:@"PROGRESS:上传进度 %d%%\nmessageId: %ld", progress, messageId], YES); }
                                             success:^(long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self messageResult:attachedMessage]], YES); }
                                               error:^(RCErrorCode errorCode, long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self errorResult:errorCode]], NO); }
                                              cancel:^(long messageId) { completion([NSString stringWithFormat:@"媒体消息已取消\nmessageId: %ld", messageId], NO); }];
}

/// 发送已上传的文件消息
/// 公开头文件：RCFileMessage.h、RCMediaMessageContent.h、RCCoreClient.h、RCChannelClient.h
/// SDK API：+messageWithFile:、RCMediaMessageContent.remoteUrl、-sendMessage:targetId:content:pushContent:pushData:option:attached:success:error:
- (void)sendRemoteFileMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    RCFileMessage *content = [RCFileMessage messageWithFile:[self string:parameters key:@"localPath"]];
    content.remoteUrl = [self string:parameters key:@"remoteUrl"];
    content.fileUrl = content.remoteUrl;
    NSString *targetId = [self string:parameters key:@"targetId"];
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    __block RCMessage *attachedMessage;
    if ([self conversationType:parameters] == ConversationType_ULTRAGROUP || channelId) {
        [RCChannelClient.sharedChannelManager sendMessage:[self conversationType:parameters] targetId:targetId channelId:channelId content:content
                                               pushContent:[self nilIfEmpty:[self string:parameters key:@"pushContent"]] pushData:[self nilIfEmpty:[self string:parameters key:@"pushData"]] option:nil
                                            attached:^(RCMessage *message) { attachedMessage = message; self.currentMediaMessageId = message.messageId; }
                                                   success:^(long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self messageResult:attachedMessage]], YES); }
                                                     error:^(RCErrorCode errorCode, long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self errorResult:errorCode]], NO); }];
        return;
    }
    [RCCoreClient.sharedCoreClient sendMessage:[self conversationType:parameters] targetId:targetId content:content
                                    pushContent:[self nilIfEmpty:[self string:parameters key:@"pushContent"]] pushData:[self nilIfEmpty:[self string:parameters key:@"pushData"]] option:nil
                                               attached:^(RCMessage *message) { attachedMessage = message; self.currentMediaMessageId = message.messageId; }
                                        success:^(long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self messageResult:attachedMessage]], YES); }
                                          error:^(RCErrorCode errorCode, long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self errorResult:errorCode]], NO); }];
}

/// 发送由 SDK 上传的文件消息
/// 公开头文件：RCFileMessage.h、RCCoreClient.h、RCChannelClient.h
/// SDK API：+messageWithFile:、-sendMediaMessage:targetId:content:pushContent:pushData:attached:progress:success:error:cancel:
- (void)sendLocalFileMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    RCFileMessage *content = [RCFileMessage messageWithFile:[self string:parameters key:@"localPath"]];
    NSString *targetId = [self string:parameters key:@"targetId"];
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    __block RCMessage *attachedMessage;
    if ([self conversationType:parameters] == ConversationType_ULTRAGROUP || channelId) {
        [RCChannelClient.sharedChannelManager sendMediaMessage:[self conversationType:parameters] targetId:targetId channelId:channelId content:content
                                                    pushContent:[self nilIfEmpty:[self string:parameters key:@"pushContent"]] pushData:[self nilIfEmpty:[self string:parameters key:@"pushData"]]
                                            attached:^(RCMessage *message) { attachedMessage = message; self.currentMediaMessageId = message.messageId; }
                                                       progress:^(int progress, long messageId) { completion([NSString stringWithFormat:@"PROGRESS:上传进度 %d%%\nmessageId: %ld", progress, messageId], YES); }
                                                        success:^(long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self messageResult:attachedMessage]], YES); }
                                                          error:^(RCErrorCode errorCode, long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self errorResult:errorCode]], NO); }
                                                         cancel:^(long messageId) { completion([NSString stringWithFormat:@"媒体消息已取消\nmessageId: %ld", messageId], NO); }];
        return;
    }
    [RCCoreClient.sharedCoreClient sendMediaMessage:[self conversationType:parameters] targetId:targetId content:content
                                         pushContent:[self nilIfEmpty:[self string:parameters key:@"pushContent"]] pushData:[self nilIfEmpty:[self string:parameters key:@"pushData"]]
                                            attached:^(RCMessage *message) { attachedMessage = message; self.currentMediaMessageId = message.messageId; }
                                            progress:^(int progress, long messageId) { completion([NSString stringWithFormat:@"PROGRESS:上传进度 %d%%\nmessageId: %ld", progress, messageId], YES); }
                                             success:^(long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self messageResult:attachedMessage]], YES); }
                                               error:^(RCErrorCode errorCode, long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self errorResult:errorCode]], NO); }
                                              cancel:^(long messageId) { completion([NSString stringWithFormat:@"媒体消息已取消\nmessageId: %ld", messageId], NO); }];
}

/// 发送已上传的短视频消息
/// 公开头文件：RCSightMessage.h、RCMediaMessageContent.h、RCCoreClient.h、RCChannelClient.h
/// SDK API：+messageWithLocalPath:thumbnail:duration:、RCMediaMessageContent.remoteUrl、-sendMessage:targetId:content:pushContent:pushData:option:attached:success:error:
- (void)sendRemoteSightMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    UIImage *thumbnail = [UIImage systemImageNamed:@"video"] ?: [[UIImage alloc] init];
    RCSightMessage *content = [RCSightMessage messageWithLocalPath:[self string:parameters key:@"localPath"]
                                                          thumbnail:thumbnail
                                                           duration:[parameters[@"duration"] longLongValue]];
    content.remoteUrl = [self string:parameters key:@"remoteUrl"];
    NSString *targetId = [self string:parameters key:@"targetId"];
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    __block RCMessage *attachedMessage;
    if ([self conversationType:parameters] == ConversationType_ULTRAGROUP || channelId) {
        [RCChannelClient.sharedChannelManager sendMessage:[self conversationType:parameters] targetId:targetId channelId:channelId content:content
                                               pushContent:[self nilIfEmpty:[self string:parameters key:@"pushContent"]] pushData:[self nilIfEmpty:[self string:parameters key:@"pushData"]] option:nil
                                               attached:^(RCMessage *message) { attachedMessage = message; self.currentMediaMessageId = message.messageId; }
                                                   success:^(long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self messageResult:attachedMessage]], YES); }
                                                     error:^(RCErrorCode errorCode, long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self errorResult:errorCode]], NO); }];
        return;
    }
    [RCCoreClient.sharedCoreClient sendMessage:[self conversationType:parameters] targetId:targetId content:content
                                    pushContent:[self nilIfEmpty:[self string:parameters key:@"pushContent"]] pushData:[self nilIfEmpty:[self string:parameters key:@"pushData"]] option:nil
                                            attached:^(RCMessage *message) { attachedMessage = message; self.currentMediaMessageId = message.messageId; }
                                        success:^(long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self messageResult:attachedMessage]], YES); }
                                          error:^(RCErrorCode errorCode, long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self errorResult:errorCode]], NO); }];
}

/// 发送由 SDK 上传的短视频消息
/// 公开头文件：RCSightMessage.h、RCCoreClient.h、RCChannelClient.h
/// SDK API：+messageWithLocalPath:thumbnail:duration:、-sendMediaMessage:targetId:content:pushContent:pushData:attached:progress:success:error:cancel:
- (void)sendLocalSightMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    UIImage *thumbnail = [UIImage systemImageNamed:@"video"] ?: [[UIImage alloc] init];
    RCSightMessage *content = [RCSightMessage messageWithLocalPath:[self string:parameters key:@"localPath"]
                                                          thumbnail:thumbnail
                                                           duration:[parameters[@"duration"] longLongValue]];
    NSString *targetId = [self string:parameters key:@"targetId"];
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    __block RCMessage *attachedMessage;
    if ([self conversationType:parameters] == ConversationType_ULTRAGROUP || channelId) {
        [RCChannelClient.sharedChannelManager sendMediaMessage:[self conversationType:parameters] targetId:targetId channelId:channelId content:content
                                                    pushContent:[self nilIfEmpty:[self string:parameters key:@"pushContent"]] pushData:[self nilIfEmpty:[self string:parameters key:@"pushData"]]
                                               attached:^(RCMessage *message) { attachedMessage = message; self.currentMediaMessageId = message.messageId; }
                                                       progress:^(int progress, long messageId) { completion([NSString stringWithFormat:@"PROGRESS:上传进度 %d%%\nmessageId: %ld", progress, messageId], YES); }
                                                        success:^(long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self messageResult:attachedMessage]], YES); }
                                                          error:^(RCErrorCode errorCode, long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self errorResult:errorCode]], NO); }
                                                         cancel:^(long messageId) { completion([NSString stringWithFormat:@"媒体消息已取消\nmessageId: %ld", messageId], NO); }];
        return;
    }
    [RCCoreClient.sharedCoreClient sendMediaMessage:[self conversationType:parameters] targetId:targetId content:content
                                         pushContent:[self nilIfEmpty:[self string:parameters key:@"pushContent"]] pushData:[self nilIfEmpty:[self string:parameters key:@"pushData"]]
                                            attached:^(RCMessage *message) { attachedMessage = message; self.currentMediaMessageId = message.messageId; }
                                            progress:^(int progress, long messageId) { completion([NSString stringWithFormat:@"PROGRESS:上传进度 %d%%\nmessageId: %ld", progress, messageId], YES); }
                                             success:^(long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self messageResult:attachedMessage]], YES); }
                                               error:^(RCErrorCode errorCode, long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self errorResult:errorCode]], NO); }
                                              cancel:^(long messageId) { completion([NSString stringWithFormat:@"媒体消息已取消\nmessageId: %ld", messageId], NO); }];
}

/// 发送富文本消息
/// 公开头文件：RCRichContentMessage.h、RCCoreClient.h、RCChannelClient.h
/// SDK API：+messageWithTitle:digest:imageURL:url:extra:、-sendMessage:targetId:content:pushContent:pushData:option:attached:success:error:
- (void)sendRichContentMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    RCRichContentMessage *content = [RCRichContentMessage messageWithTitle:[self string:parameters key:@"title"]
                                                                    digest:[self string:parameters key:@"content"]
                                                                  imageURL:[self string:parameters key:@"imageUrl"]
                                                                       url:[self nilIfEmpty:[self string:parameters key:@"remoteUrl"]]
                                                                     extra:nil];
    NSString *targetId = [self string:parameters key:@"targetId"];
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    __block RCMessage *attachedMessage;
    if ([self conversationType:parameters] == ConversationType_ULTRAGROUP || channelId) {
        [RCChannelClient.sharedChannelManager sendMessage:[self conversationType:parameters] targetId:targetId channelId:channelId content:content
                                               pushContent:[self nilIfEmpty:[self string:parameters key:@"pushContent"]] pushData:[self nilIfEmpty:[self string:parameters key:@"pushData"]] option:nil
                                            attached:^(RCMessage *message) { attachedMessage = message; self.currentMediaMessageId = message.messageId; }
                                                   success:^(long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self messageResult:attachedMessage]], YES); }
                                                     error:^(RCErrorCode errorCode, long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self errorResult:errorCode]], NO); }];
        return;
    }
    [RCCoreClient.sharedCoreClient sendMessage:[self conversationType:parameters] targetId:targetId content:content
                                    pushContent:[self nilIfEmpty:[self string:parameters key:@"pushContent"]] pushData:[self nilIfEmpty:[self string:parameters key:@"pushData"]] option:nil
                                               attached:^(RCMessage *message) { attachedMessage = message; self.currentMediaMessageId = message.messageId; }
                                        success:^(long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self messageResult:attachedMessage]], YES); }
                                          error:^(RCErrorCode errorCode, long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self errorResult:errorCode]], NO); }];
}

/// 发送合并消息
/// 公开头文件：RCCombineMessage.h、RCCoreClient.h、RCChannelClient.h
/// SDK API：+messageWithSummaryList:nameList:conversationType:content:、-sendMediaMessage:targetId:content:pushContent:pushData:attached:progress:success:error:cancel:
- (void)sendCombineMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    RCCombineMessage *content = [RCCombineMessage messageWithSummaryList:[self stringList:parameters[@"summaryList"]]
                                                                 nameList:[self stringList:parameters[@"nameList"]]
                                                         conversationType:[self conversationType:parameters]
                                                                  content:[self string:parameters key:@"content"]];
    content.localPath = [self string:parameters key:@"localPath"];
    NSString *targetId = [self string:parameters key:@"targetId"];
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    __block RCMessage *attachedMessage;
    if ([self conversationType:parameters] == ConversationType_ULTRAGROUP || channelId) {
        [RCChannelClient.sharedChannelManager sendMediaMessage:[self conversationType:parameters] targetId:targetId channelId:channelId content:content
                                                    pushContent:[self nilIfEmpty:[self string:parameters key:@"pushContent"]] pushData:[self nilIfEmpty:[self string:parameters key:@"pushData"]]
                                            attached:^(RCMessage *message) { attachedMessage = message; self.currentMediaMessageId = message.messageId; }
                                                       progress:^(int progress, long messageId) { completion([NSString stringWithFormat:@"PROGRESS:上传进度 %d%%\nmessageId: %ld", progress, messageId], YES); }
                                                        success:^(long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self messageResult:attachedMessage]], YES); }
                                                          error:^(RCErrorCode errorCode, long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self errorResult:errorCode]], NO); }
                                                         cancel:^(long messageId) { completion([NSString stringWithFormat:@"媒体消息已取消\nmessageId: %ld", messageId], NO); }];
        return;
    }
    [RCCoreClient.sharedCoreClient sendMediaMessage:[self conversationType:parameters] targetId:targetId content:content
                                         pushContent:[self nilIfEmpty:[self string:parameters key:@"pushContent"]] pushData:[self nilIfEmpty:[self string:parameters key:@"pushData"]]
                                            attached:^(RCMessage *message) { attachedMessage = message; self.currentMediaMessageId = message.messageId; }
                                            progress:^(int progress, long messageId) { completion([NSString stringWithFormat:@"PROGRESS:上传进度 %d%%\nmessageId: %ld", progress, messageId], YES); }
                                             success:^(long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self messageResult:attachedMessage]], YES); }
                                               error:^(RCErrorCode errorCode, long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self errorResult:errorCode]], NO); }
                                              cancel:^(long messageId) { completion([NSString stringWithFormat:@"媒体消息已取消\nmessageId: %ld", messageId], NO); }];
}

/// 发送引用消息
/// 公开头文件：RCReferenceMessage.h、RCCoreClient.h、RCChannelClient.h
/// SDK API：-getMessageByUId:completion:、RCReferenceMessage、-sendMessage:targetId:content:pushContent:pushData:option:attached:success:error:
- (void)sendReferenceMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    NSString *messageUId = [self string:parameters key:@"messageUId"];
    [RCCoreClient.sharedCoreClient getMessageByUId:messageUId completion:^(RCMessage *message) {
        if (!message || !message.content) {
            completion(@"没有找到可引用的本地 RCMessage，请确认 messageUId。", NO);
            return;
        }
        RCReferenceMessage *content = [[RCReferenceMessage alloc] init];
        content.content = [self string:parameters key:@"content"];
        content.referMsgUserId = [self nilIfEmpty:[self string:parameters key:@"userId"]] ?: message.senderUserId ?: @"";
        content.referMsg = message.content;
        content.referMsgUid = message.messageUId ?: messageUId;
        NSString *targetId = [self string:parameters key:@"targetId"];
        NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
        __block RCMessage *attachedMessage;
        if ([self conversationType:parameters] == ConversationType_ULTRAGROUP || channelId) {
            [RCChannelClient.sharedChannelManager sendMessage:[self conversationType:parameters] targetId:targetId channelId:channelId content:content
                                                   pushContent:[self nilIfEmpty:[self string:parameters key:@"pushContent"]] pushData:[self nilIfEmpty:[self string:parameters key:@"pushData"]] option:nil
                                                      attached:^(RCMessage *sentMessage) { attachedMessage = sentMessage; }
                                                       success:^(long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self messageResult:attachedMessage]], YES); }
                                                         error:^(RCErrorCode errorCode, long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self errorResult:errorCode]], NO); }];
            return;
        }
        [RCCoreClient.sharedCoreClient sendMessage:[self conversationType:parameters] targetId:targetId content:content
                                        pushContent:[self nilIfEmpty:[self string:parameters key:@"pushContent"]] pushData:[self nilIfEmpty:[self string:parameters key:@"pushData"]] option:nil
                                           attached:^(RCMessage *sentMessage) { attachedMessage = sentMessage; }
                                            success:^(long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self messageResult:attachedMessage]], YES); }
                                              error:^(RCErrorCode errorCode, long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self errorResult:errorCode]], NO); }];
    }];
}

/// 发送定向消息
/// 公开头文件：RCCoreClient.h、RCChannelClient.h
/// SDK API：-sendDirectionalMessage:targetId:toUserIdList:content:pushContent:pushData:attached:success:error:，频道版增加 channelId 和 option
- (void)sendDirectionalMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    NSArray<NSString *> *userIds = [self stringList:parameters[@"userIdList"]];
    if (userIds.count == 0) {
        completion(@"userIdList 不能为空。", NO);
        return;
    }
    RCTextMessage *content = [RCTextMessage messageWithContent:[self string:parameters key:@"content"]];
    NSString *targetId = [self string:parameters key:@"targetId"];
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    __block RCMessage *attachedMessage;
    if ([self conversationType:parameters] == ConversationType_ULTRAGROUP || channelId) {
        [RCChannelClient.sharedChannelManager sendDirectionalMessage:[self conversationType:parameters]
                                                             targetId:targetId
                                                            channelId:channelId
                                                         toUserIdList:userIds
                                                              content:content
                                                          pushContent:[self nilIfEmpty:[self string:parameters key:@"pushContent"]]
                                                             pushData:[self nilIfEmpty:[self string:parameters key:@"pushData"]]
                                                               option:nil
                                               attached:^(RCMessage *message) { attachedMessage = message; self.currentMediaMessageId = message.messageId; }
                                                              success:^(long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self messageResult:attachedMessage]], YES); }
                                                                error:^(RCErrorCode errorCode, long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self errorResult:errorCode]], NO); }];
        return;
    }
    [RCCoreClient.sharedCoreClient sendDirectionalMessage:[self conversationType:parameters]
                                                  targetId:targetId
                                              toUserIdList:userIds
                                                   content:content
                                               pushContent:[self nilIfEmpty:[self string:parameters key:@"pushContent"]]
                                                  pushData:[self nilIfEmpty:[self string:parameters key:@"pushData"]]
                                            attached:^(RCMessage *message) { attachedMessage = message; self.currentMediaMessageId = message.messageId; }
                                                   success:^(long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self messageResult:attachedMessage]], YES); }
                                                     error:^(RCErrorCode errorCode, long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self errorResult:errorCode]], NO); }];
}

/// 发送自定义消息
/// 公开头文件：RCDemoCustomMessage.h、RCCoreClient.h、RCChannelClient.h
/// SDK API：+messageWithContent:、-sendMessage:targetId:content:pushContent:pushData:option:attached:success:error:
- (void)sendCustomMessage:(NSDictionary *)parameters completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    RCDemoCustomMessage *content = [RCDemoCustomMessage messageWithContent:[self string:parameters key:@"content"]];
    NSString *targetId = [self string:parameters key:@"targetId"];
    NSString *channelId = [self nilIfEmpty:[self string:parameters key:@"channelId"]];
    __block RCMessage *attachedMessage;
    if ([self conversationType:parameters] == ConversationType_ULTRAGROUP || channelId) {
        [RCChannelClient.sharedChannelManager sendMessage:[self conversationType:parameters] targetId:targetId channelId:channelId content:content
                                               pushContent:[self nilIfEmpty:[self string:parameters key:@"pushContent"]] pushData:[self nilIfEmpty:[self string:parameters key:@"pushData"]] option:nil
                                               attached:^(RCMessage *message) { attachedMessage = message; self.currentMediaMessageId = message.messageId; }
                                                   success:^(long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self messageResult:attachedMessage]], YES); }
                                                     error:^(RCErrorCode errorCode, long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self errorResult:errorCode]], NO); }];
        return;
    }
    [RCCoreClient.sharedCoreClient sendMessage:[self conversationType:parameters] targetId:targetId content:content
                                    pushContent:[self nilIfEmpty:[self string:parameters key:@"pushContent"]] pushData:[self nilIfEmpty:[self string:parameters key:@"pushData"]] option:nil
                                            attached:^(RCMessage *message) { attachedMessage = message; self.currentMediaMessageId = message.messageId; }
                                        success:^(long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self messageResult:attachedMessage]], YES); }
                                          error:^(RCErrorCode errorCode, long messageId) { completion([NSString stringWithFormat:@"messageId: %ld\n%@", messageId, [self errorResult:errorCode]], NO); }];
}

/// 注册自定义消息类型
/// 公开头文件：RCCoreClient.h
/// SDK API：-registerMessageType:
/// 前置条件：应在初始化 AppKey 后、连接 Token 前调用。
- (void)registerCustomMessage:(RCDemoIMLibCoreExecutionCompletion)completion {
    [RCCoreClient.sharedCoreClient registerMessageType:RCDemoCustomMessage.class];
    completion(@"RCDemoCustomMessage 已注册。", YES);
}

@end

