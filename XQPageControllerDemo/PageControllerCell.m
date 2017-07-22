//
//  PageControllerCell.m
//  XQPageControllerDemo
//
//  Created by Ticsmatic on 2017/7/21.
//  Copyright © 2017年 Ticsmatic. All rights reserved.
//

#import "PageControllerCell.h"
#import "PageControllerCellSticky.h"

@interface PageControllerCell ()
@property (nonatomic, strong) KlineController *vc1;
@property (nonatomic, strong) KlineController *vc2;
@property (nonatomic, strong) KlineController *vc3;
@end

@implementation PageControllerCell

- (void)viewDidLoad {
    // 等宽
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
        return self.vc1;
    } else if (index == 1) {
        return self.vc2;
    } else if (index == 2) {
        return self.vc3;
    }
    return nil;
}

#pragma mark - Getter 

- (KlineController *)vc1 {
    if (_vc1 == nil) {
        _vc1 = [KlineController new];
        _vc1.model = @"分时页面";
    }
    return _vc1;
}
- (KlineController *)vc2 {
    if (_vc2 == nil) {
        _vc2 = [KlineController new];
        _vc2.model = @"日K页面";
    }
    return _vc2;
}
- (KlineController *)vc3 {
    if (_vc3 == nil) {
        _vc3 = [KlineController new];
        _vc3.model = @"周K页面";
    }
    return _vc3;
}
@end

