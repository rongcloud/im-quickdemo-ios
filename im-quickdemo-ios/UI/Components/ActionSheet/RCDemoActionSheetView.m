//
//  RCDemoActionSheetView.m
//  im-quickdemo-ios
//
//  Created by pengwenxin on 2022/7/15.
//


#import "RCDemoActionSheetView.h"
#import <RongIMKit/RongIMKit.h>

static const CGFloat RCDemoActionSheetCancelBarHeight = 8;
static const CGFloat RCDemoActionSheetCellHeight = 56;
static NSString * const RCDemoActionSheetCellReuseIdentifier = @"RCDemoActionSheetCell";

@interface RCDemoActionSheetView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray<NSString *> *items;
@property (nonatomic, copy) NSString *cancelTitle;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, copy) void (^selectionHandler)(NSString *title);

@end

@implementation RCDemoActionSheetView

- (instancetype)initWithCancelTitle:(NSString *)cancelTitle
                         otherTitles:(NSArray<NSString *> *)titles
                    selectionHandler:(void (^)(NSString *title))selectionHandler {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _items = titles.copy;
        _cancelTitle = cancelTitle.copy;
        _contentHeight = (titles.count + 1) * RCDemoActionSheetCellHeight + RCDemoActionSheetCancelBarHeight;
        _selectionHandler = [selectionHandler copy];
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [RCKitUtility generateDynamicColor:[HEXCOLOR(0x000000) colorWithAlphaComponent:0.5]
                                                    darkColor:[HEXCOLOR(0x000000) colorWithAlphaComponent:0.5]];
    [self addSubview:self.tableView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    if (point.y < CGRectGetHeight(self.bounds) - self.contentHeight) {
        [self dismiss:nil];
    }
    [super touchesBegan:touches withEvent:event];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = UIColor.systemBackgroundColor;
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:RCDemoActionSheetCellReuseIdentifier];
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.separatorColor = [RCKitUtility generateDynamicColor:HEXCOLOR(0xE3E3E3)
                                                             darkColor:HEXCOLOR(0xE3E3E3)];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? self.items.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RCDemoActionSheetCellReuseIdentifier
                                                             forIndexPath:indexPath];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [RCKitUtility generateDynamicColor:HEXCOLOR(0x2A2A2A)
                                                        darkColor:HEXCOLOR(0x2A2A2A)];
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.textLabel.text = indexPath.section == 0 ? self.items[indexPath.row] : self.cancelTitle;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RCDemoActionSheetCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 0 ? RCDemoActionSheetCancelBarHeight : 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = section == 0
        ? [RCKitUtility generateDynamicColor:HEXCOLOR(0xF6F6F6) darkColor:HEXCOLOR(0xF6F6F6)]
        : UIColor.clearColor;
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        __weak typeof(self) weakSelf = self;
        [self dismiss:^{
            if (weakSelf.selectionHandler) {
                weakSelf.selectionHandler(weakSelf.items[indexPath.row]);
            }
        }];
    } else {
        [self dismiss:nil];
    }
}

#pragma mark - Presentation

- (void)show {
    id<UIApplicationDelegate> applicationDelegate = UIApplication.sharedApplication.delegate;
    UIWindow *window = applicationDelegate.window;
    if (!window) {
        return;
    }

    self.frame = window.bounds;
    [window addSubview:self];
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    self.tableView.frame = CGRectMake(0, height, width, self.contentHeight);

    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.frame = CGRectMake(0, height - self.contentHeight, width, self.contentHeight);
    }];
}

- (void)dismiss:(void (^ _Nullable)(void))completion {
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    self.tableView.frame = CGRectMake(0, height - self.contentHeight, width, self.contentHeight);

    NSTimeInterval duration = completion ? 0.1 : 0.2;
    [UIView animateWithDuration:duration animations:^{
        self.tableView.frame = CGRectMake(0, height, width, self.contentHeight);
        self.backgroundColor = UIColor.clearColor;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
}

@end
