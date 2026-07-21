//
//  RCDemoSettingsModel.h
//  im-quickdemo-ios
//
//  Created by pengwenxin on 2022/7/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const RCDemoSettingsMuteNotificationsItemIdentifier;
FOUNDATION_EXPORT NSString * const RCDemoSettingsShowPushContentItemIdentifier;
FOUNDATION_EXPORT NSString * const RCDemoSettingsPushLanguageItemIdentifier;

@class RCDemoSettingsHeaderModel;
@class RCDemoSettingsItemModel;

/// 设置页的展示模型，包含用户头部信息和可操作的 SDK 设置项。
@interface RCDemoSettingsModel : NSObject

@property (nonatomic, strong) RCDemoSettingsHeaderModel *headerModel;
@property (nonatomic, copy) NSArray<RCDemoSettingsItemModel *> *items;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

/// 设置页顶部展示的当前用户资料。
@interface RCDemoSettingsHeaderModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *portraitUri;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

/// 单个设置项的标题、当前值和稳定标识；标识用于映射到具体 SDK 调用。
@interface RCDemoSettingsItemModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *identifier;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END
