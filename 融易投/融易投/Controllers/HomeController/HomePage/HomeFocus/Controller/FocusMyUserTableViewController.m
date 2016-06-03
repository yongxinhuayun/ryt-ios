//
//  FocusMyArtistTableViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/29.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "FocusMyUserTableViewController.h"
#import "CommonUserHomeViewController.h"
#import "ArtistUserHomeViewController.h"

#import "FocusMyTableViewCell.h"

#import "PageInfoListMyModel.h"

#import <MJExtension.h>

#import "CommonHeader.h"
#import "CommonFooter.h"

@interface FocusMyUserTableViewController ()<focusMyTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *models;

/** 用来加载下一页数据 */
@property (nonatomic, strong) NSString *lastPageIndex;

@end

@implementation FocusMyUserTableViewController

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
    
    //字典转模型
    [self dictToModel];
    
    [self loadNewData];
    
    //设置刷新控件
    [self setUpRefresh];
    
    //去除多余的线
    [self improveTableView];
    
    //跟新我的界面的数据控制器
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFocusAndFansNotification) name:UpdateFocusAndFansNotification object:nil];
}

-(void)updateFocusAndFansNotification{
    
    //获取用户信息数据
    [self loadNewData];
}
-(void)improveTableView
{
    self.tableView.tableFooterView = [[UIView alloc]init];  //删除多余的行
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {  //防止分割线显示不
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
}
-(void)dictToModel{
    
    [ArtUserFollowedMyModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        
        return @{
                 @"ID"          :@"id"
                 };
    }];
    
    [UserMyModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        
        return @{
                 @"ID"          :@"id"
                 };
    }];
    
    [FollowerMyModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        
        return @{
                 @"ID"          :@"id"
                 };
    }];
    
    [MasterMyModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        
        return @{
                 @"ID"          :@"id"
                 };
    }];
    
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
    NSString *pageSize = @"20";
    NSString *pageIndex = @"1";

    //参数
    UserMyModel *userModel = TakeLoginUserModel;
    NSString *userId = userModel.ID;
    NSString *otherUserId = self.userId;
    
    NSString *flag = @"1";
    
    //相等为自己看自己,flag为1
    if ([userId isEqualToString:otherUserId]) {
        
        flag = @"1";
    }else { //不等为自己看别人,flag为2
        
        flag = @"2";
    }

    // type为1是艺术家,为2时为用户
    NSString *type = @"2";

    // 3.设置请求体
    NSDictionary *json = @{
                           @"userId":userId,
                           @"otherUserId":otherUserId,
                           @"type":type,
                           @"pageSize" : pageSize,
                           @"pageIndex" : pageIndex,
                           @"flag": flag
                           };
    
    NSString *url = @"userFollowed.do";
    
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:url parameters:json showHUDView:self.view andBlock:^(id respondObj) {
        
        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        NSLog(@"返回结果:%@",jsonStr);
        
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        
        self.models = [PageInfoListMyModel mj_objectArrayWithKeyValuesArray:modelDict[@"pageInfoList"]];
        
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
    
    //参数
    UserMyModel *userModel = TakeLoginUserModel;
    NSString *userId = userModel.ID;
    NSString *otherUserId = self.userId;
    
    NSString *flag = @"1";
    
    //相等为自己看自己,flag为1
    if ([userId isEqualToString:otherUserId]) {
        
        flag = @"1";
    }else { //不等为自己看别人,flag为2
        
        flag = @"2";
    }

    NSString *type = @"2";
    
    NSString *pageSize = @"20";
    NSString *pageIndex = [NSString stringWithFormat:@"%d",newPageIndex];
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"userId":userId,
                           @"otherUserId":otherUserId,
                           @"type":type,
                           @"pageSize" : pageSize,
                           @"pageIndex" : pageIndex,
                           @"flag": flag
                           };
    
    NSString *url = @"userFollowed.do";
    
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:url parameters:json showHUDView:self.view andBlock:^(id respondObj) {
        
        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        NSLog(@"返回结果:%@",jsonStr);
        
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        
        NSArray *moreModels =  [PageInfoListMyModel mj_objectArrayWithKeyValuesArray:modelDict[@"pageInfoList"]];
        //拼接数据
        [self.models addObjectsFromArray:moreModels];
        
        
        //在主线程刷新UI数据
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tableView.mj_footer endRefreshing];
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
    
    FocusMyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    PageInfoListMyModel *model = self.models[indexPath.row];
    
    cell.model = model;
    cell.delegate = self;
    cell.indexPath = indexPath;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

#pragma mark - cell delegate
-(void)clickUserIcon:(NSIndexPath *)indexPath{
    [self jumpToUserHome:indexPath];
}

-(void)jumpToUserHome:(NSIndexPath *)indexPath{
    PageInfoListMyModel *model = self.models[indexPath.row];
    NSString *userId = model.artUserFollowed.user.ID;
    if (userId) {
        if (model.artUserFollowed.user.master) {
            ArtistUserHomeViewController *home = [[ArtistUserHomeViewController alloc] init];
            home.userId = model.artUserFollowed.user.ID;
            home.title = model.artUserFollowed.user.name;
            home.navigationItem.title = model.artUserFollowed.user.name;
            [self.navigationController pushViewController:home animated:YES];
        }else{
            CommonUserHomeViewController *commonUserHome = [[CommonUserHomeViewController alloc] init];
            commonUserHome.userId = userId;
            commonUserHome.navigationItem.title = model.artUserFollowed.user.name;
            [self.navigationController pushViewController:commonUserHome animated:YES];
        }
    }
}
@end
