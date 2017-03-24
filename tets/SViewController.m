//
//  ViewController.m
//  JXChannelSegment
//
//  Created by JackXu on 16/9/16.
//  Copyright © 2016年 BFMobile. All rights reserved.
//

#import "SViewController.h"
#import "JXSegment.h"
#import "JXPageView.h"
#import "NEWViewController.h"
#import "SDCycleScrollView.h"
#import "MJRefresh.h"
#import "NewsCell.h"
#import "NewThreeImgCell.h"
#import "ImageSeeViewController.h"
#import "WebViewController.h"
#import "BANetManager.h"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@interface SViewController ()<JXSegmentDelegate,JXPageViewDataSource,JXPageViewDelegate,SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    JXPageView *pageView;
    JXSegment *segment;
    NSInteger _count;
}
@property (nonatomic,strong)NSMutableArray *toplabelArray;
@property (nonatomic,strong)NSMutableArray *typeArray;
@property(nonatomic,strong)NSMutableArray *newsArray;
@property(nonatomic,strong)NSMutableArray *songjiaoArray;
@property(nonatomic,strong)SDCycleScrollView *sdcView;
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define kURL_FirstNEWSLIST @"http://c.3g.163.com/nc/article/headline/%@/%ld-20.html"
#define kURL_NEWSLIST @"http://c.m.163.com/nc/article/list/%@/%ld-20.html"
@end

@implementation SViewController
-(NSMutableArray *)newsArray{
    if (!_newsArray) {
        _newsArray=[NSMutableArray array];
    }
    return _newsArray;
}
-(NSMutableArray *)songjiaoArray{
    if (!_songjiaoArray) {
        _songjiaoArray=[NSMutableArray array];
    }
    return _songjiaoArray;
    
}
-(NSMutableArray *)typeArray{
    if (!_typeArray) {
        _typeArray=[NSMutableArray array];
    }
    return _typeArray;

}
-(NSMutableArray *)toplabelArray{
    if (!_toplabelArray) {
        _toplabelArray=[NSMutableArray array];
    }
    return _toplabelArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    segment = [[JXSegment alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    
    NSMutableArray *titlearray=[[NSUserDefaults standardUserDefaults] objectForKey:@"datasource"] ;
    NSMutableArray *titlearr=[[NSMutableArray alloc]init];
    NSMutableArray *typearr=[[NSMutableArray alloc]init];
    for (int i=0; i<titlearray.count; i++) {
        [titlearr addObject: [titlearray[i] objectForKey:@"name"]];
        [typearr addObject: [titlearray[i] objectForKey:@"type"]];
    }
    _typeArray=[typearr copy];
    _toplabelArray=[titlearr copy];
    NSLog(@"titlearr%@",titlearr);
    [segment updateChannels:titlearr];
    segment.delegate = self;
    [self.view addSubview:segment];
    
    pageView =[[JXPageView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, self.view.bounds.size.height - 100)];
    pageView.datasource = self;
    pageView.delegate = self;
    [segment didChengeToIndex:0];
    [pageView changeToItemAtIndex:0];
   // [pageView reloadData];
  
   
    [self.view addSubview:pageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - JXPageViewDataSource
-(NSInteger)numberOfItemInJXPageView:(JXPageView *)pageView{
    return _toplabelArray.count;
}

-(UIView*)pageView:(JXPageView *)pageView viewAtIndex:(NSInteger)index{
   // [_newsArray removeAllObjects];
    UIView *view = [[UIView alloc] init];
    self.newsType=_typeArray[index];
    [self getdata];
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"defualt"]];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
        //
    self.tableView.backgroundColor=[UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    [_tableView registerClass:[NewsCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[NewThreeImgCell class] forCellReuseIdentifier:@"images"];
        
    _tableView.dataSource=self;
    _tableView.delegate=self;
      
    
      [view addSubview:_tableView];
    
   //  [pageView reloadData];
    return view;
    ;
}

#pragma mark - JXSegmentDelegate
- (void)JXSegment:(JXSegment*)segment didSelectIndex:(NSInteger)index{
    [pageView changeToItemAtIndex:index];
}

#pragma mark - JXPageViewDelegate
- (void)didScrollToIndex:(NSInteger)index{
    [segment didChengeToIndex:index];
}

//-(UITableView *)tableView{
//    if (!_tableView) {
////        self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
// self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
//        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"defualt"]];
//        self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
//        [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
//        [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
//        //
//        self.tableView.backgroundColor=[UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
//        [_tableView registerClass:[NewsCell class] forCellReuseIdentifier:@"cell"];
//        [self.tableView registerClass:[NewThreeImgCell class] forCellReuseIdentifier:@"images"];
//        
//        _tableView.dataSource=self;
//        _tableView.delegate=self;
//
//    }
//    return _tableView;
//}
-(void)getdata{
    NSString *urlString;
    if ([self.newsType isEqualToString:@"T1348647853363"]) {
        urlString = [NSString stringWithFormat:kURL_FirstNEWSLIST,self.newsType, (long)_count];
    }else{
        urlString = [NSString stringWithFormat:kURL_NEWSLIST,self.newsType, (long)_count];
    }
    
    
    [BANetManager ba_requestWithType:BAHttpRequestTypeGet
                           urlString:urlString
                          parameters:nil
                        successBlock:^(id response) {
                            if (!_count||_count==0) {
                                [_newsArray removeAllObjects];
                            }
                            
                            NSLog(@"get请求数据成功： *** %@", response);
                            NSArray *array=[response objectForKey:self.newsType];
                            NSLog(@"get的array： *** %@", array);
                            NSLog(@"get的arraycount： *** %ld", array.count);
                            NSMutableArray *mArr=[[NSMutableArray alloc]init];
                            for (NSDictionary *dict in array) {
                                NewsListModel *model = [[NewsListModel alloc]init];
                                [model setValuesForKeysWithDictionary:dict];
                                if (model.imgextra) {
                                    model.flag = 1; //三张图片cell, //三张图片又是图片集
                                }
                                if (model.imgType == 1) {
                                    model.flag = 2; //一张大图cell
                                }
                                //图片集
                                if (model.skipID && [model.skipType isEqualToString:@"photoset"]) {
                                    model.isPhotoset = YES;
                                }
                                [mArr addObject:model];
                            }
                            
                            [self.newsArray addObjectsFromArray:mArr];
                            [self.tableView reloadData];
                            
                        } failureBlock:^(NSError *error) {
                            
                        } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                            
                        }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _newsArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"%zd",_newsArray.count);
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsListModel *model=_newsArray[indexPath.row];
    return model.cellHeight;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewsListModel *model=_newsArray[indexPath.row];
    
    if (model.flag == 1) {
        NewThreeImgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"images" forIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell updateWithModel:model];
        return cell;
    } else if(model.flag == 2) {
        NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell updateWithModel:model];
        return cell;
    }
    else{
        NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        [cell updateWithModel:model];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsListModel *model=_newsArray[indexPath.row];
    ImageSeeViewController *imgVC=[[ImageSeeViewController alloc]init];
    if (model.isPhotoset) {
        if ([model.skipID containsString:@"|"]) {
            NSArray *IDs = [model.skipID componentsSeparatedByString:@"|"];
            if (IDs) {
                //   model.skipID = IDs[1];
                imgVC.skipID = IDs[1];
                imgVC.skipTypeID = IDs[0];
            }
        }
        //   imgVC.skipID = model.skipID;
        //  [self.navigationController pushViewController:imgVC animated:YES];
        [self presentViewController:imgVC animated:YES completion:^{
            
        }];
        
    }else{
        WebViewController *wbVC=[[WebViewController alloc]init];
        wbVC.url_3w=model.url_3w;
        wbVC.docid=model.docid;
        wbVC.newsTitle = model.title;
        wbVC.flag = model.boardid;
        [self setHidesBottomBarWhenPushed:YES];//隐藏tabbar
        [self setHidesBottomBarWhenPushed:NO];
        [self.navigationController pushViewController:wbVC animated:NO];
    }
}
- (void)footerRereshing {
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        _count += 20;
        [self getdata];
        [self.tableView footerEndRefreshing];
    }];
    
}
- (void)headerRereshing{
    //[self.tableView addLegendHeaderWithRefreshingBlock:^{
    _count = 0;
    [self getdata];
    [self.tableView headerEndRefreshing];
    //  [self.tableView headerBeginRefreshing];
}
//- (UIColor *) randomColor
//{
//    CGFloat hue = ( arc4random() % 256 / 256.0 );
//    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
//    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
//    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
//}

@end
