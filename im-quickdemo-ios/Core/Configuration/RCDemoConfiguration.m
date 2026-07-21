//
//  RCDemoConfiguration.m
//  im-quickdemo-ios
//
//  Created by pengwenxin on 2022/7/25.
//

#import "RCDemoConfiguration.h"

static NSString * const RCDemoAppKeyDefaultsKey = @"appKey";
static NSString * const RCDemoTokenDefaultsKey = @"token";
static NSString * const RCDemoUserIdDefaultsKey = @"userId";
static NSString * const RCDemoDisplayConversationTypesDefaultsKey = @"displayConversationTypeArray";
static NSString * const RCDemoCollectionConversationTypesDefaultsKey = @"collectionConversationTypeArray";
static NSString * const RCDemoNaviServerDefaultsKey = @"naviServer";
static NSString * const RCDemoFileServerDefaultsKey = @"fileServer";

@interface RCDemoConfiguration ()

@property (nonatomic, copy, nullable) NSString *sessionToken;

@end

@implementation RCDemoConfiguration

+ (instancetype)shared {
    static RCDemoConfiguration *_sharedGlobalConfig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedGlobalConfig = [[RCDemoConfiguration alloc] init];
        // 清理旧版本曾写入 UserDefaults 的明文 token。
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:RCDemoTokenDefaultsKey];
    });
    return _sharedGlobalConfig;
}

- (void)setAppKey:(NSString *)appKey {
    if (appKey.length == 0) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:RCDemoAppKeyDefaultsKey];
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:appKey forKey:RCDemoAppKeyDefaultsKey];
}

- (NSString *)appKey {
    return [[NSUserDefaults standardUserDefaults] objectForKey:RCDemoAppKeyDefaultsKey];
}

- (void)removeAppKey {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:RCDemoAppKeyDefaultsKey];
}

- (void)setToken:(NSString *)token {
    self.sessionToken = token.length > 0 ? token : nil;
}

- (NSString *)token {
    return self.sessionToken;
}

- (void)removeToken {
    self.sessionToken = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:RCDemoTokenDefaultsKey];
}

- (void)setUserId:(NSString *)userId {
    if (userId.length == 0) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:RCDemoUserIdDefaultsKey];
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:RCDemoUserIdDefaultsKey];
}

- (NSString *)userId {
    return [[NSUserDefaults standardUserDefaults] objectForKey:RCDemoUserIdDefaultsKey];
}

- (void)removeUserId {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:RCDemoUserIdDefaultsKey];
}

- (void)setDisplayConversationTypeArray:(NSArray<NSNumber *> *)displayConversationTypeArray {
    if (displayConversationTypeArray.count == 0) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:displayConversationTypeArray forKey:RCDemoDisplayConversationTypesDefaultsKey];
}

- (NSArray<NSNumber *> *)displayConversationTypeArray {
    return [[NSUserDefaults standardUserDefaults] objectForKey:RCDemoDisplayConversationTypesDefaultsKey];
}

- (void)setCollectionConversationTypeArray:(NSArray<NSNumber *> *)collectionConversationTypeArray {
    if (collectionConversationTypeArray.count == 0) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:collectionConversationTypeArray forKey:RCDemoCollectionConversationTypesDefaultsKey];
}

- (NSArray<NSNumber *> *)collectionConversationTypeArray {
    return [[NSUserDefaults standardUserDefaults] objectForKey:RCDemoCollectionConversationTypesDefaultsKey];
}

- (void)setNaviServer:(NSString *)naviServer {
    if (naviServer.length == 0) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:RCDemoNaviServerDefaultsKey];
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:naviServer forKey:RCDemoNaviServerDefaultsKey];
}

- (NSString *)naviServer {
    return [[NSUserDefaults standardUserDefaults] objectForKey:RCDemoNaviServerDefaultsKey];
}

- (void)setFileServer:(NSString *)fileServer {
    if (fileServer.length == 0) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:RCDemoFileServerDefaultsKey];
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:fileServer forKey:RCDemoFileServerDefaultsKey];
}

- (NSString *)fileServer {
    return [[NSUserDefaults standardUserDefaults] objectForKey:RCDemoFileServerDefaultsKey];
}

@end
