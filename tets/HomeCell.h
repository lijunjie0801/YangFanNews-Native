//
//  HomeCell.h
//  tets
//
//  Created by lijunjie on 2016/12/2.
//  Copyright © 2016年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
@interface HomeCell : UITableViewCell
@property(nonatomic,strong)UIImageView *imgView;
@property(nonatomic,strong)UILabel *titlelabel;
@property(nonatomic,strong)UILabel *contentlabel;
-(void)updateWithModel:(HomeModel *)model;
-(void)updateWithArray:(NSArray *)array;
@end
