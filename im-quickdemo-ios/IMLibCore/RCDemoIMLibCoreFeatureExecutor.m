#import "RCDemoIMLibCoreFeatureExecutor+Internal.h"

@implementation RCDemoIMLibCoreFeatureExecutor

+ (instancetype)sharedExecutor {
    static RCDemoIMLibCoreFeatureExecutor *executor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        executor = [[self alloc] init];
    });
    return executor;
}

- (void)executeFeature:(RCDemoIMLibCoreFeature *)feature
             parameters:(NSDictionary<NSString *, id> *)parameters
              completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    if (feature.action <= RCDemoIMLibCoreFeatureActionGetConversationMentionedCount) {
        [self executeConversationFeature:feature parameters:parameters completion:completion];
    } else if (feature.action <= RCDemoIMLibCoreFeatureActionRegisterCustomMessage) {
        [self executeMessageSendFeature:feature parameters:parameters completion:completion];
    } else if (feature.action <= RCDemoIMLibCoreFeatureActionSetDuplicateCheck) {
        [self executeMessageOperationFeature:feature parameters:parameters completion:completion];
    } else {
        [self executeMessageHistoryFeature:feature parameters:parameters completion:completion];
    }
}

@end

@implementation RCDemoIMLibCoreFeatureExecutor (Utilities)

- (NSString *)string:(NSDictionary *)parameters key:(NSString *)key {
    id value = parameters[key];
    if ([value isKindOfClass:NSString.class]) {
        return [value stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    }
    return [value description] ?: @"";
}

- (nullable NSString *)nilIfEmpty:(NSString *)value {
    return value.length > 0 ? value : nil;
}

- (NSArray<NSString *> *)stringList:(id)value {
    if ([value isKindOfClass:NSArray.class]) return value;
    NSMutableArray<NSString *> *items = [NSMutableArray array];
    for (NSString *part in [[value description] componentsSeparatedByString:@","]) {
        NSString *item = [part stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
        if (item.length > 0) [items addObject:item];
    }
    return items;
}

- (NSArray<NSNumber *> *)numberList:(id)value defaultValues:(NSArray<NSNumber *> *)defaultValues {
    NSArray<NSString *> *strings = [self stringList:value];
    if (strings.count == 0) return defaultValues;
    NSMutableArray<NSNumber *> *numbers = [NSMutableArray array];
    for (NSString *string in strings) [numbers addObject:@(string.integerValue)];
    return numbers;
}

- (RCConversationType)conversationType:(NSDictionary *)parameters {
    return (RCConversationType)[parameters[@"conversationType"] integerValue];
}

- (nullable NSDictionary<NSString *, NSString *> *)jsonStringDictionary:(id)value
                                                              completion:(RCDemoIMLibCoreExecutionCompletion)completion {
    NSString *json = [value isKindOfClass:NSString.class] ? value : @"{}";
    NSError *error;
    id object = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
                                                options:0
                                                  error:&error];
    if (![object isKindOfClass:NSDictionary.class]) {
        completion([NSString stringWithFormat:@"JSON 参数解析失败：%@", error.localizedDescription ?: @"根对象必须是字典"], NO);
        return nil;
    }
    for (id key in [object allKeys]) {
        if (![key isKindOfClass:NSString.class] || ![object[key] isKindOfClass:NSString.class]) {
            completion(@"JSON 的 key 和 value 都必须是字符串。", NO);
            return nil;
        }
    }
    return object;
}

- (RCReceivedStatusInfo *)receivedStatusInfo:(NSDictionary *)parameters {
    RCReceivedStatusInfo *statusInfo = [[RCReceivedStatusInfo alloc] initWithReceivedStatus:0];
    if ([parameters[@"isRead"] boolValue]) [statusInfo markAsRead];
    if ([parameters[@"isListened"] boolValue]) [statusInfo markAsListened];
    if ([parameters[@"isDownloaded"] boolValue]) [statusInfo markAsDownloaded];
    return statusInfo;
}

- (NSString *)errorResult:(NSInteger)errorCode {
    return [NSString stringWithFormat:@"SDK errorCode: %ld", (long)errorCode];
}

- (NSString *)conversationListResult:(NSArray<RCConversation *> *)conversations {
    NSMutableArray<NSString *> *lines = [NSMutableArray array];
    for (RCConversation *conversation in conversations) {
        [lines addObject:[NSString stringWithFormat:@"type=%lu, targetId=%@, channelId=%@, unread=%d, top=%@, sentTime=%lld",
                          (unsigned long)conversation.conversationType,
                          conversation.targetId,
                          conversation.channelId ?: @"",
                          conversation.unreadMessageCount,
                          conversation.isTop ? @"YES" : @"NO",
                          conversation.sentTime]];
    }
    return [NSString stringWithFormat:@"count: %lu\n%@", (unsigned long)conversations.count, [lines componentsJoinedByString:@"\n"]];
}

- (NSString *)messageResult:(RCMessage *)message {
    if (!message) return @"message: <nil>";
    return [NSString stringWithFormat:@"messageId: %ld\nmessageUId: %@\ntype: %lu\ntargetId: %@\nchannelId: %@\ndirection: %lu\nobjectName: %@\nsenderUserId: %@\nsentTime: %lld\nsentStatus: %lu",
            message.messageId,
            message.messageUId ?: @"",
            (unsigned long)message.conversationType,
            message.targetId ?: @"",
            message.channelId ?: @"",
            (unsigned long)message.messageDirection,
            message.objectName ?: @"",
            message.senderUserId ?: @"",
            message.sentTime,
            (unsigned long)message.sentStatus];
}

- (NSString *)messageListResult:(NSArray<RCMessage *> *)messages {
    NSMutableArray<NSString *> *lines = [NSMutableArray array];
    for (RCMessage *message in messages) [lines addObject:[self messageResult:message]];
    return [NSString stringWithFormat:@"count: %lu\n\n%@", (unsigned long)messages.count, [lines componentsJoinedByString:@"\n---\n"]];
}

- (void)messagesForUIds:(NSArray<NSString *> *)messageUIds completion:(void (^)(NSArray<RCMessage *> *))completion {
    if (messageUIds.count == 0) {
        completion(@[]);
        return;
    }
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("io.rong.demo.imlibcore.messages", DISPATCH_QUEUE_SERIAL);
    NSMutableArray<RCMessage *> *messages = [NSMutableArray array];
    for (NSString *messageUId in messageUIds) {
        dispatch_group_enter(group);
        [RCCoreClient.sharedCoreClient getMessageByUId:messageUId completion:^(RCMessage *message) {
            if (message) dispatch_async(queue, ^{ [messages addObject:message]; });
            dispatch_group_leave(group);
        }];
    }
    dispatch_group_notify(group, queue, ^{ completion(messages.copy); });
}

- (void)emitEvent:(NSString *)event {
    NSLog(@"[IMLibCore] %@", event);
    if (self.eventCompletion) self.eventCompletion(event, YES);
}

@end

