//
//  GestureTableView.m
//  CollectionWorld
//
//  Created by Ticsmatic on 2017/2/23.
//  Copyright © 2017年 Ticsmatic. All rights reserved.
//

#import "GestureTableView.h"

@implementation GestureTableView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.tableHeaderView && CGRectContainsPoint(self.tableHeaderView.frame, point)) {
        return NO;   
    }
    return [super pointInside:point withEvent:event];
}

/// 是否支持多手势触发，返回YES，则可以多个手势一起触发方法，返回NO则为互斥
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


@end
