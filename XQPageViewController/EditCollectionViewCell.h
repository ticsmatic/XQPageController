//
//  EditCollectionViewCell.h
//  XQPageControllerDemo
//
//  Created by Ticsmatic on 2017/7/20.
//  Copyright © 2017年 Ticsmatic. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const editCollectionCellID;
extern NSString *const editCollectionSelectCell;

@interface EditCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) UILabel *titleLabel;
@end


@interface EditSelectedCollectionViewCell : UICollectionViewCell
@end
