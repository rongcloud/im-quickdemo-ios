//
//  RCDemoCustomMediaMessageCell.h
//  im-quickdemo-ios
//
//  Created by 于艳平 on 2022/7/31.
//

#import <RongIMKit/RongIMKit.h>
NS_ASSUME_NONNULL_BEGIN

/// `RCDemoCustomMediaMessage` 的 IMKit 展示 Cell，优先显示本地或消息体内的缩略图。
@interface RCDemoCustomMediaMessageCell : RCMessageCell

/// 自定义媒体缩略图的显示区域。
@property (nonatomic, strong) UIImageView *imageView;
@end

NS_ASSUME_NONNULL_END
