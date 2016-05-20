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

#import "NewFeatureViewController.h"


static NSString *appKey = @"539b73fd73c82f1134120a57";
static NSString *channel = @"Publish channel";
static BOOL isProduction = FALSE;

#define SSVersionKey @"curVersion"

#define SSUserDefaults [NSUserDefaults standardUserDefaults]

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

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //自定义参数，key是自己定义的
}
- (void)networkDidLogin:(NSNotification *)notification {
    
    
    if ([JPUSHService registrationID]) {
        NSLog(@"get RegistrationID:%@",[JPUSHService registrationID]);//获取registrationID
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //微信登录
//    [BQLAuthEngine initialAuthEngine];
    
    //JPush
    // Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    NSNotificationCenter *defaultCenter1 = [NSNotificationCenter defaultCenter];
    [defaultCenter1 addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    
    // Required
    //如需兼容旧版本的方式，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化和同时使用pushConfig.plist文件声明appKey等配置内容。
    [JPUSHService setupWithOption:launchOptions appKey:appKey channel:channel apsForProduction:isProduction];
    
    //BeeCloud
    /*
     如果使用BeeCloud控制台的APP Secret初始化，代表初始化生产环境；
     如果使用BeeCloud控制台的Test Secret初始化，代表初始化沙箱测试环境;
     测试账号 appid: c5d1cba1-5e3f-4ba0-941d-9b0a371fe719
     appSecret: 39a7a518-9ac8-4a9e-87bc-7885f33cf18c
     testSecret: 4bfdd244-574d-4bf3-b034-0c751ed34fee
     由于支付宝的政策原因，测试账号的支付宝支付不能在生产环境中使用，带来不便，敬请原谅！
     */

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
    self.window.rootViewController = [self defaultViewController];
//    LognController *logn = [[LognController alloc] init];
    //2.设置窗口的根控制器
//    self.window.rootViewController = logn;
    
    //3.显示窗口
    [self.window makeKeyAndVisible];
    
    //4.注册通知切换控制器
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchRootViewController:) name:ChangeRootViewControllerNotification object:nil];
    
    return YES;
}

//*******************************切换控制器********************************
-(BOOL)isNewVewsion{

    //1.判断下用户有没有最先版本
    //2.最新的版本都是保存到Info.plist
    //3.从Info.plist文件获取最新版本
    
    //1>获取Info.plist
    //    NSString *infoPath = [[NSBundle mainBundle] pathForResource:@"Info.plist" ofType:nil];
    //    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:infoPath];
    //获取Info.plist方法二:
    NSDictionary *dict = [NSBundle mainBundle].infoDictionary;
    NSString *curVersion = dict[@"CFBundleShortVersionString"];
    
    //2>获取上一次的版本号
    //利用偏好设置
    NSString *lastVersion = [SSUserDefaults objectForKey:SSVersionKey];
    
    //3>判断  之前的最新版本号 lastVersion
    if ([curVersion  isEqualToString:lastVersion]) {
        //版本号相同
        //进入主框架的界面
        NSLog(@"不是新版本,进入主框架的界面");
        
        return NO;
    }else{ //有最新的版本
        //保存最新的版本号
        //保存到偏好设置
        [SSUserDefaults setObject:curVersion forKey:SSVersionKey];
        
        //进入新特性界面
        NSLog(@"有新版本,进入新特性界面");
        
        return YES;
    }
}


-(UIViewController *)defaultViewController {

    if ([self isNewVewsion]) {
        
        NewFeatureViewController *newFea = [[NewFeatureViewController alloc] init];
        
        return newFea;

    }else {
    
        //设置窗口的根控制器
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
        
        return tabBarController;
    }
    
}

-(void)switchRootViewController:(NSNotification *)notice{
    
    //获取通知传递的信息
    NSDictionary *info = notice.userInfo;
    
    NSString *str = info[@"message"];
    
    if ([str isEqualToString:@"2"]) { //登录
        
        LognController *logn = [[LognController alloc] init];
        //2.设置窗口的根控制器
        self.window.rootViewController = logn;
        
    }else if([str isEqualToString:@"3"]){ //注册
        RegViewController *reg = [[RegViewController alloc] init];
        
        //2.设置窗口的根控制器
        self.window.rootViewController = reg;
    
    }else {
    
        //设置窗口的根控制器
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
        
        //2.设置窗口的根控制器
        self.window.rootViewController = tabBarController;
        
    }
}



//*******************************JPush********************************

//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
//    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window makeKeyAndVisible];
//
//    // Required
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//        //可以添加自定义categories
//        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
//                                                          UIUserNotificationTypeSound |
//                                                          UIUserNotificationTypeAlert)
//                                              categories:nil];
//    } else {
//        //categories 必须为nil
//        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
//                                                          UIRemoteNotificationTypeSound |
//                                                          UIRemoteNotificationTypeAlert)
//                                              categories:nil];
//    }
//
//    // Required
//    //如需兼容旧版本的方式，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化和同时使用pushConfig.plist文件声明appKey等配置内容。
//    [JPUSHService setupWithOption:launchOptions appKey:appKey channel:channel apsForProduction:isProduction];
//    return YES;
//}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [JPUSHService registerDeviceToken:deviceToken];
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@">>>>>>>>>2userInfo%@",[self logDic:userInfo]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    completionHandler(UIBackgroundFetchResultNewData);
    
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@">>>>>>>>>1userInfo%@",[self logDic:userInfo]);
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
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
