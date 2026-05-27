//
//  AppGlobalConfig.h
//  support-im-ios-debugdemo
//
//  Created by pengwenxin on 2022/7/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppGlobalConfig : NSObject

+ (instancetype)shareInstance;
//appKey  从融云开发者平台创建应用后获取到的 App Key
@property (nonatomic, strong) NSString * appKey;

//token   从您服务器端获取的 token (用户身份令牌)
@property (nonatomic, strong) NSString * token;

//userId  当前连接成功所用的用户 ID
@property (nonatomic, strong) NSString * userId;

- (void)setAppKey:(NSString * _Nonnull)appKey;

- (void)removeAppkey;

- (void)setToken:(NSString * _Nonnull)token;

- (void)removeToken;

- (void)setUserId:(NSString * _Nonnull)userId;

- (void)removeUserId;
/*!
    的会话类型数组
 */
@property (nonatomic, strong) NSArray* displayConversationTypeArray;
/*!
    聚合为会话类型数组
 */
@property (nonatomic, strong) NSArray *collectionConversationTypeArray;

- (void)setDisplayConversationTypeArray:(NSArray * _Nonnull)displayConversationTypeArray;

- (void)setCollectionConversationTypeArray:(NSArray * _Nonnull)collectionConversationTypeArray;

//导航服务器地址
@property (nonatomic, strong) NSString * naviServer;
//文件服务器地址
@property (nonatomic, strong) NSString * fileServer;

- (void)setNaviServer:(NSString * _Nonnull)naviServer;

- (void)setFileServer:(NSString * _Nonnull)fileServer;


@end

NS_ASSUME_NONNULL_END
