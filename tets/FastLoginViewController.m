//
//  FastLoginViewController.m
//  tets
//
//  Created by lijunjie on 2017/1/6.
//  Copyright © 2017年 dev. All rights reserved.
//

#import "FastLoginViewController.h"
#import "ViewController.h"
#import <SMS_SDK/SMSSDK.h>
//#import "SMSSDK.h"
#import "RDVTabBarController.h"
#import "RegistViewController.h"
#import "MBProgressHUD.h"
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#import "MZTimerLabel.h"
#import "UIColor+expanded.h"
#import "UIImage+Common.h"
#import "FMDB.h"

@interface FastLoginViewController ()<MZTimerLabelDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,strong)UITextField *tf;
@property(nonatomic,strong)UIButton *btnResult;
@property(nonatomic,strong)UITextField *tfResult;
@property(nonatomic,strong)UILabel *timer_show;
@property (nonatomic, strong) FMDatabase *db;
@end

@implementation FastLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"登录";
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self setview];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:222/255.0 green:81/255.0 blue:15/255.0 alpha:1]] forBarMetrics:UIBarMetricsDefault];
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
- (void)query
{
    // 1.执行查询语句
    NSString *sqlstring=[NSString stringWithFormat:@"SELECT * FROM t_student where name='%@'",self.tf.text];
    FMResultSet *resultSet = [self.db executeQuery:sqlstring];//[self.db executeQuery:@"SELECT * FROM t_student where name='13166330593'"];
    
    // 2.遍历结果
    NSMutableArray *marr=[NSMutableArray array];
    while ([resultSet next]) {
        int ID = [resultSet intForColumn:@"id"];
        NSString *name = [resultSet stringForColumn:@"name"];
        NSString *age = [resultSet stringForColumn:@"age"];
        NSDictionary *dic=@{
                                   @"name":name,
                                   @"age":age,
                                   };
        [marr addObject:dic];
        NSLog(@"%d %@ %@", ID, name, age);
    }
    NSLog(@"marr:%@",marr);
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.mode = MBProgressHUDModeText;

    if (marr.count==0) {
               HUD.labelText = @"该账号不存在";
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        } completionBlock:^{
            [HUD removeFromSuperview];
        }];

    }else{
        NSString *password=[marr[0] objectForKey:@"age"];
        if ([self.tfResult.text isEqualToString:password]) {
            NSLog(@"成功登陆");
            NSDictionary *userDic=@{
                                           @"name":self.tf.text,
                                           @"password":self.tfResult.text,
                                           };
            [[NSUserDefaults standardUserDefaults] setObject:userDic forKey:@"userinf"];
            [self.navigationController popViewControllerAnimated:NO];
        }else{
            NSLog(@"密码错误");
        }

    }
   }
-(void)viewWillAppear:(BOOL)animated{
     [self.rdv_tabBarController setTabBarHidden:YES animated:NO];
}
-(void)setview{
    UIView *backview=[[UIView alloc]initWithFrame:CGRectMake(20, 100, SCREEN_WIDTH-40, 120)];
    //backview.layer.borderColor=[UIColor grayColor];
    backview.layer.borderWidth=0.5;
    [backview.layer setMasksToBounds:YES];
    [backview.layer setCornerRadius:5.0];
    [self.view addSubview:backview];
    
     UITextField *nametf=[[UITextField alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-60, 40)];
    nametf.placeholder=@"用户名";
    self.tf=nametf;
    nametf.keyboardType = UIKeyboardTypeASCIICapable;
    nametf.clearButtonMode = UITextFieldViewModeAlways;
    [backview addSubview:nametf];
    
    UIView *sepeview=[[UIView alloc]initWithFrame:CGRectMake(0, 59.5, SCREEN_WIDTH-40, 0.5)];
    
    sepeview.backgroundColor=[UIColor blackColor];
    [backview addSubview:sepeview];
    UITextField *passwordtf=[[UITextField alloc]initWithFrame:CGRectMake(10, 70, SCREEN_WIDTH-60, 40)];
    passwordtf.placeholder=@"密   码";
    self.tfResult=passwordtf;
     passwordtf.secureTextEntry = YES;
    [backview addSubview:passwordtf];
    
    
    UIButton *loginbtn=[[UIButton alloc]initWithFrame:CGRectMake(20, 230, SCREEN_WIDTH-40, 60)];
    [loginbtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginbtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    loginbtn.backgroundColor=[UIColor orangeColor];
    [loginbtn.layer setMasksToBounds:YES];
    [loginbtn.layer setCornerRadius:5.0];
    [self.view addSubview:loginbtn];
    
    
    UIButton *forgetbtn=[[UIButton alloc]initWithFrame:CGRectMake(20, 300, 100, 20)];
    [forgetbtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    forgetbtn.titleLabel.font=[UIFont systemFontOfSize:14];
     forgetbtn.contentHorizontalAlignment=1;
    [self.view addSubview:forgetbtn];
    
    
    UIButton *registbtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-20-100, 300, 100, 20)];
    [registbtn setTitle:@"注  册" forState:UIControlStateNormal];
    [registbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [registbtn addTarget:self action:@selector(registClick) forControlEvents:UIControlEventTouchUpInside];
    registbtn.titleLabel.font=[UIFont systemFontOfSize:14];
    registbtn.contentHorizontalAlignment=2;
    [self.view addSubview:registbtn];
//    UITextField *tf=[[UITextField alloc]initWithFrame:CGRectMake(10, 10, 150, 25)];
//    self.tf=tf;
//    [tf setBorderStyle:UITextBorderStyleRoundedRect];
//    tf.placeholder=@"手机号";
//    [backview addSubview:tf];
//    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(170, 10, 100, 25)];
//    self.btn=btn;
//    [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
//    [btn.layer setMasksToBounds:YES];
//    [btn.layer setCornerRadius:5.0];
//    [btn setBackgroundColor:[UIColor redColor]];
//    [btn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
//    [backview addSubview:btn];
//    
//    
//    
//    
//    UITextField *tfResult=[[UITextField alloc]initWithFrame:CGRectMake(10, 40, 150, 25)];
//    self.tfResult=tfResult;
//    [tfResult setBorderStyle:UITextBorderStyleRoundedRect];
//    tfResult.placeholder=@"验证码";
//    [backview addSubview:tfResult];
//    UIButton *btnResult=[[UIButton alloc]initWithFrame:CGRectMake(170, 40, 100, 25)];
//    self.btnResult=btnResult;
//    [btnResult setTitle:@"发送验证码" forState:UIControlStateNormal];
//    [btnResult.layer setMasksToBounds:YES];
//    [btnResult.layer setCornerRadius:5.0];
//    [btnResult setBackgroundColor:[UIColor redColor]];
//    [btnResult addTarget:self action:@selector(setReq) forControlEvents:UIControlEventTouchUpInside];
//    
//    [backview addSubview:btnResult];
}
-(void)login{
    [self query];
}
//获取验证码

-(void)registClick{
    RegistViewController *RVC=[[RegistViewController alloc]init];
    [self.navigationController pushViewController:RVC animated:NO];
}
-(void)sendMessage
{
    
    
    
    /**
     *  @from                    v1.1.1
     *  @brief                   获取验证码(Get verification code)
     *
     *  @param method            获取验证码的方法(The method of getting verificationCode)
     *  @param phoneNumber       电话号码(The phone number)
     *  @param zone              区域号，不要加"+"号(Area code)
     *  @param customIdentifier  自定义短信模板标识 该标识需从官网http://www.mob.com上申请，审核通过后获得。(Custom model of SMS.  The identifier can get it  from http://www.mob.com  when the application had approved)
     *  @param result            请求结果回调(Results of the request)
     */
    NSString *phoneNum=self.tf.text;
    [self timeCount];
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phoneNum
                                   zone:@"86"
                       customIdentifier:nil
                                 result:^(NSError *error)
     {  if (!error) {
        NSLog(@"获取验证码成功");
    } else {
        NSLog(@"错误信息：%@",error);
    }}];
}

- (void)timeCount{//倒计时函数
    [self.btn setTitle:nil forState:UIControlStateNormal];//把按钮原先的名字消掉
    UILabel *timer_show = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 85, 20)];//UILabel设置成和UIButton一样的尺寸和位置
    self.timer_show=timer_show;
    [self.btn addSubview:timer_show];//把timer_show添加到_dynamicCode_btn按钮上
    MZTimerLabel *timer_cutDown = [[MZTimerLabel alloc] initWithLabel:timer_show andTimerType:MZTimerLabelTypeTimer];//创建MZTimerLabel类的对象timer_cutDown
    [timer_cutDown setCountDownTime:60];//倒计时时间60s
    timer_cutDown.timeFormat = @"倒计时 ss";//倒计时格式,也可以是@"HH:mm:ss SS"，时，分，秒，毫秒；想用哪个就写哪个
    timer_cutDown.timeLabel.textColor = [UIColor whiteColor];//倒计时字体颜色
    timer_cutDown.timeLabel.font = [UIFont systemFontOfSize:13.0];//倒计时字体大小
    timer_cutDown.timeLabel.textAlignment = NSTextAlignmentCenter;//剧中
    timer_cutDown.delegate = self;//设置代理，以便后面倒计时结束时调用代理
    self.btn.userInteractionEnabled = NO;//按钮禁止点击
    [timer_cutDown start];//开始计时
}

- (void)timerLabel:(MZTimerLabel *)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    [self.btn setTitle:@"获取验证码" forState:UIControlStateNormal];//倒计时结束后按钮名称改为"发送验证码"
    [self.timer_show removeFromSuperview];//移除倒计时模块
    self.btn.userInteractionEnabled = YES;//按钮可以点击
}
//验证是否成功
-(void)setReq{
    [SMSSDK commitVerificationCode:self.tfResult.text phoneNumber:self.tf.text zone:@"86" result:^(NSError *error) {
        //        SecondView *S=[[SecondView alloc]init];
        //
        //        [self.navigationController pushViewController:S animated:YES];
        
        if (!error) {
            
            NSLog(@"验证成功");
            //            NSString *messages = [NSString stringWithFormat:@"发现新版本%@，是否要更新",VersionNumber];
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"验证成功" message:@"是否登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"验证失败" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            
            [alert show];
            NSLog(@"错误信息：%@",error);
            
            
        }}];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
//        SecondView *S=[[SecondView alloc]init];
//        
//        [self.navigationController pushViewController:S animated:NO];
        
        
        
        
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavigationBar{
    [self.navigationController setNavigationBarHidden:YES];
    
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 32)];
    
    [bar setBackgroundImage:[UIImage imageNamed:@"yi.png"] forBarMetrics:UIBarMetricsDefault];
    [bar setBackgroundColor:[UIColor redColor]];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:nil];
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [left setFrame:CGRectMake(0, 2, 28, 28)];
    [left setImage:[UIImage imageNamed:@"zhuche_back.png"] forState:UIControlStateNormal];
    
    [left addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:left];
    [item setLeftBarButtonItem:leftButton];
    [bar pushNavigationItem:item animated:NO];
    
    [self.view addSubview:bar];
}


- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end

