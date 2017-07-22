//
//  ColumnEditViewController.h
//  XQPageControllerDemo
//
//  Created by Ticsmatic on 2017/7/20.
//  Copyright © 2017年 Ticsmatic. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const EditTitleKey;
extern NSString *const EditIDKey;

@protocol ColumnEditViewControllerDelegate <NSObject>
@optional

- (void)columnDidEdit:(NSArray *)array;
@end

@interface ColumnEditViewController : UIViewController

@property (nonatomic ,strong) NSMutableArray *usingArray;
@property (nonatomic ,strong) NSArray *allArray;

@property (nonatomic ,weak) id <ColumnEditViewControllerDelegate> delegate;
- (instancetype)initWithColumnArray:(NSMutableArray *)array allCloumn:(NSArray *)allArray;


@end
