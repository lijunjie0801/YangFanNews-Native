//
//  AddLabelViewController.m
//  tets
//
//  Created by lijunjie on 2016/12/20.
//  Copyright © 2016年 dev. All rights reserved.
//

#import "AddLabelViewController.h"
#import "MineCollectionViewCell.h"
#define DEVICE_WIDTH   ([UIScreen mainScreen].bounds.size.width)
#define DEVICE_HEIGHT  ([UIScreen mainScreen].bounds.size.height)
#import "NEWViewController.h"
#import "ViewController.h"
static NSString *collectionCell = @"mineCell";
static NSString *secondcollectionCell = @"sencondeCell";
@interface AddLabelViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *mineCollection;
@property (nonatomic, strong) UICollectionView *secondCollection;
@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, strong) NSMutableArray *secondArray;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *cellAttributesArray;
@property (nonatomic, assign) CGPoint lastPressPoint;
@property (nonatomic, strong)UILabel *hidelabel;
@property (nonatomic, strong)UILabel *recommentlabel;
@property (nonatomic, strong)UIButton *editbtn;
@property (nonatomic, assign)BOOL isHidden;
@end

@implementation AddLabelViewController
- (NSMutableArray *)imagesArray{
    if (!_imagesArray) {
        self.imagesArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _imagesArray;
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}
-(NSMutableArray *)secondArray{
    if (!_secondArray) {
        _secondArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _secondArray;
}
- (NSMutableArray *)cellAttributesArray{
    if (!_cellAttributesArray) {
        self.cellAttributesArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _cellAttributesArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];

     self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:244/255.0 alpha:1.0];
    [self setshutBtn];
    _isHidden=YES;
    [self getdata];
    [self setTopCollectionView];
    [self setBottomCollectionView];
   

}
-(void)getdata{
    NSMutableArray *array=[[NSUserDefaults standardUserDefaults] objectForKey:@"datasource"];
    NSMutableArray *array1=[[NSUserDefaults standardUserDefaults] objectForKey:@"seconddatasource"];
    _dataArray=array;
    for (int i = 0; i < array.count; i++) {
        [self.imagesArray addObject:array[i][@"name"]];
    }
    for (int i = 0; i < array1.count; i++) {
        [self.secondArray addObject:array1[i][@"name"]];
    }
//    NSLog(@"self.imagesArray-------count=%@,%ld",self.imagesArray,self.imagesArray.count);
//    NSLog(@"self.secondArray-------count=%@,%ld",self.secondArray,self.secondArray.count);
}
-(void)setTopCollectionView{
      _lastPressPoint = CGPointZero;
     self.automaticallyAdjustsScrollViewInsets = NO;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 5.0;
    layout.minimumInteritemSpacing = 5.0;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    CGFloat f=self.imagesArray.count/4+1;
    _mineCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 105, DEVICE_WIDTH, ceil(f)*50) collectionViewLayout:layout];
  //  _mineCollection.collectionViewLayout=layout;
    _mineCollection.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:244/255.0 alpha:1.0];
    _mineCollection.dataSource = self;
    _mineCollection.delegate = self;
    [_mineCollection registerClass:[MineCollectionViewCell class] forCellWithReuseIdentifier:collectionCell];
    [self.view addSubview:_mineCollection];

}
-(void)setBottomCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 5.0;
    layout.minimumInteritemSpacing = 5.0;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    CGFloat f=self.imagesArray.count/4+1;
    CGFloat tf=self.secondArray.count/4+1;
    _secondCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, ceil(f)*50+150, DEVICE_WIDTH, ceil(tf)*50) collectionViewLayout:layout];
   // _secondCollection.collectionViewLayout=layout;
    _secondCollection.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:244/255.0 alpha:1.0];
    _secondCollection.dataSource = self;
    _secondCollection.delegate = self;
    [_secondCollection registerClass:[MineCollectionViewCell class] forCellWithReuseIdentifier:collectionCell];
    [self.view addSubview:_secondCollection];

}
-(void)setshutBtn{
    UIButton *backbtn=[[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-30, 40, 15, 15)];
    [backbtn setImage:[UIImage imageNamed:@"shut"] forState:UIControlStateNormal];
    [self.view addSubview:backbtn];
    [backbtn addTarget:self action:@selector(shut) forControlEvents:UIControlEventTouchUpInside];

    UILabel *mychanel=[[UILabel alloc]initWithFrame:CGRectMake(10, 75, 80, 20)];
    mychanel.text=@"我的频道";
    mychanel.font=[UIFont systemFontOfSize:16];
    mychanel.textColor=[UIColor blackColor];
    [self.view addSubview:mychanel];

    UILabel *hidelabel=[[UILabel alloc]initWithFrame:CGRectMake(90, 75, 140, 20)];
    hidelabel.text=@"拖拽可以排序";
    hidelabel.font=[UIFont systemFontOfSize:12];
    hidelabel.textColor=[UIColor lightGrayColor];
    self.hidelabel=hidelabel;
    hidelabel.hidden=YES;
    [self.view addSubview:hidelabel];

    UIButton *editbtn=[[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-70, 75, 40, 20)];
    self.editbtn=editbtn;
    [editbtn setTitle:@"编辑" forState:UIControlStateNormal];
    editbtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [editbtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    editbtn.layer.cornerRadius=0.5;
    [editbtn.layer setMasksToBounds:YES];
    [editbtn.layer setCornerRadius:7]; //设置矩形四个圆角半径
    [editbtn.layer setBorderWidth:1.0]; //
    editbtn.layer.borderColor=[UIColor redColor].CGColor;
    [self.view addSubview:editbtn];
    [editbtn addTarget:self action:@selector(editcilick) forControlEvents:UIControlEventTouchUpInside];
    
    _recommentlabel=[[UILabel alloc]init];
    _recommentlabel.text=@"推荐频道";
    _recommentlabel.font=[UIFont systemFontOfSize:16];
    [self.view addSubview:_recommentlabel];

}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView==_mineCollection) {
        if (_isHidden==NO) {
            if (indexPath.row==0) {
                
            }else{
            [self.secondArray addObject:_imagesArray[indexPath.row]];
            [self.imagesArray removeObjectAtIndex:indexPath.row];
            NSMutableArray *array=[[[NSUserDefaults standardUserDefaults] objectForKey:@"datasource"] mutableCopy];
             NSMutableArray *array1=[[[NSUserDefaults standardUserDefaults] objectForKey:@"seconddatasource"] mutableCopy];
            [array1 addObject:array[indexPath.row]];
            [array removeObjectAtIndex:indexPath.row];
            [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"datasource"];
            [[NSUserDefaults standardUserDefaults] setObject:array1 forKey:@"seconddatasource"];
           
          
            [self.mineCollection reloadData];
                [self.secondCollection reloadData];}
        }else{
            NSDictionary *dic=@{
                                @"index":[NSString stringWithFormat:@"%ld",(long)indexPath.row],
                                };
            [[NSNotificationCenter defaultCenter] postNotificationName:@"indexpage" object:nil userInfo:dic];
            [self dismissViewControllerAnimated:NO completion:^{
                
            }];
        }
    }else{
        [self.imagesArray addObject:self.secondArray[indexPath.row]];
        [self.secondArray removeObjectAtIndex:indexPath.row];
      
        NSLog(@"self.imagesArray-------count=%@,%ld",self.imagesArray,self.imagesArray.count);
        NSLog(@"self.secondArray-------count=%@,%ld",self.secondArray,self.secondArray.count);
        NSMutableArray *array1=[[[NSUserDefaults standardUserDefaults] objectForKey:@"datasource"] mutableCopy];
        NSMutableArray *array=[[[NSUserDefaults standardUserDefaults] objectForKey:@"seconddatasource"] mutableCopy];
        [array1 addObject:array[indexPath.row]];
        [array removeObjectAtIndex:indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:array1 forKey:@"datasource"];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"seconddatasource"];
      
        
      
        [self.mineCollection reloadData];
        [self.secondCollection reloadData];

    }
   
  //  return;
}
-(void)editcilick{
    if (self.hidelabel.isHidden==YES) {
        self.hidelabel.hidden=NO;
          [self.editbtn setTitle:@"完成" forState:UIControlStateNormal];
        _isHidden=NO;
        [self.mineCollection reloadData];
     
    }else{
        self.hidelabel.hidden=YES;
        [self.editbtn setTitle:@"编辑" forState:UIControlStateNormal];
         _isHidden=YES;
        [self.mineCollection reloadData];
     //   NSLog(@"$$$$$$$$$$%ld",self.currentpage);
    }
}

-(void)shut{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"shut" object:nil userInfo:self.imagesArray];
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@" self.imagesArray.count=%ld",self.imagesArray.count);
    NSLog(@" self.sencondArray.count=%ld",self.secondArray.count);
    if (collectionView==_mineCollection) {
        return self.imagesArray.count;
    }else {
        return self.secondArray.count;
    }
    //self.imagesArray.count;
   
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width - 50) / 4.0, 40);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  
    MineCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCell forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    if (collectionView==_mineCollection) {
        if (indexPath.row==0) {
            cell.cellImage.hidden=YES;
        }
        CGFloat f=self.imagesArray.count/(float)4;
        collectionView.frame=CGRectMake(0, 105, DEVICE_WIDTH, ceil(f)*50);
        if(_isHidden==NO){
            if (indexPath.row!=0) {
                 cell.cellImage.hidden=NO;
            }
        }else{
            cell.cellImage.hidden=YES;
        }
        NSLog(@"$$$$$$$$$$%ld",self.currentpage);
        if (indexPath.row==self.currentpage) {
            cell.label.textColor=[UIColor redColor];
        }else{
            cell.label.textColor=[UIColor blackColor];
        }
        cell.label.text=self.imagesArray[indexPath.row];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesture:)];
        if (indexPath.row==0) {
            
        }else{
            [cell addGestureRecognizer:longPress];
        }
     

    }else{
        
        CGFloat f=self.imagesArray.count/(float)4;
        CGFloat tf=self.secondArray.count/(float)4;
        _recommentlabel.frame=CGRectMake(10, ceil(f)*50+140, DEVICE_WIDTH, 20);
       collectionView.frame=CGRectMake(0, ceil(f)*50+170, DEVICE_WIDTH, ceil(tf)*50);
       
          cell.label.text=self.secondArray[indexPath.row];
    }
    
       return cell;
}

- (void)longPressGesture:(UILongPressGestureRecognizer *)sender{
 
    MineCollectionViewCell *cell = (MineCollectionViewCell *)sender.view;
    NSIndexPath *cellIndexPath = [_mineCollection indexPathForCell:cell];
    [_mineCollection bringSubviewToFront:cell];
    BOOL isChanged = NO;
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self.cellAttributesArray removeAllObjects];
        for (int i = 0;i< self.imagesArray.count; i++) {
            [self.cellAttributesArray addObject:[_mineCollection layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]]];
        }
        self.lastPressPoint = [sender locationInView:_mineCollection];
    }else if (sender.state == UIGestureRecognizerStateChanged){
        cell.center = [sender locationInView:_mineCollection];
        for (UICollectionViewLayoutAttributes *attributes in self.cellAttributesArray) {
            if (CGRectContainsPoint(attributes.frame, cell.center) && cellIndexPath != attributes.indexPath) {
                isChanged = YES;
                //对数组中存放的元素重新排序
                if (attributes.indexPath.row==0) {
                    NSLog(@"hihihihi");
                }else{
                NSString *imageStr = self.imagesArray[cellIndexPath.row];
                [self.imagesArray removeObjectAtIndex:cellIndexPath.row];
                [self.imagesArray insertObject:imageStr atIndex:attributes.indexPath.row];
                
                NSMutableArray *array=[[[NSUserDefaults standardUserDefaults] objectForKey:@"datasource"] mutableCopy];
                NSMutableDictionary *dic = array[cellIndexPath.row];
                 NSLog(@"排序前数据%@ 数量%ld",array,array.count);
                [array removeObjectAtIndex:cellIndexPath.row];
                [array insertObject:dic atIndex:attributes.indexPath.row];
                [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"datasource"];

                [self.mineCollection moveItemAtIndexPath:cellIndexPath toIndexPath:attributes.indexPath];
                
              
                }
                
            }
        }
        
    }else if (sender.state == UIGestureRecognizerStateEnded) {
        if (!isChanged) {
            cell.center = [_mineCollection layoutAttributesForItemAtIndexPath:cellIndexPath].center;
        }
       // NSLog(@"排序后数据%@ 数量%ld",_dataArray,_dataArray.count);
        NSLog(@"排序后---%@ 数量%ld",self.imagesArray,self.imagesArray.count);
      

        
    }
    
    
}


@end
