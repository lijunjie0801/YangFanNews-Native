//
//  HomeCell.m
//  tets
//
//  Created by lijunjie on 2016/12/2.
//  Copyright © 2016年 dev. All rights reserved.
//

#import "HomeCell.h"
#import "UIView+AutoLayout.h"
@implementation HomeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor=[UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];;
        for (int i=0; i<2; i++) {
            UIImageView *imageView=[[UIImageView alloc]init];
            [self.contentView addSubview:imageView];
            CGFloat width=([UIScreen mainScreen].bounds.size.width-5)/2;
            [imageView autoSetDimensionsToSize:CGSizeMake(width, 195)];
            [imageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:i*width+5*i];
            [imageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
            //   imageView.backgroundColor=[UIColor redColor];
            imageView.tag=100+i;
            
            UILabel *jiangjiaLabel=[[UILabel alloc]init];
            [self.contentView addSubview:jiangjiaLabel];
            //    jiangjiaLabel.backgroundColor=[UIColor redColor];
            [jiangjiaLabel autoSetDimensionsToSize:CGSizeMake(width, 20)];
            [jiangjiaLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:i*width+5*i];
            [jiangjiaLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:imageView withOffset:0];
            //            [jiangjiaLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
            //titleLabel.backgroundColor=[UIColor redColor];
            jiangjiaLabel.textAlignment=NSTextAlignmentCenter;
            jiangjiaLabel.tag=300+i;
            
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.headIndent = 30;//缩进
            style.firstLineHeadIndent = 0;
            UILabel *titleLabel=[[UILabel alloc]init];
            [self.contentView addSubview:titleLabel];
            [titleLabel autoSetDimensionsToSize:CGSizeMake(width, 40)];
            [titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:i*width+5*i];
            [titleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:imageView withOffset:5];
            
            //titleLabel.backgroundColor=[UIColor redColor];
            //  titleLabel.textAlignment=NSTextAlignmentCenter;
            titleLabel.tag=200+i;
            
        }
        
    }
    return self;

}
-(void)updateWithModel:(HomeModel *)model{
  //  self.imgView.image=[UIImage imageNamed:model.img];
    self.titlelabel.text=model.title;
    self.contentlabel.text=model.content;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}
-(void)updateWithArray:(NSArray *)array{
    NSLog(@"%@",array);
    for (int i=0; i<2; i++) {
        UIImageView *imageView=(UIImageView *)[self viewWithTag:100+i];
        imageView.image=[UIImage imageNamed:array[i][@"img"]];
        
        UILabel *jiangjiaLabel=(UILabel *)[self viewWithTag:300+i];
        if (array[i][@"jiangjia"]) {
            jiangjiaLabel.backgroundColor=[UIColor colorWithRed:222/255.0 green:81/255.0 blue:15/255.0 alpha:1];
            jiangjiaLabel.text=[NSString stringWithFormat:@"您关注的商品已优惠%d元",[array[i][@"jiangjia"] intValue]];
            jiangjiaLabel.font=[UIFont systemFontOfSize:12];
            jiangjiaLabel.textColor=[UIColor whiteColor];
        }
        
        UILabel *titleLabel=(UILabel *)[self viewWithTag:200+i];
        titleLabel.text=array[i][@"title"];
        titleLabel.font=[UIFont systemFontOfSize:12];
        titleLabel.numberOfLines=0;
        if (array[i][@"zhixiao"]) {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:titleLabel.text];
            NSMutableParagraphStyle   *paragraphStyle   = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setFirstLineHeadIndent:25.0];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [ titleLabel.text length])];
            [titleLabel setAttributedText:attributedString];
        
            UIImageView *rxImgView=[[UIImageView alloc]init];
            [titleLabel addSubview:rxImgView];
            [rxImgView autoSetDimensionsToSize:CGSizeMake(20, 18)];
            [rxImgView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:4];
            [rxImgView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:2];
            rxImgView.image=[UIImage imageNamed:@"zhixiao_1"];
            
        }
        
        
        
        
    }

}

@end
