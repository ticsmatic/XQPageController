//
//  PageOnNavBarWithMoreController.m
//  XQPageControllerDemo
//
//  Created by Ticsmatic on 2017/7/22.
//  Copyright © 2017年 Ticsmatic. All rights reserved.
//

#import "PageOnNavBarWithMoreController.h"
#import "ColumnEditViewController.h"
#import "ChildController1.h"

@interface PageOnNavBarWithMoreController ()<ColumnEditViewControllerDelegate>
@property (nonatomic, strong) NSMutableDictionary *modelDictionary;
@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, strong) NSMutableArray *arrayForShow;
@end

@implementation PageOnNavBarWithMoreController
- (void)viewDidLoad {
    self.showOnNavigationBar = YES;
    self.showMore = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    // slideBar bgcolor
    self.slideBar.backgroundColor = [UIColor clearColor];
    self.modelDictionary = [NSMutableDictionary dictionary];
    // loadData
    [self loadData];
}

/// network request, get cat list
- (void)loadData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // network request data ....
        // get local cache
        id array = [[NSUserDefaults standardUserDefaults] objectForKey:@"catlist"];
        _arrayForShow = [NSMutableArray arrayWithArray:array];
        // normally, error value is from request
        NSError *error = nil;
        if (!error) {
            NSData *jsonData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Untitled1" ofType:@"json"]];
            _dataArray = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
            if (_arrayForShow.count == 0) {
                // you can add a custom item, here is all
                _arrayForShow = [NSMutableArray arrayWithArray:_dataArray];
                [_arrayForShow insertObject:@{@"name" : @"全部", @"code" : @""} atIndex:0];
                // save to local
                [[NSUserDefaults standardUserDefaults] setObject:_arrayForShow forKey:@"catlist"];
            }
        }
        // reload
        [self reloadData];
    });
}

#pragma mark - ScrollPageViewControllerProtocol

- (NSArray *)arrayForControllerTitles {
    return [_arrayForShow valueForKeyPath:@"name"];
}

- (NSArray *)arrayForEditAllTitles {
    NSMutableArray *array = [NSMutableArray array];
    [self.dataArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:@{EditTitleKey:obj[@"name"], EditIDKey:obj[@"code"]}];
    }];
    return array;
}

- (NSArray *)arrayForEditTitles {
    NSMutableArray *array = [NSMutableArray array];
    [self.arrayForShow enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:@{EditTitleKey:obj[@"name"], EditIDKey:obj[@"code"]}];
    }];
    return array;
}


- (UIViewController *)viewcontrollerWithIndex:(NSInteger)index {
    if (index <0 || index > self.arrayForControllerTitles.count) return nil;
    id model = _arrayForShow[index];
    NSString *key = [NSString stringWithFormat:@"%@%@",NSStringFromClass([model class]), model[@"code"]];
    ChildController1 *vc = self.modelDictionary[key];
    if (!vc) {
        vc = [ChildController1 new];
        // pass parameter to controller
        vc.model = model;
        // recorde controller
        self.modelDictionary[key] = vc;
    }
    return vc;
}

#pragma mark - ColumnEditViewControllerDelegate

- (void)columnDidEdit:(NSArray *)array {
    if (!array.count) return;
    // this item is "all", sepcial one, we know
    NSDictionary *firstDict = array[0];
    if ([firstDict[EditIDKey] isEqualToString:@""]) {
        [self.arrayForShow removeAllObjects];
        [array enumerateObjectsUsingBlock:^(NSDictionary *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            NSLog(@"%@", obj);
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"name"] = obj[EditTitleKey];
            dict[@"code"] = obj[EditIDKey];
            [self.arrayForShow addObject:dict];
        }];
        // save to local
        [[NSUserDefaults standardUserDefaults] setObject:_arrayForShow forKey:@"catlist"];
    }
    // remove controler recorder, reload UI
    [self.modelDictionary removeAllObjects];
    [self reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 200, 50)];
    [btn setTitle:@"tap to close this page" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnTouch) forControlEvents:UIControlEventTouchUpInside];
    btn.center = self.view.center;
    [self.view addSubview:btn];
}

- (void)btnTouch {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
