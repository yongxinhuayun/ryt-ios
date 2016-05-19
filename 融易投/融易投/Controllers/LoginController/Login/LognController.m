//
//  LognController.m
//  融易投
//
//  Created by efeiyi on 16/3/31.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "LognController.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

#import "RegViewController.h"
#import "ForgetPasswordViewController.h"

#import <SVProgressHUD.h>
#import "BQLAuthEngine.h"

#define serverULR @"http://j.efeiyi.com:8080/app-wikiServer/app/login.do"

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
    
    [self setUpNavBar];
}

// 设置导航条
-(void)setUpNavBar
{
    //设置导航条标题
    self.navigationItem.title = @"登录";
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
    
    [self test];
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
    //时间
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a =[date timeIntervalSince1970] * 1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    
    NSArray *strArray = [timeString componentsSeparatedByString:@"."];
    
    NSLog(@"%@",strArray.firstObject);
    
    //参数
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *timestamp = strArray.firstObject;
    NSString *appkey = @"BL2QEuXUXNoGbNeHObD4EzlX+KuGc70U";
    
    NSLog(@"username=%@,password=%@,timestamp=%@",username,password,timestamp);
    
    NSLog(@"111");
    
    NSArray *arra = @[@"username",@"password",@"timestamp"];
    NSArray *sortArr = [arra sortedArrayUsingSelector:@selector(compare:)];
    NSLog(@"%@",sortArr);
    
    NSString *signmsg = [NSString stringWithFormat:@"password=%@&timestamp=%@&username=%@&key=%@",password,timestamp,username,appkey];
    NSLog(@"%@",signmsg);
    
    NSString *signmsgMD5 = [self md5:signmsg];
    
    //对key进行自然排序
    //    for (NSString *s in [dict allKeys]) {
    //        NSLog(@"value: %@", s);
    //    }
    
    NSLog(@"signmsgMD5=%@",signmsgMD5);
    
    // 1.创建请求
    NSURL *url = [NSURL URLWithString:@"http://j.efeiyi.com:8080/app-wikiServer/app/login.do"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    // 2.设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"username" : username,
                           @"password" : password,
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    
    //    NSData --> NSDictionary
    // NSDictionary --> NSData
    NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPBody = data;
    
    
    // 4.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
//        NSString *obj =  [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",obj);

        //5. 解析从服务器获取的JSON数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        NSLog(@"%@",dict);
        
        /*
         {
         "userInfo":{"id":"imhipoyk18s4k52u","username":"18513234278","name":null,"name2":null,"password":"11111111","status":1,"confirmPassword":null,"oldPassword":null,"enabled":true,"accountExpired":false,"accountLocked":false,"credentialsExpired":false,"utype":null,"lastLoginDatetime":null,"lastLogoutDatetime":null,"createDatetime":1459503521000,"source":null,"fullName":"null[18513234278]","credentialsNonExpired":true,"accountNonExpired":true,"accountNonLocked":true},
         "resultCode":"0",
         "resultMsg":"成功"
         }
         */
        
        NSString *LognInfo = dict[@"resultMsg"];
        
        if (dict[@"resultCode"] != 0) {
            
             [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"登录%@",LognInfo]];
            
            
            
        }else { //登录失败
            
           [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",LognInfo]];
        }
        
        
    }];
}

-(void)test {

    //时间
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a =[date timeIntervalSince1970] * 1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    
    NSArray *strArray = [timeString componentsSeparatedByString:@"."];
    
    NSLog(@"%@",strArray.firstObject);
    
    //参数
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *timestamp = strArray.firstObject;
    NSString *appkey = @"BL2QEuXUXNoGbNeHObD4EzlX+KuGc70U";
    
    
    NSArray *arra = @[@"username",@"password",@"timestamp"];
    NSArray *sortArr = [arra sortedArrayUsingSelector:@selector(compare:)];
    NSLog(@"%@",sortArr);
    
    NSString *signmsg = [NSString stringWithFormat:@"password=%@&timestamp=%@&username=%@&key=%@",password,timestamp,username,appkey];
    NSLog(@"%@",signmsg);
    
    NSString *signmsgMD5 = [MyMD5 md5:signmsg];
    NSLog(@"signmsgMD5=%@",signmsgMD5);
    
    
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"username" : username,
                           @"password" : password,
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    
    [[HttpRequstTool shareInstance] handlerNetworkingPOSTRequstWithServerUrl:serverULR Parameters:json showHUDView:self.view success:^(id respondObj) {
        
        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        NSLog(@"返回结果:%@",jsonStr);
    }];
    
}


-(NSString *) md5: (NSString *) inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}



@end
