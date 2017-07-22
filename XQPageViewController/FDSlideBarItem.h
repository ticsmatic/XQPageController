//
//  FDSlideBarItem.h
//  FDSlideBarDemo
//
//  Created by Ticsmatic on 2017/7/20.
//  Copyright © 2017年 Ticsmatic. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FDSlideBarItemDelegate;

@interface FDSlideBarItem : UIView

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, weak) id<FDSlideBarItemDelegate> delegate;

- (void)setItemTitle:(NSString *)title;
- (void)setItemTitleFont:(CGFloat)fontSize;
- (void)setItemTitleColor:(UIColor *)color;
- (void)setItemSelectedTileFont:(CGFloat)fontSize;
- (void)setItemSelectedTitleColor:(UIColor *)color;

+ (CGFloat)widthForTitle:(NSString *)title;

@end

@protocol FDSlideBarItemDelegate <NSObject>

- (void)slideBarItemSelected:(FDSlideBarItem *)item;

@end
