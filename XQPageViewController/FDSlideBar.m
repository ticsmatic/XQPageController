//
//  FDSlideBar.m
//  FDSlideBarDemo
//
//  Created by fergusding on 15/6/4.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import "FDSlideBar.h"

#define DEVICE_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define DEFAULT_SLIDER_COLOR [UIColor orangeColor]
#define SLIDER_VIEW_HEIGHT 1.5
#define LAYOUTINSET 10
#define slidebarMenuButtonImage @"gonggao_customized.png"

NSInteger const kDefaultHeightOFSlideBar = 40;
NSInteger const kDefaultUnifyWidth = 50;
NSInteger const MenuButtonWidth = 50;

@interface FDSlideBar () <FDSlideBarItemDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIButton *menuButton;

@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) UIView *sliderView;

@property (strong, nonatomic) FDSlideBarItem *selectedItem;
@property (copy, nonatomic) FDSlideBarItemSelectedCallback callback;

@property (copy, nonatomic) void(^menuCallBack)(BOOL show);
@property (copy, nonatomic) void(^resetCallBack)(void);

@end

@interface UIScrollView (VisibleCenterScroll)

@end
@implementation UIScrollView (VisibleCenterScroll)

- (void)scrollRectToVisibleCenteredOn:(CGRect)visibleRect
                             animated:(BOOL)animated {
    UIEdgeInsets inset = self.contentInset;
    CGRect frameForLayout = self.frame;
    CGPoint centerPoint = CGPointMake(visibleRect.origin.x + visibleRect.size.width / 2 , visibleRect.origin.y + visibleRect.size.height / 2);
    CGPoint offset = CGPointMake(centerPoint.x - frameForLayout.size.width / 2 , centerPoint.y - frameForLayout.size.height / 2);
    offset.x = MAX(offset.x, -inset.left);
    offset.x = MIN(offset.x, self.contentSize.width - frameForLayout.size.width + inset.right);
    offset.y = MAX(offset.y, -inset.top);
    offset.y = MIN(offset.y, self.contentSize.height - frameForLayout.size.height + inset.bottom);
    [self setContentOffset:offset];
}

@end

@implementation FDSlideBar
@synthesize menuButtonWidth = _menuButtonWidth;

#pragma mark - Lifecircle

- (instancetype)init {
    CGRect frame = CGRectMake(0, 0, DEVICE_WIDTH, kDefaultHeightOFSlideBar);
    return [self initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        _items = [NSMutableArray array];
        _showSelectSlide = YES;
        [self setup];
    }
    return self;
}

- (void)setup {
    [self addSubview:self.scrollView];
    self.scrollView.frame = self.bounds;
    [self addSubview:self.menuButton];
}

- (void)setShowSelectSlide:(BOOL)showSelectSlide {
    _showSelectSlide = showSelectSlide;
    self.sliderView.alpha = showSelectSlide ? 1:0;
}

- (UIButton *)menuButton {
    if (_menuButton == nil) {
        _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _menuButton.backgroundColor = [UIColor whiteColor];
        _menuButton.frame = CGRectMake(self.bounds.size.width - self.menuButtonWidth, 0, self.menuButtonWidth, self.bounds.size.height);
        _menuButton.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
        [_menuButton addTarget:self action:@selector(menuButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        _menuButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_menuButton setImage:[UIImage imageNamed:slidebarMenuButtonImage] forState:(UIControlStateNormal)];
    }
    
    return _menuButton;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
}

#pragma - mark Action
- (void)menuButtonClick:(UIButton *)sender {
    if (_menuCallBack) {
        sender.enabled = NO;
        _menuCallBack(sender.selected);
        sender.enabled = YES;
    }
}

#pragma - mark Custom Accessors
- (void)setShowMenuButton:(BOOL)showMenuButton {
    _showMenuButton = showMenuButton;
    if (showMenuButton == YES) {
        UIEdgeInsets inset = UIEdgeInsetsMake(0, LAYOUTINSET, 0, LAYOUTINSET);
        inset.right += MenuButtonWidth;
        self.scrollView.contentInset = inset;
        self.menuButton.alpha = 1;
    } else {
        self.menuButton.alpha = 0;
        UIEdgeInsets inset = UIEdgeInsetsMake(0, LAYOUTINSET, 0, LAYOUTINSET);
        self.scrollView.contentInset = inset;
    }
}

- (void)setMenuButtonSelectedTitleColor:(UIColor *)menuButtonSelectedTitleColor {
    _menuButtonSelectedTitleColor = menuButtonSelectedTitleColor;
    [_menuButton setTitleColor:menuButtonSelectedTitleColor forState:(UIControlStateSelected)];
}

- (void)setMenuButtonTitleColor:(UIColor *)menuButtonTitleColor {
    _menuButtonTitleColor = menuButtonTitleColor;
        [_menuButton setTitleColor:menuButtonTitleColor forState:(UIControlStateNormal)];
}

- (void)setMenuButtonTitle:(NSString *)menuButtonTitle {
    _menuButtonTitle = menuButtonTitle;
    [_menuButton setTitle:menuButtonTitle forState:(UIControlStateNormal)];
}
- (void)setMenuButtonSelectedTitle:(NSString *)menuButtonSelectedTitle {
    _menuButtonSelectedTitle = menuButtonSelectedTitle;
     [_menuButton setTitle:_menuButtonSelectedTitle forState:(UIControlStateSelected)];
}
- (void)setMenuButtonImage:(UIImage *)menuButtonImage {
    _menuButtonImage = menuButtonImage;
    [self.menuButton setImage:_menuButtonImage forState:(UIControlStateNormal)];
}

- (void)setMenuButtonSelectedImage:(UIImage *)menuButtonSelectedImage {
    _menuButtonSelectedImage = menuButtonSelectedImage;
    [self.menuButton setImage:_menuButtonImage forState:(UIControlStateHighlighted)];
}

- (void)setItemsTitle:(NSArray *)itemsTitle {
    _itemsTitle = [itemsTitle copy];
    [self setupItems];
}

- (void)setItemColor:(UIColor *)itemColor {
    _itemColor = itemColor;
    for (FDSlideBarItem *item in _items) {
        [item setItemTitleColor:itemColor];
    }
}

- (void)setItemSelectedColor:(UIColor *)itemSelectedColor {
    _itemSelectedColor = itemSelectedColor;
    for (FDSlideBarItem *item in _items) {
        [item setItemSelectedTitleColor:itemSelectedColor];
    }
}

- (void)setSliderColor:(UIColor *)sliderColor {
    _sliderColor = sliderColor;
    self.sliderView.backgroundColor = _sliderColor;
}

- (void)setSelectedItem:(FDSlideBarItem *)selectedItem {
    _selectedItem.selected = NO;
    _selectedItem = selectedItem;
    _selectedItem.selected = YES;
    
    if (_callback) _callback([self.items indexOfObject:_selectedItem]);
}

- (NSInteger)menuButtonWidth {
    if (_menuButtonWidth == 0 || _menuButtonWidth == NSNotFound) {
        return MenuButtonWidth;
    }
    return _menuButtonWidth;
}

- (void)setMenuButtonWidth:(NSInteger)menuButtonWidth {
    _menuButtonWidth = menuButtonWidth;
    if (self.showMenuButton) {
        _menuButton.frame = CGRectMake(self.bounds.size.width - self.menuButtonWidth, 0, self.menuButtonWidth, self.bounds.size.height);
    }
    [self setShowMenuButton:_showMenuButton];
}

- (NSInteger)unifyWidth {
    if (_unifyWidth == 0 || _unifyWidth == NSNotFound) {
        return 0;
    }
    return _unifyWidth;
}

#pragma - mark Private

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (UIView *)sliderView {
    if (_sliderView == nil) {
        _sliderView = [[UIView alloc] init];
        if (_sliderColor == nil) {
            _sliderColor = DEFAULT_SLIDER_COLOR;
        }
        _sliderView.backgroundColor = self.sliderColor;
    }
    return _sliderView;
}

- (void)setupItems {
    CGFloat itemX = 0;
    for (UIView *sub in _scrollView.subviews) {
        [sub removeFromSuperview];
    }
    [_items removeAllObjects];
    
    if (!_menuButton.selected) {
        if (_resetCallBack) {
            _resetCallBack();
        }
    }
    
    if (_itemsTitle.count == 0) {
        return;
    }
    [_scrollView addSubview:self.sliderView];
    for (NSString *title in _itemsTitle) {
        FDSlideBarItem *item = [[FDSlideBarItem alloc] init];
        item.delegate = self;
        
        // Init the current item's frame
        CGFloat itemW =  self.isUnifyWidth ? self.unifyWidth? : DEVICE_WIDTH / _itemsTitle.count :[FDSlideBarItem widthForTitle:title];
        item.frame = CGRectMake(itemX, 0, itemW, CGRectGetHeight(_scrollView.frame));
        [_scrollView addSubview:item];
        if (_itemSelectedColor) {
            [item setItemSelectedTitleColor:_itemSelectedColor];
        }
        if (_itemColor) {
            [item setItemTitleColor:_itemColor];
        }
        
        [item setItemTitle:title];
        [_items addObject:item];
        
        // Caculate the origin.x of the next item
        itemX = CGRectGetMaxX(item.frame);
    }
    
    // Cculate the scrollView 's contentSize by all the items
    _scrollView.contentSize = CGSizeMake(MAX(itemX, CGRectGetWidth(_scrollView.frame)), CGRectGetHeight(_scrollView.frame));
    
    UIEdgeInsets inset = UIEdgeInsetsZero;

    if (self.isUnifyWidth) {

    } else {
        if (_showMenuButton) {
                inset.left += LAYOUTINSET;
                inset.right += LAYOUTINSET + MenuButtonWidth;
        } else {
            inset.left += LAYOUTINSET;
            inset.right += LAYOUTINSET;
        }
    }
    _scrollView.contentInset = inset;
    
    if (!(self.currentSelected < self.items.count)) {
        self.currentSelected = 0;
    }
    
    FDSlideBarItem *firstItem = [self.items objectAtIndex:self.currentSelected];
    firstItem.selected = YES;
    _selectedItem = firstItem;
    
    _sliderView.frame = CGRectMake(0, self.frame.size.height - SLIDER_VIEW_HEIGHT, firstItem.frame.size.width, SLIDER_VIEW_HEIGHT);
    
    [self scrollToVisibleItem:firstItem];
    
    if(_callback) _callback(self.currentSelected);
}

- (void)scrollToVisibleItem:(FDSlideBarItem *)item {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState animations:^{
                        [self.scrollView scrollRectToVisibleCenteredOn:item.frame animated:NO];
            _sliderView.frame = CGRectMake(CGRectGetMinX(item.frame), _sliderView.frame.origin.y, CGRectGetWidth(item.frame), SLIDER_VIEW_HEIGHT);
        } completion:^(BOOL finished) {
            
        }];
    });
}

- (void)scrollToNextIndex:(NSInteger)nextIndex progress:(CGFloat)progress {
    if (nextIndex < self.items.count && nextIndex >=0  && nextIndex != self.currentSelected) {
        FDSlideBarItem *item = [self.items objectAtIndex:nextIndex];
        FDSlideBarItem *originItem = [self.items objectAtIndex:self.currentSelected];
        
        CGFloat origin = CGRectGetMinX(originItem.frame);
        CGFloat next = CGRectGetMinX(item.frame);
        CGFloat offset = next - origin;
        
        CGFloat originWidth = CGRectGetWidth(originItem.frame);
        CGFloat nextWidth = CGRectGetWidth(item.frame);
        CGFloat offsetWidth = nextWidth - originWidth;
        
        _sliderView.frame = CGRectMake(origin + progress * offset, _sliderView.frame.origin.y, originWidth + progress * offsetWidth, SLIDER_VIEW_HEIGHT);
    }
}

#pragma mark - Public
- (void)slideBarItemResetCallBack:(void (^)(void))resetCallBack {
    _resetCallBack = resetCallBack;
}
- (void)slideShowMenuCallBack:(void (^)(BOOL ))menuCallBack {
    _menuCallBack = menuCallBack;
}
- (void)slideBarItemSelectedCallback:(FDSlideBarItemSelectedCallback)callback {
    _callback = callback;
}

- (void)selectSlideBarItemAtIndex:(NSUInteger)index {
    if (index < self.items.count) {
        FDSlideBarItem *item = [self.items objectAtIndex:index];
        [self scrollToVisibleItem:item];
        if ([item isEqual:_selectedItem]) {
            return;
        }
        self.currentSelected = index;
        self.selectedItem = item;
    }
}

#pragma mark - FDSlideBarItemDelegate

- (void)slideBarItemSelected:(FDSlideBarItem *)item {
    if ([item isEqual:_selectedItem]) {
        return;
    }
    [self selectSlideBarItemAtIndex:[self.items indexOfObject:item]];
}

@end
