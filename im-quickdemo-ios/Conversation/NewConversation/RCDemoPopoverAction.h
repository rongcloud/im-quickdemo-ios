//
//  RCDemoPopoverAction.h
//  im-quickdemo-ios
//
//  Created by pengwenxin on 2022/7/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, RCDemoPopoverStyle) {
    RCDemoPopoverStyleDefault = 0,
    RCDemoPopoverStyleDark,
};

/// 弹出菜单中的单个操作项，封装图标、标题和点击回调。
@interface RCDemoPopoverAction : NSObject


@property (nonatomic, strong, readonly, nullable) UIImage *image;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) void(^handler)(RCDemoPopoverAction *action);

+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(RCDemoPopoverAction *action))handler;

/// 创建带图标的菜单操作项；选中后由弹出菜单调用 handler。
+ (instancetype)actionWithImage:(nullable UIImage *)image title:(NSString *)title handler:(void (^)(RCDemoPopoverAction *action))handler;

@end

NS_ASSUME_NONNULL_END
