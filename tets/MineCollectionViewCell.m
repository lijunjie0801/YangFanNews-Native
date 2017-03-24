//
//  MineCollectionViewCell.m
//  CollectionviewSort
//
//  Created by wangwenke on 16/4/12.
//  Copyright © 2016年 wangwenke. All rights reserved.
//

#import "MineCollectionViewCell.h"

@implementation MineCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    
        _label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, ([UIScreen mainScreen].bounds.size.width - 50)/4, 40)];
         [self.contentView addSubview:_label];
        _label.textAlignment=UITextAlignmentCenter;
        
        
        
        _cellImage = [[UIImageView alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 50)/4-5, -5,12,12)];
        _cellImage.image=[UIImage imageNamed:@"sx"];
        _cellImage.hidden=YES;
        [_label addSubview:_cellImage];
        
    }
    return self;
}

@end
