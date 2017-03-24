//
//  HomeImageCell.m
//  tets
//
//  Created by lijunjie on 2017/1/3.
//  Copyright © 2017年 dev. All rights reserved.
//

#import "HomeImageCell.h"
#define kscreenWidth [UIScreen mainScreen].bounds.size.width
@implementation HomeImageCell


-(instancetype)init{
    CGFloat imgwidth=(kscreenWidth-40)/3;
    self = [super init];
    if (self) {
        self.contentView.backgroundColor=[UIColor whiteColor];
        
        
        for (int i=0; i<13; i++) {
            CGFloat x=(i%3*imgwidth)+(i%3+1)*10;
            CGFloat y=(i/3*imgwidth)+(i/3+1)*10;
            _backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y,imgwidth,imgwidth)];
            _backgroundImageView.backgroundColor=[UIColor redColor];
            [self.contentView addSubview:_backgroundImageView];
            _backgroundImageView.tag=100+i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleClick:)];
            [_backgroundImageView addGestureRecognizer:tap];
            _backgroundImageView.userInteractionEnabled=YES;
            
            UIView *backview=[[UIView alloc]initWithFrame:CGRectMake(0, imgwidth-20, imgwidth, 20)];
            [_backgroundImageView addSubview:backview];
            backview.backgroundColor=[UIColor grayColor];
            backview.alpha=0.2;
            _bottomlbel=[[UILabel alloc]initWithFrame:CGRectMake(0, imgwidth-20, imgwidth, 20)];
//            _bottomlbel.alpha=0.2;
            _bottomlbel.font=[UIFont systemFontOfSize:15];
            _bottomlbel.tag=200+i;
            _bottomlbel.textColor=[UIColor whiteColor];
            _bottomlbel.textAlignment=NSTextAlignmentCenter;
            [_backgroundImageView addSubview:_bottomlbel];
        }
    }
    return self;

}
-(void)updateCellWithArray:(NSArray *)array{
    NSLog(@"myarray&&&%@",array);
    _cellarray=[array copy];
    if ([array count]!=0){
        for (int i=0; i<[array count]; i++) {
            UIImageView *imgV = (UIImageView *)[self viewWithTag:100+i];
            imgV.image=[UIImage imageNamed:[NSString stringWithFormat:@"group%d",i]];
            UILabel *bottomLabel=(UILabel *)[self viewWithTag:200+i];
            bottomLabel.text=array[i];
        }
    }


}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)titleClick:(UITapGestureRecognizer *)tap
{
    UIImageView *imgview = (UIImageView *)tap.view;
    NSInteger index = tap.view.tag-100;
    NSString *type=self.cellarray[index];
    NSDictionary *dic = @{@"type":type};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cellClick" object:nil userInfo:dic];
    
}
@end
