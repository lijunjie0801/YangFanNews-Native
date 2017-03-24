//
//  ViewController.m
//  tets
//
//  Created by lijunjie on 2016/11/29.
//  Copyright © 2016年 dev. All rights reserved.
//

#import "ViewController.h"
#import "SDCycleScrollView.h"
#import "NEWViewController.h"
#import "AddLabelViewController.h"

static CGFloat const labelW = 75;
static CGFloat const radio = 1.3;
#define WLScreenW [UIScreen mainScreen].bounds.size.width
#define WLScreenH [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<UIScrollViewDelegate>{
    NSInteger currentpage;
}
@property (nonatomic, strong) UILabel *selLabel;

@property (nonatomic, strong) NSMutableArray *titleLabels;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *tapArray;
@property (nonatomic, strong)UIScrollView *titleScrollView;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@end

@implementation ViewController

-(NSMutableArray*)tapArray
{
    if (!_tapArray) {
        _tapArray=[NSMutableArray array];
    }
    return _tapArray;
}
- (NSMutableArray *)titleLabels
{
    if (_titleLabels == nil) {
        _titleLabels = [NSMutableArray array];
    }
    return _titleLabels;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray= [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray=[[NSUserDefaults standardUserDefaults] objectForKey:@"datasource"] ;
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIImageView *imgview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    imgview.image=[UIImage imageNamed:@"title"];
    self.navigationItem.titleView=imgview;
   
    [self setUpAllViewController];
    [self setUpScrollView];
    [self setUpTitleLabel];
    [self setAddView];
    
}
-(void)viewWillAppear:(BOOL)animated{

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(post:) name:@"indexpage" object:nil];
   // [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getnewdata:) name:@"shut" object:nil];

    NSMutableArray *newData= [[NSUserDefaults standardUserDefaults] objectForKey:@"datasource"] ;
    NSString *str1=[newData componentsJoinedByString:@","];
    NSString *str2=[_dataArray componentsJoinedByString:@","];

    if ([str1 isEqualToString:str2]) {
        NSLog(@"这俩货相等");
    }else{
         NSLog(@"这俩货不相等");
       
        
        _dataArray=[[NSUserDefaults standardUserDefaults] objectForKey:@"datasource"];
    
        for (NEWViewController *nc in self.childViewControllers) {
            [nc removeFromParentViewController];
        }
        [self.titleScrollView removeFromSuperview];
        [self.contentScrollView removeFromSuperview];
        
        [self setUpAllViewController];
        [self setUpScrollView];
        [self setUpTitleLabel];
        [self setAddView];
        
//        int i=0;
//        for (UILabel *label in self.titleScrollView.subviews) {
//            if (i==0) {
//                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleClick:)];
//                [label addGestureRecognizer:tap];
//                [self titleClick:tap];
//                
//            }
//            i++;
//        }

    }


    
}
-(void)post:(NSNotification *)noti{
    NSString *index =[[noti userInfo] objectForKey:@"index"];
    self.index=[index intValue];
    int i=0;
    for (UILabel *label in self.titleScrollView.subviews) {
        if (i==self.index) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleClick:)];
                [label addGestureRecognizer:tap];
               [self titleClick:tap];

        }
        i++;
    }

}
-(void)getnewdata:(NSNotification *)noti{
    NSMutableArray *newdataarray =[noti userInfo];
//    int i=0;
    NSMutableArray *newtypearray=[[NSMutableArray alloc]init];
//    for (NSMutableDictionary *dic in _dataArray) {
//        if ([[dic objectForKey:@"name"] isEqualToString:newdataarray[i]]) {
//             [newtypearray addObject:dic];
//        }
//       
//        i++;
//    }
    
    for (int i=0; i<_dataArray.count; i++) {
        for (int j=0; j<newdataarray.count; j++) {
            if ([newdataarray[j] isEqualToString:_dataArray[i][@"name"]]) {
                [newtypearray addObject:_dataArray[i]];
            }
        }
    }
    
    NSLog(@"%@",newtypearray);
}
-(void)setAddView{
    UIButton *addbtn=[[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-50, 0, 45, 40)];
    [self.view addSubview:addbtn];
    [addbtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    addbtn.imageEdgeInsets=UIEdgeInsetsMake(10, 15, 10, 10);
    [addbtn addTarget:self action:@selector(addclick) forControlEvents:UIControlEventTouchUpInside];
    [addbtn setBackgroundColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:244/255.0 alpha:0.8]];
}
- (void)addclick{
    AddLabelViewController *addVC=[[AddLabelViewController alloc]init];
    addVC.currentpage=currentpage;
    [self presentViewController:addVC animated:YES completion:^{
        
    }];
    

}
- (void)setUpScrollView
{
    NSUInteger count = self.childViewControllers.count;
    self.titleScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WLScreenW, 40)];
    _titleScrollView.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:244/255.0 alpha:1.0];
    [self.view addSubview:_titleScrollView];
    self.titleScrollView.contentSize = CGSizeMake(count * labelW, 0);
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    
    // 设置内容滚动条
     self.contentScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, WLScreenW, WLScreenH-64-40)];
    [self.view addSubview:_contentScrollView];
    self.contentScrollView.contentSize = CGSizeMake(count * WLScreenW, 0);
    // 开启分页
    self.contentScrollView.pagingEnabled = YES;
    // 没有弹簧效果
    self.contentScrollView.bounces = NO;
    // 隐藏水平滚动条
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    
    self.contentScrollView.delegate = self;
}


-(void)setUpTitleLabel
{
    NSUInteger count = self.childViewControllers.count;
    NSLog(@"%zd",count);
    CGFloat labelX = 0;
    CGFloat labelY = 0;
    CGFloat labelH = 40;
    
    [self.tapArray removeAllObjects];
    [self.titleLabels removeAllObjects];
    for (int i = 0; i < count; i++) {
        // 获取对应子控制器
        UIViewController *vc = self.childViewControllers[i];
        // 创建label
        UILabel *label = [[UILabel alloc] init];
        labelX = i * labelW;
        // 设置尺寸
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        // 设置label文字
        label.text = vc.title;
        NSLog(@"%@",vc.title);
        // 设置高亮文字颜色
        label.highlightedTextColor = [UIColor redColor];
        // 设置label的tag
        label.tag = i;
        // 设置用户的交互
        label.userInteractionEnabled = YES;
        // 文字居中
        label.textAlignment = NSTextAlignmentCenter;
        // 添加到titleLabels数组
        [self.titleLabels addObject:label];
        // 添加点按手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleClick:)];
        [label addGestureRecognizer:tap];
        // 默认选中第0个label
        if (i == self.index) {
            [self titleClick:tap];
        }
        [self.tapArray addObject:tap];
      //  self.titleScrollView.contentOffset = CGPointMake(labelW*2, 0);
        // 添加label到标题滚动条上
        [self.titleScrollView addSubview:label];
    }
}
// 点击标题的时候就会调用
- (void)titleClick:(UITapGestureRecognizer *)tap
{
    UILabel *label = (UILabel *)tap.view;
    
    [self selectView:label];
    
    
    NSInteger index = tap.view.tag;
    
    
    CGFloat offsetX = index * WLScreenW;
    self.contentScrollView.contentOffset = CGPointMake(offsetX, 0);
    
    [self showVc:index];
    
    [self setupTitleCenter:label];
}

-(void)setupTitleCenter:(UILabel *)label
{
    CGFloat offsetX = label.center.x - WLScreenW * 0.5;
    if (offsetX<0) {
        offsetX = 0;
    }
    CGFloat maxOffsetX = self.titleScrollView.contentSize.width - WLScreenW;
    if (offsetX>maxOffsetX) {
        offsetX = maxOffsetX;
    }
    
    [self.titleScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}
-(void)showVc:(NSInteger)index
{
    CGFloat offsetX = index*WLScreenW;
    
    UIViewController *vc = self.childViewControllers[index];
    
    
    if (vc.isViewLoaded) {
        return;
    }
    
    vc.view.frame = CGRectMake(offsetX, 0, self.contentScrollView.bounds.size.width, self.contentScrollView.bounds.size.height);
    [self.contentScrollView addSubview:vc.view];
}


-(void)selectView:(UILabel *)label
{
    _selLabel.highlighted = NO;
    
    // 取消形变
    _selLabel.transform = CGAffineTransformIdentity;
    label.highlighted = YES;
    
    // 高大
    label.transform = CGAffineTransformMakeScale(radio, radio);
    // 颜色恢复
    _selLabel.textColor = [UIColor blackColor];
    _selLabel = label;
}


- (void)setUpAllViewController
{
  
   NSMutableArray *marr=[NSMutableArray array];
    [marr addObjectsFromArray:_dataArray];
    
    for (int i=0; i<_dataArray.count; i++) {
        NEWViewController *wordVc= [[NEWViewController alloc] init];
        wordVc.title =[_dataArray[i] objectForKey:@"name"];
        wordVc.newsType=[_dataArray[i] objectForKey:@"type"];
        [self addChildViewController:wordVc];
        
    }
    
}
-(void)updateViewController{
   
    for (int i=0; i<_dataArray.count; i++) {
        NEWViewController *wordVc= [[NEWViewController alloc] init];
        wordVc.title =[_dataArray[i] objectForKey:@"name"];
        wordVc.newsType=[_dataArray[i] objectForKey:@"type"];
        [self addChildViewController:wordVc];
    }

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat curPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
    currentpage=curPage;
    // 左边label角标
    NSInteger leftIndex = curPage;
    // 右边的label角标
    NSInteger rightIndex = leftIndex + 1;
    
    
    // 获取左边的label
    UILabel *leftLabel = self.titleLabels[leftIndex];
    
    // 获取右边的label
    UILabel *rightLabel;
    if (rightIndex < self.titleLabels.count-1) {
        rightLabel = self.titleLabels[rightIndex];
    }
    
    CGFloat rightScale = curPage - leftIndex;
    CGFloat leftScale = 1- rightScale;
    
    // 左边缩放
    leftLabel.transform = CGAffineTransformMakeScale(leftScale * 0.3 + 1, leftScale * 0.3+ 1);
    
    // 右边缩放
    rightLabel.transform = CGAffineTransformMakeScale(rightScale * 0.3 + 1, rightScale * 0.3+ 1);
    
    
    // 设置文字颜色渐变
    /*
     R G B
     黑色 0 0 0
     红色 1 0 0
     */
    leftLabel.textColor = [UIColor colorWithRed:leftScale green:0 blue:0 alpha:1];
    rightLabel.textColor = [UIColor colorWithRed:rightScale green:0 blue:0 alpha:1];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    currentpage=index;
    [self showVc:index];
    
    UILabel *selLabel = self.titleLabels[index];
    
    [self selectView:selLabel];
    
    [self setupTitleCenter:selLabel];
    
}
@end
