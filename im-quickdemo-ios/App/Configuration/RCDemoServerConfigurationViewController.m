//
//  RCDemoServerConfigurationViewController.m
//  im-quickdemo-ios
//
//  Created by pengwenxin on 2022/7/19.
//

#import "RCDemoServerConfigurationViewController.h"
#import "RCDemoConfiguration.h"
#import <RongIMKit/RongIMKit.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface RCDemoServerConfigurationViewController ()

@property (nonatomic, strong) UILabel * naviServerLab;
@property (nonatomic, strong) UILabel * fileServerLab;
@property (nonatomic, strong) UITextField * naviServerTextField;
@property (nonatomic, strong) UITextField * fileServerTextField;

@end

@implementation RCDemoServerConfigurationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"导航和文件服务";
    
    [self setNavigationItem];
    
    [self addSubviews];
    
    [self loadData];
}
#pragma mark - views
- (void)addSubviews {
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.naviServerLab];
    [self.view addSubview:self.fileServerLab];
    [self.view addSubview:self.naviServerTextField];
    [self.view addSubview:self.fileServerTextField];
    self.naviServerLab.frame = CGRectMake(8, 110, 80, 20);
    self.fileServerLab.frame = CGRectMake(8, 170, 80, 20);
    self.naviServerTextField.frame = CGRectMake(100, 100, 250, 40);
    self.fileServerTextField.frame = CGRectMake(100, 160, 250, 40);
}

- (void)setNavigationItem{
    UIImage *leftImage = [[UIImage imageNamed:@"nav_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem * leftBarItem = [[UIBarButtonItem alloc] initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(backButtonAction)];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonAction)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)backButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveButtonAction{
    NSString *naviServer = [self.naviServerTextField.text stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    NSString *fileServer = [self.fileServerTextField.text stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    [[RCDemoConfiguration shared] setNaviServer:naviServer];
    [[RCDemoConfiguration shared] setFileServer:fileServer];
    [SVProgressHUD showSuccessWithStatus:@"配置已保存，下次初始化 SDK 时生效"];
}

- (void)loadData {
    NSString *naviServer = [RCDemoConfiguration shared].naviServer;
    if (naviServer.length > 0) {
        self.naviServerTextField.text = naviServer;
    }else{
        self.naviServerTextField.text = @"";
        self.naviServerTextField.placeholder = @" 单行输入";
    }
    NSString *fileServer = [RCDemoConfiguration shared].fileServer;
    if (fileServer.length > 0) {
        self.fileServerTextField.text = fileServer;
    }else{
        self.fileServerTextField.text = @"";
        self.fileServerTextField.placeholder = @" 单行输入";
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:true];
}

- (UILabel *)naviServerLab{
    if (!_naviServerLab) {
        _naviServerLab = [[UILabel alloc] init];
        _naviServerLab.text = @"naviServer";
        _naviServerLab.textColor = [UIColor blackColor];
        _naviServerLab.lineBreakMode = NSLineBreakByTruncatingTail;
        _naviServerLab.font = [UIFont systemFontOfSize:15];
        _naviServerLab.numberOfLines = 1;
    }
    return _naviServerLab;
}

- (UILabel *)fileServerLab{
    if (!_fileServerLab) {
        _fileServerLab = [[UILabel alloc] init];
        _fileServerLab.text = @"fileServer";
        _fileServerLab.textColor = [UIColor blackColor];
        _fileServerLab.lineBreakMode = NSLineBreakByTruncatingTail;
        _fileServerLab.font = [UIFont systemFontOfSize:15];
        _fileServerLab.numberOfLines = 1;
    }
    return _fileServerLab;
}

- (UITextField *)fileServerTextField{
    if(!_fileServerTextField){
        
        _fileServerTextField = [[UITextField alloc] init];
        _fileServerTextField.font = [UIFont systemFontOfSize:15];
        _fileServerTextField.layer.masksToBounds = YES;
        _fileServerTextField.layer.borderWidth = 1.0;
        _fileServerTextField.layer.cornerRadius = 6;
        _fileServerTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
        _fileServerTextField.leftView.userInteractionEnabled = NO;
        _fileServerTextField.leftViewMode = UITextFieldViewModeAlways;
        _fileServerTextField.layer.borderColor = [RCKitUtility generateDynamicColor:HEXCOLOR(0xCFCFCF)
                                                                          darkColor:HEXCOLOR(0xCFCFCF)].CGColor;
        _fileServerTextField.textColor = [RCKitUtility generateDynamicColor:HEXCOLOR(0x707071)
                                                                  darkColor:HEXCOLOR(0x707071)];
        _fileServerTextField.backgroundColor = [UIColor whiteColor];
        _fileServerTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 单行输入" attributes:@{NSForegroundColorAttributeName:[RCKitUtility generateDynamicColor:HEXCOLOR(0xD7DADA) darkColor:HEXCOLOR(0xD7DADA)], NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    }
    return _fileServerTextField;
}

- (UITextField *)naviServerTextField{
    if(!_naviServerTextField){
        
        _naviServerTextField = [[UITextField alloc] init];
        _naviServerTextField.font = [UIFont systemFontOfSize:15];
        _naviServerTextField.layer.masksToBounds = YES;
        _naviServerTextField.layer.borderWidth = 1.0;
        _naviServerTextField.layer.cornerRadius = 6;
        _naviServerTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
        _naviServerTextField.leftView.userInteractionEnabled = NO;
        _naviServerTextField.leftViewMode = UITextFieldViewModeAlways;
        _naviServerTextField.layer.borderColor = [RCKitUtility generateDynamicColor:HEXCOLOR(0xCFCFCF)
                                                                          darkColor:HEXCOLOR(0xCFCFCF)].CGColor;
        _naviServerTextField.textColor = [RCKitUtility generateDynamicColor:HEXCOLOR(0x707071)
                                                                  darkColor:HEXCOLOR(0xF5F5F5)];
        _naviServerTextField.backgroundColor = [UIColor whiteColor];
        _naviServerTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 单行输入" attributes:@{NSForegroundColorAttributeName:[RCKitUtility generateDynamicColor:HEXCOLOR(0xD7DADA) darkColor:HEXCOLOR(0xD7DADA)], NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    }
    return _naviServerTextField;
}
@end
