//
//  UserCommentViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/11.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "UserCommentViewController.h"

#import "CommonHeader.h"
#import "CommonFooter.h"

#import <MJExtension.h>

#import "UserCommonResultModel.h"
#import "UserCommentObjectModel.h"
#import "ArtworkCommentListModel.h"
#import "CreatorModel.h"

#import "UserCommonCell.h"
#import "UserReplyCommentCell.h"
#import "ArtworkCommentListModel.h"

@interface UserCommentViewController ()
@property (nonatomic, strong) NSMutableArray *models;
//-----------------------联动属性-----------------------
@property(nonatomic,assign) BOOL isfoot;
//-----------------------联动属性-----------------------
@end

@implementation UserCommentViewController

static NSString *ID = @"userCommentCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 300;
    self.tableView.rowHeight = 250;
    
    [UserCommentObjectModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"artworkCommentList":[ArtworkCommentListModel class],
                 @"fatherComment" : [ArtworkCommentListModel class],
                 };
    }];
    
    
    [CreatorModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID" : @"id"};
    }];
    [self loadData];
    [self setUpRefresh];
    //注册创建cell ,这样注册就不用在XIB设置ID
    [self.tableView registerNib:[UINib nibWithNibName:@"UserCommonCell" bundle:nil] forCellReuseIdentifier:ID];
    [self.tableView registerNib:[UINib nibWithNibName:@"UserReplyCommentCell" bundle:nil] forCellReuseIdentifier:@"ReplyCell"];
}

-(void)setUpRefresh
{
    //自定义上拉加载更多
    self.tableView.mj_footer = [CommonFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    //要是其他控制器也需要,直接把上面的拷贝到其他控制器就可以了
}


-(void)loadData{
    
    //参数
    //    NSString *artWorkId = [[NSUserDefaults standardUserDefaults] objectForKey:@"artWorkId"];
    NSString *artWorkId = self.artWorkId;
    //
//    NSString *messageId = self.artWorkId;
    NSString *pageIndex = @"1";
    NSString *pageSize = @"20";
    NSString *timestamp = [MyMD5 timestamp];
    NSString *appkey = MD5key;
    NSString *signmsg = [NSString stringWithFormat:@"artWorkId=%@&pageIndex=%@&pageSize=%@&timestamp=%@&key=%@",artWorkId,pageIndex,pageSize,timestamp,appkey];
    NSString *signmsgMD5 = [MyMD5 md5:signmsg];
    // 1.创建请求 http://j.efeiyi.com:8080/app-wikiServer/
    NSString *url = @"http://192.168.1.41:8085/app/investorArtWorkComment.do";
    // 3.设置请求体
    NSDictionary *json = @{
                           @"artWorkId" : artWorkId,
//                           @"messageId":messageId,
                           @"pageIndex":pageIndex,
                           @"pageSize":pageSize,
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    
    [[HttpRequstTool shareInstance] handlerNetworkingPOSTRequstWithServerUrl:url Parameters:json showHUDView:self.view success:^(id respondObj) {
        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        NSLog(@"返回结果:%@",jsonStr);
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        UserCommonResultModel *userCommentObject = [UserCommonResultModel mj_objectWithKeyValues:modelDict];
        
        self.models = [ArtworkCommentListModel mj_objectArrayWithKeyValuesArray:userCommentObject.object.artworkCommentList];
        for (ArtworkCommentListModel *m in self.models) {
            NSLog(@"model : %@,%@ \n",m.ID,m.content);
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [self.tableView reloadData];
            
        }];
        
    }];
}

-(void)loadMoreData{
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return  self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArtworkCommentListModel *model = self.models[indexPath.row];
    if (model.fatherComment == nil) {
        
        UserCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
        cell.model = model;
        return cell;
    }else{
        
        UserReplyCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReplyCell" forIndexPath:indexPath];
        cell.model = model;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ArtworkCommentListModel *model = self.models[indexPath.row];

    return  model.cellHeight;
}

//-----------------------联动-----------------------
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.topHeight > 0) {
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
}
//-----------------------联动-----------------------


@end
