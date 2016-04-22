//
//  CommonNavigationController.m
//  融易投
//
//  Created by efeiyi on 16/3/30.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "CommonNavigationController.h"

@interface CommonNavigationController ()<UINavigationControllerDelegate>

@property (nonatomic, strong) id popDelegate;

@end

@implementation CommonNavigationController

//因为导航条的字体大小只需要设置一次,所以写在 load 方法中
+(void)load
{
    //获取使用自定义导航控制器的全局navigationItem
    UINavigationBar *navigationBar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    attributes[NSFontAttributeName] = [UIFont boldSystemFontOfSize:17];
    
    [navigationBar setTitleTextAttributes:attributes];
    
    // 设置导航条背景图片
    // 注意: iOS9之前,如果不使用UIBarMetricsDefault,默认导航控制器的根控制器的尺寸,会少64的高度.
    // UIBarMetricsDefault:必须设置默认
//    [navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
}

//但是我们只在设置界面修改返回按钮,也只能修改设置界面的返回按钮,但是我们希望只要一个界面能够push就能修改返回按钮
//我们知道,要想出现返回,必须是导航控制器执行push方法,才能出现系统的返回按钮,所以我们可以重写系统导航控制器的push方法,直接在方法里面修改返回按钮的样式
//我们项目中已经自定义了导航控制器,所以直接在自定义导航控制器重写push方法
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 不是根控制器才需要设置
    if (self.childViewControllers.count > 0) { //等于0代表是根控制器 因为重写了系统的pushViewController方法,当程序一运行执行BSTabBarController中的initWithRootViewController方法(此方法底层会调用pushViewController方法),又因为我们把恢复系统的pushViewController方法写在这个后面,所以当程序一运行就加载tabbar,此时的childViewControllers的个数为0,然后执行系统的pushViewController方法,此时的个数就是一了.所以要是接下来的子控制器再次push的时候,此时的childViewControllers的个数至少为1,所以判断个数大于0就能排除根控制器了
        
        //1.实现左滑返回
        //因为我们覆盖掉了系统的返回按钮,所以滑动返回功能失效
        // 为什么失效? 1.排除手势就没有了 2.手势代理做了事情
        //我们先验证手势,调到系统的导航控制器看看有没有滑动手势
        /*
         @property(nullable, nonatomic, weak) id<UINavigationControllerDelegate> delegate;
         @property(nullable, nonatomic, readonly) UIGestureRecognizer *interactivePopGestureRecognizer NS_AVAILABLE_IOS(7_0) __TVOS_PROHIBITED;
         */
        //找到之后验证在覆盖系统返回按钮的时候手势是否被覆盖
        //打印发现都有值,排除手势
        //2.查看代理
        //打印结果为,并且代理打印都有值
        //<_UINavigationInteractiveTransition: 0x7f8342455a00>
        //因为创建手势之后,手势会调用自己的代理去实现一些事情,所以我们可以修改代理,把代理直接清空,不让代理去做一些事情(调用某个方法)
        
        
        // 不是根控制器
        // 设置返回按钮
        // 设置返回按钮,左边按钮
        UIBarButtonItem *backItem = [UIBarButtonItem backItemWithImage:[UIImage imageNamed:@"fanhui"] highImage:nil target:self action:@selector(back) norColor:[UIColor blackColor] highColor:[UIColor redColor] title:@""];
        
        //        NSLog(@"覆盖之前---%@",self.interactivePopGestureRecognizer);
        //        NSLog(@"覆盖之前---%@",self.interactivePopGestureRecognizer.delegate);
        
        //2. 清空代理
        //        self.interactivePopGestureRecognizer.delegate = nil;
        //运行程序,发现能实现左滑返回
        
        
        //3.但是我们在根控制器中多次在左边缘实现左滑,然后在点击设置,会出现假死状态
        //因为根控制器根本没有push,所以在根控制器的view,不需要滑动返回
        //要想让根控制器的view,不设置滑动返回,必须设置手势的代理,然后管理手势
        //所以我们把当前控制器(自定义导航控制器)设置成手势的dialing去管理手势的触发条件
        //实现手势的代理方法,排除根控制器的手势触发
        //因为设置代理只需要设置一次,所以我们可以把设置代理写在viewDidLoad 方法中
        //        self.interactivePopGestureRecognizer.delegate = self;
        
        //4.实现全屏左屏返回功能
        //我们先研究一下系统自带的返回手势
//        NSLog(@"%@",self.interactivePopGestureRecognizer);
        /*打印出来的结果,分析结果
         <UIScreenEdgePanGestureRecognizer: 0x7fe260640220; view = <UILayoutContainerView 0x7fe26062bba0>;
         target= <(action=handleNavigationTransition:,
         target=<_UINavigationInteractiveTransition 0x7fe26063f1a0>)>>
         
         1.UIScreenEdgePanGestureRecognizer加在导航控制器的view上
         
         2.target:_UINavigationInteractiveTransition
         
         3.action: handleNavigationTransition:
         
         触发UIScreenEdgePanGestureRecognizer就会调用target的handleNavigationTransition:方法
         所以我们可以根据系统调用的方法,直接添加一个全屏的时候,然后调用系统实现左滑的方法即可
         因为手势只需要设置一次,所以我们写在viewDidLoad方法中
         */
        
        //5. 因为隐藏tabbar需要设置在push之前所以,写在这里即可
        //以后就不用单独设置这个了
        viewController.hidesBottomBarWhenPushed = YES;
        
        
        //这里就是修改了系统的返回按钮,所以我们可以在这句代码前后查看一些东西
        viewController.navigationItem.leftBarButtonItem = backItem;
        
        //        NSLog(@"覆盖之后---%@",self.interactivePopGestureRecognizer);
        //        NSLog(@"覆盖之后---%@",self.interactivePopGestureRecognizer.delegate);
        
        
    }
    
    // 这个方法才是真正跳转
    [super pushViewController:viewController animated:animated];
    
    /*出现的问题
     // bug:假死:程序一直运行,但是界面动不了.
     // 在根控制器的view,不需要滑动返回,
     */
}

#pragma mark - UIGestureRecognizerDelegate
// 控制手势是否触发
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    //    return NO; 不触发
    //设置根控制器不触发左滑
    //所以要先判断什么时候是根控制器
    // 要是根控制器的时候,self.childViewControllers.count就是为1.所以排除
    return self.childViewControllers.count != 1;
    
}


// 点击返回按钮,回到上一个界面
- (void)back
{
    // self -> 导航控制器
    [self popViewControllerAnimated:YES];
    
}

//14.实现代理方法
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSLog(@"%@",viewController);
    
    //childViewControllers第一个就是根控制器
    if (viewController == self.childViewControllers[0]) {
        //恢复滑动返回手势代理
        self.interactivePopGestureRecognizer.delegate = _popDelegate;
    }
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // 实现滑动返回功能
    //    self.interactivePopGestureRecognizer.delegate = self;
    
    //因为我们要让系统的代理去帮我们实现左滑功能,并且我们要调用系统的默认实现左滑功能的方法
    //所以,我们的监听对象就是系统实现左滑的代理
    
    //创建全屏的滑动手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    
    
    //因为我们要实现全屏滑动,所以我们需要把自定义的手势的代理设置成自定义导航控制器,让他去管理手势什么时候触发
    //所以,把之前的代理注释掉
    pan.delegate = self;
    
    //把手势添加到导航控制器的view上
    [self.view addGestureRecognizer:pan];
    
    //因为我们把系统的手势覆盖掉了,所以为了防止意外,把系统的手势禁止掉
    self.interactivePopGestureRecognizer.enabled = NO;
    
    
}



@end
