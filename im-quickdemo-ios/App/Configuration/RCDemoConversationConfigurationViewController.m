//
//  RCDemoConversationConfigurationViewController.m
//  im-quickdemo-ios
//
//  Created by pengwenxin on 2022/7/22.
//

#import "RCDemoConversationConfigurationViewController.h"
#import "RCDemoConfiguration.h"
#import <RongIMKit/RongIMKit.h>

@interface RCDemoConversationConfigurationViewController ()

@property (nonatomic, strong) UILabel * titleLab;
@property (nonatomic, strong) UILabel * conversationTypeLab;
@property (nonatomic, strong) UILabel * collectionConversationTypeLab;
@property (nonatomic, strong) UIButton * conversationTypePrivateBtn;//单聊会话
@property (nonatomic, strong) UIButton * conversationTypeGroupBtn;//群会话
@property (nonatomic, strong) UIButton * conversationTypeSystemBtn;//系统会话
@property (nonatomic, strong) UIButton * collectionTypePrivateBtn;//聚合单聊
@property (nonatomic, strong) UIButton * collectionTypeGroupBtn;//聚合群组
@property (nonatomic, strong) UIButton * collectionTypeSystemBtn;//聚合系统

@property (nonatomic, copy) NSArray *displayConversationsList;
@property (nonatomic, copy) NSArray *collectionTypesList;

@end

@implementation RCDemoConversationConfigurationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"配置会话列表";
    
    [self setNavigationItem];
    
    [self addSubviews];
    
    [self loadData];
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
    [[RCDemoConfiguration shared] setDisplayConversationTypeArray:self.displayConversationsList];
    [[RCDemoConfiguration shared] setCollectionConversationTypeArray:self.collectionTypesList];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addSubviews {
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.titleLab];
    [self.view addSubview:self.conversationTypeLab];
    [self.view addSubview:self.conversationTypePrivateBtn];
    [self.view addSubview:self.conversationTypeGroupBtn];
    [self.view addSubview:self.conversationTypeSystemBtn];
    
    CGFloat screenWidth = CGRectGetWidth(UIScreen.mainScreen.bounds);
    self.titleLab.frame = CGRectMake(16, 100, screenWidth - 32, 40);
    self.conversationTypeLab.frame = CGRectMake(16, 165, 180, 20);
    self.conversationTypePrivateBtn.frame = CGRectMake(16, 200, 80, 40);
    self.conversationTypeGroupBtn.frame = CGRectMake((screenWidth - 80)/2 , 200, 80, 40);
    self.conversationTypeSystemBtn.frame = CGRectMake(screenWidth - 16 - 80, 200, 80, 40);
    
    [self.view addSubview:self.collectionConversationTypeLab];
    [self.view addSubview:self.collectionTypePrivateBtn];
    [self.view addSubview:self.collectionTypeGroupBtn];
    [self.view addSubview:self.collectionTypeSystemBtn];
    
    self.collectionConversationTypeLab.frame = CGRectMake(16, 285, 180, 20);
    self.collectionTypePrivateBtn.frame = CGRectMake(16, 310, 80, 40);
    self.collectionTypeGroupBtn.frame = CGRectMake((screenWidth - 80)/2 , 310, 80, 40);
    self.collectionTypeSystemBtn.frame = CGRectMake(screenWidth - 16 - 80, 310, 80, 40);
}

- (void)loadData{
    // 默认 会话类型  单聊 群聊 和系统会话
    NSArray *displayConversationTypeArray = [RCDemoConfiguration shared].displayConversationTypeArray;
    self.displayConversationsList = displayConversationTypeArray;
    if (displayConversationTypeArray.count>0) {
        
        for (NSNumber * number  in displayConversationTypeArray) {
            if([number longValue] == ConversationType_PRIVATE){
                if (!self.conversationTypePrivateBtn.isSelected) {
                    self.conversationTypePrivateBtn.selected = YES;
                }else{
                    self.conversationTypePrivateBtn.selected = NO;
                }
            }
            if([number longValue] == ConversationType_GROUP){
                if (!self.conversationTypeGroupBtn.isSelected) {
                    self.conversationTypeGroupBtn.selected = YES;
                }else{
                    self.conversationTypeGroupBtn.selected = NO;
                }
            }
            if([number longValue] == ConversationType_SYSTEM){
                if (!self.conversationTypeSystemBtn.isSelected) {
                    self.conversationTypeSystemBtn.selected = YES;
                }else{
                    self.conversationTypeSystemBtn.selected = NO;
                }
            }
        }
    }else{
        self.conversationTypePrivateBtn.selected = YES;
        self.conversationTypeGroupBtn.selected = YES;
        self.conversationTypeSystemBtn.selected = YES;
        NSMutableArray * muteArr = @[].mutableCopy;
        [muteArr addObject:@(ConversationType_PRIVATE)];
        [muteArr addObject:@(ConversationType_GROUP)];
        [muteArr addObject:@(ConversationType_SYSTEM)];
        self.displayConversationsList = muteArr.copy;
        [[RCDemoConfiguration shared] setDisplayConversationTypeArray:self.displayConversationsList];
    }
    // 设置聚合会话数据
    NSArray *collectionTypeArray = [RCDemoConfiguration shared].collectionConversationTypeArray;
    self.collectionTypesList = collectionTypeArray;
    if (collectionTypeArray.count>0) {
        
        for (NSNumber * number  in collectionTypeArray) {
            if([number longValue] == ConversationType_PRIVATE){
                if (!self.collectionTypePrivateBtn.isSelected) {
                    self.collectionTypePrivateBtn.selected = YES;
                }else{
                    self.collectionTypePrivateBtn.selected = NO;
                }
            }
            if([number longValue] == ConversationType_GROUP){
                if (!self.collectionTypeGroupBtn.isSelected) {
                    self.collectionTypeGroupBtn.selected = YES;
                }else{
                    self.collectionTypeGroupBtn.selected = NO;
                }
            }
            if([number longValue] == ConversationType_SYSTEM){
                if (!self.collectionTypeSystemBtn.isSelected) {
                    self.collectionTypeSystemBtn.selected = YES;
                }else{
                    self.collectionTypeSystemBtn.selected = NO;
                }
            }
        }
    }else{
        self.collectionTypePrivateBtn.selected = NO;
        self.collectionTypeGroupBtn.selected = NO;
        self.collectionTypeSystemBtn.selected = YES;
        NSMutableArray * muteArr = @[].mutableCopy;
        [muteArr addObject:@(ConversationType_SYSTEM)];
        self.collectionTypesList = muteArr.copy;
        [[RCDemoConfiguration shared] setCollectionConversationTypeArray:self.collectionTypesList];
    }
}

- (void)conversationPrivateBtnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    NSMutableArray * muteArr = @[].mutableCopy;
    if(![self.displayConversationsList containsObject:@(ConversationType_PRIVATE)]){
        [muteArr addObject:@(ConversationType_PRIVATE)];
    }
    [muteArr addObjectsFromArray:self.displayConversationsList];
    if(!btn.isSelected){
        [muteArr removeObject:@(ConversationType_PRIVATE)];
    }
    self.displayConversationsList = muteArr.copy;
}

- (void)conversationGroupBtnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    NSMutableArray * muteArr = @[].mutableCopy;
    if(![self.displayConversationsList containsObject:@(ConversationType_GROUP)]){
        [muteArr addObject:@(ConversationType_GROUP)];
    }
    [muteArr addObjectsFromArray:self.displayConversationsList];
    if(!btn.isSelected){
        [muteArr removeObject:@(ConversationType_GROUP)];
    }
    self.displayConversationsList = muteArr.copy;
}

- (void)conversationSystemBtnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    NSMutableArray * muteArr = @[].mutableCopy;
    if(![self.displayConversationsList containsObject:@(ConversationType_SYSTEM)]){
        [muteArr addObject:@(ConversationType_SYSTEM)];
    }
    [muteArr addObjectsFromArray:self.displayConversationsList];
    if(!btn.isSelected){
        [muteArr removeObject:@(ConversationType_SYSTEM)];
    }
    self.displayConversationsList = muteArr.copy;
}

- (void)collectionPrivateBtnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    NSMutableArray * muteArr = @[].mutableCopy;
    if(![self.collectionTypesList containsObject:@(ConversationType_PRIVATE)]){
        [muteArr addObject:@(ConversationType_PRIVATE)];
    }
    [muteArr addObjectsFromArray:self.collectionTypesList];
    if(!btn.isSelected){
        [muteArr removeObject:@(ConversationType_PRIVATE)];
    }
    self.collectionTypesList = muteArr.copy;
}

- (void)collectionGroupBtnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    NSMutableArray * muteArr = @[].mutableCopy;
    if(![self.collectionTypesList containsObject:@(ConversationType_GROUP)]){
        [muteArr addObject:@(ConversationType_GROUP)];
    }
    [muteArr addObjectsFromArray:self.collectionTypesList];
    if(!btn.isSelected){
        [muteArr removeObject:@(ConversationType_GROUP)];
    }
    self.collectionTypesList = muteArr.copy;
}

- (void)collectionSystemBtnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    NSMutableArray * muteArr = @[].mutableCopy;
    if(![self.collectionTypesList containsObject:@(ConversationType_SYSTEM)]){
        [muteArr addObject:@(ConversationType_SYSTEM)];
    }
    [muteArr addObjectsFromArray:self.collectionTypesList];
    if(!btn.isSelected){
        [muteArr removeObject:@(ConversationType_SYSTEM)];
    }
    self.collectionTypesList = muteArr.copy;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = @"如果不配置，本Demo默认显示单聊、群聊和系统会话，并且将系统会话聚合。";
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLab.font = [UIFont systemFontOfSize:15];
        _titleLab.numberOfLines = 3;
    }
    return _titleLab;
}

- (UILabel *)conversationTypeLab{
    if (!_conversationTypeLab) {
        _conversationTypeLab = [[UILabel alloc] init];
        _conversationTypeLab.text = @"需要显示的会话类型:";
        _conversationTypeLab.textColor = [UIColor blackColor];
        _conversationTypeLab.lineBreakMode = NSLineBreakByTruncatingTail;
        _conversationTypeLab.font = [UIFont systemFontOfSize:15];
        _conversationTypeLab.numberOfLines = 1;
    }
    return _conversationTypeLab;
}

- (UILabel *)collectionConversationTypeLab{
    if (!_collectionConversationTypeLab) {
        _collectionConversationTypeLab = [[UILabel alloc] init];
        _collectionConversationTypeLab.text = @"需要聚合显示的会话类型:";
        _collectionConversationTypeLab.textColor = [UIColor blackColor];
        _collectionConversationTypeLab.lineBreakMode = NSLineBreakByTruncatingTail;
        _collectionConversationTypeLab.font = [UIFont systemFontOfSize:15];
        _collectionConversationTypeLab.numberOfLines = 1;
    }
    return _collectionConversationTypeLab;
}

- (UIButton *)conversationTypePrivateBtn{
    if (!_conversationTypePrivateBtn) {
        _conversationTypePrivateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_conversationTypePrivateBtn setTitle:@"单聊" forState:UIControlStateNormal];
        [_conversationTypePrivateBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _conversationTypePrivateBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_conversationTypePrivateBtn setImage:[UIImage imageNamed:@"selection_unselected"] forState:UIControlStateNormal];
        [_conversationTypePrivateBtn setImage:[UIImage imageNamed:@"selection_selected"] forState:UIControlStateSelected];
        [_conversationTypePrivateBtn addTarget:self action:@selector(conversationPrivateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _conversationTypePrivateBtn;
}

- (UIButton *)conversationTypeGroupBtn{
    if (!_conversationTypeGroupBtn) {
        _conversationTypeGroupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_conversationTypeGroupBtn setTitle:@"群聊" forState:UIControlStateNormal];
        [_conversationTypeGroupBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _conversationTypeGroupBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_conversationTypeGroupBtn setImage:[UIImage imageNamed:@"selection_unselected"] forState:UIControlStateNormal];
        [_conversationTypeGroupBtn setImage:[UIImage imageNamed:@"selection_selected"] forState:UIControlStateSelected];
        [_conversationTypeGroupBtn addTarget:self action:@selector(conversationGroupBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _conversationTypeGroupBtn;
}

- (UIButton *)conversationTypeSystemBtn{
    if (!_conversationTypeSystemBtn) {
        _conversationTypeSystemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_conversationTypeSystemBtn setTitle:@"系统" forState:UIControlStateNormal];
        [_conversationTypeSystemBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _conversationTypeSystemBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_conversationTypeSystemBtn setImage:[UIImage imageNamed:@"selection_unselected"] forState:UIControlStateNormal];
        [_conversationTypeSystemBtn setImage:[UIImage imageNamed:@"selection_selected"] forState:UIControlStateSelected];
        [_conversationTypeSystemBtn addTarget:self action:@selector(conversationSystemBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _conversationTypeSystemBtn;
}


- (UIButton *)collectionTypePrivateBtn{
    if (!_collectionTypePrivateBtn) {
        _collectionTypePrivateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectionTypePrivateBtn setTitle:@"单聊" forState:UIControlStateNormal];
        [_collectionTypePrivateBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _collectionTypePrivateBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_collectionTypePrivateBtn setImage:[UIImage imageNamed:@"selection_unselected"] forState:UIControlStateNormal];
        [_collectionTypePrivateBtn setImage:[UIImage imageNamed:@"selection_selected"] forState:UIControlStateSelected];
        [_collectionTypePrivateBtn addTarget:self action:@selector(collectionPrivateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectionTypePrivateBtn;
}

- (UIButton *)collectionTypeGroupBtn{
    if (!_collectionTypeGroupBtn) {
        _collectionTypeGroupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectionTypeGroupBtn setTitle:@"群聊" forState:UIControlStateNormal];
        [_collectionTypeGroupBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _collectionTypeGroupBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_collectionTypeGroupBtn setImage:[UIImage imageNamed:@"selection_unselected"] forState:UIControlStateNormal];
        [_collectionTypeGroupBtn setImage:[UIImage imageNamed:@"selection_selected"] forState:UIControlStateSelected];
        [_collectionTypeGroupBtn addTarget:self action:@selector(collectionGroupBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectionTypeGroupBtn;
}

- (UIButton *)collectionTypeSystemBtn{
    if (!_collectionTypeSystemBtn) {
        _collectionTypeSystemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectionTypeSystemBtn setTitle:@"系统" forState:UIControlStateNormal];
        [_collectionTypeSystemBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _collectionTypeSystemBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_collectionTypeSystemBtn setImage:[UIImage imageNamed:@"selection_unselected"] forState:UIControlStateNormal];
        [_collectionTypeSystemBtn setImage:[UIImage imageNamed:@"selection_selected"] forState:UIControlStateSelected];
        [_collectionTypeSystemBtn addTarget:self action:@selector(collectionSystemBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectionTypeSystemBtn;
}
@end
