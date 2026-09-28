//
//  RCDemoIMLibCoreViewController.m
//  im-quickdemo-ios
//
//  Created by 于艳平 on 2022/7/12.
//

#import "RCDemoIMLibCoreViewController.h"
#import "RCDemoIMLibCoreFeature.h"
#import "RCDemoIMLibCoreFeatureCatalog.h"
#import "RCDemoIMLibCoreParameterViewController.h"

@interface RCDemoIMLibCoreViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray<RCDemoIMLibCoreFeatureGroup *> *groups;
@end

@implementation RCDemoIMLibCoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"IMLibCore";
    self.view.backgroundColor = UIColor.systemGroupedBackgroundColor;
    self.groups = [RCDemoIMLibCoreFeatureCatalog allGroups];
    [self configureTableView];
}

- (void)configureTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleInsetGrouped];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 56;
    [self.view addSubview:self.tableView];
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    ]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    RCDemoIMLibCoreFeatureGroup *group = self.groups[section];
    return group.isExpanded ? group.features.count : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    RCDemoIMLibCoreFeatureGroup *group = self.groups[section];
    UIControl *header = [[UIControl alloc] init];
    header.tag = section;
    header.backgroundColor = UIColor.secondarySystemGroupedBackgroundColor;
    [header addTarget:self action:@selector(groupHeaderClicked:) forControlEvents:UIControlEventTouchUpInside];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    titleLabel.text = group.title;
    [header addSubview:titleLabel];

    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:group.isExpanded ? @"chevron.down" : @"chevron.right"]];
    arrowView.translatesAutoresizingMaskIntoConstraints = NO;
    arrowView.tintColor = UIColor.secondaryLabelColor;
    [header addSubview:arrowView];

    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.leadingAnchor constraintEqualToAnchor:header.leadingAnchor constant:16],
        [titleLabel.centerYAnchor constraintEqualToAnchor:header.centerYAnchor],
        [arrowView.trailingAnchor constraintEqualToAnchor:header.trailingAnchor constant:-16],
        [arrowView.centerYAnchor constraintEqualToAnchor:header.centerYAnchor],
        [titleLabel.trailingAnchor constraintLessThanOrEqualToAnchor:arrowView.leadingAnchor constant:-12],
    ]];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 52;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8;
}

- (void)groupHeaderClicked:(UIControl *)sender {
    NSInteger section = sender.tag;
    if (section < 0 || section >= self.groups.count) return;
    RCDemoIMLibCoreFeatureGroup *group = self.groups[section];
    group.expanded = !group.isExpanded;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"RCDemoIMLibCoreFeatureCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.textLabel.numberOfLines = 0;
        cell.detailTextLabel.numberOfLines = 2;
        cell.detailTextLabel.font = [UIFont monospacedSystemFontOfSize:11 weight:UIFontWeightRegular];
    }
    RCDemoIMLibCoreFeature *feature = self.groups[indexPath.section].features[indexPath.row];
    cell.textLabel.text = feature.title;
    cell.detailTextLabel.text = feature.api;
    cell.textLabel.textColor = UIColor.labelColor;
    cell.detailTextLabel.textColor = UIColor.secondaryLabelColor;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RCDemoIMLibCoreFeature *feature = self.groups[indexPath.section].features[indexPath.row];
    RCDemoIMLibCoreParameterViewController *controller = [[RCDemoIMLibCoreParameterViewController alloc] initWithFeature:feature];
    [self.navigationController pushViewController:controller animated:YES];
}

@end

