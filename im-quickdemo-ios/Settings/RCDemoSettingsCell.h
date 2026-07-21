//
//  RCDemoSettingsCell.h
//  im-quickdemo-ios
//
//  Created by pengwenxin on 2022/7/13.
//

#import <UIKit/UIKit.h>
#import "RCDemoSettingsModel.h"

NS_ASSUME_NONNULL_BEGIN


@class RCDemoSettingsCell;

/// 将设置项的交互结果交回设置页，由控制器直接调用对应 SDK 接口。
@protocol RCDemoSettingsCellDelegate <NSObject>

- (void)settingsCell:(RCDemoSettingsCell *)cell didSelectLanguageForItem:(RCDemoSettingsItemModel *)item;

- (void)settingsCell:(RCDemoSettingsCell *)cell didToggleItem:(RCDemoSettingsItemModel *)item;

@end

/// 设置列表的可复用 Cell，根据 item identifier 展示开关或语言选择值。
@interface RCDemoSettingsCell : UITableViewCell

@property (nonatomic, strong) RCDemoSettingsItemModel *item;

@property (nonatomic, weak) id<RCDemoSettingsCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
