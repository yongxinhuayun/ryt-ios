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
#import "RankTableViewController.h"
#import "MainTableViewController.h"
#import "MeViewController.h"


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
    attrsNor[NSForegroundColorAttributeName] = TabBarColor(191, 191, 191);
    attrsNor[NSFontAttributeName] = TabButtonTitleFont;
    
    [item setTitleTextAttributes:attrsNor forState:UIControlStateNormal];
    
    
    NSMutableDictionary *attrsSel = [NSMutableDictionary dictionary];
    
    attrsSel[NSForegroundColorAttributeName] = TabBarColor(239, 91, 112);
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
    
    // 排行
    RankTableViewController *DiscoveryVC = [[RankTableViewController alloc] init];
    [self addChildViewController:DiscoveryVC];
    
    //消息
//    MessageTableViewController *MessageVC = [[MessageTableViewController alloc] init];
//    [self addChildViewController:MessageVC];
    UIStoryboard *MessageStoryBoard = [UIStoryboard storyboardWithName:NSStringFromClass([MessageTableViewController class]) bundle:nil];
    
    MessageTableViewController *MessageV = [MessageStoryBoard instantiateInitialViewController];
    [self addChildViewController:MessageV];
    
    // 我的
    MeViewController *meVC = [[MeViewController alloc] init];
    [self addChildViewController:meVC];
}

-(void)setUpAllTabButton
{
    // 首页
    UIViewController *mainNaVC = self.childViewControllers[0];
    mainNaVC.tabBarItem.title = @"首页";
    mainNaVC.tabBarItem.image = [UIImage imageNamed:@"shouye_weixuanze"];
    mainNaVC.tabBarItem.selectedImage = [UIImage imageNamedWithOriganlMode:@"shouye_yixuanze"];
    
    // 排行
    UIViewController *rankNaVC = self.childViewControllers[1];
    rankNaVC.tabBarItem.title = @"排行";
    rankNaVC.tabBarItem.image = [UIImage imageNamed:@"paihang_weixuanze"];
    rankNaVC.tabBarItem.selectedImage = [UIImage imageNamedWithOriganlMode:@"paihang_yixuanze"];
    
    //消息
    UIViewController *messageNaVC = self.childViewControllers[2];
    messageNaVC.tabBarItem.title = @"消息";
    messageNaVC.tabBarItem.image = [UIImage imageNamed:@"xiaoxi_weixuanze"];
    messageNaVC.tabBarItem.selectedImage = [UIImage imageNamedWithOriganlMode:@"xiaoxi_yixuanze"];
    
    
    // 我的
    UIViewController *meNaVC = self.childViewControllers[3];
    meNaVC.tabBarItem.title = @"我的";
    meNaVC.tabBarItem.image = [UIImage imageNamed:@"wode_weixuanze"];
    meNaVC.tabBarItem.selectedImage = [UIImage imageNamedWithOriganlMode:@"wode_yixuanze"];
    
}




@end
