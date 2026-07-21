//
//  RCDemoCustomMediaMessage.m
//  im-quickdemo-ios
//
//  Created by 于艳平 on 2022/7/31.
//

#import "RCDemoCustomMediaMessage.h"
#import "RCDemoMessageConstants.h"
#import <objc/runtime.h>

static UIImage *RCDemoGenerateThumbnailImage(UIImage *originalImage);

static UIImage *RCDemoGenerateThumbnailImage(UIImage *originalImage) {
    return [RCUtilities generateThumbnailByConfig:originalImage];
}

@interface RCDemoCustomMediaMessage ()
@property (nonatomic, copy) NSString *thumbnailBase64String;
@end

@implementation RCDemoCustomMediaMessage

+ (instancetype)messageWithLocalPath:(NSString *)localPath {
    RCDemoCustomMediaMessage *message = [[RCDemoCustomMediaMessage alloc] init];
    if (message) {
        message.localPath = localPath ? localPath : @"";
        UIImage *originalImage = [UIImage imageWithContentsOfFile:localPath];
        message.thumbnailImage = RCDemoGenerateThumbnailImage(originalImage);
    }
    return message;
}
/// 自定义媒体消息需要存入本地历史记录，并计入会话未读数。
+ (RCMessagePersistent)persistentFlag {
    return (MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.thumbnailImage = [aDecoder decodeObjectForKey:@"thumbnailImage"];
        self.extra = [aDecoder decodeObjectForKey:@"extra"];
        self.localPath = [aDecoder decodeObjectForKey:@"localPath"];
        self.remoteUrl = [aDecoder decodeObjectForKey:@"remoteUrl"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.thumbnailImage forKey:@"thumbnailImage"];
    [aCoder encodeObject:self.extra forKey:@"extra"];
    [aCoder encodeObject:self.localPath forKey:@"localPath"];
    [aCoder encodeObject:self.remoteUrl forKey:@"remoteUrl"];
}

- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    NSData *imageData = UIImageJPEGRepresentation(self.thumbnailImage, 0.3);
    NSString *thumbnailBase64String = nil;
    if ([imageData respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
        thumbnailBase64String = [imageData base64EncodedStringWithOptions:kNilOptions];
    } else {
        thumbnailBase64String = [RCUtilities base64EncodedStringFrom:imageData];
    }
    
    if (thumbnailBase64String) {
        [dataDict setObject:thumbnailBase64String forKey:@"content"];
    }
    
    if (self.extra) {
        [dataDict setObject:self.extra forKey:@"extra"];
    }
    if (self.senderUserInfo) {
        [dataDict setObject:[self encodeUserInfo:self.senderUserInfo] forKey:@"user"];
    }
    if (self.localPath.length > 0) {
        [dataDict setObject:self.localPath forKey:@"localPath"];
    }
    if (self.remoteUrl.length > 0) {
        [dataDict setObject:self.remoteUrl forKey:@"remoteUrl"];
    }

    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:kNilOptions error:nil];
    return data;
}

- (void)decodeWithData:(NSData *)data {
    if (data) {
        __autoreleasing NSError *error = nil;

        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

        if (dictionary) {
            self.extra = dictionary[@"extra"];
            self.thumbnailBase64String = dictionary[@"content"];
            self.localPath = dictionary[@"localPath"];
            self.remoteUrl = dictionary[@"remoteUrl"];
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}

- (UIImage *)thumbnailImage {
    if (!_thumbnailImage) {
        if (self.thumbnailBase64String) {
            NSData *imageData = nil;
            if (class_getInstanceMethod([NSData class], @selector(initWithBase64EncodedString:options:))) {
                imageData = [[NSData alloc] initWithBase64EncodedString:self.thumbnailBase64String
                                                                options:NSDataBase64DecodingIgnoreUnknownCharacters];
            } else {
                imageData = [RCUtilities dataWithBase64EncodedString:self.thumbnailBase64String];
            }
            self.thumbnailImage = [UIImage imageWithData:imageData];
        } else {
            RCLogI(@"[RCDemo] 自定义媒体消息缺少缩略图数据");
        }
    }
    return _thumbnailImage;
}

- (NSString *)conversationDigest {
    return @"自定义媒体消息";
}

+ (NSString *)getObjectName {
    return RCDemoCustomMediaMessageTypeIdentifier;
}
@end
