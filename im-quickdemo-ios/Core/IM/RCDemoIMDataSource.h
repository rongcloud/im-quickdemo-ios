//
//  RCDemoIMDataSource.h
//  im-quickdemo-ios
//
//  Created by pengwenxin on 2022/7/28.
//

#import <RongIMKit/RongIMKit.h>
NS_ASSUME_NONNULL_BEGIN

/// IMKit 用户、群组和群成员资料的数据源示例。
/// 登录页将该单例绑定给 `RCIM`；客户可在实现文件中替换为自己 App Server 的查询逻辑。
@interface RCDemoIMDataSource : NSObject <RCIMUserInfoDataSource, RCIMGroupInfoDataSource, RCIMGroupUserInfoDataSource, RCIMGroupMemberDataSource, RCIMReceiveMessageDelegate>

/// 返回供所有 IMKit 数据源协议共用的实例。
+ (instancetype)shared;


@end

NS_ASSUME_NONNULL_END
