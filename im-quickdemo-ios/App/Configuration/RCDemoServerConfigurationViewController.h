//
//  RCDemoServerConfigurationViewController.h
//  im-quickdemo-ios
//
//  Created by pengwenxin on 2022/7/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 私有云导航和文件服务器配置页。
/// 此页面只保存地址，登录页在下一次调用 `initWithAppKey:option:` 时将地址写入 `RCInitOption`。
@interface RCDemoServerConfigurationViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
