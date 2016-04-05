//
//  FinanceTableViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/2.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "FinanceTableViewController.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

#import "FinanceModel.h"
#import "authorModel.h"
#import <MJExtension.h>

#import "FinanceTableViewCell.h"

@interface FinanceTableViewController ()

@property (nonatomic, strong) NSMutableArray *models;

@end

@implementation FinanceTableViewController

static NSString *ID = @"financeCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //内边距的顶部应该是导航条的最大值64加上标题栏的高度
    //    UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
    //    self.tableView.contentInset = UIEdgeInsetsMake(BSNavMaxY + BSTitlesViewH, 0, 0, 0);
    //    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(BSNavMaxY + BSTitlesViewH, 0, 0, 0);
    //运行程序,发现系统帮我们自动调整scrollView的内边距,所以在精华控制器中设置automaticallyAdjustsScrollViewInsets = NO即可
    
    //设置tableView的内边距---实现全局穿透让tableView向上移动64 + 标题栏的高度35/向下移动tabBar的高度49
    //运行程序,发现底部一致到了tabBar的最下面,我们应该设置成子控制器的view的显示范围为tabBar的上面
    //同样,tabBar的高度我们也可能项目中都会用到,写在常量文件中
    self.tableView.contentInset = UIEdgeInsetsMake(SSStatusMaxH + SSTitlesViewH, 0, SSTabBarH, 0);
    //运行程序,发现滚动条上部分被标题栏和导航栏挡住了,这样会对会用造成一定的假象,造成对内容的多少判断不准确
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(SSStatusMaxH + SSTitlesViewH, 0, SSTabBarH, 0);
    
    //加载数据
    [self loadData];
    
    //注册创建cell ,这样注册就不用在XIB设置ID
    [self.tableView registerNib:[UINib nibWithNibName:@"FinanceTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
    
    
    [FinanceModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        
        return @{
                 @"descriptions":@"description",
                 };
    }];
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
    NSString *pageSize = @"20";
    NSString *pageNum = @"1";
    NSString *timestamp = strArray.firstObject;
    NSString *appkey = @"BL2QEuXUXNoGbNeHObD4EzlX+KuGc70U";
    
    NSLog(@"pageSize=%@,pageNum=%@,timestamp=%@",pageNum,pageNum,timestamp);
    
    NSString *signmsg = [NSString stringWithFormat:@"pageNum=%@&pageSize=%@&timestamp=%@&key=%@",pageNum,pageSize,timestamp,appkey];
    NSLog(@"%@",signmsg);
    
    NSString *signmsgMD5 = [self md5:signmsg];
    
    NSLog(@"signmsgMD5=%@",signmsgMD5);
    
    // 1.创建请求
    //http://192.168.1.69:8001/app/login.do
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.69:8001/app/investorIndex.do"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    // 2.设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"pageSize" : pageSize,
                           @"pageNum" : pageNum,
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    
    //    NSData --> NSDictionary
    // NSDictionary --> NSData
    NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPBody = data;
    
    NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    
    NSString *dataJson = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",dataJson);
    
    // 4.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        //5. 解析从服务器获取的JSON数据
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"------ JSON: ----- %@", jsonString);
        
        /*
          {"resultCode":"0","
            objectList":[{"id":"qydeyugqqiugd2",
                          "title":"测试","brief":"这是一个","description":null,"status":"1","investGoalMoney":1.00,"investStartDatetime":1455005261000,"investEndDatetime":1454314064000,"auctionStartDatetime":1454400455000,"auctionEndDatetime":1454400449000,
                          "author":
                                    {"id":"icjxkedl0000b6i0","username":"123123","name":"魏立中","pictureUrl":"http://tenant.efeiyi.com/background/蔡水况.jpg","cityId":null,"status":"0","createDatetime":null,"type":"10000","master":{"id":"icjxkedl0000b6i0","brief":"版画家，他使得业已消失数百年的明代印刷业老字号十竹斋重新恢复并焕发生机，成为杭州市文化产业传承创新的亮点。","title":"国家级传承人","favicon":"http://tenant.efeiyi.com/background/蔡水况.jpg","birthday":"1968年","level":"1","content":null,"presentAddress":"浙江","backgroundUrl":"background/魏立中.jpg","provinceName":"浙江","theStatus":"1","logoUrl":"logo/魏立中.jpg","masterSpeech":null,"artCategory":null,"titleCertificate":null}},
         "createDatetime":1454314046000,"artworkAttachment":[],"artworkComments":[],"artworkDraw":null,"picture_url":"http://tenant.efeiyi.com/background/蔡水况.jpg","step":null,"investsMoney":154,"creationEndDatetime":1458285471000,"type":"3","newCreationDate":null,"auctionNum":null,"newBidingPrice":null,"newBiddingDate":null}],
         "resultMsg":"成功"}
         */
        
         NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        
        //创建一个数组成员属性,保存数据
//        [FinanceModel mj_setupObjectClassInArray:^NSDictionary *{
//            return @{@"users" : [userModel class]};
//        }];
        
        self.models = [FinanceModel mj_objectArrayWithKeyValuesArray:modelDict[@"objectList"]];
        
        NSLog(@"%@",self.models);
        
        //4. 刷新数据
        [self.tableView reloadData];
        
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


#pragma mark - 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    //程序一运行就只加载一次背景颜色,如果不这么写,一滚动就会变颜色
    static UIColor *cellBgColor = nil;
    if (cellBgColor == nil) {
        cellBgColor = SSRandomColor;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = cellBgColor;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %zd", self.class, indexPath.row];
    
    return cell;
     */
    
    FinanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    FinanceModel *model = self.models[indexPath.row];
    
    cell.model = model;
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 400;
}

@end
