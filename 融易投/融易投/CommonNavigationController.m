//
//  CommonNavigationController.m
//  融易投
//
//  Created by efeiyi on 16/3/30.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "CommonNavigationController.h"

@interface CommonNavigationController ()<UIGestureRecognizerDelegate>


@end

@implementation CommonNavigationController

//因为导航条的字体大小只需要设置一次,所以写在 load 方法中
+(void)load
{
    //获取使用自定义导航控制器的全局navigationItem
    UINavigationBar *navigationBar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    attributes[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    
    [navigationBar setTitleTextAttributes:attributes];
    
    // 设置导航条背景图片
    // 注意: iOS9之前,如果不使用UIBarMetricsDefault,默认导航控制器的根控制器的尺寸,会少64的高度.
    // UIBarMetricsDefault:必须设置默认
//    [navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
}

//在自定义导航控制器重写push方法
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 不是根控制器才需要设置
    if (self.childViewControllers.count > 0) {
        
        viewController.hidesBottomBarWhenPushed = YES;
                
    }
    
    // 这个方法才是真正跳转
    [super pushViewController:viewController animated:animated];
}





@end
