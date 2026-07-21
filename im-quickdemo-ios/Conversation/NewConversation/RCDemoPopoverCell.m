//
//  RCDemoPopoverCell.m
//  im-quickdemo-ios
//
//  Created by pengwenxin on 2022/7/27.
//

#import "RCDemoPopoverCell.h"
#import <RongIMKit/RongIMKit.h>

CGFloat const RCDemoPopoverCellHorizontalMargin = 15.0;
CGFloat const RCDemoPopoverCellVerticalMargin = 3.0;
CGFloat const RCDemoPopoverCellTitleLeftEdge = 8.0;

@interface RCDemoPopoverCell ()

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, weak) UIView *bottomLine;

@end

@implementation RCDemoPopoverCell

#pragma mark - Life Cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = self.backgroundColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self initialize];
    
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.backgroundColor = _style == RCDemoPopoverStyleDefault ? [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0] : [UIColor colorWithRed:0.23 green:0.23 blue:0.23 alpha:1.00];
    } else {
        [UIView animateWithDuration:0.3f animations:^{
            self.backgroundColor = [UIColor clearColor];
        }];
    }
}

#pragma mark - Setter
- (void)setStyle:(RCDemoPopoverStyle)style {
    _style = style;
    _bottomLine.backgroundColor = [self.class bottomLineColorForStyle:style];
    UIColor *titleColor;
    if (_style == RCDemoPopoverStyleDefault) {
        titleColor = [RCKitUtility generateDynamicColor:HEXCOLOR(0x000000)
                                              darkColor:HEXCOLOR(0xF6F6F6)];
    } else {
        titleColor = [RCKitUtility generateDynamicColor:HEXCOLOR(0xFFFFFF)
                                              darkColor:HEXCOLOR(0xFFFFFF)];
    }
    [_button setTitleColor:titleColor forState:UIControlStateNormal];
    if (_button.configuration) {
        UIButtonConfiguration *configuration = _button.configuration;
        configuration.baseForegroundColor = titleColor;
        _button.configuration = configuration;
    }
}

#pragma mark - Private

- (void)initialize {
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.userInteractionEnabled = NO;
    _button.translatesAutoresizingMaskIntoConstraints = NO;
    _button.titleLabel.font = [self.class titleFont];
    _button.backgroundColor = self.contentView.backgroundColor;
    _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_button setTitleColor:[RCKitUtility generateDynamicColor:HEXCOLOR(0x000000)
                                                    darkColor:HEXCOLOR(0xF6F6F6)] forState:UIControlStateNormal];
    
    [self.contentView addSubview:_button];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[_button]-margin-|" options:kNilOptions metrics:@{@"margin" : @(RCDemoPopoverCellHorizontalMargin)} views:NSDictionaryOfVariableBindings(_button)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[_button]-margin-|" options:kNilOptions metrics:@{@"margin" : @(RCDemoPopoverCellVerticalMargin)} views:NSDictionaryOfVariableBindings(_button)]];
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.00];
    bottomLine.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:bottomLine];
    _bottomLine = bottomLine;
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bottomLine]|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(bottomLine)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomLine(lineHeight)]|" options:kNilOptions metrics:@{@"lineHeight" : @(1/[UIScreen mainScreen].scale)} views:NSDictionaryOfVariableBindings(bottomLine)]];
}

#pragma mark - Public

+ (UIFont *)titleFont {
    return [UIFont systemFontOfSize:15.f];
}


+ (UIColor *)bottomLineColorForStyle:(RCDemoPopoverStyle)style {
    return style == RCDemoPopoverStyleDefault ? [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.00]: [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.00];
}

- (void)setAction:(RCDemoPopoverAction *)action {
    UIButtonConfiguration *configuration = [UIButtonConfiguration plainButtonConfiguration];
    configuration.image = action.image;
    configuration.title = action.title;
    configuration.imagePadding = action.image ? RCDemoPopoverCellTitleLeftEdge : 0;
    configuration.contentInsets = NSDirectionalEdgeInsetsZero;
    configuration.baseForegroundColor = _style == RCDemoPopoverStyleDefault
        ? [RCKitUtility generateDynamicColor:HEXCOLOR(0x000000) darkColor:HEXCOLOR(0xF6F6F6)]
        : [RCKitUtility generateDynamicColor:HEXCOLOR(0xFFFFFF) darkColor:HEXCOLOR(0xFFFFFF)];
    configuration.titleTextAttributesTransformer = ^NSDictionary<NSAttributedStringKey, id> *(NSDictionary<NSAttributedStringKey, id> *attributes) {
        NSMutableDictionary<NSAttributedStringKey, id> *updatedAttributes = attributes.mutableCopy;
        updatedAttributes[NSFontAttributeName] = [RCDemoPopoverCell titleFont];
        return updatedAttributes;
    };
    _button.configuration = configuration;
}

- (void)showBottomLine:(BOOL)show {
    _bottomLine.hidden = !show;
}

@end
