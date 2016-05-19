//
//  AppDelegate.m
//  融易投
//
//  Created by dongxin on 16/3/30.
//  Copyright © 2016年 dongxin. All rights reserved.
//

//阿里云服务器
//http://j.efeiyi.com:8080/app-wikiServer/app/login.do
#import "DetailFinanceViewController.h"
#import "AppDelegate.h"

#import "CommonTabBarViewController.h"
#import "NotificationController.h"

#import "CompleteUserInfoController.h"
#import "WXApi.h"
#import "JPUSHService.h"

#import "NotificationController.h"
#import "CommentsController.h"
#import "RegViewController.h"
#import "MessageTableViewController.h"

#import "AliPayController.h"
#import "BeeCloud.h"

#import "XIBDemoViewController.h"
#import "LognController.h"

#import "ApplyforArtViewController.h"
#import "BQLAuthEngine.h"

static NSString *appKey = @"d1573e16403c2482826bbd35";
static NSString *channel = @"Publish channel";
static BOOL isProduction = FALSE;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([url.scheme isEqualToString:[NSString stringWithFormat:@"%@",WXAppKey]]) {
        return  [WXApi handleOpenURL:url delegate:[[BQLAuthEngine alloc] init]];
    }
    else if ([url.scheme isEqualToString:[NSString stringWithFormat:@"tencent%@",QQAppID]]) {
        return  [TencentOAuth HandleOpenURL:url];
        //return [QQApiInterface handleOpenURL:url delegate:[[BQLAuthEngine alloc] init]];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.scheme isEqualToString:[NSString stringWithFormat:@"%@",WXAppKey]]) {
        return  [WXApi handleOpenURL:url delegate:[[BQLAuthEngine alloc] init]];
    }
    else if ([url.scheme isEqualToString:[NSString stringWithFormat:@"tencent%@",QQAppID]]) {
        return  [TencentOAuth HandleOpenURL:url];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary*)options {
    
    if ([url.scheme isEqualToString:[NSString stringWithFormat:@"%@",WXAppKey]]) {
        return  [WXApi handleOpenURL:url delegate:[[BQLAuthEngine alloc] init]];
    }
    else if ([url.scheme isEqualToString:[NSString stringWithFormat:@"tencent%@",QQAppID]]) {
        return  [TencentOAuth HandleOpenURL:url];
    }
    
    return YES;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //微信登录
//    [BQLAuthEngine initialAuthEngine];
    
    
    [BeeCloud initWithAppID:@"c5d1cba1-5e3f-4ba0-941d-9b0a371fe719" andAppSecret:@"39a7a518-9ac8-4a9e-87bc-7885f33cf18c"];
    
    //    [BeeCloud initWithAppID:@"c5d1cba1-5e3f-4ba0-941d-9b0a371fe719" andAppSecret:@"4bfdd244-574d-4bf3-b034-0c751ed34fee" sandbox:YES];
    
    //开启/关闭沙箱测试模式;
    //可通过[BeeCloud getCurrentMode]查看当前模式，返回YES代表当前是sandbox环境，返回NO代表当前是生产环境
    //开启沙箱测试模式，请使用Test Secret初始化
    //    [BeeCloud setSandboxMode:YES];
    
    //初始化微信
    //此处的微信appid必须是在微信开放平台创建的移动应用的appid，且必须与在『BeeCloud控制台-》微信APP支付』配置的"应用APPID"一致，否则会出现『跳转到微信客户端后只显示一个确定按钮的现象』。
    [BeeCloud initWeChatPay:WXAppKey];
    
    //初始化PayPal
    [BeeCloud initPayPal:@"AVT1Ch18aTIlUJIeeCxvC7ZKQYHczGwiWm8jOwhrREc4a5FnbdwlqEB4evlHPXXUA67RAAZqZM0H8TCR"
                  secret:@"EL-fkjkEUyxrwZAmrfn46awFXlX-h2nRkyCVhhpeVdlSRuhPJKXx3ZvUTTJqPQuAeomXA8PZ2MkX24vF"
                 sandbox:YES];

    
    
    
    //1.创建主窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
      //2.设置窗口的根控制器
    CommonTabBarViewController *tabBarController = [[CommonTabBarViewController alloc] init];
    
    //设置tabBar的背景颜色
//    CGRect frame = tabBarController.tabBar.bounds;
//    UIView *v = [[UIView alloc] initWithFrame:frame];
//    [v setBackgroundColor:[[UIColor alloc] initWithRed:0/255.0
//                                                 green:0/255.0
//                                                  blue:0/255.0
//                                                 alpha:1.0]];
//    [tabBarController.tabBar insertSubview:v atIndex:0];
    
    //设置状态栏字体颜色和背景颜色
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    CGFloat statwidth = [[UIApplication sharedApplication] statusBarFrame].size.width;
    
    CGFloat statheight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    UIView *statusBarView=[[UIView alloc]initWithFrame:CGRectMake(0,0, statwidth, statheight)];
    
    statusBarView.backgroundColor = [[UIColor alloc] initWithRed:247.0 /255.0  green:247.0 /255.0  blue:247.0 /255.0  alpha:1.0];
    
    [tabBarController.view addSubview:statusBarView];
    
        //self.window.rootViewController = [MessageTableViewController new];
        //self.window.rootViewController = [RegViewController new];
        //self.window.rootViewController = [PersonalController new];
    
    LognController *vc = [[LognController alloc] init];
    
    self.window.rootViewController = vc;
    
    //3.显示窗口
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
