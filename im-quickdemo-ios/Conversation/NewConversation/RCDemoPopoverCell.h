//
//  RCDemoPopoverCell.h
//  im-quickdemo-ios
//
//  Created by pengwenxin on 2022/7/27.
//

#import <UIKit/UIKit.h>
#import "RCDemoPopoverAction.h"

UIKIT_EXTERN CGFloat const RCDemoPopoverCellHorizontalMargin;
UIKIT_EXTERN CGFloat const RCDemoPopoverCellVerticalMargin;
UIKIT_EXTERN CGFloat const RCDemoPopoverCellTitleLeftEdge;

NS_ASSUME_NONNULL_BEGIN

/// `RCDemoPopoverAction` 的表格展示 Cell，仅由 `RCDemoPopoverView` 使用。
@interface RCDemoPopoverCell : UITableViewCell

@property (nonatomic, assign) RCDemoPopoverStyle style;

+ (UIFont *)titleFont;

+ (UIColor *)bottomLineColorForStyle:(RCDemoPopoverStyle)style;

- (void)setAction:(RCDemoPopoverAction *)action;

/// 控制当前项下方的分隔线，最后一项通常隐藏。
- (void)showBottomLine:(BOOL)show;

@end

NS_ASSUME_NONNULL_END
