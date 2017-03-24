//
//  OrderViewController.m
//  03-FZHTabbarController
//
//  Created by lijunjie on 2016/11/25.
//  Copyright © 2016年 FZH. All rights reserved.
//

#import "OrderViewController.h"
#import "HomeImageCell.h"
#import "WMPlayer.h"
#import "BANetManager.h"
#import "AFNetworking.h"
#import "ThumbleViewController.h"
#import "RDVTabBarController.h"
#define kScreenWidth   ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight  ([UIScreen mainScreen].bounds.size.height)




@interface OrderViewController ()<UITableViewDelegate,UITableViewDataSource>{
  
}

@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,strong)NSMutableArray *datasouce;
@end

@implementation OrderViewController

-(NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray=[[NSArray alloc]init];
    }
    return _dataArray;
}
-(NSMutableArray *)datasouce{
    if (!_datasouce) {
        _datasouce=[NSMutableArray array];
    }
    return _datasouce;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"图片";
    _dataArray=@[@"明星",@"动漫",@"宠物",@"美女",@"影视",@"壁纸",@"植物",@"汽车",@"设计",@"美食",@"体育",@"军事",@"旅游"];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(CellClick:) name:@"cellClick" object:nil];
      [self settab];
  }
-(void)CellClick:(NSNotification *)noti{
    NSString *type =[[noti userInfo] objectForKey:@"type"];
    NSLog(@"%@",type);
    ThumbleViewController *tvc=[[ThumbleViewController alloc]init];
    tvc.type=type;
    [self.navigationController pushViewController:tvc animated:NO];
}
-(void)settab{
    self.table=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];

 //   self.table.separatorStyle=UITableViewCellSeparatorStyleNone;

//    self.table.backgroundColor=[UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
   // [_table registerClass:[HomeImageCell class] forCellReuseIdentifier:@"cell"];
  
    
    _table.dataSource=self;
    _table.delegate=self;
    
    
  //  [self.view  addSubview:_table];;
    self.view=_table;

}

-(void)loadData:(NSString *)type{

        NSString *urlString=[NSString stringWithFormat:@"http://image.baidu.com/channel/listjson?pn=0&rn=1&tag1=%@&tag2=全部&ie=utf8",type];
        NSString *urlStr = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        [BANetManager ba_requestWithType:BAHttpRequestTypeGet
                           urlString:urlStr
                          parameters:nil
                        successBlock:^(id response) {
             
                        NSDictionary *dic= [response objectForKey:@"data"][0];
               
                        NSString *imageurl=[dic objectForKey:@"image_url"];
                            NSMutableArray *mArr=[NSMutableArray array];
                            [mArr addObject:imageurl];
                            NSLog(@"marr---%@",mArr);
                            [_datasouce addObjectsFromArray:mArr];
                            NSLog(@"_datasouce---%@",_datasouce);
                        }failureBlock:^(NSError *error) {
                            
                        } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                        
                        }
         
     ];
    

    
  //  }
  
 
   
    
}

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (kScreenWidth-40)/3*5+60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    HomeImageCell *cell = [[HomeImageCell alloc]init];//(HomeImageCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell updateCellWithArray:_dataArray];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)viewWillAppear:(BOOL)animated{
    [self.rdv_tabBarController setTabBarHidden:NO animated:NO];
}
@end
