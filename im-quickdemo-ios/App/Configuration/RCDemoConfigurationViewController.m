//
//  RCDemoConfigurationViewController.m
//  im-quickdemo-ios
//
//  Created by pengwenxin on 2022/7/19.
//

#import "RCDemoConfigurationViewController.h"
#import "RCDemoServerConfigurationViewController.h"
#import "RCDemoConversationConfigurationViewController.h"

@interface RCDemoConfigurationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic,   copy) NSArray     * items;

@end

@implementation RCDemoConfigurationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"配置页面";
    [self setNavigationItem];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.tableView];
    CGSize screenSize = UIScreen.mainScreen.bounds.size;
    self.tableView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height - 100);
    NSArray * arr  = @[
            @{
                @"title":@"配置导航和文件服务",
            },
            @{
                @"title":@"配置会话列表页面参数",
            }];
    
    self.items = arr;
    [self.tableView reloadData];
}

- (void)setNavigationItem{
    UIImage *leftImage = [[UIImage imageNamed:@"nav_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem * leftBarItem = [[UIBarButtonItem alloc] initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(backButtonAction)];
    self.navigationItem.leftBarButtonItem = leftBarItem;
}

- (void)backButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.items.count <=0) {
        return [[UITableViewCell alloc] init];
    }
     UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
     NSDictionary * dict = self.items[indexPath.row];
     cell.textLabel.text = [dict objectForKey:@"title"];
     return cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.items.count <=0) {return;}
   
    if (indexPath.row == 0) {
        RCDemoServerConfigurationViewController * vc = [[RCDemoServerConfigurationViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.row == 1){
        RCDemoConversationConfigurationViewController * vc = [[RCDemoConversationConfigurationViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - UILazy
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = NO;
        _tableView.estimatedRowHeight = 0.f;
        _tableView.delaysContentTouches = NO;
    }
    return _tableView;
}
@end
