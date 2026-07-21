//
//  RCDemoPopoverView.h
//  im-quickdemo-ios
//
//  Created by pengwenxin on 2022/7/27.
//

#import <UIKit/UIKit.h>
#import "RCDemoPopoverAction.h"

NS_ASSUME_NONNULL_BEGIN

/// 锚定到按钮或屏幕坐标的轻量菜单，新建会话入口用它展示“发起聊天”。
@interface RCDemoPopoverView : UIView

/// 点击菜单外部区域后是否自动关闭，默认行为由实现文件设置。
@property (nonatomic, assign) BOOL hideAfterTouchOutside;

/// 是否显示覆盖页面的半透明遮罩。
@property (nonatomic, assign) BOOL showShade;

@property (nonatomic, assign) RCDemoPopoverStyle style;

+ (instancetype)popoverView;

/// 将菜单定位到指定视图附近并展示操作项。
- (void)showToView:(UIView *)pointView withActions:(NSArray<RCDemoPopoverAction *> *)actions;

/// 将菜单定位到窗口坐标并展示操作项。
- (void)showToPoint:(CGPoint)toPoint withActions:(NSArray<RCDemoPopoverAction *> *)actions;

@end

NS_ASSUME_NONNULL_END
