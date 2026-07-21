//
//  RCDemoIMDataSource.m
//  im-quickdemo-ios
//
//  Created by pengwenxin on 2022/7/28.
//

#import "RCDemoIMDataSource.h"

@implementation RCDemoIMDataSource

+ (instancetype)shared {
    static RCDemoIMDataSource *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

#pragma mark - RCIMGroupInfoDataSource

- (void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *groupInfo))completion {
    // 实际项目应异步请求 App Server；任何分支都必须执行 completion。
    if (groupId.length == 0) {
        completion(nil);
        return;
    }
    RCGroup *groupInfoModel = [[RCGroup alloc] init];
    groupInfoModel.groupName = [NSString stringWithFormat:@"群组 %@", groupId];
    groupInfoModel.groupId = groupId;
    completion(groupInfoModel);
}

#pragma mark - RCIMUserInfoDataSource

- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *userInfo))completion {
    if (userId.length == 0) {
        completion(nil);
        return;
    }
    RCUserInfo *userInfoModel = [[RCUserInfo alloc] init];
    userInfoModel.userId = userId;
    userInfoModel.name = [NSString stringWithFormat:@"用户 %@", userId];
    completion(userInfoModel);
}

#pragma mark - RCIMGroupUserInfoDataSource

- (void)getUserInfoWithUserId:(NSString *)userId
                      inGroup:(NSString *)groupId
                   completion:(void (^)(RCUserInfo *userInfo))completion {
    // Demo 未提供群名片服务，返回 nil 后 IMKit 会回退到全局用户信息。
    completion(nil);
}

#pragma mark - RCIMGroupMemberDataSource

- (void)getAllMembersOfGroup:(NSString *)groupId result:(void (^)(NSArray<NSString *> *))resultBlock {
    // 实际项目应从 App Server 获取成员 ID；空数组也必须回调。
    resultBlock(@[]);
}

#pragma mark - RCIMReceiveMessageDelegate

- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    NSLog(@"收到消息 messageId=%ld，剩余=%d", message.messageId, left);
}
@end
