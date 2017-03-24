//
//  ThumbleViewController.m
//  tets
//
//  Created by lijunjie on 2017/1/4.
//  Copyright © 2017年 dev. All rights reserved.
//

#import "ThumbleViewController.h"
#import "AFNetworking.h"
#import "CellModel.h"
#import "WSCollectionCell.h"
#import "WSLayout.h"
#import "BANetManager.h"
#import "MJRefresh.h"
#import "RDVTabBarController.h"
#import "ImageDetailViewController.h"
#import "PhotoViewController.h"
#import "UIImageView+WebCache.h"
#import "FrameModel.h"
@interface ThumbleViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>{
    NSInteger _count;
    UIView           *_coverView;
    NSMutableArray   *_frameArray;
}

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) WSLayout *wslayout;
@property (strong, nonatomic)NSMutableArray *modelarray;

@end

@implementation ThumbleViewController {
    
    NSMutableArray *modelArray;
    
}
-(NSMutableArray *)modelarray{
    if (!_modelarray) {
        _modelarray=[NSMutableArray array];
    }
    return _modelarray;
}
-(void)viewWillAppear:(BOOL)animated{
     [self.rdv_tabBarController setTabBarHidden:YES animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.type;
    self.view.backgroundColor = [UIColor whiteColor];
    
     [self.rdv_tabBarController setTabBarHidden:YES animated:NO];
    UIButton *backbtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [backbtn addTarget:self action:@selector(backclick) forControlEvents:UIControlEventTouchUpInside];
    [backbtn setImage:[UIImage imageNamed:@"comeback"] forState:UIControlStateNormal];
    UIBarButtonItem *btnitem=[[UIBarButtonItem alloc]initWithCustomView:backbtn];
    self.navigationItem.leftBarButtonItem=btnitem;

    [self loadData];
    [self _creatSubView];
}
-(void)backclick{
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)loadData{
    NSString *urlString=[NSString stringWithFormat:@"http://image.baidu.com/channel/listjson?pn=%ld&rn=20&tag1=%@&tag2=全部&ie=utf8",(long)_count,self.type];
    NSString *urlStr = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [BANetManager ba_requestWithType:BAHttpRequestTypeGet
                           urlString:urlStr
                          parameters:nil
                        successBlock:^(id response) {
                            
                            NSMutableArray *array = [response[@"data"] mutableCopy];
                            [array removeLastObject];
                            
                            modelArray = [NSMutableArray array];
                            if (!_count||_count==0) {
                                [self.modelarray removeAllObjects];
                            }
                            NSMutableArray *marray=[NSMutableArray array];
                            for (NSDictionary *dic in array) {
                                
                                CellModel *model = [[CellModel alloc]init];
                                model.imgURL = dic[@"image_url"];
                                model.imgWidth = [dic[@"image_width"] floatValue];
                                model.imgHeight = [dic[@"image_height"] floatValue];
                                model.title = dic[@"abs"];
                                
                                [marray addObject:model];
                                
                            }
                            NSArray *array1=[marray mutableCopy];
                           // _modelarray=
//                            [modelArray addObjectsFromArray:marray];
                           [self.modelarray addObjectsFromArray:array1];
                            NSLog(@"modelarray1,%ld",marray.count);
                            NSLog(@"modelarray,%ld",self.modelarray.count);
                            [self.collectionView reloadData];
                            
                        }failureBlock:^(NSError *error) {
                            
                        } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                            
                        }
     
     ];

}
- (void)footerRereshing {
    [self.collectionView addLegendFooterWithRefreshingBlock:^{
        _count += 20;
        [self loadData];
        [self.collectionView footerEndRefreshing];
    }];
    
}
- (void)headerRereshing{
    //[self.tableView addLegendHeaderWithRefreshingBlock:^{
    _count = 0;
    [self loadData];
    [self.collectionView headerEndRefreshing];
    //  [self.tableView headerBeginRefreshing];
}
- (void)_creatSubView {
    
    self.wslayout = [[WSLayout alloc] init];
    self.wslayout.lineNumber = 2; //列数
    self.wslayout.rowSpacing = 5; //行间距
    self.wslayout.lineSpacing = 5; //列间距
    self.wslayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    // 透明时用这个属性(保证collectionView 不会被遮挡, 也不会向下移)
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    // 不透明时用这个属性
    //self.extendedLayoutIncludesOpaqueBars = YES;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:self.wslayout];
    [self.collectionView addFooterWithTarget:self action:@selector(footerRereshing)];
    [self.collectionView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.collectionView registerClass:[WSCollectionCell class] forCellWithReuseIdentifier:@"collectionCell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    
    //返回每个cell的高   对应indexPath
    [self.wslayout computeIndexCellHeightWithWidthBlock:^CGFloat(NSIndexPath *indexPath, CGFloat width) {
        
        CellModel *model = self.modelarray[indexPath.row];
        CGFloat oldWidth = model.imgWidth;
        CGFloat oldHeight = model.imgHeight;
        
        CGFloat newWidth = width;
        CGFloat newHeigth = oldHeight*newWidth / oldWidth;
        return newHeigth;
    }];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.modelarray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WSCollectionCell *cell = (WSCollectionCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    
    cell.model = self.modelarray[indexPath.row];
    FrameModel *frame = [FrameModel getFrameWithView:cell];
    
    [_frameArray addObject:frame];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"选中了第%ld个item",indexPath.row);
//    ImageDetailViewController *ivc=[[ImageDetailViewController alloc]init];
//    ivc.index=indexPath.row;
//    ivc.imageArray=self.modelarray;
//    [self presentViewController:ivc animated:YES completion:^{
//        
//    }];
    WSCollectionCell *cell = (WSCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    CGRect rect = cell.frame;
    
    if (_coverView == nil) {
        _coverView = [[UIView alloc] initWithFrame:cell.bounds];
        _coverView.backgroundColor = [UIColor whiteColor];
    }
    [cell addSubview:_coverView];
    
    NSMutableArray *marr=[NSMutableArray array];
    for (int i=0; i<self.modelarray.count; i++) {
        CellModel *model=(CellModel *)self.modelarray[i];
        [marr addObject:model.imgURL];
    }
    NSArray *array=[marr mutableCopy];
    PhotoViewController *photoVC = [[PhotoViewController alloc] init];
    photoVC.urlArray = array;
    photoVC.modelArray=self.modelarray;
    photoVC.imgFrame = rect;
    photoVC.index = indexPath.row;
    photoVC.frameArray = [_frameArray copy];
    photoVC.imgData = [self getImageDataWithUrl:[array objectAtIndex:indexPath.row]];
    [self presentViewController:photoVC animated:NO completion:nil];
    
    photoVC.indexBlock = ^(NSInteger index){
        
        NSIndexPath *indexP = [NSIndexPath indexPathForItem:index inSection:0];
        WSCollectionCell *cel = (WSCollectionCell *)[collectionView cellForItemAtIndexPath:indexP];
        [cel addSubview:_coverView];
    };
    
    [photoVC setCompletedBlock:^(void){
        [_coverView removeFromSuperview];
        _coverView = nil;
    }];


}
- (NSData *)getImageDataWithUrl:(NSString *)url
{
    NSData *imageData = nil;
    BOOL isExit = [[SDWebImageManager sharedManager] diskImageExistsForURL:[NSURL URLWithString:url]];
    if (isExit) {
        NSString *cacheImageKey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:url]];
        if (cacheImageKey.length) {
            NSString *cacheImagePath = [[SDImageCache sharedImageCache] defaultCachePathForKey:cacheImageKey];
            if (cacheImagePath.length) {
                imageData = [NSData dataWithContentsOfFile:cacheImagePath];
            }
        }
    }
    if (!imageData) {
        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    }
    
    return imageData;
}


@end
