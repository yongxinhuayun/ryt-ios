//
//  LognController.m
//  融易投
//
//  Created by efeiyi on 16/3/31.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "LognController.h"

#import "RegViewController.h"
#import "ForgetPasswordViewController.h"

#import "MBProgressHUD+YXL.h"
#import "SSTextField.h"

#import <MJExtension.h>

#import "BQLAuthEngine.h"
#import "UserMyModel.h"

@interface LognController ()
{
    BQLAuthEngine *_bqlAuthEngine;
}

@property (weak, nonatomic) IBOutlet UIButton *lognButton;

@property (weak, nonatomic) IBOutlet SSTextField *usernameTextField;
@property (weak, nonatomic) IBOutlet SSTextField *passwordTextField;

@end


@implementation LognController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化微信登录控制类
     _bqlAuthEngine = [[BQLAuthEngine alloc] init];
    
    self.navigationItem.title = @"登录"; 
    
    [UserMyModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"id",
                 };
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (IBAction)lognBtnClick:(id)sender {
    
    [self loadData];
}

//微信登录
- (IBAction)weixinBtnClick:(id)sender {
    
    [_bqlAuthEngine authLoginWeChatWithSuccess:^(id response) {
        
        NSLog(@"success:%@",response);
        
    } Failure:^(NSError *error) {
        
        NSLog(@"failure:%@",error);
    }];
}
- (IBAction)registerBtnClick:(id)sender {
    
    RegViewController *reg = [[RegViewController alloc] init];
    
    [self.navigationController pushViewController:reg animated:YES];
}

- (IBAction)forgetPWDBtnClick:(id)sender {
    
    ForgetPasswordViewController *forgetPWD = [[ForgetPasswordViewController alloc] init];
    [self.navigationController pushViewController:forgetPWD animated:YES];
}



-(void)loadData
{
    
    if (self.usernameTextField.text.length < 11) {
        
        [MBProgressHUD showError:@"请输入完整的手机号"];
        return;
    }
    if(![self.usernameTextField isValidPhone])
    {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    
    [MBProgressHUD showMessage:nil];
    
    
    //参数
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text ;

    NSString *urlStr = @"login.do";

    NSDictionary *json = @{
                           @"username" : username,
                           @"password" : password,
                           };
    
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:urlStr parameters:json showHUDView:nil andBlock:^(id respondObj) {
        
//        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
//        NSLog(@"返回结果:%@",jsonStr);
        
        /*
         {
         "count1":0,"userInfo":{"id":"imhfp1yr4636pj49","username":"18513234278","name":null,"name2":"18513234278","password":"11111111","status":1,"confirmPassword":null,"oldPassword":null,"enabled":true,"accountExpired":false,"accountLocked":false,"credentialsExpired":false,"utype":null,"lastLoginDatetime":null,"lastLogoutDatetime":null,"createDatetime":1459498453000,"source":null,"fullName":"null[18513234278]","accountNonExpired":true,"accountNonLocked":true,"credentialsNonExpired":true},"roiMoney":0.00,"flag":"1","rate":0.00,"investsMoney":0.00,"resultCode":"0","count":0,"userBrief":null,"resultMsg":"成功"
         }
         */
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        
        UserMyModel *userMyModel = [UserMyModel mj_objectWithKeyValues:dict[@"userInfo"]];
        
        NSString *ID = userMyModel.ID;

        SaveUserID(ID);
        
//        NSString *a = TakeUserID;
//        SSLog(@"%@",a);
        
//        NSString *LognInfo = dict[@"resultMsg"];
        
         [MBProgressHUD hideHUD];
        
        if (dict[@"resultCode"] != 0) {
             [MBProgressHUD showSuccess:@"登录成功"];

        }else { //登录失败
             [MBProgressHUD showError:@"登录失败"];
        }
        

        //在主线程刷新UI数据
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [MBProgressHUD hideHUD];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ChangeRootViewControllerNotification object:self userInfo:@{@"message":@"1"}];
            
        }];
      
        
    }];
}



@end
