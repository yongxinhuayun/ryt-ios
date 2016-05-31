//
//  ForgetPasswordViewController.m
//  融易投
//
//  Created by efeiyi on 16/3/31.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "SSTextField.h"


@interface ForgetPasswordViewController ()<UITextFieldDelegate>
{
    int countSecond;
    NSTimer *countTimer;
}

@property (weak, nonatomic) IBOutlet UIButton *verifyCodeBtn;
@property (weak, nonatomic) IBOutlet SSTextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *PWDTextField;

/** 验证验证码成功 0 为成功  保存起来注册的时候根据辞职进行判断 */
@property (nonatomic ,strong) NSString *resultCode;

/** 注册信息提示 */
@property (nonatomic ,strong) NSString *resultMsg;

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavBar];
    
    countSecond=60;
    self.verifyCodeTextField.delegate = self;
}

// 设置导航条
-(void)setUpNavBar
{
    //设置导航条标题
    self.navigationItem.title = @"忘记密码";
    
    //左边
    UIImage *image = [UIImage imageNamed:@"fanhui"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:0 target:self action:@selector(btnClick)];
    
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

-(void)btnClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//发送验证码
- (IBAction)sendVerifyCodeBtnClick:(UIButton *)btn {

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
    
    btn.enabled=NO;
    
    [btn setTitle:[NSString stringWithFormat:@"%@(%d)",@"重发",countSecond] forState:UIControlStateDisabled];
    countTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(count:) userInfo:nil repeats:YES];
    
    //发送验证码
    [self sendVerifyCode];
}

-(void)count:(NSTimer *)timer{
    
    countSecond -- ;
    [self.verifyCodeBtn setTitle:[NSString stringWithFormat:@"%@(%d)",@"重发",countSecond] forState:UIControlStateDisabled];
    if(countSecond == 0){
        self.verifyCodeBtn.enabled = YES;
        [timer invalidate];
        countSecond = 60;
        [self.verifyCodeBtn setTitle:[NSString stringWithFormat:@"%@(%d)",@"重发",countSecond] forState:UIControlStateDisabled];
    }
}

//修改密码
- (IBAction)wanchengBtnClick:(UIButton *)btn {
    
    if (self.usernameTextField.text.length < 11) {
        
        [MBProgressHUD showError:@"请输入完整的手机号"];
        return;
    }
    if(![self.usernameTextField isValidPhone])
    {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    //验证验证码
    [self validateVerifyCode];
}

//验证验证码
-(void)validateVerifyCode{

    //参数
    NSString *username = self.usernameTextField.text;
    NSString *code = self.verifyCodeTextField.text;
    NSString *urlStr = @"verifyCode.do";
    NSDictionary *json = @{
                           @"username" : username,
                           @"code" : code
                           };
    

    [[HttpRequstTool shareInstance] loadData:POST serverUrl:urlStr parameters:json showHUDView:nil andBlock:^(id respondObj) {
        
        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        NSLog(@"返回结果:%@",jsonStr);
        //字典转模型暂时不需要
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        NSString *resultCode = dict[@"resultCode"];
        if ([resultCode intValue] == 0) {
            [MBProgressHUD showSuccess:@"验证码发送成功"];
            self.resultCode = resultCode;
        }else { //登录失败
            [MBProgressHUD showError:@"验证码发送失败,请重新发送"];
        }
        //在主线程刷新UI数据
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [MBProgressHUD hideHUD];
            
            if ([self.resultCode isEqualToString:@"0"]) {
                //更改密码
                [self changePassword];
            }
        }];
        
    }];
}

//发送验证码
-(void)sendVerifyCode{
    
    //参数
    NSString *username = self.usernameTextField.text;
    
    NSString *urlStr = @"sendCode.do";
    
    NSDictionary *json = @{
                           @"username" : username
                           };
    
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:urlStr parameters:json showHUDView:nil andBlock:^(id respondObj) {
        
        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        NSLog(@"返回结果:%@",jsonStr);
        //字典转模型暂时不需要
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        //提示用户信息
        [MBProgressHUD hideHUD];
        NSString *resultCode = dict[@"resultCode"];
        if ( [resultCode intValue] == 0) {
            [MBProgressHUD showSuccess:@"验证码发送成功"];
        }else { //登录失败
            [MBProgressHUD showError:@"验证码发送失败"];
        }
    }];
}

//更改密码
-(void)changePassword{
    
    //参数
    NSString *username = self.usernameTextField.text;
    NSString *password = self.PWDTextField.text;

    NSString *urlStr = @"retrievePassword.do";
    NSDictionary *json = @{
                           @"username" : username,
                           @"password" : password
                           };

    [[HttpRequstTool shareInstance] loadData:POST serverUrl:urlStr parameters:json showHUDView:nil andBlock:^(id respondObj) {
        
        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        NSLog(@"返回结果:%@",jsonStr);
        //字典转模型暂时不需要
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        //在主线程刷新UI数据
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSString *resultCode = dict[@"resultCode"];
            if ([resultCode intValue] == 0) {
                [MBProgressHUD showSuccess:@"更改密码成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else { //登录失败
                [MBProgressHUD showError:@"更改失败,请重新更改"];
            }
        
        }];
    }];
}
@end

