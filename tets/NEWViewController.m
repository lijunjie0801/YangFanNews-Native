//
//  NEWViewController.m
//  tets
//
//  Created by lijunjie on 2016/12/13.
//  Copyright © 2016年 dev. All rights reserved.
//

#import "NEWViewController.h"
#import "BANetManager.h"
#import "NewsCell.h"
#import "HomeModel.h"
#import "NewsListModel.h"
#import "WebViewController.h"
#import "NewThreeImgCell.h"
#import "SDCycleScrollView.h"
#import "MJRefresh.h"
#import "ImageSeeViewController.h"
#import "RDVTabBarController.h"
#import "SongjiaoModel.h"
#define kURL_CYCLE    @"http://c.3g.163.com/nc/ad/headline/0-%d.html"
@interface NEWViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger _count;//当前加载开始位置

}

@property(nonatomic,strong)NSMutableArray *newsArray;
@property(nonatomic,strong)NSMutableArray *songjiaoArray;
@property(nonatomic,strong)SDCycleScrollView *sdcView;
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define kURL_FirstNEWSLIST @"http://c.3g.163.com/nc/article/headline/%@/%ld-20.html"
#define kURL_NEWSLIST @"http://c.m.163.com/nc/article/list/%@/%ld-20.html"


@end

@implementation NEWViewController
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
- (void)viewDidLoad {
    [super viewDidLoad];
     if ([self.newsType isEqualToString:@"T1348647853363"]) {
         [self getsongjiaoArrData];
     }
    [self getdata];
    [self.tableView reloadData];
    [self setable];
   
  
}
-(void)viewWillAppear:(BOOL)animated{
    [self.rdv_tabBarController setTabBarHidden:NO animated:NO];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setable{
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
   
  
    self.view = _tableView;
   }

-(void)getsongjiaoArrData{
    NSMutableArray *sjArr=[[NSMutableArray alloc]init];
    [BANetManager ba_requestWithType:BAHttpRequestTypeGet
                           urlString:[NSString stringWithFormat:kURL_CYCLE, 5]
                          parameters:nil
                        successBlock:^(id response) {
                            NSArray *array=[response objectForKey:@"headline_ad"];
                            
                            for (NSDictionary *dic in array) {

                                [sjArr addObject:dic];
                            }
                     //     [self setSdcView:sjArr];
                              // return sjArr;
                            NSLog(@"图片数组jiu1%@",sjArr);
                        }failureBlock:^(NSError *error) {
                            
                        } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                            
                        }];
    
 
}
-(void)setSdcView:(NSMutableArray *)songjiaoarr{
    self.songjiaoArray=[songjiaoarr copy];
    NSMutableArray *imgArr=[[NSMutableArray alloc]init];
    NSMutableArray *titleArr=[[NSMutableArray alloc]init];
    for (NSDictionary *dic in songjiaoarr) {
        NSString *imgstr=[dic objectForKey:@"imgsrc"];
        NSString *titilestr=[dic objectForKey:@"title"];
        NSData *imgdata=[NSData dataWithContentsOfURL:[NSURL URLWithString:imgstr]];
        UIImage *sjimg=[UIImage imageWithData:imgdata];
        [imgArr addObject:sjimg];
        [titleArr addObject:titilestr];
    }
    SDCycleScrollView *sdView=[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 150) imageNamesGroup:imgArr];
    sdView.delegate=self;
    sdView.currentPageDotColor=[UIColor colorWithRed:222/255.0 green:81/255.0 blue:15/255.0 alpha:1];
    sdView.pageDotColor=[UIColor whiteColor];
    sdView.pageControlAliment=SDCycleScrollViewPageContolAlimentRight;
    sdView.titlesGroup=titleArr;
    sdView.titleLabelBackgroundColor=[UIColor clearColor];
    //间隔时间
    sdView.autoScrollTimeInterval=2;
    _tableView.tableHeaderView=sdView;

}
-(void)getdata{
    NSString *urlString;
    if ([self.newsType isEqualToString:@"T1348647853363"]) {
        urlString = [NSString stringWithFormat:kURL_FirstNEWSLIST,self.newsType, (long)_count];
    }else{
        urlString = [NSString stringWithFormat:kURL_NEWSLIST,self.newsType, (long)_count];
    }
   
// 
//    [BANetManager ba_requestWithType:BAHttpRequestTypeGet
//                           urlString:urlString
//                          parameters:nil
//                        successBlock:^(id response) {
//                            if (!_count||_count==0) {
//                                [_newsArray removeAllObjects];
//                            }
//
//                            NSLog(@"get请求数据成功： *** %@", response);
//                            NSArray *array=[response objectForKey:self.newsType];
//                            
//                            NSMutableArray *mArr=[[NSMutableArray alloc]init];
//                            for (NSDictionary *dict in array) {
//                                NewsListModel *model = [[NewsListModel alloc]init];
//                                [model setValuesForKeysWithDictionary:dict];
//                                if (model.imgextra) {
//                                    model.flag = 1; //三张图片cell, //三张图片又是图片集
//                                }
//                                if (model.imgType == 1) {
//                                    model.flag = 2; //一张大图cell
//                                }
//                                //图片集
//                                if (model.skipID && [model.skipType isEqualToString:@"photoset"]) {
//                                    model.isPhotoset = YES;
//                                }
//                                [mArr addObject:model];
//                            }
//                    
//                            [self.newsArray addObjectsFromArray:mArr];
//                            [self.tableView reloadData];
//                          
//                        } failureBlock:^(NSError *error) {
//                            
//                        } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
//                            
//                        }];
    
  //  NSString * URLString = @"http://webservice.webxml.com.cn/WebServices/WeatherWS.asmx/getSupportCityDataset?theRegionCode=广东";
    NSURL * URL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest * request = [[NSURLRequest alloc]initWithURL:URL];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        NSLog(@"error: %@",[error localizedDescription]);
        
    }else{
        NSLog(@"response : %@",response);
        NSLog(@"backData : %@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        if (!_count||_count==0) {
            [_newsArray removeAllObjects];
        }
      NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"get请求数据成功： *** %@", response);
        NSArray *array=[dic objectForKey:self.newsType];
        
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
    }

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
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;{
    //NewsListModel *model=_newsArray[index];
    ImageSeeViewController *imgVC=[[ImageSeeViewController alloc]init];
    
    NSString *skipId=_songjiaoArray[index][@"url"];
    
        if ([skipId containsString:@"|"]) {
            NSArray *IDs = [skipId componentsSeparatedByString:@"|"];
            if (IDs) {
                imgVC.skipID =IDs[1];
                imgVC.skipTypeID = IDs[0];
            }
        
        // [self.navigationController pushViewController:imgVC animated:YES];
        [self presentViewController:imgVC animated:YES completion:^{
            
        }];
        }

}


@end
