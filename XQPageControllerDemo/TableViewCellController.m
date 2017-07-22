//
//  TableViewCellController.m
//  XQPageControllerDemo
//
//  Created by Ticsmatic on 2017/7/21.
//  Copyright © 2017年 Ticsmatic. All rights reserved.
//

#import "TableViewCellController.h"
#import "PageControllerCell.h"
#import <Masonry.h>
#import "GestureTableView.h"

@interface TableViewCellController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) GestureTableView *tableView;
@property (nonatomic, strong) PageControllerCell *pageVC;
@end

@implementation TableViewCellController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return 20;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 0.01f;
    }
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 200;
    } else if (indexPath.section == 1) {
        return 300;
    }
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [[UITableViewCell alloc] init];
        cell.textLabel.text = @"Cell 1 的 内容";
        return cell;
    }
    else if (indexPath.section == 2) {
        cell = [[UITableViewCell alloc] init];
        cell.textLabel.text = @"Cell 3 的内容";
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"page"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"page"];
            cell.exclusiveTouch = YES;
            PageControllerCell *vc = self.pageVC;
            [cell.contentView addSubview:vc.view];
            
            [self addChildViewController:vc];
            [vc didMoveToParentViewController:self];
            [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(cell.contentView);
            }];
        }
        return cell;
    }
    return cell;
}

#pragma mark - Getter

- (PageControllerCell *)pageVC {
    if (_pageVC == nil) {
        _pageVC = [PageControllerCell new];
    }
    return _pageVC;
}

/// 使用GestureTableView，取消互斥手势，在当前页面移动k线图和pageViewController不互斥
- (GestureTableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[GestureTableView alloc] initWithFrame:self.view.bounds];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 55;
    }
    return _tableView;
}

@end
