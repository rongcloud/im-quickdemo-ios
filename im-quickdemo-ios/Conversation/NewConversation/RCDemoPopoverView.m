//
//  RCDemoPopoverView.m
//  im-quickdemo-ios
//
//  Created by pengwenxin on 2022/7/27.
//

#import "RCDemoPopoverView.h"
#import "RCDemoPopoverCell.h"
#import <RongIMKit/RongIMKit.h>

static CGFloat const kPopoverViewMargin = 8.f;
static CGFloat const kPopoverViewCellHeight = 50.f;

static NSString *kPopoverCellReuseId = @"_PopoverCellReuseId";

@interface  RCDemoPopoverView ()<UITableViewDelegate, UITableViewDataSource>

#pragma mark - UI
@property (nonatomic, weak) UIWindow *keyWindow;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *shadeView;
@property (nonatomic, weak) UITapGestureRecognizer *tapGesture;

#pragma mark - Data
@property (nonatomic, copy) NSArray<RCDemoPopoverAction *> *actions;
@property (nonatomic, assign) CGFloat windowWidth;
@property (nonatomic, assign) CGFloat windowHeight;
@property (nonatomic, assign) BOOL isUpward;

@end

@implementation RCDemoPopoverView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    [self initialize];
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _tableView.frame = CGRectMake(0, 0,
                                  CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
}

#pragma mark - Setter
- (void)setHideAfterTouchOutside:(BOOL)hideAfterTouchOutside
{
    _hideAfterTouchOutside = hideAfterTouchOutside;
    _tapGesture.enabled = _hideAfterTouchOutside;
}

- (void)setShowShade:(BOOL)showShade
{
    _showShade = showShade;
    
    _shadeView.backgroundColor = _showShade ? [UIColor colorWithWhite:0.f alpha:0.18f] : [UIColor clearColor];
    
}

- (void)setStyle:(RCDemoPopoverStyle)style
{
    _style = style;
    
    _tableView.separatorColor = [RCDemoPopoverCell bottomLineColorForStyle:_style];
    
    if (_style == RCDemoPopoverStyleDefault) {
        
        self.backgroundColor =  [RCKitUtility generateDynamicColor:HEXCOLOR(0xFFFFFF)
                                                         darkColor:HEXCOLOR(0x1E1E1E)];
    }
    else {
        
        self.backgroundColor = [UIColor colorWithRed:0.29 green:0.29 blue:0.29 alpha:1.0];
    }
}

#pragma mark - Private
- (void)initialize
{
    _actions = @[];
    _isUpward = YES;
    _style = RCDemoPopoverStyleDefault;
    
    self.backgroundColor =  [RCKitUtility generateDynamicColor:HEXCOLOR(0xFFFFFF)
                                                     darkColor:HEXCOLOR(0x1E1E1E)];
    
    _keyWindow = [UIApplication sharedApplication].delegate.window;
    _windowWidth = CGRectGetWidth(_keyWindow.bounds);
    _windowHeight = CGRectGetHeight(_keyWindow.bounds);
    
    _shadeView = [[UIView alloc] initWithFrame:_keyWindow.bounds];
    [self setShowShade:NO];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [_shadeView addGestureRecognizer:tapGesture];
    _tapGesture = tapGesture;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = [RCDemoPopoverCell bottomLineColorForStyle:_style];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.estimatedRowHeight = 0.0;
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerClass:[RCDemoPopoverCell class] forCellReuseIdentifier:kPopoverCellReuseId];
    [self addSubview:_tableView];
}


- (void)showToPoint:(CGPoint)toPoint
{
    CGFloat cornerRadius = 4.f;
        
    CGFloat minHorizontalEdge = kPopoverViewMargin + cornerRadius + 2;
    if (toPoint.x < minHorizontalEdge) {
        toPoint.x = minHorizontalEdge;
    }
    if (_windowWidth - toPoint.x < minHorizontalEdge) {
        toPoint.x = _windowWidth - minHorizontalEdge;
    }
    
    _shadeView.alpha = 0.f;
    [_keyWindow addSubview:_shadeView];
    
    [_tableView reloadData];
   
    CGFloat currentW = [self calculateMaxWidth];
    CGFloat currentH = _tableView.contentSize.height;
    
    if (_actions.count == 0) {
        currentW = 150.0;
        currentH = 20.0;
    }
    
    CGFloat statusBarHeight = CGRectGetHeight(_keyWindow.windowScene.statusBarManager.statusBarFrame);
    CGFloat maxHeight = _isUpward
        ? (_windowHeight - toPoint.y - kPopoverViewMargin)
        : (toPoint.y - statusBarHeight);
    if (currentH > maxHeight) {
        currentH = maxHeight;
        _tableView.scrollEnabled = YES;
        if (!_isUpward) {
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_actions.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
    
    CGFloat currentX = toPoint.x - currentW/2, currentY = toPoint.y;
    if (toPoint.x <= currentW/2 + kPopoverViewMargin) {
        currentX = kPopoverViewMargin;
    }
    if (_windowWidth - toPoint.x <= currentW/2 + kPopoverViewMargin) {
        currentX = _windowWidth - kPopoverViewMargin - currentW;
    }
    if (!_isUpward) {
        currentY = toPoint.y - currentH;
    }
    
    self.frame = CGRectMake(currentX, currentY, currentW, currentH);
    
    self.layer.cornerRadius  = cornerRadius;
    self.layer.masksToBounds = YES;
    [_keyWindow addSubview:self];

    [UIView animateWithDuration:0.25f animations:^{
        self.shadeView.alpha = 1.f;
    }];
}

- (CGFloat)calculateMaxWidth
{
    CGFloat maxWidth = 0.f, titleLeftEdge = 0.f, imageWidth = 0.f, imageMaxHeight = kPopoverViewCellHeight - RCDemoPopoverCellVerticalMargin*2;
    CGSize imageSize = CGSizeZero;
    UIFont *titleFont = [RCDemoPopoverCell titleFont];
    
    for (RCDemoPopoverAction *action in _actions) {
       
        imageWidth = 0.f;
        titleLeftEdge = 0.f;
        
        if (action.image) {
            
            titleLeftEdge = RCDemoPopoverCellTitleLeftEdge;
            imageSize = action.image.size;
            
            if (imageSize.height > imageMaxHeight) {
                
                imageWidth = imageMaxHeight*imageSize.width/imageSize.height;
            }
            else {
                
                imageWidth = imageSize.width;
            }
        }
        
        CGFloat titleWidth = [action.title sizeWithAttributes:@{NSFontAttributeName : titleFont}].width;
        
        CGFloat contentWidth = RCDemoPopoverCellHorizontalMargin*2 + imageWidth + titleLeftEdge + titleWidth;
        if (contentWidth > maxWidth) {
            maxWidth = ceil(contentWidth);
        }
    }
    
    if (maxWidth > CGRectGetWidth(_keyWindow.bounds) - kPopoverViewMargin*2) {
        maxWidth = CGRectGetWidth(_keyWindow.bounds) - kPopoverViewMargin*2;
    }
    
    return maxWidth;
}

- (void)hide
{
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 0.f;
        self.shadeView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self.shadeView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

#pragma mark - Public
+ (instancetype)popoverView
{
    return [[self alloc] init];
}

- (void)showToView:(UIView *)pointView withActions:(NSArray<RCDemoPopoverAction *> *)actions
{

    CGRect pointViewRect = [pointView.superview convertRect:pointView.frame toView:_keyWindow];
    CGFloat pointViewUpLength = CGRectGetMinY(pointViewRect);
    CGFloat pointViewDownLength = _windowHeight - CGRectGetMaxY(pointViewRect);

    CGPoint toPoint = CGPointMake(CGRectGetMidX(pointViewRect), 0);

    if (pointViewUpLength > pointViewDownLength) {
        toPoint.y = pointViewUpLength;
    } else {
        toPoint.y = CGRectGetMaxY(pointViewRect);
    }
    

    _isUpward = pointViewUpLength <= pointViewDownLength;
    
    if (!actions) {
        _actions = @[];
    } else {
        _actions = [actions copy];
    }
    
    [self showToPoint:toPoint];
}

- (void)showToPoint:(CGPoint)toPoint withActions:(NSArray<RCDemoPopoverAction *> *)actions
{
    if (!actions) {
        _actions = @[];
    } else {
        _actions = [actions copy];
    }
    
    _isUpward = toPoint.y <= _windowHeight - toPoint.y;
    
    [self showToPoint:toPoint];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _actions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kPopoverViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCDemoPopoverCell *cell = [tableView dequeueReusableCellWithIdentifier:kPopoverCellReuseId];
    cell.style = _style;
    [cell setAction:_actions[indexPath.row]];
    [cell showBottomLine: indexPath.row < _actions.count - 1];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 0.f;
        self.shadeView.alpha = 0.f;
    } completion:^(BOOL finished) {
        RCDemoPopoverAction *action = self.actions[indexPath.row];
        action.handler ? action.handler(action) : NULL;
        self.actions = nil;
        [self.shadeView removeFromSuperview];
        [self removeFromSuperview];
    }];
}


@end
