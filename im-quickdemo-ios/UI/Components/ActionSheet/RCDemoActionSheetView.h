//
//  RCDemoActionSheetView.h
//  im-quickdemo-ios
//
//  Created by pengwenxin on 2022/7/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 代码化操作列表组件，新建会话页用它选择单聊或群聊类型。
@interface RCDemoActionSheetView : UIView

/// 创建操作列表。点击非取消项后通过 selectionHandler 返回所选标题。
- (instancetype)initWithCancelTitle:(NSString *)cancelTitle
                         otherTitles:(NSArray<NSString *> *)titles
                    selectionHandler:(void (^)(NSString *title))selectionHandler;

/// 将操作列表添加到当前窗口并执行出现动画。
- (void)show;

@end

NS_ASSUME_NONNULL_END
