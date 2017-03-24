//
//  WebHomeViewController.m
//  tets
//
//  Created by lijunjie on 2017/1/17.
//  Copyright © 2017年 dev. All rights reserved.
//

#import "WebHomeViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface WebHomeViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *webview;
@property (nonatomic,weak) JSContext * context;
@end

@implementation WebHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path=[[NSBundle mainBundle]pathForResource:@"webtest" ofType:nil];
    NSString *appPath=[NSString stringWithFormat:@"file://%@/src/main/webapp/app/index.html#/test",path];
    UIWebView *webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, WLScreenW, WLScreenH-64-64+16)];
    self.webview=webview;
    self.webview.delegate=self;
    [self.view addSubview:webview];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:appPath]]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *requestString = [[[request URL]  absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"should-------");
    if ([requestString hasPrefix:@"fdd://"]) {
        //根据自己定义的规则，通过字符串的值，调用OC的方法。这里就输出一下字符串了。
        NSLog(@"===%@",requestString); //可能包含商品的ID，APP拿到这个ID，使用OC代码执行相关操作
        return NO; //YES 表示正常加载网页 返回NO 将停止网页加载
    }
    
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"网页加载完毕");
    //获取js的运行环境
    _context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
   
    NSLog(@"clickLi%@",_context);//html调用无参数OC
//    _context[@"test1"] = ^(){
//        [self menthod1];
//    };
    //html调用OC(传参数过来)
    _context[@"jakilllog"] = ^(){
        NSArray * args = [JSContext currentArguments];//传过来的参数
        NSLog(@"clickLi%@",args);
        //        for (id  obj in args) {
        //            NSLog(@"html传过来的参数%@",obj);
        //        }
        NSString * name = args[0];
        NSString * str = args[1];
        [self menthod2:name and:str];
    };
}
-(void)menthod2:(NSString *)str1 and:(NSString *)str2{
    NSLog(@"%@%@",str1,str2);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
