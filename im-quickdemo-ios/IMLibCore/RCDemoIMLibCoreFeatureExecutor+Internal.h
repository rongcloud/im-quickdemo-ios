#import "RCDemoIMLibCoreFeatureExecutor.h"
#import "RCDemoIMLibCoreFeature.h"
#import <RongIMLibCore/RongIMLibCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCDemoIMLibCoreFeatureExecutor ()
@property (nonatomic, copy, nullable) RCDemoIMLibCoreExecutionCompletion eventCompletion;
@property (nonatomic, assign) BOOL receiveMessageListening;
@property (nonatomic, assign) long currentMediaMessageId;
@end

@interface RCDemoIMLibCoreFeatureExecutor (Conversation)
- (void)executeConversationFeature:(RCDemoIMLibCoreFeature *)feature
                         parameters:(NSDictionary<NSString *, id> *)parameters
                         completion:(RCDemoIMLibCoreExecutionCompletion)completion;
@end

@interface RCDemoIMLibCoreFeatureExecutor (MessageSend)
- (void)executeMessageSendFeature:(RCDemoIMLibCoreFeature *)feature
                        parameters:(NSDictionary<NSString *, id> *)parameters
                        completion:(RCDemoIMLibCoreExecutionCompletion)completion;
@end

@interface RCDemoIMLibCoreFeatureExecutor (MessageOperation)
- (void)executeMessageOperationFeature:(RCDemoIMLibCoreFeature *)feature
                             parameters:(NSDictionary<NSString *, id> *)parameters
                             completion:(RCDemoIMLibCoreExecutionCompletion)completion;
@end

@interface RCDemoIMLibCoreFeatureExecutor (MessageHistory) <RCIMClientReceiveMessageDelegate>
- (void)executeMessageHistoryFeature:(RCDemoIMLibCoreFeature *)feature
                           parameters:(NSDictionary<NSString *, id> *)parameters
                           completion:(RCDemoIMLibCoreExecutionCompletion)completion;
@end

@interface RCDemoIMLibCoreFeatureExecutor (Utilities)
- (NSString *)string:(NSDictionary *)parameters key:(NSString *)key;
- (nullable NSString *)nilIfEmpty:(NSString *)value;
- (NSArray<NSString *> *)stringList:(id)value;
- (NSArray<NSNumber *> *)numberList:(id)value defaultValues:(NSArray<NSNumber *> *)defaultValues;
- (RCConversationType)conversationType:(NSDictionary *)parameters;
- (nullable NSDictionary<NSString *, NSString *> *)jsonStringDictionary:(id)value
                                                              completion:(RCDemoIMLibCoreExecutionCompletion)completion;
- (RCReceivedStatusInfo *)receivedStatusInfo:(NSDictionary *)parameters;
- (NSString *)errorResult:(NSInteger)errorCode;
- (NSString *)conversationListResult:(NSArray<RCConversation *> *)conversations;
- (NSString *)messageResult:(nullable RCMessage *)message;
- (NSString *)messageListResult:(NSArray<RCMessage *> *)messages;
- (void)messagesForUIds:(NSArray<NSString *> *)messageUIds
              completion:(void (^)(NSArray<RCMessage *> *messages))completion;
- (void)emitEvent:(NSString *)event;
@end

NS_ASSUME_NONNULL_END

