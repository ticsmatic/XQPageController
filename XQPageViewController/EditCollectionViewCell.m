//
//  EditCollectionViewCell.m
//  XQPageControllerDemo
//
//  Created by Ticsmatic on 2017/7/20.
//  Copyright © 2017年 Ticsmatic. All rights reserved.
//

#import "EditCollectionViewCell.h"

NSString *const editCollectionCellID = @"editcollectionviewcell";
NSString *const editCollectionSelectCell = @"selectCell";

@implementation EditCollectionViewCell

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        self.layer.borderWidth = 0.5;
        
        _titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_titleLabel];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.minimumScaleFactor = 0.8f;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _titleLabel.frame = CGRectMake(2, 0, self.contentView.frame.size.width - 4, self.contentView.frame.size.height);
}
@end


@implementation EditSelectedCollectionViewCell

@end
