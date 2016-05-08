//
//  FocusMyArtistTableViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/29.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "FocusMyArtistTableViewController.h"

#import "FocusMyTableViewCell.h"

#import "PageInfoListMyModel.h"

#import <MJExtension.h>

#import "CommonHeader.h"
#import "CommonFooter.h"

@interface FocusMyArtistTableViewController ()

@property (nonatomic, strong) NSMutableArray *models;

/** 用来加载下一页数据 */
@property (nonatomic, strong) NSString *lastPageIndex;

@end

@implementation FocusMyArtistTableViewController

static NSString *ID = @"focusMyCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lastPageIndex = @"1";
    
    //    self.view.backgroundColor = [UIColor redColor];
    
    //设置tableView的内边距---实现全局穿透让tableView向上移动64 + 标题栏的高度35/向下移动tabBar的高度49
    //运行程序,发现底部一致到了tabBar的最下面,我们应该设置成子控制器的view的显示范围为tabBar的上面
    //同样,tabBar的高度我们也可能项目中都会用到,写在常量文件中
    self.tableView.contentInset = UIEdgeInsetsMake(SSNavMaxY + SSTitlesViewH, 0, 0, 0);
    //运行程序,发现滚动条上部分被标题栏和导航栏挡住了,这样会对会用造成一定的假象,造成对内容的多少判断不准确
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(SSNavMaxY + SSTitlesViewH, 0, 0, 0);
    
    //注册创建cell ,这样注册就不用在XIB设置ID
    [self.tableView registerNib:[UINib nibWithNibName:@"FocusMyTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
    
    [self loadNewData];
    
    //设置刷新控件
    [self setUpRefresh];
}

-(void)setUpRefresh
{
    //但是如果我们想整个项目都要用到上拉刷新和下拉刷新呢,不能把这上面的代码一个个拷贝了吧
    //这样,我们可以使用继承,自定义刷新控件然后继承自MJRefreshNormalHeader,这里是自定义下拉刷新
    
    //    CommonHeader *header = [CommonHeader headerWithRefreshingBlock:^{
    //
    //        [self loadNewData];
    //
    //    }];
    //
    //    self.tableView.mj_header = header;
    
    //让程序一开始就加载数据
    //    [self.tableView.mj_header beginRefreshing];
    
    
    //同样,自定义上拉刷新
    self.tableView.mj_footer = [CommonFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    //要是其他控制器也需要,直接把上面的拷贝到其他控制器就可以了
}


-(void)loadNewData
{
    //8.2 取消之前的请求
    [self.tableView.mj_header endRefreshing];
    
    self.lastPageIndex = @"1";
    //参数
    NSString *userId = @"ieatht97wfw30hfd";
//     NSString *userId = TakeUserID;
    NSString *otherUserId = @"ieatht97wfw30hfd";
    
    NSString *flag = @"1";
    
    //相等为自己看自己,flag为1
    if ([userId isEqualToString:otherUserId]) {
        
        flag = @"1";
    }else { //不等为自己看别人,flag为2
    
        flag = @"2";
    }
    
    // type为1时时艺术家,为2时为用户
    NSString *type = @"1";
    
    NSString *pageSize = @"20";
    NSString *pageIndex = @"1";
    //flag为1是自己看自己,为2时是看别人,还需要传递otheruserId
        NSString *timestamp = [MyMD5 timestamp];
    NSString *appkey = MD5key;
    
    NSString *signmsg = [NSString stringWithFormat:@"pageIndex=%@&pageSize=%@&timestamp=%@&type=%@&userId=%@&key=%@",pageIndex,pageSize,timestamp,type,userId,appkey];
    NSLog(@"%@",signmsg);
    
    NSString *signmsgMD5 = [MyMD5 md5:signmsg];
    
    NSLog(@"signmsgMD5=%@",signmsgMD5);
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"userId":userId,
                           @"type":type,
                           @"pageSize" : pageSize,
                           @"pageIndex" : pageIndex,
                           @"flag": flag,
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    
    NSString *url = @"http://192.168.1.41:8080/app/userFollowed.do";
    
    [[HttpRequstTool shareInstance] handlerNetworkingPOSTRequstWithServerUrl:url Parameters:json showHUDView:self.view success:^(id respondObj) {
        
//        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
//        NSLog(@"返回结果:%@",jsonStr);
        
        /*
         {"pageInfoList":
                [{"artUserFollowed":{
                                "id":"5",
                                "user":{"id":"ieatht97wfw30hfd","username":"15110008479","name":"温群英","name2":"温群英","password":"388d079e06c2bb84c6fb092a15c3e0e0a8b01e52","status":1,"confirmPassword":null,"oldPassword":null,"enabled":true,"accountExpired":false,"accountLocked":false,"credentialsExpired":false,"utype":10000,"lastLoginDatetime":null,"lastLogoutDatetime":null,"createDatetime":1441684108000,"source":null,"fullName":"温群英[15110008479]","accountNonExpired":true,"accountNonLocked":true,"credentialsNonExpired":true},
                                "follower":                                                                         {"id":"icjxkedl0000b6i0","username":"123123","name":"魏立中","name2":null,"password":"123123","status":1,"confirmPassword":null,"oldPassword":null,"enabled":true,"accountExpired":true,"accountLocked":false,"credentialsExpired":true,"utype":10000,"lastLoginDatetime":null,"lastLogoutDatetime":null,"createDatetime":null,"source":null,"fullName":"魏立中[123123]","accountNonExpired":false,"accountNonLocked":true,"credentialsNonExpired":false},
                                "status":"1",
                                "type":"1",
                                "createDatetime":1461641660000},
                "userBrief":null,
                "master":
                        {"id":"ich9th9y00008h8v","brief":"中国工艺美术大师、高级工艺美术师、福建省工艺美术大师、中国工艺美术学会会员、美国海外艺术家协会理事、福建省工艺美术学会常务理事、协会会员、首届厦门工艺美术学会常务付理事长。","title":"","favicon":"photo/20150729144701.jpg","birthday":"1939年","level":"1","content":"","presentAddress":"福建","backgroundUrl":"background/蔡水况.jpg","provinceName":"福建","theStatus":"1","logoUrl":"logo/蔡水况.jpg","masterSpeech":null,"artCategory":null,"titleCertificate":null,"feedback":"份","identityFront":null,"identityBack":null},
                "flag":null},
            {"artUserFollowed":
                {"id":"111",
                 "user":
                        {"id":"ieatht97wfw30hfd","username":"15110008479","name":"温群英","name2":"温群英","password":"388d079e06c2bb84c6fb092a15c3e0e0a8b01e52","status":1,"confirmPassword":null,"oldPassword":null,"enabled":true,"accountExpired":false,"accountLocked":false,"credentialsExpired":false,"utype":10000,"lastLoginDatetime":null,"lastLogoutDatetime":null,"createDatetime":1441684108000,"source":null,"fullName":"温群英[15110008479]","accountNonExpired":true,"accountNonLocked":true,"credentialsNonExpired":true},
                "follower":{"id":"ieatht97wfw30hfd","username":"15110008479","name":"温群英","name2":"温群英","password":"388d079e06c2bb84c6fb092a15c3e0e0a8b01e52","status":1,"confirmPassword":null,"oldPassword":null,"enabled":true,"accountExpired":false,"accountLocked":false,"credentialsExpired":false,"utype":10000,"lastLoginDatetime":null,"lastLogoutDatetime":null,"createDatetime":1441684108000,"source":null,"fullName":"温群英[15110008479]","accountNonExpired":true,"accountNonLocked":true,"credentialsNonExpired":true},
                "status":"1",
                "type":"1",
                "createDatetime":1461917208000},
         "userBrief":null,
         "master":{"id":"ich9th9y00008h8v","brief":"中国工艺美术大师、高级工艺美术师、福建省工艺美术大师、中国工艺美术学会会员、美国海外艺术家协会理事、福建省工艺美术学会常务理事、协会会员、首届厦门工艺美术学会常务付理事长。","title":"","favicon":"photo/20150729144701.jpg","birthday":"1939年","level":"1","content":"","presentAddress":"福建","backgroundUrl":"background/蔡水况.jpg","provinceName":"福建","theStatus":"1","logoUrl":"logo/蔡水况.jpg","masterSpeech":null,"artCategory":null,"titleCertificate":null,"feedback":"份","identityFront":null,"identityBack":null},"flag":null}],"resultCode":"0","resultMsg":"请求成功","followsNum":2}
         
         */
        
            NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
    
            self.models = [PageInfoListMyModel mj_objectArrayWithKeyValuesArray:modelDict[@"pageInfoList"]];
    
//            NSLog(@"11111111111111%@",self.models);
    
    
            //在主线程刷新UI数据
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    
                [self.tableView reloadData];
    
            }];
    }];
}

-(void)loadMoreData
{
    //8.2 取消之前的请求
    [self.tableView.mj_footer endRefreshing];
    
    //参数
    int newPageIndex = self.lastPageIndex.intValue + 1;
    
    self.lastPageIndex = [NSString stringWithFormat:@"%d",newPageIndex];
    
    NSLog(@"newPageIndex%@",self.lastPageIndex);
    
    NSLog(@"%d",newPageIndex);
    
    //参数
    NSString *userId = @"ieatht97wfw30hfd";
    //     NSString *userId = TakeUserID;
    NSString *otherUserId = @"ieatht97wfw30hfd";
    
    NSString *flag = @"1";
    
    //相等为自己看自己,flag为1
    if ([userId isEqualToString:otherUserId]) {
        
        flag = @"1";
    }else { //不等为自己看别人,flag为2
        
        flag = @"2";
    }
    
    
    NSString *type = @"1";
    
    NSString *pageSize = @"20";
    NSString *pageIndex = [NSString stringWithFormat:@"%d",newPageIndex];
    NSString *timestamp = [MyMD5 timestamp];
    NSString *appkey = MD5key;
    
    NSString *signmsg = [NSString stringWithFormat:@"pageIndex=%@&pageSize=%@&timestamp=%@&type=%@&userId=%@&key=%@",pageIndex,pageSize,timestamp,type,userId,appkey];
    NSLog(@"%@",signmsg);
    
    NSString *signmsgMD5 = [MyMD5 md5:signmsg];
    
    NSLog(@"signmsgMD5=%@",signmsgMD5);
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"userId":userId,
                           @"type":type,
                           @"pageSize" : pageSize,
                           @"pageIndex" : pageIndex,
                           @"flag": flag,
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    
    NSString *url = @"http://192.168.1.41:8080/app/userFollowed.do";
    
    [[HttpRequstTool shareInstance] handlerNetworkingPOSTRequstWithServerUrl:url Parameters:json showHUDView:self.view success:^(id respondObj) {
        
//        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
//        NSLog(@"返回结果:%@",jsonStr);

        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];

        NSArray *moreModels =  [PageInfoListMyModel mj_objectArrayWithKeyValuesArray:modelDict[@"pageInfoList"]];
        //拼接数据
        [self.models addObjectsFromArray:moreModels];


        //在主线程刷新UI数据
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{

            [self.tableView reloadData];

        }];
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.models.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FocusMyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    PageInfoListMyModel *model = self.models[indexPath.row];
    
    cell.model = model;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 60;
}
@end
