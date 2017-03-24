//
//  CYRootTabViewController.m
//  IOSFramework
//
//  Created by xu on 16/3/14.
//
//

#import "CYRootTabViewController.h"
#import "RDVTabBarItem.h"
#import "HomeViewController.h"
#import "FindViewController.h"
#import "OrderViewController.h"
#import "MineViewController.h"
#import "NEWViewController.h"
#import "ViewController.h"
#import "SecondViewController.h"
#import "BGColorDemoViewController.h"
#import "InsuranceViewController.h"
#import "WebHomeViewController.h"
@interface CYRootTabViewController ()

@end

@implementation CYRootTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  //  NSLog(@"打印出的flage为：%@",_flag);
    [self setupViewControllers];
    
    [self customizeTabBarForController];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)setupViewControllers {
    
    ViewController *homePage = [[ViewController alloc] init];
  // WebHomeViewController *homePage = [[WebHomeViewController alloc] init];
    UINavigationController *nav_home = [[UINavigationController alloc] initWithRootViewController:homePage];
    
     SecondViewController *progress = [[SecondViewController alloc] init];
    UINavigationController *nav_progress = [[UINavigationController alloc] initWithRootViewController:progress];
    
    
    OrderViewController *search = [[OrderViewController alloc] init];
    UINavigationController *nav_search = [[UINavigationController alloc] initWithRootViewController:search];
    
    InsuranceViewController *me = [[InsuranceViewController alloc] init];
    UINavigationController *nav_me = [[UINavigationController alloc] initWithRootViewController:me];
    
    [self setViewControllers:@[nav_home, nav_progress, nav_search, nav_me]];
    
}

- (void)customizeTabBarForController {
    NSArray *tabBarItemImages = @[@"homePage", @"search", @"progress", @"me"];
    NSArray *tabBarItemTitles = @[@"首页", @"视频", @"图片", @"我的"];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[self tabBar] items]) {
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        [item setTitle:[tabBarItemTitles objectAtIndex:index]];
        index++;
    }
}


@end
