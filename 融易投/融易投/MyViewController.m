//
//  MyViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/1.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "MyViewController.h"

#import "LognController.h"
#import "RegViewController.h"
#import "ForgetPasswordViewController.h"
#import "CompleteUserInfoController.h"

@interface MyViewController ()

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpNavBar];
}

// 设置导航条
-(void)setUpNavBar
{
    //设置导航条标题
    self.navigationItem.title = @"我的";
    
//    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mine-setting-icon"] highImage:[UIImage imageNamed:@"mine-setting-icon-click"] target:self action:@selector(settting)];
    
//    UIBarButtonItem *nightItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mine-moon-icon"] selImage:[UIImage imageNamed:@"mine-moon-icon-click"] target:self action:@selector(night:)];
    //运行程序,发现点击还是不能实现保持选中状态
    // 按钮达到选中状态,必须通过代码实现,所以我们在按钮的点击方法中进行设置
    
    
//    self.navigationItem.rightBarButtonItems = @[settingItem,nightItem];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (IBAction)loginBtnClick:(id)sender {
    
    LognController *login = [[LognController alloc] init];
    
    [self.navigationController pushViewController:login animated:YES];
}

- (IBAction)registerBtnClick:(id)sender {
    
    RegViewController *reg = [[RegViewController alloc] init];
    [self.navigationController pushViewController:reg animated:YES];
}
- (IBAction)CompleteUserInfoBtnClick:(id)sender {
    CompleteUserInfoController *userInfo  = [[CompleteUserInfoController alloc] init];
    [self.navigationController pushViewController:userInfo animated:YES];
}
- (IBAction)ForgetPasswordBtnClick:(id)sender {
    ForgetPasswordViewController *forgetPassword = [[ForgetPasswordViewController alloc] init];
    [self.navigationController pushViewController:forgetPassword animated:YES];
}

@end
