//
//  NotificationController.m
//  融易投
//
//  Created by dongxin on 16/4/6.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "NotificationController.h"


#import "NotificationModel.h"
#import "NotificationTableViewCell.h"
#import <MJExtension.h>

@interface NotificationController ()

@property (nonatomic, strong) NSMutableArray *models;

@end

@implementation NotificationController

static NSString *cellID = @"cellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavBar];

    //加载数据
    [self loadData];
    
    //修改模型中的id为ID
    [NotificationModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        
        return @{
                 @"ID":@"id",
                 };
    }];
    
    //注册创建cell ,这样注册就不用在XIB设置ID
    [self.tableView registerNib:[UINib nibWithNibName:@"NotificationTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
}





-(void)setUpNavBar
{
    //设置导航条标题
    self.navigationItem.title = @"通知";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.models.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    NotificationModel *model = self.models[indexPath.section];
    
    cell.model = model;
    
    return cell;
}
-(void)loadData{
    
    NSString *timestamp = [MyMD5 timestamp];
    NSString *appkey = MD5key;
    
    NSString * pageNum = @"1";
    NSString* pageSize = @"99";
    
    NSLog(@"pageSize=%@,pageNum=%@,timestamp=%@",pageNum,pageNum,timestamp);
    
    NSString *signmsg = [NSString stringWithFormat:@"pageNum=%@&pageSize=%@&timestamp=%@&type=%@&userId=%@&key=%@",pageNum,pageSize,timestamp,@"0",@"iijq9f1r7apprtab",appkey];
    
    NSLog(@"%@",signmsg);
    
    NSString *signmsgMD5 = [MyMD5 md5:signmsg];
    
    NSLog(@"signmsgMD5=%@",signmsgMD5);
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"userId" : @"iijq9f1r7apprtab",
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5,
                           @"pageNum" : pageNum,
                           @"pageSize" :pageSize,
                           @"type"     :@"0"
                           };
    
    NSString *url = @"http://192.168.1.69:8001/app/information.do";
    
    [[HttpRequstTool shareInstance] handlerNetworkingPOSTRequstWithServerUrl:url Parameters:json showHUDView:self.view success:^(id respondObj) {
        
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        NSLog(@"%@",modelDict);
        self.models = [NotificationModel mj_objectArrayWithKeyValuesArray:modelDict[@"objectList"]];
        
        //在主线程刷新UI数据
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [self.tableView reloadData];
            
        }];
    }];
}


@end
