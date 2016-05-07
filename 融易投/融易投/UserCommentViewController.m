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
//    [self loadData];
//    [self setUpRefresh];
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
    NSString *url = @"http://192.168.1.41:8080/app/investorArtWorkComment.do";
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
        


//        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
//        
//        NSLog(@"%@",modelDict);
//        
//        UserCommentObjectModel *model = [UserCommentObjectModel mj_objectWithKeyValues:modelDict[@"object"]];
//        
//        NSLog(@"%@",model);
//        
//        
//        self.models = model.artworkCommentList;
//        
//        NSLog(@"------%@",[self.models class]);
//        
//        NSLog(@"------%@",self.models);
//        
//        NSLog(@"--------%ld",self.models.count);
//        
//        for (ArtworkCommentListModel *model in self.models) {
//            
//            NSLog(@"%@",model);
//            
//            NSLog(@"%ld",model.createDatetime);
//        }
        
        
        //4. 刷新数据
        //        [self.tableView reloadData];
        
        //在主线程刷新UI数据
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
        UserCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.model = model;
        return cell;
    }else{
        UserReplyCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReplyCell" forIndexPath:indexPath];
        cell.model = model;
        cell.cellHeight = 10;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ArtworkCommentListModel *model = self.models[indexPath.row];
    CGFloat margin = 10;
    CGFloat userIconY = 50;
    CGFloat maxY = userIconY + margin * 2;
    CGFloat textW = [UIScreen mainScreen].bounds.size.width - 2 * 10;
    CGSize textMaxSize = CGSizeMake(textW, MAXFLOAT);
    CGFloat textH = [[NSString stringWithFormat:@":%@",model.content] boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:15] } context:nil].size.height;
    maxY = maxY + textH + margin;
    return  maxY;
}

@end
