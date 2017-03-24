//
//  SecondViewController.m
//  tets
//
//  Created by lijunjie on 2016/12/30.
//  Copyright © 2016年 dev. All rights reserved.
//

#import "SecondViewController.h"
#import "FindViewController.h"
#define WLScreenW [UIScreen mainScreen].bounds.size.width
#define WLScreenH [UIScreen mainScreen].bounds.size.height
@interface SecondViewController ()
@property (nonatomic, strong)UIScrollView *titleScrollView;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UILabel *selLabel;

@property (nonatomic, strong) NSMutableArray *titleLabels;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *tapArray;
@end
static CGFloat const labelW = 75;
static CGFloat const radio = 1.3;
@implementation SecondViewController
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
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpAllViewController];
    [self setUpScrollView];
    [self setUpTitleLabel];
   // [self setAddView];
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
    for (int i = 0; i < count; i++) {
        UIViewController *vc = self.childViewControllers[i];
     
        UILabel *label = [[UILabel alloc] init];
        labelX = i * WLScreenW/4;
        label.frame = CGRectMake(labelX, labelY, WLScreenW/4, labelH);
        label.text = vc.title;
        NSLog(@"%@",vc.title);
        label.highlightedTextColor = [UIColor redColor];
        label.tag = i;
        label.userInteractionEnabled = YES;
        label.textAlignment = NSTextAlignmentCenter;
        [self.titleLabels addObject:label];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleClick:)];
        [label addGestureRecognizer:tap];
        // 默认选中第0个label
        if (i == 0) {
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
    
   // [self setupTitleCenter:label];
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
    
//    NSMutableArray *marr=[NSMutableArray array];
//    [marr addObjectsFromArray:_dataArray];
//
    NSArray *typearray=@[@"VAP4BFE3U",@"VAP4BFR16",@"VAP4BG6DL",@"VAP4BGTVD"];
    NSArray *titlearray=@[@"奇葩",@"萌物",@"美女",@"精品"];
    for (int i=0; i<typearray.count; i++) {
        FindViewController *wordVc= [[FindViewController alloc] init];
        wordVc.title =titlearray[i];
        wordVc.videoType=typearray[i];
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
  //  currentpage=curPage;
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
    
   // currentpage=index;
    [self showVc:index];
    
    UILabel *selLabel = self.titleLabels[index];
    
    [self selectView:selLabel];
    
//    [self setupTitleCenter:selLabel];
    
}
@end
