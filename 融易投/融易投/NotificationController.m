//
//  NotificationController.m
//  融易投
//
//  Created by dongxin on 16/4/6.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "NotificationController.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@interface NotificationController ()
{
NSMutableArray *_friendsArray;
   
}
@property (nonatomic,strong) UITableView *notification;
@end

@implementation NotificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavBar];
//    CGFloat heightT = [UIScreen mainScreen].bounds.size.height;
//    NSLog(@"%f",heightT);
//    
//    CGFloat height = self.view.height;
//    NSLog(@"%f",height);
    
    self.notification = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    
    self.notification.dataSource = self;
    self.notification.delegate =self;
    self.notification.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.notification];
    
    _friendsArray = [[NSMutableArray alloc]init];
    [self loadData];
    
}
// imhipoyk18s4k52u
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
    
    NSString *signmsgMD5 = [self md5:signmsg];
    
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
        
        /*
        
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
        */
        /*
         */
        
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


-(void)setUpNavBar
{
    //设置导航条标题
    self.navigationItem.title = @"通知";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _friendsArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];

    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
           }
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
