#import "RCDemoIMLibCoreParameterViewController.h"
#import "RCDemoIMLibCoreFeature.h"
#import "RCDemoIMLibCoreFeatureExecutor.h"
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

@interface RCDemoIMLibCoreParameterViewController () <UITextFieldDelegate, UIDocumentPickerDelegate>
@property (nonatomic, strong) RCDemoIMLibCoreFeature *feature;
@property (nonatomic, strong) UIStackView *formStackView;
@property (nonatomic, strong) UITextView *resultTextView;
@property (nonatomic, strong) NSMutableDictionary<NSString *, UIControl *> *controls;
@property (nonatomic, strong) UIButton *executeButton;
@property (nonatomic, strong) UIButton *cancelMediaButton;
@property (nonatomic, weak) UITextField *localPathTextField;
@end

@implementation RCDemoIMLibCoreParameterViewController

- (instancetype)initWithFeature:(RCDemoIMLibCoreFeature *)feature {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _feature = feature;
        _controls = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.feature.title;
    self.view.backgroundColor = UIColor.systemGroupedBackgroundColor;
    [self buildInterface];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isMovingFromParentViewController && self.feature.action == RCDemoIMLibCoreFeatureActionListenReceiveMessage) {
        [[RCDemoIMLibCoreFeatureExecutor sharedExecutor] executeFeature:self.feature
                                                             parameters:@{@"listenEnabled": @NO}
                                                              completion:^(__unused NSString *result, __unused BOOL success) {}];
    }
}

- (void)buildInterface {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    [self.view addSubview:scrollView];

    UIStackView *contentStack = [[UIStackView alloc] init];
    contentStack.axis = UILayoutConstraintAxisVertical;
    contentStack.spacing = 14;
    contentStack.translatesAutoresizingMaskIntoConstraints = NO;
    [scrollView addSubview:contentStack];

    [NSLayoutConstraint activateConstraints:@[
        [scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [contentStack.topAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.topAnchor constant:16],
        [contentStack.leadingAnchor constraintEqualToAnchor:scrollView.frameLayoutGuide.leadingAnchor constant:16],
        [contentStack.trailingAnchor constraintEqualToAnchor:scrollView.frameLayoutGuide.trailingAnchor constant:-16],
        [contentStack.bottomAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.bottomAnchor constant:-24],
    ]];

    UILabel *apiLabel = [[UILabel alloc] init];
    apiLabel.numberOfLines = 0;
    apiLabel.font = [UIFont monospacedSystemFontOfSize:13 weight:UIFontWeightRegular];
    apiLabel.textColor = UIColor.secondaryLabelColor;
    apiLabel.text = [NSString stringWithFormat:@"SDK API\n%@", self.feature.api];
    [contentStack addArrangedSubview:apiLabel];

    if (self.feature.note.length > 0) {
        UILabel *noteLabel = [[UILabel alloc] init];
        noteLabel.numberOfLines = 0;
        noteLabel.font = [UIFont systemFontOfSize:14];
        noteLabel.textColor = UIColor.systemOrangeColor;
        noteLabel.text = self.feature.note;
        [contentStack addArrangedSubview:noteLabel];
    }

    self.formStackView = [[UIStackView alloc] init];
    self.formStackView.axis = UILayoutConstraintAxisVertical;
    self.formStackView.spacing = 10;
    [contentStack addArrangedSubview:self.formStackView];

    for (NSString *parameterKey in self.feature.parameterKeys) {
        [self addControlForParameterKey:parameterKey];
    }

    self.executeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.executeButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.executeButton.backgroundColor = UIColor.systemBlueColor;
    self.executeButton.tintColor = UIColor.whiteColor;
    self.executeButton.layer.cornerRadius = 6;
    self.executeButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    [self.executeButton setTitle:@"执行接口调用" forState:UIControlStateNormal];
    [self.executeButton addTarget:self action:@selector(executeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.executeButton.heightAnchor constraintEqualToConstant:48].active = YES;
    [contentStack addArrangedSubview:self.executeButton];

    if ([self isMediaSendFeature]) {
        self.cancelMediaButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.cancelMediaButton setImage:[UIImage systemImageNamed:@"xmark.circle"] forState:UIControlStateNormal];
        [self.cancelMediaButton setTitle:@" 取消媒体发送" forState:UIControlStateNormal];
        self.cancelMediaButton.enabled = NO;
        [self.cancelMediaButton addTarget:self action:@selector(cancelMediaButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelMediaButton.heightAnchor constraintEqualToConstant:44].active = YES;
        [contentStack addArrangedSubview:self.cancelMediaButton];
    }

    UILabel *resultTitle = [[UILabel alloc] init];
    resultTitle.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    resultTitle.text = @"调用结果";
    [contentStack addArrangedSubview:resultTitle];

    self.resultTextView = [[UITextView alloc] init];
    self.resultTextView.translatesAutoresizingMaskIntoConstraints = NO;
    self.resultTextView.editable = NO;
    self.resultTextView.selectable = YES;
    self.resultTextView.font = [UIFont monospacedSystemFontOfSize:12 weight:UIFontWeightRegular];
    self.resultTextView.backgroundColor = UIColor.secondarySystemGroupedBackgroundColor;
    self.resultTextView.layer.cornerRadius = 6;
    self.resultTextView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.resultTextView.text = @"尚未执行";
    [self.resultTextView.heightAnchor constraintGreaterThanOrEqualToConstant:220].active = YES;
    [contentStack addArrangedSubview:self.resultTextView];
}

- (void)addControlForParameterKey:(NSString *)parameterKey {
    UIStackView *row = [[UIStackView alloc] init];
    row.axis = UILayoutConstraintAxisVertical;
    row.spacing = 5;

    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
    label.textColor = UIColor.secondaryLabelColor;
    label.text = [self displayNameForParameterKey:parameterKey];
    [row addArrangedSubview:label];

    if ([parameterKey isEqualToString:@"conversationType"]) {
        UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:@[@"单聊(1)", @"群聊(3)", @"超级群(10)"]];
        control.selectedSegmentIndex = 0;
        self.controls[parameterKey] = control;
        [row addArrangedSubview:control];
    } else if ([parameterKey isEqualToString:@"direction"]) {
        UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:@[@"发送消息", @"接收消息"]];
        control.selectedSegmentIndex = 0;
        self.controls[parameterKey] = control;
        [row addArrangedSubview:control];
    } else if ([parameterKey isEqualToString:@"order"]) {
        UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:@[@"降序/向后", @"升序/向前"]];
        control.selectedSegmentIndex = 0;
        self.controls[parameterKey] = control;
        [row addArrangedSubview:control];
    } else if ([self isBooleanParameter:parameterKey]) {
        UISwitch *control = [[UISwitch alloc] init];
        control.on = YES;
        self.controls[parameterKey] = control;
        [row addArrangedSubview:control];
    } else {
        UITextField *control = [[UITextField alloc] init];
        control.delegate = self;
        control.borderStyle = UITextBorderStyleRoundedRect;
        control.clearButtonMode = UITextFieldViewModeWhileEditing;
        control.font = [UIFont systemFontOfSize:15];
        control.placeholder = [self placeholderForParameterKey:parameterKey];
        control.text = [self defaultValueForParameterKey:parameterKey];
        control.autocorrectionType = UITextAutocorrectionTypeNo;
        control.autocapitalizationType = UITextAutocapitalizationTypeNone;
        control.keyboardType = [self keyboardTypeForParameterKey:parameterKey];
        control.secureTextEntry = [parameterKey isEqualToString:@"token"];
        [control.heightAnchor constraintEqualToConstant:42].active = YES;
        self.controls[parameterKey] = control;
        if ([parameterKey isEqualToString:@"localPath"]) {
            self.localPathTextField = control;
            UIStackView *inputRow = [[UIStackView alloc] init];
            inputRow.axis = UILayoutConstraintAxisHorizontal;
            inputRow.spacing = 8;
            [inputRow addArrangedSubview:control];
            UIButton *pickerButton = [UIButton buttonWithType:UIButtonTypeSystem];
            [pickerButton setImage:[UIImage systemImageNamed:@"folder"] forState:UIControlStateNormal];
            pickerButton.accessibilityLabel = @"选择本地文件";
            pickerButton.tintColor = UIColor.systemBlueColor;
            [pickerButton addTarget:self action:@selector(selectLocalFile) forControlEvents:UIControlEventTouchUpInside];
            [pickerButton.widthAnchor constraintEqualToConstant:44].active = YES;
            [inputRow addArrangedSubview:pickerButton];
            [row addArrangedSubview:inputRow];
        } else {
            [row addArrangedSubview:control];
        }
    }
    [self.formStackView addArrangedSubview:row];
}

- (void)selectLocalFile {
    UIDocumentPickerViewController *picker = [[UIDocumentPickerViewController alloc] initForOpeningContentTypes:@[UTTypeData] asCopy:NO];
    picker.delegate = self;
    picker.allowsMultipleSelection = NO;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    NSURL *sourceURL = urls.firstObject;
    if (!sourceURL) return;
    BOOL accessing = [sourceURL startAccessingSecurityScopedResource];
    NSString *fileName = sourceURL.lastPathComponent.length > 0 ? sourceURL.lastPathComponent : NSUUID.UUID.UUIDString;
    NSURL *destinationURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"imlibcore-%@-%@", NSUUID.UUID.UUIDString, fileName]]];
    NSError *error;
    [NSFileManager.defaultManager copyItemAtURL:sourceURL toURL:destinationURL error:&error];
    if (accessing) [sourceURL stopAccessingSecurityScopedResource];
    if (error) {
        [self showValidationMessage:[NSString stringWithFormat:@"复制测试文件失败：%@", error.localizedDescription]];
        return;
    }
    self.localPathTextField.text = destinationURL.path;
}

- (void)executeButtonClicked {
    NSDictionary *parameters = [self collectedParameters];
    if (![self validateParameters:parameters]) {
        return;
    }
    if (self.feature.isDangerous) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认执行"
                                                                       message:self.feature.note
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        __weak typeof(self) weakSelf = self;
        [alert addAction:[UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [weakSelf executeWithParameters:parameters];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    [self executeWithParameters:parameters];
}

- (void)executeWithParameters:(NSDictionary<NSString *, id> *)parameters {
    self.executeButton.enabled = NO;
    self.cancelMediaButton.enabled = NO;
    [self.executeButton setTitle:@"执行中..." forState:UIControlStateNormal];
    NSString *parameterDescription = [self jsonDescription:parameters];
    self.resultTextView.text = [NSString stringWithFormat:@"功能：%@\nAPI：%@\n时间：%@\n参数：\n%@\n\n状态：执行中", self.feature.title, self.feature.api, [NSDate date], parameterDescription];

    __weak typeof(self) weakSelf = self;
    [[RCDemoIMLibCoreFeatureExecutor sharedExecutor] executeFeature:self.feature parameters:parameters completion:^(NSString *result, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([result hasPrefix:@"PROGRESS:"]) {
                weakSelf.cancelMediaButton.enabled = YES;
                weakSelf.resultTextView.text = [NSString stringWithFormat:@"功能：%@\nAPI：%@\n时间：%@\n参数：\n%@\n\n状态：执行中\n%@", weakSelf.feature.title, weakSelf.feature.api, [NSDate date], parameterDescription, [result substringFromIndex:@"PROGRESS:".length]];
                return;
            }
            weakSelf.executeButton.enabled = YES;
            weakSelf.cancelMediaButton.enabled = NO;
            [weakSelf.executeButton setTitle:@"执行接口调用" forState:UIControlStateNormal];
            weakSelf.resultTextView.text = [NSString stringWithFormat:@"功能：%@\nAPI：%@\n时间：%@\n参数：\n%@\n\n状态：%@\n结果：\n%@", weakSelf.feature.title, weakSelf.feature.api, [NSDate date], parameterDescription, success ? @"成功" : @"失败", result ?: @""];
        });
    }];
}

- (void)cancelMediaButtonClicked {
    __weak typeof(self) weakSelf = self;
    [[RCDemoIMLibCoreFeatureExecutor sharedExecutor] cancelCurrentMediaMessageWithCompletion:^(NSString *result, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.cancelMediaButton.enabled = NO;
            weakSelf.executeButton.enabled = YES;
            [weakSelf.executeButton setTitle:@"执行接口调用" forState:UIControlStateNormal];
            weakSelf.resultTextView.text = [NSString stringWithFormat:@"状态：%@\n结果：\n%@", success ? @"已取消" : @"取消失败", result];
        });
    }];
}

- (BOOL)isMediaSendFeature {
    switch (self.feature.action) {
        case RCDemoIMLibCoreFeatureActionSendLocalImageMessage:
        case RCDemoIMLibCoreFeatureActionSendGIFMessage:
        case RCDemoIMLibCoreFeatureActionSendHQVoiceMessage:
        case RCDemoIMLibCoreFeatureActionSendLocalFileMessage:
        case RCDemoIMLibCoreFeatureActionSendLocalSightMessage:
        case RCDemoIMLibCoreFeatureActionSendCombineMessage:
            return YES;
        default:
            return NO;
    }
}

- (NSDictionary<NSString *, id> *)collectedParameters {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [self.controls enumerateKeysAndObjectsUsingBlock:^(NSString *key, UIControl *control, BOOL *stop) {
        if ([control isKindOfClass:UITextField.class]) {
            parameters[key] = ((UITextField *)control).text ?: @"";
        } else if ([control isKindOfClass:UISwitch.class]) {
            parameters[key] = @(((UISwitch *)control).isOn);
        } else if ([control isKindOfClass:UISegmentedControl.class]) {
            NSInteger index = ((UISegmentedControl *)control).selectedSegmentIndex;
            if ([key isEqualToString:@"conversationType"]) {
                NSInteger values[] = {1, 3, 10};
                parameters[key] = @(values[MAX(0, MIN(index, 2))]);
            } else if ([key isEqualToString:@"direction"]) {
                parameters[key] = index == 1 ? @"incoming" : @"outgoing";
            } else {
                parameters[key] = @(MAX(0, index));
            }
        }
    }];
    return parameters;
}

- (BOOL)validateParameters:(NSDictionary<NSString *, id> *)parameters {
    NSSet *requiredKeys = [NSSet setWithArray:@[@"token", @"targetId", @"userId", @"uniqueId", @"tagId", @"messageIdList", @"messageUId", @"messageUIdList", @"localPath", @"remoteUrl", @"imageUrl", @"title", @"summaryList", @"nameList", @"objectNameList", @"keyword", @"className", @"deviceTokenHex"]];
    for (NSString *key in self.feature.parameterKeys) {
        if ([requiredKeys containsObject:key] && [parameters[key] isKindOfClass:NSString.class] && [parameters[key] length] == 0) {
            [self showValidationMessage:[NSString stringWithFormat:@"%@ 为必填参数。", key]];
            return NO;
        }
    }
    NSString *localPath = parameters[@"localPath"];
    if ([localPath isKindOfClass:NSString.class] && localPath.length > 0 && ![NSFileManager.defaultManager fileExistsAtPath:localPath]) {
        [self showValidationMessage:@"localPath 指向的文件不存在。"];
        return NO;
    }
    for (NSString *urlKey in @[@"remoteUrl", @"imageUrl"]) {
        NSString *value = parameters[urlKey];
        if ([value isKindOfClass:NSString.class] && value.length > 0 && ![NSURL URLWithString:value].scheme.length) {
            [self showValidationMessage:[NSString stringWithFormat:@"%@ 需要输入完整 URL。", urlKey]];
            return NO;
        }
    }
    return YES;
}

- (void)showValidationMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"参数错误" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSString *)jsonDescription:(NSDictionary *)parameters {
    if (![NSJSONSerialization isValidJSONObject:parameters]) {
        return parameters.description;
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ?: parameters.description;
}

- (BOOL)isBooleanParameter:(NSString *)key {
    static NSSet *keys;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keys = [NSSet setWithArray:@[@"receivePush", @"listenEnabled", @"isTop", @"isBlocked", @"checkDuplicate", @"isRead", @"isListened", @"isDownloaded", @"includeLocalExistMessage", @"containBlocked", @"clearRemote", @"showPushContent"]];
    });
    return [keys containsObject:key];
}

- (NSString *)displayNameForParameterKey:(NSString *)key {
    NSDictionary *names = @{
        @"conversationType": @"conversationType（会话类型）",
        @"conversationTypeList": @"conversationTypeList（逗号分隔，如 1,3）",
        @"targetId": @"targetId（会话 ID）",
        @"targetIdList": @"targetIdList（逗号分隔）",
        @"channelId": @"channelId（频道 ID，可选）",
        @"userId": @"userId（用户 ID）",
        @"userIdList": @"userIdList（逗号分隔）",
        @"messageId": @"messageId（本地消息 ID）",
        @"messageIdList": @"messageIdList（逗号分隔）",
        @"messageUId": @"messageUId（服务端消息 ID）",
        @"messageUIdList": @"messageUIdList（逗号分隔）",
        @"baseMessageId": @"baseMessageId（本地消息 ID，0 从最新开始）",
        @"timestamp": @"timestamp（毫秒）",
        @"json": @"JSON / Key-Value 参数",
        @"localPath": @"localPath（本地媒体绝对路径）",
        @"listenEnabled": @"开启监听（关闭时移除监听）",
        @"includeLocalExistMessage": @"包含本地已存在消息",
        @"order": @"order（历史消息拉取顺序）",
        @"direction": @"direction（本地插入方向）",
        @"deviceTokenHex": @"deviceTokenHex（APNs Token 十六进制）",
    };
    return names[key] ?: key;
}

- (NSString *)placeholderForParameterKey:(NSString *)key {
    if ([key hasSuffix:@"List"]) return @"多个值使用英文逗号分隔";
    if ([key isEqualToString:@"json"]) return @"例如 {\"key\":\"value\"}";
    if ([key isEqualToString:@"startTime"]) return @"例如 22:30:00 或毫秒时间戳";
    return [NSString stringWithFormat:@"请输入 %@", key];
}

- (NSString *)defaultValueForParameterKey:(NSString *)key {
    NSDictionary *defaults = @{
        @"conversationTypeList": @"1,3",
        @"content": @"IMLibCore API test",
        @"pushContent": @"",
        @"pushData": @"",
        @"count": @"20",
        @"baseMessageId": @"0",
        @"timestamp": @"0",
        @"startTime": @"00:00:00",
        @"endTime": @"0",
        @"offset": @"0",
        @"duration": @"1",
        @"width": @"100",
        @"height": @"100",
        @"logLevel": @"4",
        @"notificationLevel": @"0",
        @"notificationLevelList": @"0,1,2,3,4,5",
        @"objectName": @"RC:TxtMsg",
        @"objectNameList": @"RC:TxtMsg",
        @"spanMins": @"60",
        @"expiry": @"3600",
        @"role": @"0",
        @"level": @"0",
        @"gender": @"0",
        @"order": @"0",
        @"direction": @"outgoing",
        @"sentStatus": @"30",
        @"languageCode": @"zh-Hans",
        @"className": @"RCDemoCustomMessage",
        @"json": @"{}",
    };
    return defaults[key] ?: @"";
}

- (UIKeyboardType)keyboardTypeForParameterKey:(NSString *)key {
    NSSet *numericKeys = [NSSet setWithArray:@[@"count", @"timestamp", @"baseMessageId", @"startTime", @"endTime", @"offset", @"duration", @"width", @"height", @"logLevel", @"notificationLevel", @"spanMins", @"expiry", @"role", @"level", @"gender", @"messageId", @"sentStatus", @"latitude", @"longitude"]];
    return [numericKeys containsObject:key] ? UIKeyboardTypeNumbersAndPunctuation : UIKeyboardTypeDefault;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end

