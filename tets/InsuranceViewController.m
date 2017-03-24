//
//  InsuranceViewController.m
//  IrregularTabBar
//
//  Created by JYJ on 16/5/3.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "InsuranceViewController.h"
//#import "SettingViewController.h"
#import "XDAlertController.h"
#import "UIImageView+WebCache.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "FastLoginViewController.h"
#import "RDVTabBarController.h"
#import "FMDB.h"
#import "MBProgressHUD.h"
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
@interface InsuranceViewController ()<UIImagePickerControllerDelegate,UIAlertViewDelegate>{
    NSInteger _count;
    BOOL _islogin;
}
@property(nonatomic,strong)UIButton *iconbtn;
@property(nonatomic,strong)UILabel *cacheSizeLabel;
@property(nonatomic,strong)UILabel *userlabel;
@property(nonatomic,strong)NSString *username;
@property (nonatomic, strong) FMDatabase *db;
@end

@implementation InsuranceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.view.backgroundColor = [UIColor grayColor];
    self.titleName = @"个人中心";
   //   [self sethead];
    NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName=[doc stringByAppendingPathComponent:@"student.sqlite"];
    
    //2.获得数据库
    FMDatabase *db=[FMDatabase databaseWithPath:fileName];
    
    //3.打开数据库
    if ([db open]) {
        //4.创表
        BOOL result=[db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_student (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age text NOT NULL);"];
        if (result) {
            NSLog(@"创表成功");
        }else{
            NSLog(@"创表失败");
        }
    }
    self.db=db;

}
-(void)sethead{
    NSString *headerimagestr=[[[NSUserDefaults standardUserDefaults] objectForKey:@"headerImage"] objectForKey:@"headerImage"];
    if (!headerimagestr||headerimagestr==nil) {
     self.headerImage.image = [UIImage imageNamed:@"group0"];
    }else{
        self.headerImage.image = [self dataURL2Image:headerimagestr];
    }
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:244/255.0 alpha:1];
    self.headerImage.userInteractionEnabled=YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTap.numberOfTapsRequired = 1;
    [self.headerImage addGestureRecognizer:singleTap];
    
    UIButton *iconView=[[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-50)/2, 100, 50, 50)];
  
   
    iconView.layer.masksToBounds = YES;
    iconView.layer.cornerRadius = 25;
    iconView.backgroundColor=[UIColor whiteColor];
    self.iconbtn=iconView;
    [self.headerImage addSubview:iconView];
   if (_islogin==YES) {
       UIImage *image=[self dataURL2Image:[self query]];
       if (!image) {
           [iconView setImage:[UIImage imageNamed:@"people"] forState:UIControlStateNormal];
       }else{
           [iconView setImage:image forState:UIControlStateNormal];
        }
        [iconView addTarget:self action:@selector(singleTap:) forControlEvents:UIControlEventTouchUpInside];
   }else{
       [iconView setImage:[UIImage imageNamed:@"people"] forState:UIControlStateNormal];
       [iconView addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    }
    UILabel *loginlabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 155, SCREEN_WIDTH, 20)];
   // loginlabel.text=self.username;
    self.userlabel=loginlabel;
    loginlabel.text=self.username;
    loginlabel.textColor=[UIColor whiteColor];
    loginlabel.font=[UIFont systemFontOfSize:13];
    loginlabel.textAlignment=NSTextAlignmentCenter;
    [self.headerImage addSubview:loginlabel];
}
- (UIImage *) dataURL2Image: (NSString *) imgSrc
{
    NSURL *url = [NSURL URLWithString: imgSrc];
    NSData *data = [NSData dataWithContentsOfURL: url];
    UIImage *image = [UIImage imageWithData: data];
    
    return image;
}
- (NSString *)getCacheSize
 {
         //定义变量存储总的缓存大小
        long long sumSize = 0;
    
        //01.获取当前图片缓存路径
        NSString *cacheFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    
     //02.创建文件管理对象
         NSFileManager *filemanager = [NSFileManager defaultManager];
    
             //获取当前缓存路径下的所有子路径
         NSArray *subPaths = [filemanager subpathsOfDirectoryAtPath:cacheFilePath error:nil];
    
             //遍历所有子文件
         for (NSString *subPath in subPaths) {
                     //1）.拼接完整路径
             NSString *filePath = [cacheFilePath stringByAppendingFormat:@"/%@",subPath];
                     //2）.计算文件的大小
                 long long fileSize = [[filemanager attributesOfItemAtPath:filePath error:nil]fileSize];
                     //3）.加载到文件的大小
                 sumSize += fileSize;
             }
         float size_m = sumSize/(1000*1000);
         return [NSString stringWithFormat:@"%.2fM",size_m];
    
     }

-(void)login{
    FastLoginViewController *FVC=[[FastLoginViewController alloc]init];
    [self.navigationController pushViewController:FVC animated:NO];
}

 #pragma mark - UIAlertViewDelegate方法实现
 - (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
 {
     if (alertView.tag==1) {
         if (buttonIndex == 1) {
             NSFileManager *fileManager = [NSFileManager defaultManager];
             NSString *cacheFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
             [fileManager removeItemAtPath:cacheFilePath error:nil];
             [self.tableView reloadData];//刷新表视图
             
         }

     }else{
         if (buttonIndex == 1) {
             NSLog(@"确定退出");
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userinf"];
             _islogin=NO;
             [self.userlabel removeFromSuperview];
             self.username=@"请登录";
             self.headerImage.image = [UIImage imageNamed:@"group0"];
             [self sethead];
         }
     }
}
- (void)singleTap:(UITapGestureRecognizer *)gesture
{
    NSString *string=[NSString stringWithFormat:@"%@",gesture.class];
    NSString *astr;
    if ([string isEqualToString:@"UIButton"]) {
        NSLog(@"点的是按钮");
        _count=0;
         astr=@"修改头像";
    }else{
        NSLog(@"点的是图");
        _count=1;
         astr=@"修改背景";
    }
    //  UIImageView *imgView = (UIImageView *)gesture.view;
    XDAlertController *alert = [XDAlertController alertControllerWithTitle:astr message:nil preferredStyle:XDAlertControllerStyleActionSheet];
  //  UIImageView *imgView = (UIImageView *)gesture.view;
    XDAlertAction *action1 = [XDAlertAction actionWithTitle:@"从相册获取" style: XDAlertActionStyleDefault handler:^( XDAlertAction * _Nonnull action) {

        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
    }];
    XDAlertAction *action2 = [XDAlertAction actionWithTitle:@"拍照" style: XDAlertActionStyleDefault handler:^( XDAlertAction * _Nonnull action) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
    }];
    
    XDAlertAction *action3 = [XDAlertAction actionWithTitle:@"取消" style:XDAlertActionStyleCancel handler:^(XDAlertAction * _Nonnull action) {
        
    }];
    
//    XDAlertAction *action3 = [XDAlertAction actionWithTitle:@"destructive" style:XDAlertActionStyleDestructive handler:^(XDAlertAction * _Nonnull action) {
//        
//    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
     [alert addAction:action3];
    
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        [self performSelector:@selector(saveImage:)  withObject:img afterDelay:0.5];
    }
    else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeMovie]) {
        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];

}
- (void)saveImage:(UIImage *)image {
    NSString *imagestr=[self image2DataURL:image];
    if (_count==1) {
        
          self.headerImage.image=image;
            NSDictionary *dic=@{
                       //     @"name":self.username,
                            @"headerImage":imagestr,
                            };
            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"headerImage"];

    }else{
       
          [self.db executeUpdate:@" alter TABLE t_student add icon varchar (256)"];
        
    NSString *str=[NSString stringWithFormat:@"UPDATE t_student SET icon ='%@' WHERE name = '%@';",imagestr ,self.username] ;
        [self.db executeUpdate:str];
        [self.iconbtn setImage:image forState:UIControlStateNormal];
    }
  
}
- (NSString *)query
{
    // 1.执行查询语句
   // FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM t_student"];
   NSString *querystr=[NSString stringWithFormat:@"SELECT icon FROM t_student where name='%@';",self.username];
    FMResultSet *resultSet = [self.db executeQuery:querystr];
    // 2.遍历结果
    NSString *iconstr=@"";
    while ([resultSet next]) {
        int ID = [resultSet intForColumn:@"id"];
        NSString *name = [resultSet stringForColumn:@"name"];
        NSString *age = [resultSet stringForColumn:@"age"];
        NSString *icon = [resultSet stringForColumn:@"icon"];
        iconstr=icon;
        NSLog(@"%d %@ %@ %@" , ID, name, age ,icon);
    }
    return iconstr;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //    [self.webView reload];
    [picker dismissViewControllerAnimated:YES completion:nil];
    //    [picker pushViewController:self.viewController animated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"insuranceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
   
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
        CGFloat width=(SCREEN_WIDTH-100-140)/3;
        NSArray *array=@[@"收藏",@"设置",@"反馈"];
    NSArray *setarray=@[@"个人信息",@"清除缓存",@"关于我们",@"退出登录"];
        for (int i=0; i<3; i++) {
            UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(i*(width+70)+50,(100-width)/2-20,width , width)];
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"me%d",i]] forState:UIControlStateNormal];
            btn.imageEdgeInsets=UIEdgeInsetsMake(0, 10, 20, 10);
            [btn addTarget:self action:@selector(threeClick) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn];
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(i*(width+70)+50,(100-width)/2+10,width , 20)];
            label.text=array[i];
            label.font=[UIFont systemFontOfSize:14];
            label.textAlignment=NSTextAlignmentCenter;
            [cell.contentView addSubview:label];
        }
        UIView *sepeview=[[UIView alloc]initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, 20)];
        sepeview.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:244/255.0 alpha:0.8];
        [cell.contentView addSubview:sepeview];
    
    for (int i=0; i<4; i++) {
        UIView *backview=[[UIView alloc]initWithFrame:CGRectMake(0, i*50+100, SCREEN_WIDTH, 50)];
        [cell.contentView addSubview:backview];
        UIButton *btns=[[UIButton alloc]initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH/2, 30)];
        if (i==1) {
            self.cacheSizeLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2,0, SCREEN_WIDTH/2-20, 50)];
            _cacheSizeLabel.text=[self getCacheSize];
            _cacheSizeLabel.textAlignment=NSTextAlignmentRight;
            _cacheSizeLabel.font=[UIFont systemFontOfSize:14];
            _cacheSizeLabel.textColor=[UIColor lightGrayColor];
            [backview addSubview:_cacheSizeLabel];
        }
        [btns setTitle:setarray[i] forState:UIControlStateNormal];
 
        btns.tag=i;
        [btns addTarget:self action:@selector(btnsclick:) forControlEvents:UIControlEventTouchUpInside];
        btns.titleLabel.textColor=[UIColor redColor];
        [btns setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        btns.contentHorizontalAlignment=1;
        [backview addSubview:btns];
        UIView *smallsepeview=[[UIView alloc]initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 1)];
        smallsepeview.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:244/255.0 alpha:1];
        [backview addSubview:smallsepeview];

        
    }
    
    return cell;
}
-(void)threeClick{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.mode = MBProgressHUDModeText;
    HUD.labelText = @"敬请期待";
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];

}
-(void)btnsclick:(UIButton *)sender{
    if (sender.tag==1) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"缓存清除" message:@"确定清除缓存?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        alertView.tag=1;
        alertView.delegate=self;
        [alertView show];

    }else if(sender.tag==3){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"退出账号" message:@"确定退出此账号" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        alertView.tag=3;
        alertView.delegate=self;
        [alertView show];

    }else{
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.mode = MBProgressHUDModeText;
        HUD.labelText = @"敬请期待";
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(2);
            } completionBlock:^{
                [HUD removeFromSuperview];
            }];
            

    }
}
- (BOOL) imageHasAlpha: (UIImage *) image
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}
- (NSString *) image2DataURL: (UIImage *) image
{
    NSData *imageData = nil;
    NSString *mimeType = nil;
    
    if ([self imageHasAlpha: image]) {
        imageData = UIImagePNGRepresentation(image);
        mimeType = @"image/png";
    } else {
        imageData = UIImageJPEGRepresentation(image, 1.0f);
        mimeType = @"image/jpeg";
    }
    
    return [NSString stringWithFormat:@"data:%@;base64,%@", mimeType,
            [imageData base64EncodedStringWithOptions: 0]];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    SettingViewController *setVc = [[SettingViewController alloc] init];
//    setVc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:setVc animated:YES];
}

 - (void)viewWillAppear:(BOOL)animated
 {
         [super viewWillAppear:YES];
     NSDictionary *dic=[[NSUserDefaults standardUserDefaults] objectForKey:@"userinf"] ;
     [self.userlabel removeFromSuperview];
     if (dic) {
         self.username=[dic objectForKey:@"name"];
         _islogin=YES;
     }else{
        self.username=@"请登录";//[dic objectForKey:@"name"];
         _islogin=NO;
     }
     [self sethead];

    [self.tableView reloadData];
     [self.rdv_tabBarController setTabBarHidden:NO animated:NO];
      [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
@end
