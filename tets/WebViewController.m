//
//  WebViewController.m
//  tets
//
//  Created by lijunjie on 2016/12/14.
//  Copyright © 2016年 dev. All rights reserved.
//

#import "WebViewController.h"
#import "BANetManager.h"
#import "NewDetailModel.h"
#import "RDVTabBarController.h"
@interface WebViewController (){
    NSInteger _count;
}
#define kUrlNewsDetails @"http://c.3g.163.com/nc/article/%@/full.html"
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
@property(nonatomic,strong)NewDetailModel *model;
@property(nonatomic,strong)UIWebView *webview;
@property(nonatomic,strong)UIButton *collectionImg;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getdata];
    [self webviewload];
    [self setbottomview];
}
-(void)setbottomview{
   // self.webview.userInteractionEnabled=YES;
    UIView *bottomview=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-46, SCREEN_WIDTH, 46)];
    bottomview.backgroundColor= [UIColor colorWithRed:245/255.0 green:245/255.0 blue:244/255.0 alpha:1.0];
    [self.navigationController.view addSubview:bottomview];
   // bottomview.userInteractionEnabled=NO;
    UIButton *replybtn=[[UIButton alloc]initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH/2, 36)];
    [bottomview addSubview:replybtn];
    replybtn.backgroundColor=[UIColor whiteColor];
    [replybtn setTitle:@"写评论..." forState:UIControlStateNormal];
    [replybtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    replybtn.contentHorizontalAlignment=1;
    replybtn.layer.borderWidth=1.0;
    replybtn.layer.cornerRadius=15;
    replybtn.layer.borderColor= [UIColor grayColor].CGColor;
    
    UIButton *collectImg=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+55, 8, 31, 31)];
    _count=0;
    self.collectionImg=collectImg;
    [collectImg setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
    [collectImg addTarget:self action:@selector(collectionClick) forControlEvents:UIControlEventTouchUpInside];
 //   collectImg.userInteractionEnabled=YES;
    [bottomview addSubview:collectImg];
    
//    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonpress1:)];
//    [imageview1 addGestureRecognizer:singleTap1];
   
    
    UIImageView *shareImg=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+125, 12, 26, 26)];
    shareImg.image=[UIImage imageNamed:@"shareq"];
    [bottomview addSubview:shareImg];
    }
-(void)collectionClick{
    if(_count==0){
         [self.collectionImg setImage:[UIImage imageNamed:@"collections"] forState:UIControlStateNormal];
        _count=1;
    }else{
         [self.collectionImg  setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
        _count=0;
    }
}
-(void)webviewload{
    NSLog(@"model.title%@",self.model.title);
     [self.rdv_tabBarController setTabBarHidden:YES animated:NO];
    UIWebView* webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-40)];
    self.webview=webView;
   // webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    [self.view addSubview:webView];
    
    webView.backgroundColor = [UIColor clearColor];
    //        _webView.scrollView.scrollEnabled = NO;
    webView.allowsInlineMediaPlayback = YES;
    webView.mediaPlaybackRequiresUserAction = YES;

    UIButton *backbtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [backbtn addTarget:self action:@selector(backclick) forControlEvents:UIControlEventTouchUpInside];
    [backbtn setImage:[UIImage imageNamed:@"comeback"] forState:UIControlStateNormal];
    UIBarButtonItem *btnitem=[[UIBarButtonItem alloc]initWithCustomView:backbtn];
    self.navigationItem.leftBarButtonItem=btnitem;
}
-(void)backclick{
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)getdata{
    NSString *url=[NSString stringWithFormat:kUrlNewsDetails, self.docid];

    [BANetManager ba_requestWithType:BAHttpRequestTypeGet
                           urlString:url
                          parameters:nil
                        successBlock:^(id response) {
                            NSLog(@"get请求数据成功： *** %@", response);
                            NSDictionary *dataDict = [response objectForKey:self.docid];
                            NewDetailModel *model= [NewDetailModel new];
                            [model setValuesForKeysWithDictionary:dataDict];
                            self.model=model;
                        
                            //_rootView.model = model;

                            
                        } failureBlock:^(NSError *error) {
                            
                        } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                            
                        }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setModel:(NewDetailModel *)model {
    if (_model != model) {
        _model = model;
        self.title= model.source;
//        self.lblDate.text = model.ptime;
//        self.lblSource.text = model.source;
        //获取图片集信息
        for (int i = 0; i < model.img.count; i++) {
            NSArray *pixArr = [model.img[i][@"pixel"]  componentsSeparatedByString:@"*"];
            if (!pixArr) {
                pixArr = @[[NSString stringWithFormat:@"%f", SCREEN_WIDTH - 20], [NSString stringWithFormat:@"%f", (SCREEN_WIDTH - 20) * 2.0 / 3]];
            }
            if ([pixArr[0] floatValue] > SCREEN_WIDTH) {
                pixArr = @[[NSString stringWithFormat:@"%f", SCREEN_WIDTH - 20],[NSString stringWithFormat:@"%f",[pixArr[1] floatValue]  * SCREEN_WIDTH / [pixArr[0] floatValue]]];
                
            }
            NSString *imgTag = [NSString stringWithFormat:@"<div style=\"border:1px font-size:14; text-align:center; solid #ccc;\"> <img style=\" width:%@; height:%@;\" src=\"%@\"><span>%@</span></div>",pixArr[0], pixArr[1], model.img[i][@"src"], model.img[i][@"alt"]];
            model.body = [model.body stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<!--IMG#%d-->", i] withString:imgTag];
        }
        for (int i = 0; i < model.video.count; i++) {
            NSString *videoTag = [NSString stringWithFormat:@"<div style=\"border:1px font-size:14; text-align:center; solid #ccc;\"><video id=\"player\" width=\"300\" height=\"250\" controls webkit-playsinline controls='controls' autoplay='autoplay'> <source src=\"%@\" type=\"video/mp4\" /> </video></div>", model.video[i][@"url_mp4"]];
            model.body = [model.body stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<!--VIDEO#%d-->", i] withString:videoTag];
        }
        [self.webview loadHTMLString:model.body baseURL:nil];
        
//        CGRect frame = self.lblSource.frame;
//        frame.size.width = [CommonNewsDetailsView getTextWidth:self.lblSource.text];
//        self.lblSource.frame = frame;
//        
//        CGRect frame2 = self.lblDate.frame;
//        frame2.origin.x = 15 + frame.size.width + 5;
//        self.lblDate.frame = frame2;
    }
}
@end
