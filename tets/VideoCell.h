//
//  VideoCell.h
//  WMVideoPlayer
//
//  Created by zhengwenming on 16/1/17.
//  Copyright © 2016年 郑文明. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VideoModel;
@interface VideoCell : UITableViewCell
@property (nonatomic,strong)  UILabel *titleLabel;
@property (nonatomic,strong) UILabel *descriptionLabel;
@property (nonatomic,strong) UIImageView *backgroundIV;
@property (nonatomic,strong) UILabel *timeDurationLabel;
@property (nonatomic,strong) UILabel *countLabel;
@property (nonatomic,strong) UIButton *playBtn;
@property (nonatomic,strong) UIImageView *iconimgview;
@property (nonatomic,strong) UILabel *sourceLabel;
@property (nonatomic, retain)VideoModel *model;



@end
