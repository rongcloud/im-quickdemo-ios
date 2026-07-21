//
//  RCDemoConfiguration.h
//  im-quickdemo-ios
//
//  Created by pengwenxin on 2022/7/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Demo 运行参数的单一存取入口。
/// App Key、服务器地址和会话列表配置持久化到 UserDefaults；Token 仅保留在当前进程内。
@interface RCDemoConfiguration : NSObject

+ (instancetype)shared;

/// 从融云开发者平台创建应用后获取的 App Key，持久化到 UserDefaults。
@property (nonatomic, copy, nullable) NSString *appKey;

/// 从应用服务器获取的用户 Token。仅在当前进程内保存，不写入明文偏好存储。
@property (nonatomic, copy, nullable) NSString *token;

/// 当前连接成功的用户 ID。
@property (nonatomic, copy, nullable) NSString *userId;

- (void)setAppKey:(NSString * _Nonnull)appKey;

- (void)removeAppKey;

- (void)setToken:(NSString * _Nonnull)token;

- (void)removeToken;

- (void)setUserId:(NSString * _Nonnull)userId;

- (void)removeUserId;

/// 会话列表直接展示的会话类型。
@property (nonatomic, copy, nullable) NSArray<NSNumber *> *displayConversationTypeArray;

/// 会话列表聚合展示的会话类型。
@property (nonatomic, copy, nullable) NSArray<NSNumber *> *collectionConversationTypeArray;

- (void)setDisplayConversationTypeArray:(NSArray<NSNumber *> *)displayConversationTypeArray;

- (void)setCollectionConversationTypeArray:(NSArray<NSNumber *> *)collectionConversationTypeArray;

/// 私有云导航服务器地址。
@property (nonatomic, copy, nullable) NSString *naviServer;

/// 私有云文件服务器地址。
@property (nonatomic, copy, nullable) NSString *fileServer;

- (void)setNaviServer:(NSString *)naviServer;

- (void)setFileServer:(NSString *)fileServer;


@end

NS_ASSUME_NONNULL_END
