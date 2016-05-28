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


#import "SSTextField.h"

#import <MJExtension.h>

#import "BQLAuthEngine.h"
#import "UserMyModel.h"
#import "RYTLoginManager.h"
#import "WXLoginModel.h"

@interface LognController ()
{
    BQLAuthEngine *_bqlAuthEngine;
}

@property (weak, nonatomic) IBOutlet UIButton *lognButton;

@property (weak, nonatomic) IBOutlet SSTextField *usernameTextField;
@property (weak, nonatomic) IBOutlet SSTextField *passwordTextField;

@property (nonatomic, strong) WXLoginModel *WXModel;

@end


@implementation LognController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化微信登录控制类
     _bqlAuthEngine = [[BQLAuthEngine alloc] init];
    
    
    [self setUpNavBar];
    
    [UserMyModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"id",
                 };
    }];
}

// 设置导航条
-(void)setUpNavBar
{
    //设置导航条标题
    self.navigationItem.title = @"登录";
    
    //右边
    UIImage *image = [UIImage imageNamed:@"denglu_guanbi"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:0 target:self action:@selector(btnClick)];
    
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

-(void)btnClick{
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
        
        NSDictionary *dict = (NSDictionary *)response;
        
        WXLoginModel *WXModel = [WXLoginModel mj_objectWithKeyValues:dict];
        self.WXModel = WXModel;
        
        [self weixinLoadData];

    } Failure:^(NSError *error) {
        
        NSLog(@"failure:%@",error);
    }];
}

-(void)weixinLoadData
{
    //参数
    NSString *nickname = self.WXModel.nickname;
    NSString *unionid = self.WXModel.unionid;
    NSString *headimgurl = self.WXModel.headimgurl;
    
    NSString *urlStr = @"WxLogin.do";
    NSDictionary *json = @{
                           @"nickname" : nickname,
                           @"unionid" : unionid,
                           @"headimgurl":headimgurl
                           };
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:urlStr parameters:json showHUDView:nil andBlock:^(id respondObj) {
        
        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        NSLog(@"返回结果:%@",jsonStr);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        [MBProgressHUD hideHUD];
        NSString *resultCode = dict[@"resultCode"];
        if ([resultCode intValue] == 0) {
            [MBProgressHUD showSuccess:@"登录成功"];
            //登录实体类
            NSString *registrationID = [[NSUserDefaults standardUserDefaults] valueForKey:@"registrationID"];
            UserMyModel *userMyModel = [UserMyModel mj_objectWithKeyValues:dict[@"userInfo"]];
            RYTLoginManager *manager = [RYTLoginManager shareInstance];
            [manager loginSuccess:userMyModel];
            //登录成功的时候注册用户的registrationId
            //注册 registrationID
            if (registrationID && (manager.takeUser != nil)) {
                NSDictionary *json = @{
                                       @"cid":registrationID,
                                       @"id":userMyModel.ID
                                       };
                [[HttpRequstTool shareInstance] loadData:POST serverUrl:@"wxBinding.do" parameters:json showHUDView:nil andBlock:^(id respondObj) {
//                    NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
//                    NSLog(@"返回结果:%@",jsonStr);
                    // TODO
                }];
                
            }
            //在主线程刷新UI数据
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                //发送通知,修改我的界面的数据
                [[NSNotificationCenter defaultCenter] postNotificationName:UpdateMeViewDataControllerNotification object:self];
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        }else { //登录失败
            [MBProgressHUD showError:@"登录失败"];
        }
        
    }];
}

- (IBAction)registerBtnClick:(id)sender {
    
    RegViewController *reg = [[RegViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:reg];
////    [self addChildViewController:nav];
    
    [self.navigationController pushViewController:reg animated:YES];
}

- (IBAction)forgetPWDBtnClick:(id)sender {
    
    ForgetPasswordViewController *forgetPWD = [[ForgetPasswordViewController alloc] init];
//     UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:forgetPWD];
//     [self presentViewController:nav animated:YES completion:nil];
    
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
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
         [MBProgressHUD hideHUD];
        NSString *resultCode = dict[@"resultCode"];
        if ([resultCode intValue] == 0) {
            [MBProgressHUD showSuccess:@"登录成功"];
            //登录实体类
            NSString *registrationID = [[NSUserDefaults standardUserDefaults] valueForKey:@"registrationID"];
            UserMyModel *userMyModel = [UserMyModel mj_objectWithKeyValues:dict[@"userInfo"]];
            RYTLoginManager *manager = [RYTLoginManager shareInstance];
            [manager loginSuccess:userMyModel];
            //登录成功的时候注册用户的registrationId
            //注册 registrationID
            if (registrationID && (manager.takeUser != nil)) {
                NSDictionary *json = @{
                                       @"cid":registrationID,
                                       @"username":userMyModel.username,
                                       @"password":self.passwordTextField.text,
                                       };
                [[HttpRequstTool shareInstance] loadData:POST serverUrl:@"userBinding.do" parameters:json showHUDView:nil andBlock:^(id respondObj) {
//                    NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
//                    NSLog(@"返回结果:%@",jsonStr);
                    // TODO
                }];

            }
            //在主线程刷新UI数据
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                //发送通知,修改我的界面的数据
                [[NSNotificationCenter defaultCenter] postNotificationName:UpdateMeViewDataControllerNotification object:self];
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        }else { //登录失败
             [MBProgressHUD showError:@"登录失败"];
        }
//        [MBProgressHUD hideHUD];
    }];
}



@end
