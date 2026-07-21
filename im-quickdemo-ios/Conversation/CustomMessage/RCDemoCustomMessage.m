//
//  RCDemoCustomMessage.m
//  im-quickdemo-ios
//
//  Created by 于艳平 on 2022/7/30.
//

#import "RCDemoCustomMessage.h"
#import "RCDemoMessageConstants.h"

@implementation RCDemoCustomMessage

+ (instancetype)messageWithContent:(NSString *)content {
    RCDemoCustomMessage *msg = [[RCDemoCustomMessage alloc] init];
    if (msg) {
        msg.content = content;
    }
    return msg;
}

/// 自定义消息需要存入本地历史记录，并计入会话未读数。
+ (RCMessagePersistent)persistentFlag {
    return (MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.extra = [aDecoder decodeObjectForKey:@"extra"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.extra forKey:@"extra"];
}

- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:self.content forKey:@"content"];
    if (self.extra) {
        [dataDict setObject:self.extra forKey:@"extra"];
    }

    if (self.senderUserInfo) {
        [dataDict setObject:[self encodeUserInfo:self.senderUserInfo] forKey:@"user"];
    }

    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:kNilOptions error:nil];
    return data;
}

- (void)decodeWithData:(NSData *)data {
    if (data) {
        __autoreleasing NSError *error = nil;

        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

        if (dictionary) {
            self.content = dictionary[@"content"];
            self.extra = dictionary[@"extra"];

            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}

- (NSString *)conversationDigest {
    return self.content;
}

+ (NSString *)getObjectName {
    return RCDemoCustomMessageTypeIdentifier;
}

@end
