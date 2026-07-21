//
//  RCDemoLoginViewController.m
//  im-quickdemo-ios
//
//  Created by 于艳平 on 2022/7/11.
//

#import "RCDemoLoginViewController.h"
#import "RCDemoConfigurationViewController.h"
#import "RCDemoCustomMediaMessage.h"
#import "RCDemoCustomMessage.h"
#import "RCDemoIMDataSource.h"
#import "RCDemoTabBarController.h"
#import "RCDemoConfiguration.h"
#import <RongIMKit/RongIMKit.h>
#import <SVProgressHUD/SVProgressHUD.h>


@interface RCDemoLoginViewController ()

@property (nonatomic, strong) UITextField *appKeyTextField;
@property (nonatomic, strong) UITextField *tokenTextField;
@property (nonatomic, strong) UIButton *loginButton;

@end

@implementation RCDemoLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    [self configureNavigationItem];
    [self configureSubviews];
#if DEBUG
    [RCCoreClient sharedCoreClient].logLevel = RC_Log_Level_Verbose;
#endif

    self.appKeyTextField.text = [RCDemoConfiguration shared].appKey ?: @"";
    self.tokenTextField.text = [RCDemoConfiguration shared].token ?: @"";
    self.tokenTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.tokenTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
}

#pragma mark - UI

- (void)configureNavigationItem {
    UIImage *settingImage = [[UIImage imageNamed:@"setting"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:settingImage
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(setConfigButtonAction:)];
    self.navigationItem.rightBarButtonItem.accessibilityLabel = @"服务器配置";
}

- (void)configureSubviews {
    UILabel *headingLabel = [[UILabel alloc] init];
    headingLabel.translatesAutoresizingMaskIntoConstraints = NO;
    headingLabel.text = @"RongCloud IM";
    headingLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle2];
    headingLabel.textColor = UIColor.labelColor;

    UILabel *appKeyLabel = [self fieldLabelWithText:@"App Key"];
    self.appKeyTextField = [self textFieldWithPlaceholder:@"请输入 App Key"];

    UILabel *tokenLabel = [self fieldLabelWithText:@"Token"];
    self.tokenTextField = [self textFieldWithPlaceholder:@"请输入 Token"];
    self.tokenTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.tokenTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;

    self.loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.loginButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.loginButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.loginButton.backgroundColor = UIColor.systemBlueColor;
    self.loginButton.layer.cornerRadius = 6;
    [self.loginButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[
        headingLabel,
        appKeyLabel,
        self.appKeyTextField,
        tokenLabel,
        self.tokenTextField,
        self.loginButton
    ]];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.spacing = 12;
    [stackView setCustomSpacing:28 afterView:headingLabel];
    [stackView setCustomSpacing:20 afterView:self.appKeyTextField];
    [stackView setCustomSpacing:28 afterView:self.tokenTextField];
    [self.view addSubview:stackView];

    UILayoutGuide *safeArea = self.view.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [stackView.topAnchor constraintEqualToAnchor:safeArea.topAnchor constant:40],
        [stackView.leadingAnchor constraintEqualToAnchor:safeArea.leadingAnchor constant:24],
        [stackView.trailingAnchor constraintEqualToAnchor:safeArea.trailingAnchor constant:-24],
        [self.appKeyTextField.heightAnchor constraintEqualToConstant:44],
        [self.tokenTextField.heightAnchor constraintEqualToConstant:44],
        [self.loginButton.heightAnchor constraintEqualToConstant:48]
    ]];
}

- (UILabel *)fieldLabelWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    label.textColor = UIColor.secondaryLabelColor;
    return label;
}

- (UITextField *)textFieldWithPlaceholder:(NSString *)placeholder {
    UITextField *textField = [[UITextField alloc] init];
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.placeholder = placeholder;
    textField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    return textField;
}

#pragma mark - Actions

- (void)setConfigButtonAction:(id)sender {
    RCDemoConfigurationViewController *viewController = [[RCDemoConfigurationViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)loginButtonAction:(UIButton *)sender {
    NSString *appKey = [self.appKeyTextField.text stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    NSString *token = [self.tokenTextField.text stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    if (appKey.length == 0) {
        [RCAlertView showAlertController:@"提示" message:@"App Key 不能为空" cancelTitle:@"确定" inViewController:self];
        return;
    }
    if (token.length == 0) {
        [RCAlertView showAlertController:@"提示" message:@"Token 不能为空" cancelTitle:@"确定" inViewController:self];
        return;
    }

    sender.enabled = NO;
    [[RCDemoConfiguration shared] setAppKey:appKey];
    [[RCDemoConfiguration shared] setToken:token];

    RCInitOption *initOption = [[RCInitOption alloc] init];
    initOption.naviServer = [RCDemoConfiguration shared].naviServer;
    initOption.fileServer = [RCDemoConfiguration shared].fileServer;
    [[RCIM sharedRCIM] initWithAppKey:appKey option:initOption];
    [[RCIM sharedRCIM] registerMessageType:[RCDemoCustomMessage class]];
    [[RCIM sharedRCIM] registerMessageType:[RCDemoCustomMediaMessage class]];

    [self configureRongIMSDK];
    [self connectIM:token];
}

#pragma mark - SDK Lifecycle

/// SDK 连接回调不保证在主线程，所有 UI 更新都切回主线程。
- (void)connectIM:(NSString *)token {
    [[RCIM sharedRCIM] connectWithToken:token dbOpened:^(RCDBErrorCode code) {
        NSLog(@"IM 数据库打开结果：%ld", (long)code);
    } success:^(NSString *userId) {
        dispatch_async(dispatch_get_main_queue(), ^{
            RCUserInfo *userInfoModel = [[RCUserInfo alloc] init];
            userInfoModel.userId = userId;
            userInfoModel.name = [NSString stringWithFormat:@"用户 %@", userId];
            [RCIM sharedRCIM].currentUserInfo = userInfoModel;
            [[RCDemoConfiguration shared] setUserId:userId];

            UIWindow *window = self.view.window;
            window.rootViewController = [[RCDemoTabBarController alloc] init];
            [window makeKeyAndVisible];
        });
    } error:^(RCConnectErrorCode errorCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.loginButton.enabled = YES;
            if (errorCode == RC_CONN_TOKEN_INCORRECT) {
                [[RCDemoConfiguration shared] removeToken];
                self.tokenTextField.text = @"";
                [SVProgressHUD showErrorWithStatus:@"Token 无效，请重新获取"];
            } else {
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"登录失败：%ld", (long)errorCode]];
            }
        });
    }];
}

- (void)configureRongIMSDK {
    // Demo 开启视频选择，用于展示 Sight 等媒体消息能力。
    RCKitConfigCenter.message.isMediaSelectorContainVideo = YES;

    RCDemoIMDataSource *dataSource = [RCDemoIMDataSource shared];
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
    [RCIM sharedRCIM].userInfoDataSource = dataSource;
    [RCIM sharedRCIM].groupInfoDataSource = dataSource;
    [RCIM sharedRCIM].groupUserInfoDataSource = dataSource;
    [RCIM sharedRCIM].groupMemberDataSource = dataSource;
    [RCIM sharedRCIM].receiveMessageDelegate = dataSource;
}

@end
