//
//  TableCellFooterMoreController.m
//  XQPageControllerDemo
//
//  Created by Ticsmatic on 2017/7/21.
//  Copyright © 2017年 Ticsmatic. All rights reserved.
//

#import "TableCellFooterMoreController.h"
#import "GestureTableView.h"
#import "PageControllerFooterMore.h"
#import <Masonry.h>
#import "Header.h"

#define kPageTabHeight  40

@interface TableCellFooterMoreController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) PageControllerFooterMore *pageVC;
@property (nonatomic, strong) GestureTableView *tableView;

@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabView;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabViewPre;
@property (nonatomic, assign) BOOL canScroll;

@property (nonatomic, strong) UIGestureRecognizer *pan;
@end

@implementation TableCellFooterMoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    _canScroll = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kLeaveTopNotificationName object:nil];
}

- (void)acceptMsg:(NSNotification *)notification {
    NSLog(@"%@",notification);
    if ([notification.name isEqualToString:kLeaveTopNotificationName]) {
        _canScroll = YES;
    }
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 获取pageTab的偏移量
    CGFloat pageTabOffsetY = [_tableView rectForSection:2].origin.y - 64;
    CGFloat offsetY = scrollView.contentOffset.y;
    // NSLog(@"%f---%f", offsetY, pageTabOffsetY);
    // 先保留状态
    _isTopIsCanNotMoveTabViewPre = _isTopIsCanNotMoveTabView;
    if (offsetY >= pageTabOffsetY) {
        // 置顶
        [scrollView setContentOffset:CGPointMake(0, pageTabOffsetY) animated:NO];
        // 不允许滚动 标记
        _isTopIsCanNotMoveTabView = YES;
    } else {
        // 允许滚动
        _isTopIsCanNotMoveTabView = NO;
    }
    // 状态有改变
    if (_isTopIsCanNotMoveTabView != _isTopIsCanNotMoveTabViewPre) {
        // 之前能滚动，现在不能滚动，表示进入置顶状态
        if (!_isTopIsCanNotMoveTabViewPre && _isTopIsCanNotMoveTabView) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kGoTopNotificationName object:nil userInfo:nil];
            _canScroll = NO;
        }
        // 之前不能滚动，现在能滚动，表示进入取消置顶
        if(_isTopIsCanNotMoveTabViewPre && !_isTopIsCanNotMoveTabView){
            if (_canScroll == NO) {
                scrollView.contentOffset = CGPointMake(0, pageTabOffsetY);
                _isTopIsCanNotMoveTabView = YES;
            } else {
                NSLog(@"%s", __func__);
            }
        }
    }
    if (_isTopIsCanNotMoveTabView && _isTopIsCanNotMoveTabViewPre) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGoTopNotificationName object:nil userInfo:nil];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return kPageTabHeight;
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
    if (section == 2) {
        return self.pageVC.slideBar;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        return (self.view.frame.size.height - kPageTabHeight - 64);
    }
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [[UITableViewCell alloc] init];
        cell.textLabel.text = @"cell 1 content，or tableHeader content";
        return cell;
    } else if (indexPath.section == 1){
        cell = [[UITableViewCell alloc] init];
        cell.textLabel.text = @"cell 2 content";
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"page"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"page"];
            cell.exclusiveTouch = YES;
            PageControllerFooterMore *vc = self.pageVC;
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

- (PageControllerFooterMore *)pageVC {
    if (_pageVC == nil) {
        _pageVC = [PageControllerFooterMore new];
    }
    return _pageVC;
}

- (GestureTableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[GestureTableView alloc] initWithFrame:self.view.bounds];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 44;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

@end
