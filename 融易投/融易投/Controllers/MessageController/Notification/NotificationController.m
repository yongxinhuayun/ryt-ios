//
//  NotificationController.m
//  融易投
//
//  Created by dongxin on 16/4/6.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "NotificationController.h"

#import "UserMyModel.h"
#import "NotificationModel.h"
#import "NotificationTableViewCell.h"

#import <MJExtension.h>
#import "UITableView+Improve.h"
#import "CommonNavigationController.h"
@interface NotificationController ()<CommonNavigationDelegate>

@property (nonatomic, strong) NSMutableArray *models;

@end

@implementation NotificationController

static NSString *cellID = @"cellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    CommonNavigationController *nav = (CommonNavigationController *)self.navigationController;
    nav.commonDelegate = self;
    self.navigationItem.title = @"通知";
    [self.tableView setSeparatorColor:[UIColor colorWithRed:208.0 / 255.0 green:209.0 / 255.0 blue:210.0 / 255.0 alpha:0.4]];
    //加载数据
    [self loadData];
    //修改模型中的id为ID
    [NotificationModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID":@"id",
                 };
    }];
    [UserMyModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID":@"id",
                 };
    }];
    
    //注册创建cell ,这样注册就不用在XIB设置ID
    [self.tableView registerNib:[UINib nibWithNibName:@"NotificationTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
    [self.tableView improveTableView];
}

-(void)beforeBack{
    // 点击返回按钮，清除用户私信未读的数量
    NSString *userId = @"ioe4rahi670jsgdt";
    NSString *group = @"notification";
    NSDictionary *json = @{
                           @"group" : group,
                           @"userId" : userId
                           };
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:@"updateWatchedStatus" parameters:json
                                 showHUDView:nil andBlock:^(id respondObj) {
                                     NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
                                     NSLog(@"返回结果:%@",jsonStr);
                                 }];
}

-(void)loadData{
    NSString * pageNum = @"1";
    NSString* pageSize = @"99";
    // 3.设置请求体
    NSDictionary *json = @{
                           @"userId" : @"iijq9f1r7apprtab",
                           @"pageNum" : pageNum,
                           @"pageSize" :pageSize,
                           @"type"     :@"0"
                           };
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:@"information.do" parameters:json showHUDView:self.view andBlock:^(id respondObj) {
//        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];        
//        NSLog(@"返回结果:%@",jsonStr);
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        NSLog(@"%@",modelDict);
        self.models = [NotificationModel mj_objectArrayWithKeyValuesArray:modelDict[@"objectList"]];
        //在主线程刷新UI数据
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
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
    if(model.isWatch){
        cell.backgroundColor = [UIColor whiteColor];
    }else{
    cell.backgroundColor = [UIColor colorWithRed:247.0 / 255.0 green:247.0 / 255.0 blue:247.0 / 255.0 alpha:1.0];
    }
    
    return cell;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
@end
