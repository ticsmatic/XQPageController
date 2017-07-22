//
//  FDSlideBar.h
//  FDSlideBarDemo
//
//  Created by fergusding on 15/6/4.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDSlideBarItem.h"

#define ScreenHeight    [UIScreen mainScreen].bounds.size.height
#define ScreenWidth    [UIScreen mainScreen].bounds.size.width

extern NSInteger const kDefaultHeightOFSlideBar;
extern NSInteger const kDefaultUnifyWidth;
typedef void(^FDSlideBarItemSelectedCallback)(NSUInteger idx);

@interface FDSlideBar : UIView

// All the titles of FDSilderBar
@property (copy, nonatomic) NSArray *itemsTitle;

// All the item's text color of the normal state
@property (strong, nonatomic) UIColor *itemColor;

@property (nonatomic, copy) NSString *menuButtonTitle;
@property (nonatomic, copy) NSString *menuButtonSelectedTitle;
@property (nonatomic, strong) UIColor *menuButtonTitleColor;
@property (nonatomic, strong) UIColor *menuButtonSelectedTitleColor;
@property (nonatomic, strong) UIImage *menuButtonImage;
@property (nonatomic, strong) UIImage *menuButtonSelectedImage;

@property (assign, nonatomic) BOOL showMenuButton;

@property (assign, nonatomic) BOOL isUnifyWidth; //是否统一宽度

@property (assign, nonatomic) BOOL showSelectSlide;


@property (assign, nonatomic) NSInteger currentSelected;

@property (assign, nonatomic) NSInteger unifyWidth; //统一宽度的值

@property(nonatomic, assign)  NSInteger menuButtonWidth;

// The selected item's text color
@property (strong, nonatomic) UIColor *itemSelectedColor;

// The slider color
@property (strong, nonatomic) UIColor *sliderColor;

// Add the callback deal when a slide bar item be selected
- (void)slideBarItemSelectedCallback:(FDSlideBarItemSelectedCallback)callback;
- (void)slideBarItemResetCallBack:(void(^)(void))resetCallBack;

- (void)slideShowMenuCallBack:(void(^) (BOOL show))menuCallBack;

// Set the slide bar item at index to be selected
- (void)selectSlideBarItemAtIndex:(NSUInteger)index;

- (void)scrollToNextIndex:(NSInteger)nextIndex progress:(CGFloat)progress;

@end
