//
//  MessageTableViewController.m
//  融易投
//
//  Created by efeiyi on 16/3/30.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "MessageTableViewController.h"


#import "CommentsController.h"

#import "NotificationController.h"

#import "PrivateLetterViewController.h"

@interface MessageTableViewController ()

- (IBAction)NaThings:(id)sender;

- (IBAction)pingLunThings:(id)sender;
- (IBAction)singxinThings:(id)sender;
@end

@implementation MessageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavBar];
}

// 设置导航条
-(void)setUpNavBar
{
    //设置导航条标题
    self.navigationItem.title = @"消息";
    
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
    //    NSString *username = self.phoneNumTextField.text;
    //    NSString *password = self.passWordTextField.text;
    NSString *timestamp = strArray.firstObject;
    
    NSString *appkey = @"BL2QEuXUXNoGbNeHObD4EzlX+KuGc70U";
    NSLog(@"userId=%@,timestamp=%@",@"imhipoyk18s4k52u",timestamp);
    NSArray *arra = @[@"userId",@"timestamp"];
    NSArray *sortArr = [arra sortedArrayUsingSelector:@selector(compare:)];
    NSLog(@"%@",sortArr);
    
    NSString *signmsg = [NSString stringWithFormat:@"timestamp=%@&userId=%@&key=%@",timestamp,@"imhipoyk18s4k52u"
                         ,appkey];
    NSLog(@"%@",signmsg);
    
    NSString *signmsgMD5 = [MyMD5 md5:signmsg];
    
    //对key进行自然排序
    //    for (NSString *s in [dict allKeys]) {
    //        NSLog(@"value: %@", s);
    //    }
    
    NSLog(@"signmsgMD5=%@",signmsgMD5);
    
    // 1.创建请求   'http://192.168.1.69:8001/app/login.do'
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.69:8001/app/informationList.do"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    // 2.设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"userId" : @"imhipoyk18s4k52u",
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

- (IBAction)NaThings:(id)sender {
    
    NotificationController *NoController = [NotificationController new];
    [self.navigationController pushViewController:NoController animated:YES];
    
}
- (IBAction)pingLunThings:(id)sender {
    
    CommentsController *commentsController = [CommentsController new];
    [self.navigationController pushViewController:commentsController animated:YES];
}

- (IBAction)singxinThings:(id)sender {

    PrivateLetterViewController *privateLetterVC = [[PrivateLetterViewController alloc] init];
    [self.navigationController pushViewController:privateLetterVC animated:YES];
}
@end
