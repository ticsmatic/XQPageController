//
//  PageControllerOnBottom.m
//  XQPageControllerDemo
//
//  Created by Ticsmatic on 2017/7/21.
//  Copyright © 2017年 Ticsmatic. All rights reserved.
//

#import "PageControllerOnBottom.h"
#import "ChildController1.h"

@interface PageControllerOnBottom ()
@property (nonatomic, strong) ChildController1 *vc1;
@property (nonatomic, strong) ChildController1 *vc2;
@end

@implementation PageControllerOnBottom
@synthesize slideBar = _slideBar;

- (void)viewDidLoad {
     self.slideBarCustom = YES;
    self.slideBar.isUnifyWidth = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.slideBar];
    self.slideBar.backgroundColor = [UIColor grayColor];
}

- (NSArray *)arrayForControllerTitles {
    return @[@"Bottom One Tab", @"Bottom Two Tab"];
}

- (UIViewController *)viewcontrollerWithIndex:(NSInteger)index {
    if (index <0 || index > self.arrayForControllerTitles.count) return nil;
    if (index == 0) {
        return self.vc1;
    } else if (index == 1) {
        return self.vc2;
    }
    return nil;
}

/// 重写次方法，布局pageViewController
- (void)layoutPageViewController {
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kDefaultHeightOFSlideBar);
}
#pragma mark - Getter
/// 重新合成次属性，改变位置
- (FDSlideBar *)slideBar {
    if (_slideBar == nil) {
        _slideBar = [[FDSlideBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 64 - kDefaultHeightOFSlideBar, self.view.frame.size.width, kDefaultHeightOFSlideBar)];
    }
    return _slideBar;
}

- (ChildController1 *)vc1 {
    if (_vc1 == nil) {
        _vc1 = [ChildController1 new];
        _vc1.testContent = @"界面一";
    }
    return _vc1;
}

- (ChildController1 *)vc2 {
    if (_vc2 == nil) {
        _vc2 = [ChildController1 new];
        _vc2.testContent = @"界面二";
    }
    return _vc2;
}
@end
