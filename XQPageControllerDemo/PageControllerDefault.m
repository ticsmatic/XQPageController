//
//  PageControllerDefault.m
//  XQPageControllerDemo
//
//  Created by Ticsmatic on 2017/7/20.
//  Copyright © 2017年 Ticsmatic. All rights reserved.
//

#import "PageControllerDefault.h"
#import "ChildController1.h"

@interface PageControllerDefault ()
/// 当有多个子控制器时，或者子控制器的个数不能由接口驱动时，此属性用来存储记录控制器
@property (nonatomic, strong) NSMutableDictionary *modelDictionary;
@property (nonatomic, copy) NSArray *dataArray;
@end

@implementation PageControllerDefault

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.modelDictionary = [NSMutableDictionary dictionary];
    // loadData
    [self loadData];
}

/// 服务器接口返回有哪些标题，以及标题对应的模型
- (void)loadData {
    // 进行网络请求，获取模型（模型里一般包括的是标题和Id值）
    // 为dataArray赋值 _dataArray = jsonDataArray;
    NSData *jsonData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Untitled1" ofType:@"json"]];
    _dataArray = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    // 如果指定直接跳转到某个控制器，那么指定currentIndex
    self.currentIndex = 1;
    // 刷新PageController
    [self reloadData];

}

#pragma mark - ScrollPageViewControllerProtocol

- (NSArray *)arrayForControllerTitles {
    return [_dataArray valueForKeyPath:@"name"];
}

- (UIViewController *)viewcontrollerWithIndex:(NSInteger)index {
    if (index <0 || index > self.arrayForControllerTitles.count) return nil;
    id model = _dataArray[index];
    NSString *key = [NSString stringWithFormat:@"%@%@",NSStringFromClass([model class]), model[@"code"]];
    ChildController1 *vc = self.modelDictionary[key];
    if (!vc) {
        vc = [ChildController1 new];
        // 给控制器传递参数
        vc.model = model;
        self.modelDictionary[key] = vc;
    }
    return vc;
}
@end
