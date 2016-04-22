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

@interface UserCommentViewController ()


@property (nonatomic, strong) NSMutableArray *models;

@end

@implementation UserCommentViewController

static NSString *ID = @"userCommentCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
//   self.tableView.backgroundColor = [UIColor blueColor];
    
    
    [ArtworkCommentListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        
        return @{
                 @"ID"          :@"id",
                 };
    }];
    
    [CreatorModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        
        return @{
                 @"ID"          :@"id",
                 };
    }];
    
    [self loadData];
    
    [self setUpRefresh];
    
    //注册创建cell ,这样注册就不用在XIB设置ID
    [self.tableView registerNib:[UINib nibWithNibName:@"UserCommonCell" bundle:nil] forCellReuseIdentifier:ID];
    
    

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
    
     NSString *artWorkId = @"qydeyugqqiugd2";
    
    NSLog(@"-----%@",artWorkId); //imyuxey8ze7lp8h5 ---in5z7r5f2w2f73so
    
    
    NSString *messageId = @"imhipoyk18s4k52u";
    
    NSString *pageIndex = @"1";
    NSString *pageSize = @"20";
    
    NSString *timestamp = [MyMD5 timestamp];
    NSString *appkey = MD5key;
    
    NSString *signmsg = [NSString stringWithFormat:@"artWorkId=%@&messageId=%@&pageIndex=%@&pageSize=%@&timestamp=%@&key=%@",artWorkId,messageId,pageIndex,pageSize,timestamp,appkey];
    
    NSLog(@"%@",signmsg);
    
    NSString *signmsgMD5 = [MyMD5 md5:signmsg];
    
    // 1.创建请求 http://j.efeiyi.com:8080/app-wikiServer/
    NSString *url = @"http://192.168.1.69:8001/app/investorArtWorkComment.do";
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"artWorkId" : artWorkId,
                           @"messageId":messageId,
                           @"pageIndex":pageIndex,
                           @"pageSize":pageSize,
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    
    [[HttpRequstTool shareInstance] handlerNetworkingPOSTRequstWithServerUrl:url Parameters:json showHUDView:self.view success:^(id respondObj) {
        
        
//        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
//        NSLog(@"返回结果:%@",jsonStr);
        
        /*
         {"resultCode":"0","resultMsg":"成功",
         "object":
                {"artworkCommentList":
                        [
                            {"id":"3",
                            "content":"地方",
                            "creator":{"id":"iijq9f1r7apprtab","username":"18510251819","name":"杜锐","pictureUrl":"http://rongyitou2.efeiyi.com/headPortrait/18510251819.jpeg@!ryt_head_portrai","cityId":null,"status":"1","createDatetime":1450930002000,"type":null,"master":null},
                            "createDatetime"1460194750000,
                             "status":"1",
                             "isWatch":"0",
                             "fatherComment":null},
                            {"id":"1","content":"阿凡达","creator":{"id":"imhfp1yr4636pj49","username":"18513234278","name":null,"pictureUrl":"http://rongyitou2.efeiyi.com/headPortrait/18513234278","cityId":null,"status":"1","createDatetime":1459498453000,"type":null,"master":null},"createDatetime":1455861042000,"status":"1","isWatch":"0","fatherComment":{"id":"3","content":"地方","creator":{"id":"iijq9f1r7apprtab","username":"18510251819","name":"杜锐","pictureUrl":"http://rongyitou2.efeiyi.com/headPortrait/18510251819.jpeg@!ryt_head_portrai","cityId":null,"status":"1","createDatetime":1450930002000,"type":null,"master":null},"createDatetime":1460194750000,"status":"1","isWatch":"0","fatherComment":null}}
                            ]
                }
        }
         
         */
        
        /*
         {"resultCode":"0",
         "resultMsg":"成功",
         "object":{
                "artworkCommentList":[
                        {"id":"3",
                        "content":"地方",
                        "creator":{
                                "id":"iijq9f1r7apprtab","username":"18510251819","name":"杜锐","pictureUrl":"http://rongyitou2.efeiyi.com/headPortrait/18510251819.jpeg@!ryt_head_portrai","cityId":null,"status":"1","createDatetime":1450930002000,"type":null,"master":null
                                    },
                        "createDatetime":1460194750000,
                        "status":"1",
                        "isWatch":"0",
                        "fatherComment":null
                            },
                        {"id":"1","content":"阿凡达","creator":{"id":"imhfp1yr4636pj49","username":"18513234278","name":null,"pictureUrl":"http://rongyitou2.efeiyi.com/headPortrait/18513234278","cityId":null,"status":"1","createDatetime":1459498453000,"type":null,"master":null},"createDatetime":1455861042000,"status":"1","isWatch":"0","fatherComment":{"id":"3","content":"地方","creator":{"id":"iijq9f1r7apprtab","username":"18510251819","name":"杜锐","pictureUrl":"http://rongyitou2.efeiyi.com/headPortrait/18510251819.jpeg@!ryt_head_portrai","cityId":null,"status":"1","createDatetime":1450930002000,"type":null,"master":null},"createDatetime":1460194750000,"status":"1","isWatch":"0","fatherComment":null}}]}}
         */

        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        
        UserCommonResultModel *userCommentObject = [UserCommonResultModel mj_objectWithKeyValues:modelDict];
        
        self.models = userCommentObject.object.artworkCommentList;
        
        NSLog(@"11111111111111----%ld",self.models.count);
        NSLog(@"%@",self.models);
        
        for (ArtworkCommentListModel *model in self.models) {
            
//            NSLog(@"%@",model.ID);
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
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return  self.models.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UserCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    ArtworkCommentListModel *model = self.models[indexPath.row];
    
    cell.model = model;
    
    return cell;
}




@end
