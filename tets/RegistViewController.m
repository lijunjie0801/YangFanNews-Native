//
//  RegistViewController.m
//  tets
//
//  Created by lijunjie on 2017/1/6.
//  Copyright © 2017年 dev. All rights reserved.
//

#import "RegistViewController.h"
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#import "MBProgressHUD.h"
#import "FMDB.h"
@interface RegistViewController ()<MZTimerLabelDelegate>{
    BOOL isRight;
}
@property(nonatomic,strong)UILabel *timer_show;
@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,strong)UITextField *tf;
@property(nonatomic,strong)UITextField *tfResult;
@property(nonatomic,strong)UITextField *passwordtf;
@property (nonatomic, strong) FMDatabase *db;
@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setview];
    self.title=@"注册";
    
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
//    [self insert];
//    [self query];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setview{
    UIView *backview=[[UIView alloc]initWithFrame:CGRectMake(20, 40, SCREEN_WIDTH-40, 180)];
    //backview.layer.borderColor=[UIColor grayColor];
    backview.layer.borderWidth=0.5;
    [backview.layer setMasksToBounds:YES];
    [backview.layer setCornerRadius:5.0];
    [self.view addSubview:backview];
    
    UITextField *nametf=[[UITextField alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-60, 40)];
    nametf.placeholder=@"请输入手机号码";
     nametf.keyboardType = UIKeyboardTypeNumberPad;
    self.tf=nametf;
    nametf.keyboardType = UIKeyboardTypeASCIICapable;
    nametf.clearButtonMode = UITextFieldViewModeAlways;
    [backview addSubview:nametf];
    
    UIButton *identifybtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-30-120, 18, 100, 25)];
    self.btn=identifybtn;
    [identifybtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [identifybtn.layer setMasksToBounds:YES];
    [identifybtn.layer setCornerRadius:5.0];
    [identifybtn setBackgroundColor:[UIColor orangeColor]];
    [identifybtn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [backview addSubview:identifybtn];

    
    UIView *sepeview=[[UIView alloc]initWithFrame:CGRectMake(0, 59.5, SCREEN_WIDTH-40, 0.5)];
    sepeview.backgroundColor=[UIColor blackColor];
    [backview addSubview:sepeview];
    
    UITextField *vertifytf=[[UITextField alloc]initWithFrame:CGRectMake(10, 70, SCREEN_WIDTH-60, 40)];
    vertifytf.placeholder=@"请输入验证码";
    vertifytf.keyboardType = UIKeyboardTypeNumberPad;
   // passwordtf.secureTextEntry = YES;
    self.tfResult=vertifytf;
    [backview addSubview:vertifytf];
    
    
    UIView *sepeviewtwo=[[UIView alloc]initWithFrame:CGRectMake(0, 59.5+60, SCREEN_WIDTH-40, 0.5)];
    sepeviewtwo.backgroundColor=[UIColor blackColor];
    [backview addSubview:sepeviewtwo];

    
    UITextField *passwordtf=[[UITextField alloc]initWithFrame:CGRectMake(10, 130, SCREEN_WIDTH-60, 40)];
    passwordtf.placeholder=@"请设置密码";
    self.passwordtf=passwordtf;
    passwordtf.secureTextEntry = YES;
    [backview addSubview:passwordtf];
    
    UIButton *registbtn=[[UIButton alloc]initWithFrame:CGRectMake(20, 230, SCREEN_WIDTH-40, 60)];
    [registbtn setTitle:@"注册" forState:UIControlStateNormal];
    registbtn.backgroundColor=[UIColor orangeColor];
    [registbtn.layer setMasksToBounds:YES];
    [registbtn.layer setCornerRadius:5.0];
     [registbtn addTarget:self action:@selector(regist) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registbtn];
    

}
-(void)regist{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
     HUD.mode = MBProgressHUDModeText;
    BOOL b=[self checkPassword:self.passwordtf.text];
    BOOL pb=[self isMobile:self.tf.text];
    if ([self.tf.text isEqualToString:@""]) {
        HUD.labelText = @"请输入手机号";
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        } completionBlock:^{
            [HUD removeFromSuperview];
        }];
        return;
    }else if ([self.tfResult.text isEqualToString:@""]){
         HUD.labelText = @"请输入验证码";
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        } completionBlock:^{
            [HUD removeFromSuperview];
        }];
         return;

    }else if([self.passwordtf.text isEqualToString:@""]){
        HUD.labelText = @"请设置密码";
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        } completionBlock:^{
            [HUD removeFromSuperview];
        }];
         return;
    }else if (pb==NO){
        HUD.labelText = @"请输入正确手机号";
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        } completionBlock:^{
            [HUD removeFromSuperview];
        }];
        return;
        
    }else if (b==NO){
        HUD.labelText = @"密码由6-18位数字和字母组合";
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        } completionBlock:^{
            [HUD removeFromSuperview];
        }];
        return;

    }else{
         [self setReq];
    }
   
    
        
        
    
   
}
-(void)createTable{
    [self insert];
    [self query];
}
 -(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
 {
        // [self delete];
     
     }
-(void)insert
 {
//         for (int i = 0; i<10; i++) {
//                 NSString *name = [NSString stringWithFormat:@"jack-%d", arc4random_uniform(100)];
                 // executeUpdate : 不确定的参数用?来占位
                 [self.db executeUpdate:@"INSERT INTO t_student (name, age) VALUES (?, ?);", self.tf.text, self.passwordtf.text];
  
         //    }
     }
 - (void)query
 {
         // 1.执行查询语句
         FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM t_student"];
    
         // 2.遍历结果
         while ([resultSet next]) {
                 int ID = [resultSet intForColumn:@"id"];
                 NSString *name = [resultSet stringForColumn:@"name"];
                 NSString *age = [resultSet stringForColumn:@"age"];
                 NSLog(@"%d %@ %@", ID, name, age);
             }
     [self.navigationController popViewControllerAnimated:NO];
     }
-(BOOL)checkPassword:(NSString *) password
{
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
    
}
-(BOOL)isMobile:(NSString *)mobileNumbel{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,181(增加)
     */
    NSString * MOBIL = @"^1(3[0-9]|5[0-35-9]|7[0-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,181(增加)
     22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNumbel]
         || [regextestcm evaluateWithObject:mobileNumbel]
         || [regextestct evaluateWithObject:mobileNumbel]
         || [regextestcu evaluateWithObject:mobileNumbel])) {
        return YES;
    }
    
    return NO;
}
-(void)sendMessage
{
    
    NSString *phoneNum=self.tf.text;
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.mode = MBProgressHUDModeText;
   // BOOL b=[self checkPassword:self.passwordtf.text];
    BOOL pb=[self isMobile:self.tf.text];
    if ([self.tf.text isEqualToString:@""]) {
        HUD.labelText = @"请输入手机号";
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        } completionBlock:^{
            [HUD removeFromSuperview];
        }];
        return;
    }else if (pb==NO){
        HUD.labelText = @"请输入正确手机号";
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        } completionBlock:^{
            [HUD removeFromSuperview];
        }];
        return;
        
    }
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
-(void)setReq{
    [SMSSDK commitVerificationCode:self.tfResult.text phoneNumber:self.tf.text zone:@"86" result:^(NSError *error) {
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.mode = MBProgressHUDModeText;
        if (!error) {
//            isRight=YES;
            NSLog(@"验证成功");
            HUD.labelText = @"注册成功";
            [self createTable];
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(2);
            } completionBlock:^{
                [HUD removeFromSuperview];
                [self.navigationController popViewControllerAnimated:NO];
            }];
           
        }
        else
        {
            HUD.labelText = @"验证码不正确";
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(2);
            } completionBlock:^{
                [HUD removeFromSuperview];
            }];

//              isRight=NO;
//            NSLog(@"错误信息：%@",error);
            
            
        }}];
}


@end
