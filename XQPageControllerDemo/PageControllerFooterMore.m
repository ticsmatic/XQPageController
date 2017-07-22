//
//  PageControllerFooterMore.m
//  XQPageControllerDemo
//
//  Created by Ticsmatic on 2017/7/21.
//  Copyright © 2017年 Ticsmatic. All rights reserved.
//

#import "PageControllerFooterMore.h"
#import "CellFooterMoreChildController.h"

@interface PageControllerFooterMore ()
@property (nonatomic, strong) CellFooterMoreChildController *vc1;
@property (nonatomic, strong) CellFooterMoreChildController *vc2;
@property (nonatomic, strong) CellFooterMoreChildController *vc3;
@end

@implementation PageControllerFooterMore

- (void)viewDidLoad {
    self.slideBarCustom = YES;
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

- (CellFooterMoreChildController *)vc1 {
    if (_vc1 == nil) {
        _vc1 = [CellFooterMoreChildController new];
        _vc1.testContent = @"分时页面";
    }
    return _vc1;
}

- (CellFooterMoreChildController *)vc2 {
    if (_vc2 == nil) {
        _vc2 = [CellFooterMoreChildController new];
        _vc2.testContent = @"日K页面";
    }
    return _vc2;
}

- (CellFooterMoreChildController *)vc3 {
    if (_vc3 == nil) {
        _vc3 = [CellFooterMoreChildController new];
        _vc3.testContent = @"周K页面";
    }
    return _vc3;
}
@end
