//
//  HomeViewController.m
//  03-FZHTabbarController
//
//  Created by lijunjie on 2016/11/25.
//  Copyright © 2016年 FZH. All rights reserved.
//

#import "HomeViewController.h"
#import "SDCycleScrollView.h"
#import "HomeCell.h"
#import "HomeModel.h"
@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *proArray;
@end

@implementation HomeViewController
-(NSArray *)proArray{
    if (!_proArray) {
        NSString *path=[[NSBundle mainBundle] pathForResource:@"pros.plist" ofType:nil];
        NSArray *marr=[NSArray arrayWithContentsOfFile:path];
        self.proArray=marr;
    }
    return _proArray;
   

}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [self settableView];
    [self setheadView];
    [self setLunBo];
    
}
-(void)settableView{
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.backgroundColor=[UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.view = _tableView;
    //[self.view addSubview:self.tableView];
}

-(void)setheadView{
    UIButton *erbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [erbtn setFrame: CGRectMake(0,0, 30, 30)];
    [erbtn setImage:[UIImage imageNamed: @"erweima"] forState:UIControlStateNormal];
    [erbtn setTintColor:[UIColor whiteColor]];
    erbtn.imageEdgeInsets=UIEdgeInsetsMake(-10, 0, 0, 0);
    
    UILabel *sLabel=[[UILabel alloc]init];
    sLabel.text=@"扫一扫";
    sLabel.font=[UIFont systemFontOfSize:6];
    sLabel.textColor=[UIColor whiteColor];
    [erbtn addSubview:sLabel];
    [sLabel autoSetDimensionsToSize:CGSizeMake(35, 12)];
    [sLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:erbtn withOffset:2];
    [sLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:6];
    
    UIBarButtonItem *leftCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:erbtn];
    self.navigationItem.leftBarButtonItem = leftCunstomButtonView;
    
    
    
    
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/3, 5, self.view.bounds.size.width/3*2, 30)];
    [btn setTitle:@"雷神笔记本" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.imageEdgeInsets=UIEdgeInsetsMake(0, 10, 0, 0);
    btn.titleEdgeInsets=UIEdgeInsetsMake(0, 20, 0, 0);
    
    
    [btn setBackgroundColor:[UIColor colorWithRed:183/255.0 green:49/255.0 blue:4/255.0 alpha:1]];
    self.navigationItem.titleView=btn;
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn2 setFrame: CGRectMake(self.view.bounds.size.width/3*2-25, 5, 20, 20)];
    [btn2 setBackgroundImage:[UIImage imageNamed: @"camera"] forState:UIControlStateNormal];
    btn2.contentMode = UIViewContentModeScaleAspectFill;
    [btn addSubview: btn2];
    
    
    UIButton *mbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [mbtn setFrame: CGRectMake(0,0, 30, 30)];
    [mbtn setImage:[UIImage imageNamed: @"xiaoxi_2"] forState:UIControlStateNormal];
    [mbtn setTintColor:[UIColor whiteColor]];
    mbtn.imageEdgeInsets=UIEdgeInsetsMake(-10, 0, 0, 0);
    
    UILabel *mLabel=[[UILabel alloc]init];
    mLabel.text=@"消  息";
    mLabel.font=[UIFont systemFontOfSize:6];
    mLabel.textColor=[UIColor whiteColor];
    [mbtn addSubview:mLabel];
    [mLabel autoSetDimensionsToSize:CGSizeMake(35, 12)];
    [mLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:mbtn withOffset:2];
    [mLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:7];
    
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:mbtn];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:attrs forState:UIControlStateNormal];


}
-(void)setLunBo{
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 3350)];
    //bgView.backgroundColor=[UIColor yellowColor];
    self.tableView.tableHeaderView=bgView;
//    [self.view addSubview:bgView]
    NSMutableArray *imgArr=[[NSMutableArray alloc]init];
     NSMutableArray *imgArr1=[[NSMutableArray alloc]init];
    for (int i=0; i<3; i++) {
        UIImage *img=[UIImage imageNamed:[NSString stringWithFormat:@"0%d",i]];
         UIImage *img1=[UIImage imageNamed:[NSString stringWithFormat:@"lunbo0%d",i]];
        [imgArr addObject:img];
        [imgArr1 addObject:img1];
        
    }
    
    SDCycleScrollView *sdView=[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 150) imageNamesGroup:imgArr];
    sdView.currentPageDotColor=[UIColor colorWithRed:222/255.0 green:81/255.0 blue:15/255.0 alpha:1];
    sdView.pageDotColor=[UIColor whiteColor];
    sdView.pageControlAliment=SDCycleScrollViewPageContolAlimentRight;
    //间隔时间
    sdView.autoScrollTimeInterval=2;
    sdView.titleLabelBackgroundColor=[UIColor greenColor];
    [bgView addSubview:sdView];
    
    UIImageView *midImgView=[[UIImageView alloc]init];
    [bgView addSubview:midImgView];
    [midImgView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
     [midImgView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [midImgView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:sdView withOffset:0];
    [midImgView autoSetDimension:ALDimensionHeight toSize:155];
    midImgView.image=[UIImage imageNamed:@"middle"];
    
    UIImageView *midImgView2=[[UIImageView alloc]init];
    [bgView addSubview:midImgView2];
    [midImgView2 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [midImgView2 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [midImgView2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:midImgView withOffset:0];
    [midImgView2 autoSetDimension:ALDimensionHeight toSize:55];
    midImgView2.image=[UIImage imageNamed:@"middle_2"];
    
    UIImageView *midImgView3=[[UIImageView alloc]init];
    [bgView addSubview:midImgView3];
    [midImgView3 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [midImgView3 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [midImgView3 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:midImgView2 withOffset:10];
    [midImgView3 autoSetDimension:ALDimensionHeight toSize:65];
    midImgView3.image=[UIImage imageNamed:@"middle_3"];
    
    UIView *midbgView=[[UIView alloc]initWithFrame:CGRectMake(0, 450, SCREEN_WIDTH, 620)];
    
   midbgView.backgroundColor=[UIColor colorWithRed:218/255.0 green:70/255.0 blue:41/255.0 alpha:1];
    [bgView addSubview:midbgView];
    
    UIImageView *midImgView4=[[UIImageView alloc]init];
    [midbgView addSubview:midImgView4];
    [midImgView4 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5];
    [midImgView4 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5];
    [midImgView4 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
    [midImgView4 autoSetDimension:ALDimensionHeight toSize:300];
    midImgView4.image=[UIImage imageNamed:@"middle_4"];
    
    UIImageView *midImgView5=[[UIImageView alloc]init];
    [midbgView addSubview:midImgView5];
    [midImgView5 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5];
    [midImgView5 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5];
    [midImgView5 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:midImgView4 withOffset:0];
    [midImgView5 autoSetDimension:ALDimensionHeight toSize:300];
    midImgView5.image=[UIImage imageNamed:@"middle_5"];

    UIImageView *midImgView6=[[UIImageView alloc]init];
    [bgView addSubview:midImgView6];
    [midImgView6 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [midImgView6 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [midImgView6 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:midbgView withOffset:0];
    [midImgView6 autoSetDimension:ALDimensionHeight toSize:600];
    midImgView6.image=[UIImage imageNamed:@"middle_6"];
    
    UIView *scrbgView=[[UIView alloc]init];
    [bgView addSubview:scrbgView];
    [scrbgView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [scrbgView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [scrbgView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:midImgView6 withOffset:0];
    [scrbgView autoSetDimension:ALDimensionHeight toSize:75];
   
    
    SDCycleScrollView *sdView2=[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 75) imageNamesGroup:imgArr1];
    sdView2.currentPageDotColor=[UIColor colorWithRed:222/255.0 green:81/255.0 blue:15/255.0 alpha:1];
    sdView2.pageDotColor=[UIColor whiteColor];
    sdView2.pageControlAliment=SDCycleScrollViewPageContolAlimentCenter;
    //间隔时间
    sdView2.autoScrollTimeInterval=2;
    sdView2.titleLabelBackgroundColor=[UIColor greenColor];
    [scrbgView addSubview:sdView2];

    UIImageView *midImgView7=[[UIImageView alloc]init];
    [bgView addSubview:midImgView7];
    [midImgView7 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [midImgView7 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [midImgView7 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:scrbgView withOffset:0];
    [midImgView7 autoSetDimension:ALDimensionHeight toSize:550];
    midImgView7.image=[UIImage imageNamed:@"middle_7"];
    
    UIView *scrbgView1=[[UIView alloc]init];
    [bgView addSubview:scrbgView1];
    [scrbgView1 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [scrbgView1 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [scrbgView1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:midImgView7 withOffset:0];
    [scrbgView1 autoSetDimension:ALDimensionHeight toSize:75];
    
    
    SDCycleScrollView *sdView3=[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 75) imageNamesGroup:imgArr1];
    sdView3.currentPageDotColor=[UIColor colorWithRed:222/255.0 green:81/255.0 blue:15/255.0 alpha:1];
    sdView3.pageDotColor=[UIColor whiteColor];
    sdView3.pageControlAliment=SDCycleScrollViewPageContolAlimentCenter;
    //间隔时间
    sdView3.autoScrollTimeInterval=2;
    sdView3.titleLabelBackgroundColor=[UIColor greenColor];
    [scrbgView1 addSubview:sdView3];
    
    
    UIImageView *midImgView8=[[UIImageView alloc]init];
    [bgView addSubview:midImgView8];
    [midImgView8 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [midImgView8 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [midImgView8 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:scrbgView1 withOffset:0];
    [midImgView8 autoSetDimension:ALDimensionHeight toSize:550];
    midImgView8.image=[UIImage imageNamed:@"middle_8"];
    
    UIImageView *midImgView9=[[UIImageView alloc]init];
    [bgView addSubview:midImgView9];
    [midImgView9 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [midImgView9 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [midImgView9 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:midImgView8 withOffset:0];
    [midImgView9 autoSetDimension:ALDimensionHeight toSize:425];
    midImgView9.image=[UIImage imageNamed:@"middle_9"];


    
    
}
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSString *path=[[NSBundle mainBundle] pathForResource:@"pros.plist" ofType:nil];
//    NSArray *marr=[NSArray arrayWithContentsOfFile:path];
    NSLog(@"8888888%ld",self.proArray.count/2);
    return self.proArray.count/2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 250;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeCell *cell=[[HomeCell alloc]init];//[_tableView dequeueReusableCellWithIdentifier:@"cell"];
    HomeModel *model=[[HomeModel alloc]init];
    NSString *s=[NSString stringWithFormat:@"%zd",indexPath.row];
   // model.img=self.proArray[indexPath.row][@"img"];
    model.title=s;//self.proArray[indexPath.row][@"title"];
    model.content=self.proArray[indexPath.row][@"content"];
    //[cell updateWithModel:model];
    NSDictionary *dic1=self.proArray[indexPath.row*2];
    NSDictionary *dic2=self.proArray[indexPath.row*2+1];
    NSMutableArray *linarr=[NSMutableArray array];
    [linarr addObject:dic1];
    [linarr addObject:dic2];
    [cell updateWithArray:linarr];
    return cell;
}

- (void)verticalImageAndTitle:(CGFloat)spacing
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
