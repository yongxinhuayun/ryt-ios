//
//  RegViewController.m
//  融易投
//
//  Created by dongxin on 16/3/31.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "RegViewController.h"

#import "LognController.h"

#import "SVProgressHUD.h"
#import "MJExtension.h"
#import "registerModel.h"

#import "MBProgressHUD+YXL.h"
#import "SSTextField.h"
#import "BQLAuthEngine.h"

@interface RegViewController () <UITextFieldDelegate>
{
    int countSecond;
    NSTimer *countTimer;
    BQLAuthEngine *_bqlAuthEngine;
}

//控件
@property (weak, nonatomic) IBOutlet SSTextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UIButton *verifyCodeBtn;

//模型数组
@property (nonatomic, strong) NSArray *registers;

/** 验证验证码成功 0 为成功  保存起来注册的时候根据辞职进行判断 */
@property (nonatomic ,strong) NSString *resultCode;

/** 注册信息提示 */
@property (nonatomic ,strong) NSString *resultMsg;

@end

@implementation RegViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [registerModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        
        return @{
                 @"ID":@"id",
                 };
    }];
    
    //设置导航条
    [self setUpNavBar];
    
     countSecond=60;
    
    //初始化微信登录控制类
    _bqlAuthEngine = [[BQLAuthEngine alloc] init];
    
    //监听验证输入框的状态
    self.verifyCodeTextField.delegate = self;
}

//当编辑结束验证验证码
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    
}

// 设置导航条
-(void)setUpNavBar
{
    //设置导航条标题
    self.navigationItem.title = @"加入融艺投";
    
    //左边
//    UIImage *image = [UIImage imageNamed:@"fanhui"];
//    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    
//    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:0 target:self action:@selector(btnClick)];
//    
//    self.navigationItem.leftBarButtonItem = barButtonItem;
}

-(void)btnClick{

    [self.navigationController popViewControllerAnimated:YES];
}


//注册
- (IBAction)regBtn:(id)sender {
    
    if (self.phoneNumTextField.text.length < 11) {
        
        [MBProgressHUD showError:@"请输入完整的手机号"];
        return;
    }
    if(![self.phoneNumTextField isValidPhone])
    {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    //验证验证码
    [self loadDataAuth];
    if ([self.resultCode isEqualToString:@"0"]) {
        [self loadData];
    }
}

//微信登录
- (IBAction)WXLogin:(UIButton *)btn {
    
    [_bqlAuthEngine authLoginWeChatWithSuccess:^(id response) {
        
        NSLog(@"success:%@",response);
        
    } Failure:^(NSError *error) {
        
        NSLog(@"failure:%@",error);
    }];
}

//发送验证码
- (IBAction)geName:(UIButton *)btn {
    
    btn.enabled=NO;
    
    [btn setTitle:[NSString stringWithFormat:@"%@(%d)",@"重发",countSecond] forState:UIControlStateDisabled];
    countTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(count:) userInfo:nil repeats:YES];
    
    //发送网络请求
    [self loadDataget];
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

// 18210800956

//发送验证码
-(void)loadDataget
{
    if (self.phoneNumTextField.text.length < 11) {
        
        [MBProgressHUD showError:@"请输入完整的手机号"];
        return;
    }
    if(![self.phoneNumTextField isValidPhone])
    {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    [MBProgressHUD showMessage:nil];
    //参数
    NSString *username = self.phoneNumTextField.text;
    NSString *urlStr = @"sendCode.do";
    // 3.设置请求体
    NSDictionary *json = @{
                           @"username" : username
                           };
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:urlStr parameters:json showHUDView:nil andBlock:^(id respondObj) {

        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        NSLog(@"返回结果:%@",jsonStr);
        /*
         {"resultCode":"0","message":"OK","resultMsg":"成功"}
         */
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

//验证验证码
-(void)loadDataAuth
{
    //参数
    NSString *username = self.phoneNumTextField.text;
    NSString *code = self.verifyCodeTextField.text;
    NSString *urlStr = @"verifyCode.do";
      // 3.设置请求体
    NSDictionary *json = @{
                           @"username" : username,
                           @"code" : code
                           };
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:urlStr parameters:json showHUDView:nil andBlock:^(id respondObj) {
//        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
//        NSLog(@"返回结果:%@",jsonStr);
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

        }];
    }];
}

//注册
-(void)loadData
{
    [MBProgressHUD showMessage:nil];
    //参数
    NSString *username = self.phoneNumTextField.text;
    NSString *password = self.passWordTextField.text;
    
    NSString *urlStr = @"register.do";
    
    NSDictionary *json = @{
                           @"username" : username,
                           @"password" : password,
                           };
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:urlStr parameters:json showHUDView:nil andBlock:^(id respondObj) {
        
//        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
//        NSLog(@"返回结果:%@",jsonStr);
        //字典转模型暂时不需要
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        NSArray *registerArray = dict[@"userInfo"];
        self.registers = [registerModel mj_objectArrayWithKeyValuesArray:registerArray];
        //提示用户信息
        [MBProgressHUD hideHUD];
        //在主线程刷新UI数据
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSString *resultCode = dict[@"resultCode"];
            if ([resultCode intValue] == 0) {
                [MBProgressHUD showSuccess:@"注册成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else { //登录失败
                [MBProgressHUD showError:@"注册失败"];
            }
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
