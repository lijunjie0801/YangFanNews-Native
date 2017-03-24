//
//  AppDelegate.m
//  tets
//
//  Created by lijunjie on 2016/11/29.
//  Copyright © 2016年 dev. All rights reserved.
//

#import "AppDelegate.h"
#import "CYRootTabViewController.h"
#import "UIColor+expanded.h"
#import "UIImage+Common.h"
#import <Bugly/Bugly.h>
#import <SMS_SDK/SMSSDK.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //DE510F
//    //设置item普通状态
//    UIBarButtonItem *item = [UIBarButtonItem appearance];
//
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
//    attrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
//    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];

    UINavigationBar *naviGationBar = [UINavigationBar appearance];
    naviGationBar.translucent = NO;
    
    [naviGationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:222/255.0 green:81/255.0 blue:15/255.0 alpha:1]] forBarMetrics:UIBarMetricsDefault];
    [naviGationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    UIWindow *window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    
    self.window=window;
    [self.window makeKeyAndVisible];
    [self.window setRootViewController:[[CYRootTabViewController alloc]init] ];

    [Bugly startWithAppId:@"031cd0f2dd"];
    [SMSSDK registerApp:@"13138a5622b50"
             withSecret:@"e46fb2c05dfd8b3cbcd3dd6c4f74d2a5"];
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        NSLog(@"第一次启动");
        NSString *path= [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
        //NSData *data=[NSData dataWithContentsOfFile:path];
        NSArray *array=[NSArray arrayWithContentsOfFile:path];
        NSMutableArray *marr=[NSMutableArray array];
        for (int i=0; i<array.count; i++) {
            [marr addObject:array[i]];;
        }
        NSLog(@"这是总数据%@",[marr class]);
        [[NSUserDefaults standardUserDefaults] setObject:marr forKey:@"datasource"];

    
        NSString *path1= [[NSBundle mainBundle] pathForResource:@"secondData" ofType:@"plist"];
        NSArray *array1=[NSArray arrayWithContentsOfFile:path1];
        NSMutableArray *marr1=[NSMutableArray array];
        for (int i=0; i<array1.count; i++) {
            [marr1 addObject:array1[i]];;
        }
        [[NSUserDefaults standardUserDefaults] setObject:marr1 forKey:@"seconddatasource"];

    }else{
        NSLog(@"不是第一次启动");
    }
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"tets"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
