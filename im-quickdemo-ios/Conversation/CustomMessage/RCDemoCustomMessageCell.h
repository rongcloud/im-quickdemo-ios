//
//  RCDemoCustomMessageCell.h
//  im-quickdemo-ios
//
//  Created by 于艳平 on 2022/7/31.
//

#import <RongIMKit/RongIMKit.h>
#import "RCDemoCustomMessage.h"

NS_ASSUME_NONNULL_BEGIN

/// `RCDemoCustomMessage` 的 IMKit 展示 Cell，显示文本内容和消息扩展计数。
@interface RCDemoCustomMessageCell : RCMessageCell

/// 自定义消息文本及扩展计数的显示区域。
@property (strong, nonatomic) UILabel *textLabel;

@end

NS_ASSUME_NONNULL_END
