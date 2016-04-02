//
//  RegViewController.m
//  融易投
//
//  Created by dongxin on 16/3/31.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "RegViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

#import "SVProgressHUD.h"
#import "MJExtension.h"
#import "registerModel.h"

@interface RegViewController ()

//控件
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;

//模型数组
@property (nonatomic, strong) NSArray *registers;

/** 注册成功 0 为成功 */
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
    
    [self setUpNavBar];
}

// 设置导航条
-(void)setUpNavBar
{
    //设置导航条标题
    self.navigationItem.title = @"快速注册";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



- (IBAction)regBtn:(id)sender {
    [self loadData];
}

- (IBAction)geName:(id)sender {
    [self loadDataget];
}

- (IBAction)authBtb:(id)sender {
    [self loadDataAuth];
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
    NSString *username = self.phoneNumTextField.text;
    NSString *password = self.passWordTextField.text;
    NSString *timestamp = strArray.firstObject;
    NSString *appkey = @"BL2QEuXUXNoGbNeHObD4EzlX+KuGc70U";
    
    NSLog(@"username=%@,password=%@,timestamp=%@",username,password,timestamp);
    
    
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
    NSURL *url = [NSURL URLWithString:@"http://j.efeiyi.com:8080/app-wikiServer/app/register.do"];
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
        
        NSString *obj =  [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",obj);
        
        //字典转模型暂时不需要
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//
        NSArray *registerArray = dict[@"userInfo"];
//
        self.registers = [registerModel mj_objectArrayWithKeyValuesArray:registerArray];
        
        //提示用户信息
        NSString *resultMsg = dict[@"resultMsg"];
        
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@",resultMsg]];
        
        //保存注册信息
        [self saveUserInfo:dict[@"userInfo"]];
        
        /*
         请求报文：
          {
         "userInfo":{
            "id":"imhfp1yr4636pj49","username":"18513234278","name":null,"name2":null,"password":"11111111","status":1,"confirmPassword":null,"oldPassword":null,"enabled":true,"accountExpired":false,"accountLocked":false,"credentialsExpired":false,"utype":null,"lastLoginDatetime":null,"lastLogoutDatetime":null,"createDatetime":1459498453297,"source":null,"fullName":"null[18513234278]","accountNonExpired":true,"accountNonLocked":true,"credentialsNonExpired":true},
         "resultCode":"0",
         "resultMsg":"注册成功！"
         }
         */
        
    }];
    
}

-(void)saveUserInfo:(registerModel *)model{
    
    //NSUserDefaults  是个单例,但是取出不是shared
    [[NSUserDefaults standardUserDefaults] setObject:model.ID forKey:@"id"];
    [[NSUserDefaults standardUserDefaults] setObject:model.username forKey:@"username"];
}

-(void)readUserInfo:(registerModel *)model{

    NSString *id = [[NSUserDefaults standardUserDefaults] objectForKey:model.ID];
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:model.username];
}


-(void)loadDataget
{
    //时间
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a =[date timeIntervalSince1970] * 1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    
    NSArray *strArray = [timeString componentsSeparatedByString:@"."];
    
    NSLog(@"%@",strArray.firstObject);
    
    //参数
    NSString *username = self.phoneNumTextField.text;

    NSString *timestamp = strArray.firstObject;
    NSString *appkey = @"BL2QEuXUXNoGbNeHObD4EzlX+KuGc70U";
    
    NSLog(@"username=%@,,timestamp=%@",username,timestamp);
    
    
    NSArray *arra = @[@"username",@"timestamp"];
    NSArray *sortArr = [arra sortedArrayUsingSelector:@selector(compare:)];
    NSLog(@"%@",sortArr);
    
    NSString *signmsg = [NSString stringWithFormat:@"timestamp=%@&username=%@&key=%@",timestamp,username,appkey];
    NSLog(@"%@",signmsg);
    
    NSString *signmsgMD5 = [self md5:signmsg];
    
    //对key进行自然排序
    //    for (NSString *s in [dict allKeys]) {
    //        NSLog(@"value: %@", s);
    //    }
    
    NSLog(@"signmsgMD5=%@",signmsgMD5);
    
    // 1.创建请求
    NSURL *url = [NSURL URLWithString:@"http://j.efeiyi.com:8080/app-wikiServer/app/sendCode.do"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    // 2.设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"username" : username,
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    
    //    NSData --> NSDictionary
    // NSDictionary --> NSData
    NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPBody = data;
    
    // 4.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSString *obj =  [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",obj);
        
    }];
    
}
-(void)loadDataAuth
{
    //时间
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a =[date timeIntervalSince1970] * 1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    
    NSArray *strArray = [timeString componentsSeparatedByString:@"."];
    
    NSLog(@"%@",strArray.firstObject);
    
    //参数
    NSString *username = self.phoneNumTextField.text;
    NSString *code = self.verifyCodeTextField.text;
    NSString *timestamp = strArray.firstObject;
    NSString *appkey = @"BL2QEuXUXNoGbNeHObD4EzlX+KuGc70U";
    
    NSLog(@"username=%@,code=%@,timestamp=%@",username,code,timestamp);
    
    
    NSArray *arra = @[@"username",@"code",@"timestamp"];
    NSArray *sortArr = [arra sortedArrayUsingSelector:@selector(compare:)];
    NSLog(@"%@",sortArr);
    
    NSString *signmsg = [NSString stringWithFormat:@"code=%@&timestamp=%@&username=%@&key=%@",code,timestamp,username,appkey];
    NSLog(@"%@",signmsg);
    
    NSString *signmsgMD5 = [self md5:signmsg];
    
    //对key进行自然排序
    //    for (NSString *s in [dict allKeys]) {
    //        NSLog(@"value: %@", s);
    //    }
    
    NSLog(@"signmsgMD5=%@",signmsgMD5);
    
    // 1.创建请求
    NSURL *url = [NSURL URLWithString:@"http://j.efeiyi.com:8080/app-wikiServer/app/verifyCode.do"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    // 2.设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"username" : username,
                           @"code" : code,
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    
    //    NSData --> NSDictionary
    // NSDictionary --> NSData
    NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPBody = data;
    
    // 4.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSString *obj =  [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",obj);
        
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
