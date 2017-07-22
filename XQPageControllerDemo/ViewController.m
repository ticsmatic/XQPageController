//
//  ViewController.m
//  XQPageControllerDemo
//
//  Created by Ticsmatic on 2017/7/20.
//  Copyright © 2017年 Ticsmatic. All rights reserved.
//

#import "ViewController.h"
#import "PageControllerDefault.h"
#import "PageControllerOnNavBar.h"
#import "TableViewCellStickyController.h"
#import "TableViewCellController.h"
#import "TableCellFooterMoreController.h"
#import "PageControllerOnBottom.h"
#import "PageViewControllerMore.h"
#import "PageOnNavBarWithMoreController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _dataArray = @[@"PageController Style Default",
                   @"PageController Style On NavigationBar",
                   @"PageController Style On TableViewCell Sticky",
                   @"PageController Style On TableViewCell",
                   @"PageController Style On TableViewCell Sticky Footer More",
                   @"PageController Style on Bottom",
                   @"PageController Style Default With MoreBtn",
                   @"PageController Style On NavigationBar With MoreBtn"];
    self.title = @"XQPageControllerDemo";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    // Configure the cell...
    cell.textLabel.text = _dataArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0: {
            PageControllerDefault *vc = [PageControllerDefault new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:{
            PageControllerOnNavBar *vc = [PageControllerOnNavBar new];
            // 通常情况下，更改ScrollPageViewController的属性，需要继承ScrollPageViewController控制器，在子类里面修改属性值
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2: {
            TableViewCellStickyController *vc = [TableViewCellStickyController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3: {
            TableViewCellController *vc = [TableViewCellController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4: {
            TableCellFooterMoreController *vc = [TableCellFooterMoreController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5: {
            PageControllerOnBottom *vc = [PageControllerOnBottom new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6: {
            PageViewControllerMore *vc = [PageViewControllerMore new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 7: {
            PageOnNavBarWithMoreController *vc = [PageOnNavBarWithMoreController new];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }
        default:
            break;
    }
}

@end
