//
//  RecordTableViewController.m
//  融易投
//
//  Created by dongxin on 16/5/3.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "RecordTableViewController.h"
#import "RecordTableViewCell.h"
#import "TopRecordTableViewCell.h"
#import <MJExtension.h>
#import "CommonHeader.h"
#import "CommonFooter.h"
#import "RecordModelList.h"
#import "UserMyModel.h"

@interface RecordTableViewController ()


@property(nonatomic,strong) NSMutableArray *artTopList;
@property (nonatomic, strong) NSMutableArray *artList;
/** 用来加载下一页数据 */
@property (nonatomic, strong) NSString *lastPageIndex;

//-----------------------联动属性-----------------------
@property(nonatomic,assign) BOOL isfoot;
//-----------------------联动属性-----------------------

@end

@implementation RecordTableViewController

//--------------
-(void)setUpRefresh
{
        CommonHeader *header = [CommonHeader headerWithRefreshingBlock:^{
    
            [self loadNewData];
    
        }];
    
        self.tableView.mj_header = header;
    
    //让程序一开始就加载数据
        [self.tableView.mj_header beginRefreshing];
    
    
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
    
    NSString *pageSize = @"20";
    NSString *pageIndex = @"1";
    //flag为1是自己看自己,为2时是看别人,还需要传递otheruserId
    NSString *timestamp = [MyMD5 timestamp];
    NSString *appkey = MD5key;
    
    NSString *signmsg = [NSString stringWithFormat:@"artWorkId=%@&pageIndex=%@&pageSize=%@&timestamp=%@&key=%@",self.ID,pageIndex,pageSize,timestamp,appkey];
    NSLog(@"%@",signmsg);
    
    NSString *signmsgMD5 = [MyMD5 md5:signmsg];
    
    NSLog(@"signmsgMD5=%@",signmsgMD5);
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"artWorkId":self.ID,
                           @"pageSize" : pageSize,
                           @"pageIndex" : pageIndex,
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    
    NSString *url = @"http://192.168.1.75:8001/app/investorArtWorkInvest.do";
    
    [[HttpRequstTool shareInstance] handlerNetworkingPOSTRequstWithServerUrl:url Parameters:json showHUDView:self.view success:^(id respondObj) {
        
                NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
                NSLog(@"返回结果:%@",jsonStr);
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        
        RecordModelList *model = [RecordModelList mj_objectWithKeyValues:modelDict[@"object"]];
        self.artList = model.artworkInvestList;
        self.artTopList = model.artworkInvestTopList;
//        self.models = model.artworks;
        
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
    NSString *pageSize = @"20";
    NSString *pageIndex = [NSString stringWithFormat:@"%d",newPageIndex];
    NSString *timestamp = [MyMD5 timestamp];
    NSString *appkey = MD5key;
    
    NSString *signmsg = [NSString stringWithFormat:@"artWorkId=%@&pageIndex=%@&pageSize=%@&timestamp=%@&key=%@",self.ID,pageIndex,pageSize,timestamp,appkey];
    NSLog(@"%@",signmsg);
    
    NSString *signmsgMD5 = [MyMD5 md5:signmsg];
    
    NSLog(@"signmsgMD5=%@",signmsgMD5);
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"artWorkId":self.ID,
                           @"pageSize" : pageSize,
                           @"pageIndex" : pageIndex,
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    
    NSString *url = @"http://192.168.1.41:8080/app/investorArtWorkInvest.do";
    
    [[HttpRequstTool shareInstance] handlerNetworkingPOSTRequstWithServerUrl:url Parameters:json showHUDView:self.view success:^(id respondObj) {
        
                NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
                NSLog(@"返回结果:%@",jsonStr);
        
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        
        RecordModelList *model = [RecordModelList mj_objectWithKeyValues:modelDict[@"object"]];
        //拼接数据
        self.artTopList = model.artworkInvestTopList;
        
        if (model.artworkInvestList != nil) {
            [self.artList addObject:model.artworkInvestList];
        }

//        [self.models addObjectsFromArray:moreModels];
        
        //在主线程刷新UI数据
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [self.tableView reloadData];
            
        }];
        
    }];
}
//--------------
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 刷新
    self.lastPageIndex = @"1";
    [self loadNewData];
    //设置刷新控件
    [self setUpRefresh];
    [RecordModelList mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"artworkInvestTopList":@"RecordModel",
                 @"artworkInvestList":@"RecordModel"
                 };
    }];

    
    self.isfoot = YES;
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"RecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"RecordCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TopRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"TopRecordCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else{
        return 20;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   
    UIView *header = [[UIView alloc] init];
    header.frame = CGRectMake(0, 0, tableView.width, 80);
    header.backgroundColor = [UIColor whiteColor];
    if (section ==0) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"touzimingxingbang"]];
        imgView.center = header.center;
        imgView.height = 59;
        imgView.width = 266;
        [header addSubview:imgView];
    }else{
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zuixintouzijilu"]];
        imgView.center = header.center;
        imgView.height = 15;
        [header addSubview:imgView];
    }
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TopRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopRecordCell" forIndexPath:indexPath];
        
        return cell;
    }else{
        RecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordCell"                                                                    forIndexPath:indexPath];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{
    if (indexPat.section ==0) {
        return 200;
    }else{
        return 60;
    }
}

//-----------------------联动-----------------------
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 80; //sectionHeaderHeight
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
    CGPoint offset = scrollView.contentOffset;
    UIScrollView *superView = (UIScrollView *)scrollView.superview.superview.superview.superview;
    if (superView.contentOffset.y >= self.topHeight) {
        self.isfoot = NO;
        superView.contentOffset = CGPointMake(0, self.topHeight);
        scrollView.scrollEnabled = YES;
    }
    if (superView.contentOffset.y <= 0) {
        self.isfoot = YES;
        superView.contentOffset = CGPointMake(0, 0);
        scrollView.scrollEnabled = YES;
    }
//    NSLog(@"bool = %d",self.isfoot);
    CGFloat zeroY = superView.contentOffset.y + scrollView.contentOffset.y;
    if (self.isfoot && scrollView.contentOffset.y > 0) {
     superView.contentOffset = CGPointMake(0, superView.contentOffset.y + scrollView.contentOffset.y);
        scrollView.contentOffset = CGPointZero;
    }
    if (!self.isfoot && scrollView.contentOffset.y < 0) {
        superView.contentOffset = CGPointMake(0, superView.contentOffset.y + scrollView.contentOffset.y);
    }
    if (superView.contentOffset.y < self.topHeight && scrollView.contentOffset.y >0) {
        superView.contentOffset = CGPointMake(0, superView.contentOffset.y + scrollView.contentOffset.y);
        scrollView.contentOffset = CGPointZero;
    }
    if(superView.contentOffset.y < self.topHeight && scrollView.contentOffset.y <= 0){
       CGFloat y = scrollView.contentOffset.y / 10;
        zeroY = superView.contentOffset.y + y;
        
        if (zeroY < 0) {
            [superView setContentOffset:CGPointZero animated:YES];
        }else{
            superView.contentOffset = CGPointMake(0, superView.contentOffset.y + y);
        }
//        if (scrollView.contentOffset.y > -10) {
//            if (zeroY < 0) {
//                [superView setContentOffset:CGPointZero animated:YES];
//            }else{
//                superView.contentOffset = CGPointMake(0, superView.contentOffset.y + scrollView.contentOffset.y);
//            }
//        }else{
//            superView.contentOffset = CGPointMake(0, superView.contentOffset.y + y);
//            if (scrollView.contentOffset.y <= -100) {
//                [superView setContentOffset:CGPointMake(0, superView.contentOffset.y + y) animated:YES];
//            }else
//            {
//                
//                if (zeroY < 0) {
//                    superView.contentOffset = CGPointZero;
//                }else{
//                 [superView setContentOffset:CGPointMake(0, superView.contentOffset.y + y) animated:YES];
//                }
//           
//            }
//        }
    }
}
//-----------------------联动-----------------------


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSMutableArray *)artTopList{
    if (!_artTopList) {
        _artTopList = [[NSMutableArray alloc] init];
    }
    return _artTopList;
}
-(NSMutableArray *)artList{
    if (!_artList) {
        _artList = [[NSMutableArray alloc] init];
    }
    return _artList;
}
@end
