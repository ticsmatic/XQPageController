//
//  ChildController1.m
//  XQPageControllerDemo
//
//  Created by Ticsmatic on 2017/7/20.
//  Copyright © 2017年 Ticsmatic. All rights reserved.
//

#import "ChildController1.h"
#import <Masonry.h>

@interface ChildController1 () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ChildController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableView = [[UITableView alloc] init];
    [self.view addSubview:_tableView];
    // _tableView.frame = self.view.bounds;
    // 由于控制器创建的时候默认是屏幕尺寸，推荐使用约束布局子控件，这样就不用考虑计算高度了，或在viewDidLayoutSubviews更新手动布局也可以
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    // 如果是某个单独确定的控制器，那么直接请求数据即可，然后展示
    // 如果是多个控制器同一个样式，根据传递过来的id或者其他参数请求，然后展示
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    // Configure the cell...
    cell.textLabel.text = @"i am looking up";
    if (_model) {
        cell.textLabel.text = _model[@"name"];
    }
    if (_testContent) {
        cell.textLabel.text = _testContent;
    }
    return cell;
}

//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    _tableView.frame = self.view.bounds;
//}
@end
