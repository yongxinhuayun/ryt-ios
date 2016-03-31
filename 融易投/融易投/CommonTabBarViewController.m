//
//  TabBarViewController.m
//  融易投
//
//  Created by efeiyi on 16/3/30.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "CommonTabBarViewController.h"

#import "CommonNavigationController.h"

#import "MessageTableViewController.h"
#import "MeTableViewController.h"
#import "DiscoveryTableViewController.h"
#import "MainTableViewController.h"

//111

//TabBar的颜色
#define TabBarColor(r,g,b) [UIColor colorWithRed: (r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1];
//TabBar按钮字体的大小
#define TabButtonTitleFont [UIFont systemFontOfSize:12]

@interface CommonTabBarViewController ()

@end

@implementation CommonTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1. 添加子控制器(导航控制器):必须要有跟控制器
    [self setUpAllChildViewController];
    
    // 2. 设置所有子控制器对应按钮的内容
    [self setUpAllTabButton];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

//3. 设置tabbar的标题文字颜色和大小
+(void)load
{
    // 获取整个app中tabBarItem
    UITabBarItem *item =  [UITabBarItem appearanceWhenContainedIn:self, nil];
    
    NSMutableDictionary *attrsNor = [NSMutableDictionary dictionary];
    
    //NSForegroundColorAttributeName 在UIKIT框架的第一个头文件中
    attrsNor[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    attrsNor[NSFontAttributeName] = TabButtonTitleFont;
    
    [item setTitleTextAttributes:attrsNor forState:UIControlStateNormal];
    
    
    NSMutableDictionary *attrsSel = [NSMutableDictionary dictionary];
    
    attrsSel[NSForegroundColorAttributeName] = TabBarColor(64, 64, 64);
    attrsSel[NSFontAttributeName] = TabButtonTitleFont;
    
    [item setTitleTextAttributes:attrsSel forState:UIControlStateSelected];
}

//重写addChildViewController方法
-(void)addChildViewController:(UIViewController *)childController
{
    CommonNavigationController *navC = [[CommonNavigationController alloc] initWithRootViewController:childController];
    
    
    [super addChildViewController:navC];
}


-(void)setUpAllChildViewController
{
    //首页
    MainTableViewController *mainVC = [[MainTableViewController alloc] init];
    [self addChildViewController:mainVC];
    
    // 发现
    DiscoveryTableViewController *DiscoveryVC = [[DiscoveryTableViewController alloc] init];
    [self addChildViewController:DiscoveryVC];
    
    //消息
    MessageTableViewController *MessageVC = [[MessageTableViewController alloc] init];
    [self addChildViewController:MessageVC];
    
    // 我的
    MeTableViewController *meVC = [[MeTableViewController alloc] init];
    [self addChildViewController:meVC];
}

-(void)setUpAllTabButton
{
    // 首页
    UIViewController *mainNaVC = self.childViewControllers[0];
    mainNaVC.tabBarItem.title = @"首页";
    //    mainNaVC.tabBarItem.image = [UIImage imageNamed:@"tabBar_me_icon"];
    //    mainNaVC.tabBarItem.selectedImage = [UIImage imageNamedWithOriganlMode:@"tabBar_me_click_icon"];
    
    // 发现
    UIViewController *discoveryNaVC = self.childViewControllers[1];
    discoveryNaVC.tabBarItem.title = @"发现";
    //    discoveryNaVC.tabBarItem.image = [UIImage imageNamed:@"tabBar_friendTrends_icon"];
    //    discoveryNaVC.tabBarItem.selectedImage = [UIImage imageNamedWithOriganlMode:@"tabBar_friendTrends_click_icon"];
    
    //消息
    UIViewController *messageNaVC = self.childViewControllers[2];
    messageNaVC.tabBarItem.title = @"消息";
//    messageNaVC.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon"];
//    messageNaVC.tabBarItem.selectedImage = [UIImage imageNamedWithOriganlMode:@"tabBar_essence_click_icon"];
    
    
    // 我的
    UIViewController *meNaVC = self.childViewControllers[3];
    meNaVC.tabBarItem.title = @"我的";
//    meNaVC.tabBarItem.image = [UIImage imageNamed:@"tabBar_new_icon"];
//    meNaVC.tabBarItem.selectedImage = [UIImage imageNamedWithOriganlMode:@"tabBar_new_click_icon"];
    
    

    

    
}




@end
