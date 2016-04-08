//
//  PersonalController.m
//  融易投
//
//  Created by dongxin on 16/4/7.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "PersonalController.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>


@interface PersonalController ()

@end

@implementation PersonalController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSArray *arra = @[@"userId",@"timestamp",@"signmsg",@"type",@"pageSize",@"pageNum"];
    
    NSArray *sortArr = [arra sortedArrayUsingSelector:@selector(compare:)];
    NSLog(@"%@",sortArr);
    
    NSString * pageNum = @"1";
    NSString* pageSize = @"1";
    
    NSString *signmsg = [NSString stringWithFormat:@"pageNum=%@&pageSize=%@&timestamp=%@&type=%@&userId=%@&key=%@",pageNum,pageSize,timestamp,@"2",@"iijqf1r7apprtab",appkey];
    
    NSLog(@"%@",signmsg);
    NSLog(@"");
    NSString *signmsgMD5 = [self md5:signmsg];
    
    //对key进行自然排序
    //    for (NSString *s in [dict allKeys]) {
    //        NSLog(@"value: %@", s);
    //    }
    
    NSLog(@"signmsgMD5=%@",signmsgMD5);
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.69:8001/app/information.do"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    // 2.设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"userId" : @"iijqf1r7apprtab",
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5,
                           @"pageNum" : @"1",
                           @"pageSize" :@"1",
                           @"type"     :@"0"
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
    
    NSString *timestamp = [MyMD5 timestamp];
    NSString *appkey = MD5key;
    
    NSString * pageNum = @"1";
    NSString* pageSize = @"1";
    
    NSLog(@"pageSize=%@,pageNum=%@,timestamp=%@",pageNum,pageNum,timestamp);
    
    NSString *signmsg = [NSString stringWithFormat:@"pageNum=%@&pageSize=%@&timestamp=%@&type=%@&userId=%@&key=%@",pageNum,pageSize,timestamp,@"1",@"iijqf1r7apprtab",appkey];
    
    NSLog(@"%@",signmsg);
    
    NSString *signmsgMD5 = [MyMD5 md5:signmsg];
    
    NSLog(@"signmsgMD5=%@",signmsgMD5);
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"userId" : @"iijqf1r7apprtab",
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5,
                           @"pageNum" : @"1",
                           @"pageSize" :@"1",
                           @"type"     :@"0"
                           };
    
    NSString *url = @"http://192.168.1.69:8001/app/information.do";
    
    [[HttpRequstTool shareInstance] handlerNetworkingPOSTRequstWithServerUrl:url Parameters:json showHUDView:self.view success:^(id respondObj) {
        
        //        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        //        NSLog(@"返回结果:%@",jsonStr);
        
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        
        NSLog(@"%@",modelDict);
        //拼接数据
        
        
        //在主线程刷新UI数据
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            
        }];
        
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
