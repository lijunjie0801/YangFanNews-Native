//
//  NewsCell.m
//  tets
//
//  Created by lijunjie on 2016/12/13.
//  Copyright © 2016年 dev. All rights reserved.
//

#import "NewsCell.h"
#import "UIView+AutoLayout.h"
#import "UIImageView+WebCache.h"
@implementation NewsCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *imgView=[[UIImageView alloc]init];
        self.imgView=imgView;
        [self.contentView addSubview:imgView];
        CGFloat imgwidth=([UIScreen mainScreen].bounds.size.width-40)/3;
        imgView.frame=CGRectMake(10, 10, imgwidth, 90);

        UILabel *titleLabel=[[UILabel alloc]init];
        [self.contentView addSubview:titleLabel];
        self.titlelabel=titleLabel;
        self.titlelabel.numberOfLines=0;
        self.titlelabel.font=[UIFont systemFontOfSize:18];
        titleLabel.frame=CGRectMake(imgwidth+20, 10, [UIScreen mainScreen].bounds.size.width-imgwidth-30, 150);
        
        UILabel *sourceLabel=[[UILabel alloc]init];
        [self.contentView addSubview:sourceLabel];
        self.sourcelabel=sourceLabel;
        self.sourcelabel.font=[UIFont systemFontOfSize:11];
        
        UILabel *replyLabel=[[UILabel alloc]init];
        [self.contentView addSubview:replyLabel];
        self.replylabel=replyLabel;
        self.replylabel.font=[UIFont systemFontOfSize:11];
        
        UIView *separaView=[[UIView alloc]init];
        [self.contentView addSubview:separaView];
        self.sparaView=separaView;

    }
    return self;
}

-(void)updateWithModel:(NewsListModel *)model{
    CGFloat max=[UIScreen mainScreen].bounds.size.width-self.imgView.bounds.size.width-30;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            NSString *labelText=model.title;
            NSString *sourceText=model.source;
            NSString *replyText=@"";
            if (model.replyCount > 10000) {
                NSInteger temp = model.replyCount / 10000;
                model.replyCount = model.replyCount % 10000 / 1000;
                replyText = [NSString stringWithFormat:@"%li.%li万人跟帖",(long)temp, (long)model.replyCount];
            } else if (model.replyCount == 0){
            
            } else {
               replyText = [NSString stringWithFormat:@"%li人跟帖",(long)model.replyCount];
            }
        
         dispatch_async(dispatch_get_main_queue(), ^{
//             [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"defaultCycle" ofType:@"png"]]  options:SDWebImageRetryFailed];
             [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:[UIImage imageNamed:@"default"]  options:SDWebImageRetryFailed];

            self.titlelabel.text=labelText;
             self.sourcelabel.text=sourceText;
             self.replylabel.text=replyText;
             CGSize s=[labelText boundingRectWithSize:CGSizeMake(max, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
             CGSize s1=[sourceText boundingRectWithSize:CGSizeMake(max, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
             CGSize s2=[self.replylabel.text boundingRectWithSize:CGSizeMake(max, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;

             self.titlelabel.font=[UIFont systemFontOfSize:18];
             self.titlelabel.frame=CGRectMake(CGRectGetMaxX(self.imgView.bounds)+20, 10, s.width,s.height);
             CGFloat maximgY=CGRectGetMaxY(self.imgView.bounds);
             self.sourcelabel.frame=CGRectMake(CGRectGetMaxX(self.imgView.bounds)+20, maximgY, s1.width,s1.height);
             self.replylabel.frame=CGRectMake(CGRectGetMaxX(self.imgView.bounds)+30+s1.width, maximgY, s2.width, s2.height);
             
             self.sparaView.frame=CGRectMake(10, maximgY+20, [UIScreen mainScreen].bounds.size.width-20, 0.5);
             self.sparaView.backgroundColor=[UIColor grayColor];
        });
    });
   

   //[UIImage imageWithData:imgData];
    
  

   
   
//    CGSize size = [model.title sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(width,10000.0f)lineBreakMode:UILineBreakModeWordWrap];
//    [self.titlelabel autoSetDimensionsToSize:CGSizeMake(size.width, size.height)];
//    self.titlelabel.numberOfLines = 0; // 最关键的一句

  }
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}


@end
