//
//  RCDemoSettingsViewController.m
//  im-quickdemo-ios
//
//  Created by 于艳平 on 2022/7/11.
//

#import "RCDemoSettingsViewController.h"
#import "RCDemoSettingsModel.h"
#import "RCDemoSettingsCell.h"
#import "RCDemoActionSheetView.h"
#import "RCDemoNotifications.h"
#import <RongIMKit/RongIMKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SVProgressHUD/SVProgressHUD.h>

static NSString * const RCDemoSettingsCellReuseIdentifier = @"RCDemoSettingsCell";

@interface RCDemoSettingsHeaderView : UIView

@property (nonatomic, strong) RCDemoSettingsHeaderModel *headerModel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *userIdLabel;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIButton *logoutButton;
@property (nonatomic, copy) void (^logoutHandler)(void);
@property (nonatomic, strong) UIView *separatorView;

@end

@implementation RCDemoSettingsHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubviews];
    }
    return self;
}

#pragma mark - Views

- (void)addSubviews {
    self.backgroundColor = [RCKitUtility generateDynamicColor:HEXCOLOR(0xF5F5F5)
                                                    darkColor:HEXCOLOR(0xF5F5F5)];
    [self addSubview:self.nameLabel];
    [self addSubview:self.userIdLabel];
    [self addSubview:self.avatarImageView];
    [self addSubview:self.logoutButton];
    [self addSubview:self.separatorView];

}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    self.avatarImageView.frame = CGRectMake(20, (height - 70) / 2, 70, 70);
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.avatarImageView.frame) + 10, (height - 60) / 2, 160, 20);
    self.userIdLabel.frame = CGRectMake(CGRectGetMinX(self.nameLabel.frame), height - 40, 160, 20);
    self.logoutButton.frame = CGRectMake(width - 90, (height - 40) / 2, 80, 40);
    self.separatorView.frame = CGRectMake(0, height - 0.5, width, 0.5);
}

- (void)setHeaderModel:(RCDemoSettingsHeaderModel *)headerModel {
    _headerModel = headerModel;

    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:headerModel.portraitUri]
                            placeholderImage:RCResourceImage(@"default_portrait_msg")];
    self.nameLabel.text = headerModel.name;
    self.userIdLabel.text = [NSString stringWithFormat:@"ID: %@", headerModel.userId];
}

- (void)logoutButtonTapped {
    if (self.logoutHandler) {
        self.logoutHandler();
    }
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"你的昵称";
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _nameLabel.font = [UIFont boldSystemFontOfSize:17];
        _nameLabel.numberOfLines = 1;
    }
    return _nameLabel;
}

- (UILabel *)userIdLabel {
    if (!_userIdLabel) {
        _userIdLabel = [[UILabel alloc] init];
        _userIdLabel.textColor = [UIColor blackColor];
        _userIdLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _userIdLabel.font = [UIFont systemFontOfSize:15];
        _userIdLabel.numberOfLines = 1;
    }
    return _userIdLabel;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.backgroundColor = [RCKitUtility generateDynamicColor:HEXCOLOR(0xE5E7EB)
                                                                darkColor:HEXCOLOR(0xE5E7EB)];
        _avatarImageView.layer.cornerRadius = 35;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.borderWidth = 1.0;
        _avatarImageView.layer.borderColor = [RCKitUtility generateDynamicColor:HEXCOLOR(0x4CA1F0)
                                                                  darkColor:HEXCOLOR(0x4CA1F0)].CGColor;
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _avatarImageView;
}

- (UIButton *)logoutButton {
    if (!_logoutButton) {
        _logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _logoutButton.backgroundColor = [UIColor whiteColor];
        _logoutButton.layer.masksToBounds = YES;
        _logoutButton.layer.borderWidth = 1.0;
        _logoutButton.layer.cornerRadius = 4;
        _logoutButton.layer.borderColor = [RCKitUtility generateDynamicColor:HEXCOLOR(0x707071)
                                                                darkColor:HEXCOLOR(0x707071)].CGColor;
        [_logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [_logoutButton setTitleColor:[RCKitUtility generateDynamicColor:HEXCOLOR(0x707071)
                                                           darkColor:HEXCOLOR(0x707071)] forState:UIControlStateNormal];
        _logoutButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_logoutButton addTarget:self action:@selector(logoutButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logoutButton;
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

@interface RCDemoSettingsViewController () <UITableViewDelegate, UITableViewDataSource, RCDemoSettingsCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray<RCDemoSettingsItemModel *> *items;
@property (nonatomic, strong) RCDemoSettingsHeaderView *headerView;

@end

@implementation RCDemoSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";

    [self addSubviews];
    [self loadData];
    
    [self.headerView setLogoutHandler:^{
        [[RCIM sharedRCIM] logout];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:RCDemoDidLogoutNotification object:nil];
        });
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;

    CGRect headerFrame = self.headerView.frame;
    CGFloat tableWidth = CGRectGetWidth(self.tableView.bounds);
    if (CGRectGetWidth(headerFrame) != tableWidth) {
        headerFrame.size.width = tableWidth;
        self.headerView.frame = headerFrame;
        self.tableView.tableHeaderView = self.headerView;
    }
}

- (void)addSubviews {
    [self.view addSubview:self.tableView];
}

- (void)loadData {
    RCPushProfile *pushProfile = [[RCCoreClient sharedCoreClient] pushProfile];
    NSString *language;
    switch (pushProfile.pushLanguage) {
        case RCPushLanguage_EN_US:
            language = @"英语";
            break;
        case RCPushLanguage_AR_SA:
            language = @"阿拉伯语";
            break;
        case RCPushLanguage_ZH_CN:
            language = @"简体中文";
            break;
        default:
            language = @"简体中文";
            break;
    }

    BOOL showsPushContent = pushProfile.isShowPushContent;
    __weak typeof(self) weakSelf = self;
    [[RCChannelClient sharedChannelManager] getNotificationQuietHoursLevel:^(NSString *startTime, int spanMins, RCPushNotificationQuietHoursLevel level) {
        BOOL muteNotifications = [startTime isEqualToString:@"00:00:00"] && spanMins == 1439;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf updateSettingsWithLanguage:language
                                showsPushContent:showsPushContent
                                muteNotifications:muteNotifications];
        });
    } error:^(RCErrorCode status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf updateSettingsWithLanguage:language
                                showsPushContent:showsPushContent
                                muteNotifications:NO];
        });
    }];
}

- (void)updateSettingsWithLanguage:(NSString *)language
                  showsPushContent:(BOOL)showsPushContent
                 muteNotifications:(BOOL)muteNotifications {
    RCUserInfo *currentUserInfo = [[RCIM sharedRCIM] currentUserInfo];
    NSDictionary *data = @{
        @"header": @{
            @"name": currentUserInfo.name ?: @"",
            @"userId": currentUserInfo.userId ?: @"",
            @"portraitUri": currentUserInfo.portraitUri ?: @""
        },
        @"list": @[
            @{@"title": @"全局免打扰", @"value": muteNotifications ? @"1" : @"0", @"identifier": RCDemoSettingsMuteNotificationsItemIdentifier},
            @{@"title": @"显示远程推送", @"value": showsPushContent ? @"1" : @"0", @"identifier": RCDemoSettingsShowPushContentItemIdentifier},
            @{@"title": @"推送多语言", @"value": language, @"identifier": RCDemoSettingsPushLanguageItemIdentifier}
        ]
    };

    RCDemoSettingsModel *model = [[RCDemoSettingsModel alloc] initWithDictionary:data];
    self.headerView.headerModel = model.headerModel;
    self.items = model.items;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.items.count == 0) {
        return [[UITableViewCell alloc] init];
    }
    RCDemoSettingsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:RCDemoSettingsCellReuseIdentifier];
    if (!cell) {
        cell = [[RCDemoSettingsCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:RCDemoSettingsCellReuseIdentifier];
        cell.delegate = self;
    }
    cell.item = self.items[indexPath.row];
    cell.tintColor = [UIColor colorWithRed:58 / 255.0 green:145 / 255.0 blue:243 / 255.0 alpha:1.0];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - RCDemoSettingsCellDelegate

- (void)settingsCell:(RCDemoSettingsCell *)cell didSelectLanguageForItem:(RCDemoSettingsItemModel *)item {
    NSArray *languages = @[@"阿拉伯语", @"英语", @"简体中文"];
    __weak typeof(self) weakSelf = self;
    RCDemoActionSheetView *actionSheet = [[RCDemoActionSheetView alloc] initWithCancelTitle:@"取消" otherTitles:languages selectionHandler:^(NSString *title) {
        NSString *languageCode;
        if ([title isEqualToString:@"阿拉伯语"]) {
            languageCode = @"ar_SA";
        } else if ([title isEqualToString:@"英语"]) {
            languageCode = @"en_US";
        } else {
            languageCode = @"zh_CN";
        }
        [[RCCoreClient sharedCoreClient].pushProfile setPushLanguageCode:languageCode success:^{
            item.value = title;
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showSuccessWithStatus:@"设置推送语言成功"];
                [weakSelf.tableView reloadData];
            });
        } error:^(RCErrorCode status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"设置推送语言失败 %ld", status]];
            });
        }];
    }];
    [actionSheet show];
}

- (void)settingsCell:(RCDemoSettingsCell *)cell didToggleItem:(RCDemoSettingsItemModel *)item {
    if ([item.identifier isEqualToString:RCDemoSettingsMuteNotificationsItemIdentifier]) {
        [self updateMuteNotifications:[item.value isEqualToString:@"1"] model:item];
    } else if ([item.identifier isEqualToString:RCDemoSettingsShowPushContentItemIdentifier]) {
        [self updateShowPushContent:[item.value isEqualToString:@"1"] model:item];
    }
}

- (void)updateMuteNotifications:(BOOL)enabled model:(RCDemoSettingsItemModel *)model {
    __weak typeof(self) weakSelf = self;
    void (^success)(void) = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:enabled ? @"已开启全局免打扰" : @"已关闭全局免打扰"];
            [weakSelf.tableView reloadData];
        });
    };
    void (^failure)(RCErrorCode) = ^(RCErrorCode status) {
        model.value = enabled ? @"0" : @"1";
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"设置失败：%ld", (long)status]];
        });
    };

    if (enabled) {
        [[RCChannelClient sharedChannelManager] setNotificationQuietHoursLevel:@"00:00:00"
                                                                      spanMins:1439
                                                                         level:RCPushNotificationQuietHoursLevelBlocked
                                                                       success:success
                                                                         error:failure];
    } else {
        [[RCChannelClient sharedChannelManager] removeNotificationQuietHours:success error:failure];
    }
}

- (void)updateShowPushContent:(BOOL)showsContent model:(RCDemoSettingsItemModel *)model {
    __weak typeof(self) weakSelf = self;
    [[RCCoreClient sharedCoreClient].pushProfile updateShowPushContentStatus:showsContent success:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:showsContent ? @"已显示推送内容" : @"已隐藏推送内容"];
            [weakSelf.tableView reloadData];
        });
    } error:^(RCErrorCode status) {
        model.value = showsContent ? @"0" : @"1";
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"设置失败：%ld", (long)status]];
        });
    }];
}

#pragma mark - Lazy Loading

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        self.headerView = [[RCDemoSettingsHeaderView alloc] initWithFrame:CGRectMake(0, 0, 0, 100)];
        
        _tableView.tableHeaderView = self.headerView;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 0.f;
        _tableView.delaysContentTouches = NO;
    }
    return _tableView;
}

@end
