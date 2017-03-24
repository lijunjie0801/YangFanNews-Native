//
//  ImageSeeViewController.m
//  tets
//
//  Created by lijunjie on 2016/12/15.
//  Copyright © 2016年 dev. All rights reserved.
//

#import "ImageSeeViewController.h"
#import "BANetManager.h"
#import "ImagesDisplayModel.h"
#import "UIImageView+WebCache.h"
#import "RDVTabBarController.h"
@interface ImageSeeViewController ()<UIScrollViewDelegate>{
    CGFloat lastScale;
    CGRect oldFrame;    //保存图片原来的大小
    CGRect largeFrame;  //确定图片放大最大的程
}
#define kURL_ImagesSet @"http://c.3g.163.com/photo/api/set/%@/%@.json"
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
@property(nonatomic,strong)NSMutableArray *photoArray;
@property(nonatomic,strong)NSMutableArray *decArray;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIImageView *imageview;
@property(nonatomic,strong)UILabel *decLabel;
@property(nonatomic,strong)UIButton *backbtn;
@property (nonatomic,assign) CGFloat totalScale;
@end

@implementation ImageSeeViewController
-(NSMutableArray *)photoArray{
    if (!_photoArray) {
        _photoArray=[NSMutableArray array];
    }
    return _photoArray;
}
-(NSMutableArray *)decArray{
    if (!_decArray) {
        _decArray=[NSMutableArray array];
    }
    return _decArray;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
     [self.rdv_tabBarController setTabBarHidden:NO animated:NO];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;//  [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
//    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(100, 100, 200, 100)];
//    [self.view addSubview:label];
//    label.text=self.skipID;
    [self readDataByURL];

}
-(void)setscroll{
    

     NSMutableArray *mArr=[[NSMutableArray alloc]init];
        NSMutableArray *decArr=[[NSMutableArray alloc]init];
    for (int i=0; i<_photoArray.count; i++) {
        NSString *imgstr=_photoArray[i][@"imgurl"];
        //UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgstr]]];
        NSString *decstr=_photoArray[i][@"note"];
        [mArr addObject:imgstr];
        [decArr addObject:decstr];
    }
    _decArray=[decArr copy];
    
    UIScrollView *imageScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.scrollView = imageScroll;
   imageScroll.delegate=self;
    imageScroll.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:1.0];
    imageScroll.contentSize = CGSizeMake(SCREEN_WIDTH*mArr.count, SCREEN_HEIGHT);
    [self.view addSubview:imageScroll];
    imageScroll.pagingEnabled = YES;
    imageScroll.bounces = NO;
    
    for (int i = 0; i<mArr.count; i++) {
     
       // [mixScrollView setDelegate:self];
        
         UIImageView *img = [[UIImageView alloc]init];
         self.imageview=img;
       //  [img sd_setImageWithURL:mArr[i]];
         [self.imageview sd_setImageWithURL:[NSURL URLWithString:mArr[i]] placeholderImage:[UIImage imageNamed:@"default"]  options:SDWebImageRetryFailed];
         img.contentMode = UIViewContentModeScaleAspectFit;
         img.frame = CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
         [imageScroll addSubview:img];
        
        img.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom)];
            singleRecognizer.numberOfTapsRequired = 1; // 单击
            [img addGestureRecognizer:singleRecognizer];
        
    }

    
    

        UILabel *lab = [[UILabel alloc]init];
        self.decLabel=lab;
        [self.decLabel setHidden:NO];
        lab.font=[UIFont systemFontOfSize:15];
        lab.numberOfLines=0;
        NSString *decstr=[NSString stringWithFormat:@"1/%ld  %@",_decArray.count,decArr[0]];
        CGSize s1=[decstr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        lab.text =decstr;
        self.decLabel.frame=CGRectMake(0, SCREEN_HEIGHT-s1.height-20, SCREEN_WIDTH, s1.height);
        lab.textColor=[UIColor whiteColor];
        [self.view addSubview:lab];
    
    UIButton *backbtn=[[UIButton alloc]initWithFrame:CGRectMake(2, 20, 50, 50)];
    self.backbtn=backbtn;
    [self.backbtn setHidden:NO];
    [backbtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.view addSubview:backbtn];
    [backbtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)readDataByURL {
    NSString *skiptype=[self.skipTypeID substringFromIndex:4];
    NSString *urlString=[NSString stringWithFormat:kURL_ImagesSet,skiptype, self.skipID];
    
    [BANetManager ba_requestWithType:BAHttpRequestTypeGet
                    urlString:urlString
                    parameters:nil
                    successBlock:^(id response) {
                        NSLog(@"get请求数据成功： *** %@", response);
                        NSDictionary *dataDict = [NSDictionary dictionaryWithDictionary:response];
                        ImagesDisplayModel *model = [[ImagesDisplayModel alloc] init];
                        [model setValuesForKeysWithDictionary:dataDict];
                        NSMutableArray *mArr=[[NSMutableArray alloc]init];
                        NSArray *photoarr=model.photos;
                        for (NSMutableDictionary *dict in photoarr) {
                            [mArr addObject:dict];
                        }
                        _photoArray=[mArr copy];
                        NSLog(@"图片数量%@",_photoArray);
                        [self setscroll];
                    } failureBlock:^(NSError *error) {
                                
                    } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                                
                    }];

   
}
- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView {
    NSInteger index = self.scrollView.contentOffset.x / SCREEN_WIDTH;
    NSString *dectext=[NSString stringWithFormat:@"%ld/%ld  %@",index+1,_decArray.count,_decArray[index]];
     CGSize s1=[dectext boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    self.decLabel.text=dectext;
    self.decLabel.frame=CGRectMake(0, SCREEN_HEIGHT-s1.height-20, SCREEN_WIDTH, s1.height);
}
-(void)back{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)handleSingleTapFrom{
    if (self.decLabel.isHidden==NO) {
        [self.decLabel setHidden:YES];
    }else{
        [self.decLabel setHidden:NO];
    }
    if (self.backbtn.isHidden==NO) {
        [self.backbtn setHidden:YES];
    }else{
        [self.backbtn setHidden:NO];
    }
    
}




@end
