//
//  NewThreeImgCell.h
//  tets
//
//  Created by lijunjie on 2016/12/14.
//  Copyright © 2016年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsListModel.h"
@interface NewThreeImgCell : UITableViewCell
@property(nonatomic,strong)UIImageView *imgView;
@property(nonatomic,strong)UIImageView *middleimgView;
@property(nonatomic,strong)UIImageView *rightimgView;
@property(nonatomic,strong)UILabel *titlelabel;
@property(nonatomic,strong)UILabel *sourcelabel;
@property(nonatomic,strong)UILabel *replylabel;
@property(nonatomic,strong)UIView *sparaView;
-(void)updateWithModel:(NewsListModel *)model;
@end
