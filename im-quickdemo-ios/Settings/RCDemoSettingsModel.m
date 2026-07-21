//
//  RCDemoSettingsModel.m
//  im-quickdemo-ios
//
//  Created by pengwenxin on 2022/7/13.
//

#import "RCDemoSettingsModel.h"

NSString * const RCDemoSettingsMuteNotificationsItemIdentifier = @"101";
NSString * const RCDemoSettingsShowPushContentItemIdentifier = @"102";
NSString * const RCDemoSettingsPushLanguageItemIdentifier = @"103";

@implementation RCDemoSettingsModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        NSDictionary *headerDictionary = dictionary[@"header"];
        if (headerDictionary) {
            self.headerModel = [[RCDemoSettingsHeaderModel alloc] initWithDictionary:headerDictionary];
        }

        NSArray<NSDictionary *> *itemDictionaries = dictionary[@"list"];
        if (itemDictionaries) {
            NSMutableArray<RCDemoSettingsItemModel *> *items = [NSMutableArray arrayWithCapacity:itemDictionaries.count];
            for (NSDictionary *itemDictionary in itemDictionaries) {
                RCDemoSettingsItemModel *item = [[RCDemoSettingsItemModel alloc] initWithDictionary:itemDictionary];
                [items addObject:item];
            }
            self.items = items.copy;
        }
    }
    return self;
}
@end


@implementation RCDemoSettingsHeaderModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}
@end


@implementation RCDemoSettingsItemModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

@end
