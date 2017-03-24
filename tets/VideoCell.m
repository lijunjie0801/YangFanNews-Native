//
//  VideoCell.m
//  WMVideoPlayer
//
//  Created by zhengwenming on 16/1/17.
//  Copyright © 2016年 郑文明. All rights reserved.
//

#import "VideoCell.h"
#import "VideoModel.h"
#import "UIImageView+WebCache.h"
#define kScreenWidth   ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight  ([UIScreen mainScreen].bounds.size.height)

@implementation VideoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor=[UIColor whiteColor];
        
        
        _backgroundIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,210)];
        _backgroundIV.userInteractionEnabled=YES;
        [self.contentView addSubview:_backgroundIV];
        _playBtn =[[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth-50)/2, 80, 50, 50)];
        [_playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
         [self.contentView addSubview:_playBtn];
        
        
        _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
        _titleLabel.text=@"666";
        _titleLabel.textColor=[UIColor whiteColor];
//        _titleLabel.backgroundColor=[UIColor blackColor];
//        _titleLabel.alpha=0.2;
        [_backgroundIV addSubview:_titleLabel];
        
        _iconimgview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 220,30,30)];
        [self.contentView addSubview:_iconimgview];
        _iconimgview.layer.masksToBounds = YES;
        _iconimgview.layer.cornerRadius = 15;
        _iconimgview.layer.borderWidth=1;
        _iconimgview.layer.borderColor=[UIColor whiteColor].CGColor;
        
        _sourceLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, 220, 100, 30)];
        _sourceLabel.textColor=[UIColor blackColor];
        [self.contentView addSubview:_sourceLabel];
        
        _countLabel=[[UILabel alloc]initWithFrame:CGRectMake(260, 220, 100, 30)];
        _countLabel.textColor=[UIColor grayColor];
        [self.contentView addSubview:_countLabel];

        UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0,260, kScreenWidth, 15)];
        bottomView.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:244/255.0 alpha:0.8];
        [self.contentView addSubview:bottomView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)setModel:(VideoModel *)model{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.titleLabel.text = model.title;
     self.sourceLabel.text = model.videosource;
    self.countLabel.text = [NSString stringWithFormat:@"%@次播放",model.playCount];
    self.countLabel.font=[UIFont systemFontOfSize:14];
    [self.iconimgview sd_setImageWithURL:[NSURL URLWithString:model.topicImg] placeholderImage:[UIImage imageNamed:@"logo"]];
//    self.descriptionLabel.text = model.descriptionDe;
    [self.backgroundIV sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"logo"]];
    
    
//    self.countLabel.text = [NSString stringWithFormat:@"%ld.%ld万",model.playCount/10000,model.playCount/1000-model.playCount/10000];
//    self.timeDurationLabel.text = [model.ptime substringWithRange:NSMakeRange(12, 4)];

}
@end
