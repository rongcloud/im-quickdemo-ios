//
//  FunctionRootVC.m
//  support-im-ios-debugdemo
//
//  Created by 于艳平 on 2022/7/12.
//

#import "FunctionRootVC.h"
#import "TextViewCell.h"
#import "MessageFunctionListVC.h"
#import "ChatRoomFunctionListVC.h"

@interface FunctionRootVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation FunctionRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"功能清单";
    self.dataSource = [@[
        @"消息",
        @"聊天室"
    ] mutableCopy];
    
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"TextViewCell";
    TextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[TextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.txtName.text = [self.dataSource objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *sbId;
    switch (indexPath.row) {
        case 0:
            // 消息
            sbId = @"MessageFunctionListVC";
            break;
        case 1:
            // 聊天室
            sbId = @"ChatRoomFunctionListVC";
            break;
        default:
            break;
    }
    if (sbId.length > 0) {
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:sbId];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
