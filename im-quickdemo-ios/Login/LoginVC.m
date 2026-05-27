//
//  ViewController.m
//  support-im-ios-debugdemo
//
//  Created by 于艳平 on 2022/7/11.
//

#import "LoginVC.h"
#import "TabBarController.h"
#import "ChatListVC.h"
#import "ConfigInfoVC.h"
#import "CustomMessage.h"
#import "CustomMediaMessage.h"
#import "IMDataSource.h"


@interface LoginVC ()

@property (weak, nonatomic) IBOutlet UITextField *appkeyTextField;
@property (weak, nonatomic) IBOutlet UITextField *tokenTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登录";
    [RCCoreClient sharedCoreClient].logLevel = RC_Log_Level_Verbose;

    NSString *appKey = [AppGlobalConfig shareInstance].appKey;
    if (appKey.length > 0) {
        self.appkeyTextField.text = appKey;
    } else {
        self.appkeyTextField.text = ;
    }
    NSString *token = [AppGlobalConfig shareInstance].token;
    if (token.length > 0) {
        self.tokenTextField.text = token;
    } else {
        self.tokenTextField.text =
    }
}

- (IBAction)setConfigButtonAction:(id)sender {
    ConfigInfoVC * vc = [[ConfigInfoVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)loginButtonAction:(UIButton *)sender {
    if (self.appkeyTextField.text.length == 0) {
        [RCAlertView showAlertController:@"标题" message:@"appkey不能为空" cancelTitle:@"确定" inViewController:self];
        return;
    }
    if (self.tokenTextField.text.length == 0) {
        [RCAlertView showAlertController:@"标题" message:@"token不能为空" cancelTitle:@"确定" inViewController:self];
        return;
    }

    [[AppGlobalConfig shareInstance] setAppKey:self.appkeyTextField.text];
    [[AppGlobalConfig shareInstance] setToken:self.tokenTextField.text];

    // 初始化 SDK
    [[RCIM sharedRCIM] initWithAppKey:self.appkeyTextField.text];
    // 注册自定义消息
    [[RCCoreClient sharedCoreClient] registerMessageType:[CustomMessage class]];
    [[RCCoreClient sharedCoreClient] registerMessageType:[CustomMediaMessage class]];

    [self configRongIMSDK];
    [self connectIM:self.tokenTextField.text];
}

- (void)connectIM:(NSString *)token {
    [[RCIM sharedRCIM] connectWithToken:token dbOpened:^(RCDBErrorCode code) {

    } success:^(NSString *userId) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //从 APP 服务器获得当前用户信息
            RCUserInfo *userInfoModel = [[RCUserInfo alloc] init];
            userInfoModel.userId = userId;
            userInfoModel.name = [NSString stringWithFormat:@"用户 %@",userId];
            userInfoModel.portraitUri= @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg3.doubanio.com%2Fview%2Fgroup_topic%2Fl%2Fpublic%2Fp314207052.jpg&refer=http%3A%2F%2Fimg3.doubanio.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1638589198&t=39c7009d85d3f904cb57e1ee1c008982";
            [[RCIM sharedRCIM] setCurrentUserInfo:userInfoModel];
            
            TabBarController *tabBarVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
            [[UIApplication sharedApplication].keyWindow setRootViewController:tabBarVC];
        });
    } error:^(RCConnectErrorCode errorCode) {
        if (errorCode == RC_CONN_TOKEN_INCORRECT) {
            [[AppGlobalConfig shareInstance] removeToken];
            [SVProgressHUD showErrorWithStatus:@"token失效，点击登录按钮重新获取"];
        } else {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"登录失败:%ld", errorCode]];
        }
    }];
}


- (void)configRongIMSDK{
    /*!
      选择媒体资源时，是否包含视频文件，默认值是NO
      @discussion 默认是不包含， 如果设置成 YES 图库中 包含了视频文件
     */
    RCKitConfigCenter.message.isMediaSelectorContainVideo = YES;
    
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
    [RCIM sharedRCIM].userInfoDataSource = RCDataSource;
    [RCIM sharedRCIM].groupInfoDataSource = RCDataSource;
    [RCIM sharedRCIM].groupUserInfoDataSource = RCDataSource;
    [RCIM sharedRCIM].groupMemberDataSource = RCDataSource;
    [RCIM sharedRCIM].receiveMessageDelegate = RCDataSource;
    
}

@end
