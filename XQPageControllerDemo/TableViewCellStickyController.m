//
//  ChiledController6.m
//  XQPageControllerDemo
//
//  Created by Ticsmatic on 2017/7/20.
//  Copyright © 2017年 Ticsmatic. All rights reserved.
//

#import "TableViewCellStickyController.h"
#import "PageControllerCellSticky.h"
#import <Masonry.h>
#import "GestureTableView.h"

@interface TableViewCellStickyController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) GestureTableView *tableView;
@property (nonatomic, strong) PageControllerCellSticky *pageVC;
@end

@implementation TableViewCellStickyController

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
    if (section == 1) {
        return 40;
    }
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 0.01f;
    }
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        self.pageVC.slideBar.frame = CGRectMake(0, 0, self.tableView.frame.size.width, tableView.sectionHeaderHeight);
        return self.pageVC.slideBar;
    }
    return nil;
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
        cell.textLabel.text = @"Cell 1 的 内容，或者是tableHeader也可以";
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
            PageControllerCellSticky *vc = self.pageVC;
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

- (PageControllerCellSticky *)pageVC {
    if (_pageVC == nil) {
        _pageVC = [PageControllerCellSticky new];
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
