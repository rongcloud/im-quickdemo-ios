#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, RCDemoIMLibCoreFeatureAction) {
    RCDemoIMLibCoreFeatureActionGetConversationList,
    RCDemoIMLibCoreFeatureActionGetConversationListPage,
    RCDemoIMLibCoreFeatureActionGetConversationListForAllChannelsPage,
    RCDemoIMLibCoreFeatureActionGetConversationListForChannel,
    RCDemoIMLibCoreFeatureActionGetConversationListForAllChannels,
    RCDemoIMLibCoreFeatureActionRemoveConversation,
    RCDemoIMLibCoreFeatureActionSetConversationTop,
    RCDemoIMLibCoreFeatureActionGetTopConversationList,
    RCDemoIMLibCoreFeatureActionSetLegacyNotificationStatus,
    RCDemoIMLibCoreFeatureActionSetNotificationLevel,
    RCDemoIMLibCoreFeatureActionGetLegacyNotificationStatus,
    RCDemoIMLibCoreFeatureActionGetNotificationLevel,
    RCDemoIMLibCoreFeatureActionGetBlockedConversationList,
    RCDemoIMLibCoreFeatureActionGetUnreadConversationList,
    RCDemoIMLibCoreFeatureActionSaveDraft,
    RCDemoIMLibCoreFeatureActionGetDraft,
    RCDemoIMLibCoreFeatureActionClearDraft,
    RCDemoIMLibCoreFeatureActionGetConversationUnreadCount,
    RCDemoIMLibCoreFeatureActionGetTotalUnreadCount,
    RCDemoIMLibCoreFeatureActionClearConversationUnread,
    RCDemoIMLibCoreFeatureActionClearConversationUnreadByTime,
    RCDemoIMLibCoreFeatureActionGetUnreadCountByLevels,
    RCDemoIMLibCoreFeatureActionGetMentionedUnreadCountByLevels,
    RCDemoIMLibCoreFeatureActionGetConversationMentionedCount,

    RCDemoIMLibCoreFeatureActionSendTextMessage,
    RCDemoIMLibCoreFeatureActionSendMentionedMessage,
    RCDemoIMLibCoreFeatureActionSendRemoteImageMessage,
    RCDemoIMLibCoreFeatureActionSendLocalImageMessage,
    RCDemoIMLibCoreFeatureActionSendGIFMessage,
    RCDemoIMLibCoreFeatureActionSendVoiceMessage,
    RCDemoIMLibCoreFeatureActionSendHQVoiceMessage,
    RCDemoIMLibCoreFeatureActionSendRemoteFileMessage,
    RCDemoIMLibCoreFeatureActionSendLocalFileMessage,
    RCDemoIMLibCoreFeatureActionSendRemoteSightMessage,
    RCDemoIMLibCoreFeatureActionSendLocalSightMessage,
    RCDemoIMLibCoreFeatureActionSendRichContentMessage,
    RCDemoIMLibCoreFeatureActionSendCombineMessage,
    RCDemoIMLibCoreFeatureActionSendReferenceMessage,
    RCDemoIMLibCoreFeatureActionSendDirectionalMessage,
    RCDemoIMLibCoreFeatureActionSendCustomMessage,
    RCDemoIMLibCoreFeatureActionRegisterCustomMessage,

    RCDemoIMLibCoreFeatureActionRecallMessage,
    RCDemoIMLibCoreFeatureActionDeleteRemoteMessages,
    RCDemoIMLibCoreFeatureActionClearRemoteHistory,
    RCDemoIMLibCoreFeatureActionDeleteLocalMessages,
    RCDemoIMLibCoreFeatureActionClearLocalHistoryBeforeTime,
    RCDemoIMLibCoreFeatureActionClearConversationMessages,
    RCDemoIMLibCoreFeatureActionSetMessageSentStatus,
    RCDemoIMLibCoreFeatureActionSetMessageReceivedStatus,
    RCDemoIMLibCoreFeatureActionBatchInsertMessage,
    RCDemoIMLibCoreFeatureActionInsertMessage,
    RCDemoIMLibCoreFeatureActionSetDuplicateCheck,

    RCDemoIMLibCoreFeatureActionListenReceiveMessage,
    RCDemoIMLibCoreFeatureActionGetLocalHistory,
    RCDemoIMLibCoreFeatureActionGetRemoteHistory,
    RCDemoIMLibCoreFeatureActionGetFirstUnreadMessage,
    RCDemoIMLibCoreFeatureActionGetHistoryByMessageTypes,
    RCDemoIMLibCoreFeatureActionGetMessage,
    RCDemoIMLibCoreFeatureActionGetMessageCount,
    RCDemoIMLibCoreFeatureActionGetUnreadMentionedMessages,
    RCDemoIMLibCoreFeatureActionSetReadBeforeTime,
};

@interface RCDemoIMLibCoreFeature : NSObject

@property (nonatomic, assign, readonly) RCDemoIMLibCoreFeatureAction action;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *api;
@property (nonatomic, copy, readonly) NSString *note;
@property (nonatomic, copy, readonly) NSArray<NSString *> *parameterKeys;
@property (nonatomic, assign, readonly, getter=isDangerous) BOOL dangerous;

+ (instancetype)featureWithAction:(RCDemoIMLibCoreFeatureAction)action
                            title:(NSString *)title
                              api:(NSString *)api
                    parameterKeys:(NSArray<NSString *> *)parameterKeys
                        dangerous:(BOOL)dangerous
                             note:(NSString *)note;

@end

@interface RCDemoIMLibCoreFeatureGroup : NSObject

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSArray<RCDemoIMLibCoreFeature *> *features;
@property (nonatomic, assign, getter=isExpanded) BOOL expanded;

+ (instancetype)groupWithTitle:(NSString *)title features:(NSArray<RCDemoIMLibCoreFeature *> *)features;

@end

NS_ASSUME_NONNULL_END

