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

#import "HTTPSessionManager.h"


@interface LognController ()

@property (weak, nonatomic) IBOutlet UIButton *lognButton;

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic ,weak)  AFHTTPSessionManager *mgr;

@end

@implementation LognController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"1111");
    
    
    
}
- (IBAction)lognBtnClick:(id)sender {
    
    [self test];
}
- (IBAction)weixinBtnClick:(id)sender {
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
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.69:8001/app/login.do"];
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
        
    }];
    
    
    
}

-(void)test{

    // 1.1 创建请求会话管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    _mgr = mgr;
    
    NSString *url = @"http://192.168.1.69:8001/app/login.do";
    
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
    
    NSArray *arra = @[@"username",@"password",@"timestamp"];
    NSArray *sortArr = [arra sortedArrayUsingSelector:@selector(compare:)];
    NSLog(@"%@",sortArr);
    
    NSString *signmsg = [NSString stringWithFormat:@"password=%@&timestamp=%@&username=%@&key=%@",password,timestamp,username,appkey];
    NSLog(@"%@",signmsg);
    
    NSString *signmsgMD5 = [self md5:signmsg];

    
    // 1.2 拼接请求参数
    NSDictionary *json = @{
                           @"username" : username,
                           @"password" : password,
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    
    //    NSData --> NSDictionary
    // NSDictionary --> NSData
    NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    
    [mgr POST:url parameters:data progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *obj =  [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",obj);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
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
