//
//  PageControllerCellSticky.m
//  XQPageControllerDemo
///Users/Ticsmatic/Desktop/XQPageControllerDemo/XQPageControllerDemo
//  Created by Ticsmatic on 2017/7/20.
//  Copyright © 2017年 Ticsmatic. All rights reserved.
//

#import "PageControllerCellSticky.h"

@interface PageControllerCellSticky ()

@end

@implementation PageControllerCellSticky

- (void)viewDidLoad {
    // 等宽
    self.slideBarCustom = YES;
    self.slideBar.isUnifyWidth = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - ScrollPageViewControllerProtocol

- (NSArray *)arrayForControllerTitles {
    return @[@"分时", @"日K", @"周K"];
}

- (UIViewController *)viewcontrollerWithIndex:(NSInteger)index {
    if (index <0 || index > self.arrayForControllerTitles.count) return nil;
    if (index == 0) {
        KlineController *vc = [KlineController new];
        vc.model = @"分时页面";
        return vc;
    } else if (index == 1) {
        KlineController *vc = [KlineController new];
        vc.model = @"日K页面";
        return vc;
    } else if (index == 2) {
        KlineController *vc = [KlineController new];
        vc.model = @"周K页面";
        return vc;
    }
    return nil;
}
@end


@implementation KlineController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, self.view.frame.size.width - 100 * 2, 50)];
    [self.view addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blueColor];
    label.text = _model;
}

@end
