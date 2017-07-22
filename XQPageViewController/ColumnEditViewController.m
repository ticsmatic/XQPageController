//
//  ColumnEditViewController.m
//  XQPageControllerDemo
//
//  Created by Ticsmatic on 2017/7/20.
//  Copyright © 2017年 Ticsmatic. All rights reserved.
//

#import "ColumnEditViewController.h"
#import "LXReorderableCollectionViewFlowLayout.h"
#import "EditCollectionViewCell.h"
#import <YYCategories.h>

#define ScreenHeight    [UIScreen mainScreen].bounds.size.height
#define ScreenWidth    [UIScreen mainScreen].bounds.size.width

 NSString *const EditTitleKey = @"EditTitleKey";
 NSString *const EditIDKey = @"EditIDKey";

@interface ColumnEditViewController () <UICollectionViewDataSource,UICollectionViewDelegate, LXReorderableCollectionViewDelegateFlowLayout ,LXReorderableCollectionViewDataSource>

@property (weak, nonatomic) IBOutlet LXReorderableCollectionViewFlowLayout *layout;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong ,nonatomic) NSMutableArray *unUsingArray;
@property (assign , nonatomic) BOOL needUpdate;
@end

@implementation ColumnEditViewController

- (instancetype)initWithColumnArray:(NSMutableArray *)array allCloumn:(NSArray *)allArray {
    if (self = [self init]) {
        _usingArray = [NSMutableArray arrayWithArray:array];
        _allArray = [allArray copy];
        [self reloadData];
    }
    return self;
}
- (void)createUnUsing {
    self.unUsingArray = [NSMutableArray array];
    NSArray *usingKey = [self.usingArray valueForKey:EditIDKey];
    NSArray *allKey = [self.allArray valueForKey:EditIDKey];
    
    for (NSString *string in allKey) {
        if (![usingKey containsObject:string]) {
            NSUInteger index = [allKey indexOfObject:string];
            [self.unUsingArray addObject:[self.allArray objectAtIndex:index]];
        }
    }
}

- (void)reloadData {
    [self createUnUsing];
    [self.collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configViews];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self doneAction:self];
}

- (void)configViews {
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[EditCollectionViewCell class] forCellWithReuseIdentifier:editCollectionCellID];
    [self.collectionView registerClass:[EditSelectedCollectionViewCell class] forCellWithReuseIdentifier:editCollectionSelectCell];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
}


#pragma mark - Action
- (void)doneAction:(id)sender {
    if (_needUpdate) {
        if ([self.delegate respondsToSelector:@selector(columnDidEdit:)]) {
            [self.delegate columnDidEdit:self.usingArray];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - layout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count;
    if (section == 0) {
        count =  [self.usingArray count];
    } else {
        count = [self.unUsingArray count];
    }
    return count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.section == 0 && indexPath.item == 0) || indexPath.section == 1) {
        return NO;
    }
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath {
    if ((toIndexPath.section == 0 && toIndexPath.item == 0) || toIndexPath.section == 1) {
        return NO;
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath {
//    if (fromIndexPath.section == 0) {
//        
//        [self.usingArray exchangeObjectAtIndex:fromIndexPath.item withObjectAtIndex:toIndexPath.item];
//        _needUpdate = YES;
//    }
//    [collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath {
    if (fromIndexPath.section == 0) {
        id obj = self.usingArray[fromIndexPath.item];
        [self.usingArray removeObjectAtIndex:fromIndexPath.item];
        [self.usingArray insertObject:obj atIndex:toIndexPath.item];
        _needUpdate = YES;
    } else {
        id obj = self.unUsingArray[fromIndexPath.item];
        [self.unUsingArray removeObjectAtIndex:fromIndexPath.item];
        [self.unUsingArray insertObject:obj atIndex:toIndexPath.item];
        _needUpdate = YES;
    }
    //可以实现变化
}
#pragma mark - 
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.item == 0) {
        return;
    }
    
    if (indexPath.section == 0) {
        [collectionView performBatchUpdates:^{
            [self.unUsingArray addObject:[self.usingArray objectAtIndex:indexPath.item]];
            [collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:(self.unUsingArray.count -1) inSection:1]]];
            
            [self.usingArray removeObjectAtIndex:indexPath.item];
            [collectionView deleteItemsAtIndexPaths:@[indexPath]];
            
        } completion:^(BOOL finished) {
            _needUpdate = YES;
        }];

    } else {
        [collectionView performBatchUpdates:^{
            [self.usingArray addObject:[self.unUsingArray objectAtIndex:indexPath.item]];
            [collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:(self.usingArray.count - 1) inSection:0]]];
            
            [self.unUsingArray removeObjectAtIndex:indexPath.item];
            [collectionView deleteItemsAtIndexPaths:@[indexPath]];
        } completion:^(BOOL finished) {
            _needUpdate = YES;
        }];
    }
}

#pragma mark -
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    //开始拖动
}
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    //已经拖动
}
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    //将要停止
}
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    //已经停止
}

//- coll

#pragma mark -
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets inset;
    if (section == 0) {
        inset = UIEdgeInsetsMake(10, 10, 10, 10);
    } else {
        inset = UIEdgeInsetsMake(0, 0, 10, 0);
    }
    inset = UIEdgeInsetsMake(10, 10, 10, 10);
    return inset;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    CGFloat spacing;
    if (section == 0) {
        spacing = 10;
    } else {
        spacing = 0;
    }
    spacing = 10;
    return spacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    CGFloat spacing;
    if (section == 0) {
        spacing = 10;
    } else {
        spacing = 0;
    }
    spacing = 10;
    return spacing;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size;
    if (indexPath.section == 0) {
        size = CGSizeMake(70, 30);
    } else {
        size = CGSizeMake(ScreenWidth, 38);
    }
    size = CGSizeMake(70, 30);
    return size;
}
#pragma mmark -
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EditCollectionViewCell *cell;
    NSIndexPath *path = [self.layout selectedItemIndexPath];
    
    if ([path isEqual:indexPath]) {
        cell  = [collectionView dequeueReusableCellWithReuseIdentifier:editCollectionSelectCell forIndexPath:indexPath];
    
    } else if (indexPath.section == 0) {
      cell  = [collectionView dequeueReusableCellWithReuseIdentifier:editCollectionCellID forIndexPath:indexPath];
        cell.titleLabel.text = self.usingArray[indexPath.item][EditTitleKey];
        if (indexPath.item == 0) {
            cell.titleLabel.textColor = [UIColor colorWithHexString:@"#13c99e"];
            cell.layer.borderColor = [UIColor colorWithHexString:@"#13C99E"].CGColor;
        } else {
            cell.titleLabel.textColor = [UIColor colorWithHexString:@"#888888"];
            cell.layer.borderColor = [UIColor colorWithHexString:@"#dcdcdc"].CGColor;
        }

    } else if (indexPath.section == 1){
        cell  = [collectionView dequeueReusableCellWithReuseIdentifier:editCollectionCellID forIndexPath:indexPath];
        cell.titleLabel.text = self.unUsingArray[indexPath.item][EditTitleKey];
        cell.titleLabel.textColor = [UIColor colorWithHexString:@"#888888"];
        cell.layer.borderColor = [UIColor colorWithHexString:@"#dcdcdc"].CGColor;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGFloat height;
    if (section == 0 ) {
        height = 35;
    } else {
        height = 45;
    }
    return CGSizeMake(collectionView.frame.size.width, height);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath ];
        view.backgroundColor = [UIColor whiteColor];
        for (UIView *subView in view.subviews) {
            [subView removeFromSuperview];
        }
        if (indexPath.section == 0) {
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = [UIColor colorWithHexString:@"ececec"];
            [view addSubview:line];
            line.frame = CGRectMake(0, view.frame.size.height-1, view.frame.size.width, 0.5);
            
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.text = @"我的栏目";
            titleLabel.font = [UIFont systemFontOfSize:16];
            titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
            [view addSubview:titleLabel];
            UILabel *mesage = [[UILabel alloc] init];
            mesage.text = @"点击删除，拖动排序";
            mesage.font = [UIFont systemFontOfSize:12];
            mesage.textColor = [UIColor colorWithHexString:@"888888"];
            
            [view addSubview:titleLabel];
            [view addSubview:mesage];
            titleLabel.frame = CGRectMake(10, 0, [titleLabel sizeThatFits:CGSizeMake(300, 20)].width, view.frame.size.height);
            mesage.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame) + 10, 0, [mesage sizeThatFits:CGSizeMake(300, 20)].width, view.frame.size.height);
        } else {
            // indexPath.section == 1
            UIView *seperateView = [[UIView alloc] init];
            seperateView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
            [view addSubview:seperateView];
            seperateView.frame = CGRectMake(0, 0, view.frame.size.width, 10);
            
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = [UIColor colorWithHexString:@"ececec"];
            [view addSubview:line];
            line.frame = CGRectMake(0, view.frame.size.height-1, view.frame.size.width, 0.5);
            
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.text = @"可添加的公告";
            titleLabel.font = [UIFont systemFontOfSize:16];
            titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
            [view addSubview:titleLabel];
            UILabel *mesage = [[UILabel alloc] init];
            
            mesage.text = @"点击添加更多栏目";
            mesage.font = [UIFont systemFontOfSize:13];
            mesage.textColor = [UIColor colorWithWhite:0.5 alpha:1];
            [view addSubview:mesage];
            titleLabel.frame = CGRectMake(10, CGRectGetMaxY(seperateView.frame), [titleLabel sizeThatFits:CGSizeMake(300, 20)].width, view.frame.size.height - CGRectGetHeight(seperateView.frame));
            mesage.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame) + 10, titleLabel.frame.origin.y, [mesage sizeThatFits:CGSizeMake(300, 20)].width, titleLabel.frame.size.height);
        }
        return view;
    }
    return nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
@end
