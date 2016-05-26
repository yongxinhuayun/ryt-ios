//
//  FocusMyArtistTableViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/29.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "TouGuoViewController.h"

#import "InvestProjectCell.h"

#import "PageInfoModel.h"
#import "ArtworksModel.h"

#import <MJExtension.h>

#import "CommonHeader.h"
#import "CommonFooter.h"

#import "DetailFinanceViewController.h"
#import "DetailCreationViewController.h"


@interface TouGuoViewController ()

@property (nonatomic, strong) NSMutableArray *models;

/** 用来加载下一页数据 */
@property (nonatomic, strong) NSString *lastPageIndex;

//-----------------------联动属性-----------------------
@property(nonatomic,assign) BOOL isfoot;
//-----------------------联动属性-----------------------

@end

@implementation TouGuoViewController

static NSString *ID = @"InvestProjectCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isfoot = YES;

    self.lastPageIndex = @"1";
    
    //    self.tableView.contentInset = UIEdgeInsetsMake(SSNavMaxY + SSTitlesViewH, 0, 0, 0);
    //    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(SSNavMaxY + SSTitlesViewH, 0, 0, 0);
    
    //注册创建cell ,这样注册就不用在XIB设置ID
    [self.tableView registerNib:[UINib nibWithNibName:@"InvestProjectCell" bundle:nil] forCellReuseIdentifier:ID];
    
    [PageInfoModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"artworks" : @"ArtworksModel",
                 };
    }];
    
    [ArtworksModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        
        return @{
                 @"ID"          :@"id"
                 };
    }];
    
    [self loadNewData];
    
    //设置刷新控件
    [self setUpRefresh];

}
-(void)setUpRefresh
{
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
    UserMyModel *model = TakeLoginUserModel;
    NSString *userId = model.ID;
//    NSString *userId = @"ieatht97wfw30hfd";
    
    NSString *pageSize = @"20";
    NSString *pageIndex = @"1";
    
    NSString *url = @"my.do";
    // 3.设置请求体
    NSDictionary *json = @{
                           @"userId":userId,
                           @"pageSize" : pageSize,
                           @"pageIndex" : pageIndex
                           };
    
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:url parameters:json showHUDView:nil andBlock:^(id respondObj) {
        
//        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
//        NSLog(@"返回结果:%@",jsonStr);

        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        
        PageInfoModel *model = [PageInfoModel mj_objectWithKeyValues:modelDict[@"pageInfo"]];

        //在主线程刷新UI数据
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            self.models = model.artworks;
            
            if (self.models.count) {
                
                [self.tableView reloadData];
                
            }else{
                
                UIView *touGuoview = [[UIView alloc] initWithFrame:self.view.bounds];
                touGuoview.backgroundColor = [UIColor whiteColor];
                UILabel *label = [[UILabel alloc] init];
                label.center = CGPointMake(self.view.width * 0.3, self.view.height * 0.4);
                label.text = @"还没有投资过任何项目...";
                label.textColor = [UIColor grayColor];
                label.font = [UIFont systemFontOfSize:14];
                label.height = 30;
                [label sizeToFit];
                [touGuoview addSubview:label];
                self.view = touGuoview;
                [self.view layoutIfNeeded];
            }
        }];
    }];
}

-(void)loadMoreData
{
    //8.2 取消之前的请求x
    [self.tableView.mj_footer endRefreshing];
    
    //参数
    int newPageIndex = self.lastPageIndex.intValue + 1;
    
    self.lastPageIndex = [NSString stringWithFormat:@"%d",newPageIndex];
    
    //参数
        UserMyModel *model = TakeLoginUserModel;
        NSString *userId = model.ID;
//    NSString *userId = @"ieatht97wfw30hfd";

    NSString *pageSize = @"20";
    NSString *pageIndex = [NSString stringWithFormat:@"%d",newPageIndex];

     NSString *url = @"my.do";
    // 3.设置请求体
    NSDictionary *json = @{
                           @"userId":userId,
                           @"pageSize" : pageSize,
                           @"pageIndex" : pageIndex
                           };
    
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:url parameters:json showHUDView:nil andBlock:^(id respondObj) {
        
//        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
//        NSLog(@"返回结果:%@",jsonStr);
        
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        
        PageInfoModel *model = [PageInfoModel mj_objectWithKeyValues:modelDict[@"pageInfo"]];
        
        NSArray *moreModels = model.artworks;
        
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
    
    InvestProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    ArtworksModel *model = self.models[indexPath.row];
    
    cell.model = model;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 374;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

     ArtworksModel *model = self.models[indexPath.row];
    
    if ([model.step isEqualToString:@"10"]){
        
        [MBProgressHUD showError:@"审核待审核,请您耐心等待"];
        
    }else if ([model.step isEqualToString:@"11"]){
        
        [MBProgressHUD showError:@"审核审核中,请您耐心等待"];
        
    }else if ([model.step isEqualToString:@"13"]){
        
        [MBProgressHUD showError:@"审核未通过,请您耐心等待"];
        
    }else if ([model.step isEqualToString:@"14"]){
        
        //跳转
        DetailFinanceViewController *detail = [[DetailFinanceViewController alloc] init];
        detail.artworkId = model.ID;
        [self.navigationController pushViewController:detail animated:YES];
        
    }else if ([model.step isEqualToString:@"21"]||[model.step isEqualToString:@"22"]||[model.step isEqualToString:@"24"]||[model.step isEqualToString:@"25"]){
        
        DetailCreationViewController *creationDetailsVC = [[DetailCreationViewController alloc] init];
        creationDetailsVC.artworkId = model.ID;
        [self.navigationController pushViewController:creationDetailsVC animated:YES];
        
    }else if([model.step isEqualToString:@"100"]) {
        
        [MBProgressHUD showError:@"项目可以编辑"];
    }else {
        
        [MBProgressHUD showError:@"拍卖即将开始"];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    if (superView.contentOffset.y < -64) {
        self.isfoot = YES;
        superView.contentOffset = CGPointMake(0, -64);
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
            [superView setContentOffset:CGPointMake(0, -64) animated:YES];
        }else{
            superView.contentOffset = CGPointMake(0, superView.contentOffset.y + y);
        }
    }
}
//-----------------------联动-----------------------

@end
