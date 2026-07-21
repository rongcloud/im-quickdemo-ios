//
//  RCDemoSettingsCell.m
//  im-quickdemo-ios
//
//  Created by pengwenxin on 2022/7/13.
//

#import "RCDemoSettingsCell.h"
#import <RongIMKit/RongIMKit.h>

@interface RCDemoSettingsCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UISwitch *toggleSwitch;
@property (nonatomic, strong) UIButton *languageButton;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIView *separatorView;

@end


@implementation RCDemoSettingsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.toggleSwitch];
        [self.contentView addSubview:self.languageButton];
        [self.contentView addSubview:self.arrowImageView];
        [self.contentView addSubview:self.separatorView];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat width = CGRectGetWidth(self.contentView.bounds);
    CGFloat height = CGRectGetHeight(self.contentView.bounds);
    self.titleLabel.frame = CGRectMake(16, (height - 20) / 2, 120, 20);
    self.toggleSwitch.frame = CGRectMake(width - 80, (height - 40) / 2, 80, 40);
    self.languageButton.frame = CGRectMake(width - 115, (height - 40) / 2, 80, 40);
    self.arrowImageView.frame = CGRectMake(width - 30, (height - 20) / 2, 20, 20);
    self.separatorView.frame = CGRectMake(8, height - 0.5, width - 16, 0.5);
}

#pragma mark - Action
- (void)toggleSwitchValueChanged {
    self.item.value = self.toggleSwitch.on ? @"1" : @"0";
    if ([self.delegate respondsToSelector:@selector(settingsCell:didToggleItem:)]) {
        [self.delegate settingsCell:self didToggleItem:self.item];
    }
}

- (void)setItem:(RCDemoSettingsItemModel *)item {
    _item = item;

    if ([item.identifier isEqualToString:RCDemoSettingsPushLanguageItemIdentifier]) {
        self.toggleSwitch.hidden = YES;
        self.languageButton.hidden = NO;
        self.arrowImageView.hidden = NO;
        [self.languageButton setTitle:item.value forState:UIControlStateNormal];
    } else {
        self.toggleSwitch.hidden = NO;
        self.languageButton.hidden = YES;
        self.arrowImageView.hidden = YES;
        self.toggleSwitch.on = [item.value isEqualToString:@"1"];
    }
    self.titleLabel.text = item.title;
}

- (void)languageButtonTapped {
    if ([self.delegate respondsToSelector:@selector(settingsCell:didSelectLanguageForItem:)]) {
        [self.delegate settingsCell:self didSelectLanguageForItem:self.item];
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

- (UISwitch *)toggleSwitch {
    if (!_toggleSwitch) {
        _toggleSwitch = [[UISwitch alloc] init];
        _toggleSwitch.on = NO;
        _toggleSwitch.hidden = YES;
        _toggleSwitch.onTintColor = [RCKitUtility generateDynamicColor:HEXCOLOR(0x4DA7F8)
                                                           darkColor:HEXCOLOR(0x4DA7F8)];
        [_toggleSwitch addTarget:self action:@selector(toggleSwitchValueChanged) forControlEvents:UIControlEventValueChanged];
    }
    return _toggleSwitch;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow"]];
        _arrowImageView.hidden = YES;
        _arrowImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _arrowImageView;
}

- (UIButton *)languageButton {
    if (!_languageButton) {
        _languageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _languageButton.hidden = YES;
        [_languageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _languageButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_languageButton addTarget:self action:@selector(languageButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _languageButton;
}

- (UIView *)separatorView {
    if (!_separatorView) {
        _separatorView = [[UIView alloc] init];
        _separatorView.backgroundColor = [RCKitUtility generateDynamicColor:HEXCOLOR(0xE5E7EB)
                                                            darkColor:HEXCOLOR(0xE5E7EB)];
    }
    return _separatorView;
}

@end
