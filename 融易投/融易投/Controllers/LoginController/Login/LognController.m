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

#import <SVProgressHUD.h>

#import <MJExtension.h>

#import "BQLAuthEngine.h"
#import "UserAccount.h"

@interface LognController ()
{
    BQLAuthEngine *_bqlAuthEngine;
}

@property (weak, nonatomic) IBOutlet UIButton *lognButton;

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

//@property (nonatomic ,weak)  AFHTTPSessionManager *mgr;

@end

@implementation LognController

- (void)viewDidLoad {
    [super viewDidLoad];
     _bqlAuthEngine = [[BQLAuthEngine alloc] init];
    self.navigationItem.title = @"登录";
    [UserAccount mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
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
    
//    if ([self isValidateMobile:self.usernameTextField.text] == NO) {
//        
//        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
//    }
//    
//    if ([self isValidatePWD:self.passwordTextField.text] == NO) {
//        
//        [SVProgressHUD showErrorWithStatus:@"请输入正确的密码格式"];
//    }
//    
//    if ([self isValidateMobile:self.usernameTextField.text] == YES  && [self isValidatePWD:self.passwordTextField.text] == YES) {
//        
////        [self test];
//        
//        [SVProgressHUD showWithStatus:@"正在登录中..."];
//    }
    
    [self loadData];
}

//手机号码的正则表达式
- (BOOL)isValidateMobile:(NSString *)mobile{
    //手机号以13、15、18开头，八个\d数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

//密码的正则表达式
- (BOOL)isValidatePWD:(NSString *)pwd{
    NSString *pwdRegex = @"^[a-zA-Z]|[0-9]{6,18}$";
    NSPredicate *pwdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pwdRegex];
    return [pwdTest evaluateWithObject:pwd];
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
    //参数
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;

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
        
        UserAccount *userAccount = [UserAccount mj_objectWithKeyValues:dict[@"userInfo"]];
        
        NSString *ID = userAccount.ID;

        SaveUserID(ID);
        
//        NSString *a = TakeUserID;
//        SSLog(@"%@",a);
        
        NSString *LognInfo = dict[@"resultMsg"];
        
        if (dict[@"resultCode"] != 0) {
            
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"登录%@",LognInfo]];
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];

        }else { //登录失败
            
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",LognInfo]];
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        }
        

        //在主线程刷新UI数据
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [SVProgressHUD dismiss];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ChangeRootViewControllerNotification object:self userInfo:@{@"message":@"1"}];
            
        }];
      
        
    }];
}

@end
