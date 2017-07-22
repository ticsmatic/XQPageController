//
//  ScrollPageViewController.m
//  XQPageControllerDemo
//
//  Created by Ticsmatic on 2017/7/20.
//  Copyright © 2017年 Ticsmatic. All rights reserved.
//

#import "ScrollPageViewController.h"
#import <objc/runtime.h>
#import <YYCategories.h>
#import "ColumnEditViewController.h"

@interface UIViewController (pageIndex)
@end

@implementation UIViewController (pageIndex)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethod:@selector(scrollpage_viewDidAppear:) with:@selector(viewDidAppear:)];
    });
}

- (NSInteger)index {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setIndex:(NSInteger)index {
    objc_setAssociatedObject(self, @selector(index), @(index), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)scrollpage_viewDidAppear:(BOOL)animated {
    [self scrollpage_viewDidAppear:animated];
    [self changePage];
}

- (id)pageDelegate {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setPageDelegate:(id)pageDelegate {
    objc_setAssociatedObject(self, @selector(pageDelegate), pageDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (void)changePage {
    if ([self.pageDelegate respondsToSelector:@selector(pageViewController:didShowViewController:atIndex:)]) {
        [self.pageDelegate pageViewController:self.pageDelegate didShowViewController:self atIndex:self.index];
    }
}

@end

#define titles [self.dataSource arrayForControllerTitles]

@interface ScrollPageViewController ()

@property (nonatomic, strong, readwrite) UIPageViewController *pageViewController;
@property (nonatomic, assign) BOOL inTransition;
@property (nonatomic, assign) BOOL inDragging;
@property (nonatomic, assign) NSInteger nextIndex;

@end

@implementation ScrollPageViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    if(kiOS7Later) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _showMore = NO;
    _showOnNavigationBar = NO;
    _slideBarCustom = NO;
    self.dataSource = self;
    [self addObserver:self forKeyPath:@"currentIndex" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
}

#pragma mark - Public

- (void)reloadData {
    self.slideBar.currentSelected = self.currentIndex;
    self.slideBar.itemsTitle = titles;

    if ([titles count]) [self setToIndex:self.currentIndex];
}

/// 切换到某个index
- (void)setToIndex:(NSInteger)index {
    self.nextIndex = NSNotFound;
    if ([titles count]) {
        // 判断index，防止传入异常数据导致角标越界
        if (index >= [titles count]) index = [titles count] - 1;
        if (index < 0) index = 0;
        
        __weak typeof(self) weakSelf = self;
        UIViewController *list = [self controllerWithIndex:index];
        [self.pageViewController setViewControllers:@[list] direction:(index > self.currentIndex ?UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse) animated:YES completion:^(BOOL finished){
            weakSelf.currentIndex = index;
        }];
    }
}

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self reloadData];
}

- (void)initUI {
    self.view.backgroundColor = [UIColor colorWithWhite:.95 alpha:1];
    // exclusiveTouch
    self.slideBar.exclusiveTouch = YES;
    self.pageViewController.view.exclusiveTouch = YES;
    // slideBar
    if (!_slideBarCustom) {
        if (self.showOnNavigationBar && self.navigationController.navigationBar) {
            self.navigationItem.titleView = self.slideBar;
        } else {
            [self.view addSubview:self.slideBar];
        }
    }
    [self setupSlideBar];
    // pageViewController
    [self addChildViewController:self.pageViewController];
    [self.pageViewController didMoveToParentViewController:self];
    [self.view addSubview:self.pageViewController.view];
    // layout Frame
    [self layoutViews];
}
- (void)setupSlideBar {
    FDSlideBar *slide = self.slideBar;
    slide.backgroundColor = [UIColor whiteColor];
    slide.itemColor = [UIColor blackColor];
    slide.itemSelectedColor = [UIColor redColor];
    slide.sliderColor = [UIColor redColor];
    slide.showMenuButton = _showMore;
    slide.menuButtonSelectedTitleColor = [UIColor colorWithWhite:.5 alpha:1];
    slide.menuButtonImage = [UIImage imageNamed:@"gonggao_customized.png"];
    slide.menuButtonSelectedImage = [UIImage imageNamed:@"gonggao_customized.png"];
    slide.menuButtonTitleColor = [UIColor colorWithWhite:0.5 alpha:1];
    // callBack
    __weak typeof(self) weakSel = self;
    [slide slideBarItemSelectedCallback:^(NSUInteger idx) {
        if (idx != weakSel.currentIndex) {
            [weakSel setToIndex:idx];
        }
    }];
    
    [slide slideShowMenuCallBack:^(BOOL show) {
        ColumnEditViewController *columnEdit = [[ColumnEditViewController alloc] initWithColumnArray:[[weakSel.dataSource arrayForEditTitles] mutableCopy] allCloumn:[weakSel.dataSource arrayForEditAllTitles]];
        columnEdit.hidesBottomBarWhenPushed = true;
        columnEdit.delegate = weakSel.dataSource;
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
        item.title = @"完成";
        weakSel.navigationController.navigationBar.topItem.backBarButtonItem = item;
        [weakSel.navigationController pushViewController:columnEdit animated:YES];
    }];
}

- (void)layoutViews {
    [self layoutSlideBar];
    [self layoutPageViewController];
}

- (void)layoutSlideBar {
    if (_slideBarCustom) return;
    // 手势滑动导航栏滚动的时候 self.navigationController.navigationBar 为 nil
    if (self.showOnNavigationBar && self.navigationController.navigationBar) {
        if (self.slideBar.origin.x != 0) {
            self.slideBar.width = self.view.frame.size.width - self.slideBar.origin.x;
        }
    }
}

- (void)layoutPageViewController {
    CGFloat originY = (self.showOnNavigationBar) ? 0 : CGRectGetMaxY(_slideBar.frame);
    if (_slideBarCustom) originY = 0;
    self.pageViewController.view.frame = CGRectMake(0, originY, self.view.frame.size.width, self.view.frame.size.height - originY);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.pageViewController viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.pageViewController viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.pageViewController viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.pageViewController viewDidDisappear:animated];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"currentIndex"];
}

#pragma mark - Setter
- (void)setShowOnNavigationBar:(BOOL)showOnNavigationBar {
    if (_showOnNavigationBar == showOnNavigationBar) return;
    _showOnNavigationBar = showOnNavigationBar;
    if (self.slideBar.superview) {
        [self.slideBar removeFromSuperview];
        [self layoutViews];
    }
}
- (void)setControllerGap:(NSInteger)controllerGap {
    _controllerGap = controllerGap;
    if (self.pageViewController.view.superview) {
        self.pageViewController.view.frame = CGRectMake(0, CGRectGetMaxY(self.slideBar.frame) + self.controllerGap, self.view.width, self.view.height - self.slideBar.frame.size.height - self.controllerGap);
    }
}

/// 在变化中不允许slidebar点击
- (void)setInTransition:(BOOL)inTransition {
    _inTransition = inTransition;
    self.slideBar.userInteractionEnabled = !inTransition;
}

- (NSInteger)nextIndex {
    if (_nextIndex == NSNotFound) {
        return self.currentIndex;
    }
    return _nextIndex;
}

#pragma mark - getter

- (FDSlideBar *)slideBar {
    if (_slideBar == nil) {
        _slideBar = [[FDSlideBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kDefaultHeightOFSlideBar)];
    }
    return _slideBar;
}

- (UIPageViewController *)pageViewController {
    if (_pageViewController == nil) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:(UIPageViewControllerTransitionStyleScroll) navigationOrientation:(UIPageViewControllerNavigationOrientationHorizontal) options:@{UIPageViewControllerOptionSpineLocationKey: @(0),UIPageViewControllerOptionInterPageSpacingKey: @(self.controllerPageGap)}];

        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;

        for (UIView *v in self.pageViewController.view.subviews) {
            if ([v isKindOfClass:[UIScrollView class]]) {
                ((UIScrollView *) v).delegate = (id)self;
            }
        }
    }
    return _pageViewController;
}

- (NSInteger)controllerPageGap {
    if (_controllerPageGap == NSNotFound) {
        return 2;
    }
    return _controllerPageGap;
}
#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    self.inTransition = YES;
    self.nextIndex = pendingViewControllers[0].index;
    if ([self.dataSource respondsToSelector:@selector(pageViewController:willTransitionToViewControllers:)] && ![self isEqual:self.dataSource]) {
        [self.dataSource pageViewController:pageViewController willTransitionToViewControllers:pendingViewControllers];
    }
}
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    self.inTransition = NO;
}

- (void)pageViewController:(id<ScrollPageViewControllerProtocol>)pageViewController didShowViewController:(UIViewController *)controller atIndex:(NSInteger)index {
    self.nextIndex = NSNotFound;
    self.currentIndex = index;
    if ([self.dataSource respondsToSelector:@selector(pageViewController:didShowViewController:atIndex:)] && ![self.dataSource isEqual:self]) {
        [self.dataSource pageViewController:pageViewController didShowViewController:controller atIndex:index];
    }
}
#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerBeforeViewController:(UIViewController *)vc {
    NSInteger index = self.nextIndex - 1;
    return [self controllerWithIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerAfterViewController:(UIViewController *)vc {
    NSInteger index = self.nextIndex + 1;
    return [self controllerWithIndex:index];
}

- (UIViewController *)controllerWithIndex:(NSInteger)index {
    if (index < [titles count] && index >= 0) {
        UIViewController *controller = [self.dataSource viewcontrollerWithIndex:index];
        controller.index = index;

        controller.pageDelegate = self;
        return controller;
    }
    return nil;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.inDragging = YES;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.inDragging = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.inDragging) {
        CGPoint offset = scrollView.contentOffset;
        CGFloat offsetX = ABS(offset.x - kScreenWidth);
        if (offsetX > kScreenWidth / 2) {
            self.currentIndex = self.nextIndex;
        }
        CGFloat progress = offsetX / kScreenWidth;
        if ([self.slideBar respondsToSelector:@selector(scrollToNextIndex:progress:)]) {
            [self.slideBar scrollToNextIndex:self.nextIndex progress:progress];
        }
    }
}

#pragma mark - Observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *, id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"currentIndex"]) {
        NSUInteger changenew = [change[@"new"] integerValue];
        NSUInteger changeold = [change[@"old"] integerValue];
        if (changeold != changenew) {
            [self.slideBar selectSlideBarItemAtIndex:changenew];
        }
    }
}

@end
