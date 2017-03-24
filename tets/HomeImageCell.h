//
//  HomeImageCell.h
//  tets
//
//  Created by lijunjie on 2017/1/3.
//  Copyright © 2017年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeImageCell : UITableViewCell
@property (nonatomic,strong)NSMutableArray *cellarray;
@property (nonatomic,strong) UIImageView *backgroundImageView;
@property (nonatomic,strong)UILabel *bottomlbel;
-(void)updateCellWithArray:(NSArray *)array;
@end
