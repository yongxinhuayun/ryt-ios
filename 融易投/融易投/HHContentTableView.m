//
//  HHContentTableView.m
//  HHHorizontalPagingView
//
//  Created by Huanhoo on 15/7/16.
//  Copyright (c) 2015年 Huanhoo. All rights reserved.
//

#import "HHContentTableView.h"


#import "CommonHeader.h"
#import "CommonFooter.h"

#import "ProjectDetailCell.h"

@interface HHContentTableView ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation HHContentTableView


+ (HHContentTableView *)contentTableView {
    
    HHContentTableView *contentTV = [[HHContentTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    contentTV.backgroundColor = [UIColor clearColor];
    contentTV.dataSource = contentTV;
    contentTV.delegate = contentTV;
    
    //设置滚动偏移
    contentTV.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 200, 0);

    contentTV.contentInset = UIEdgeInsetsMake(0, 0, 200, 0);
        
    //设置上下拉刷新
//   contentTV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        // 进入刷新状态后会自动调用这个block
//       
//    }];
//
//    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
//    contentTV.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
//    
//    // 马上进入刷新状态
//    [contentTV.mj_header beginRefreshing];
//        
//   contentTV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        // 进入刷新状态后会自动调用这个block
//    }];
//    
//    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
//   contentTV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
    return contentTV;
}



-(void)loadNewData{
    
    //参数
    NSString *artWorkId = @"qydeyugqqiugd7";
    NSString *currentUserId = @"imhipoyk18s4k52u";
    
    //注意:刷新最新数据的时候,是全部刷新,包括4个tab里面的数据所以应该判断当前tab为哪个选项
    NSString *tab = @"view";
    
    NSString *timestamp = [MyMD5 timestamp];
    NSString *appkey = MD5key;
    
    NSString *signmsg = [NSString stringWithFormat:@"artWorkId=%@&currentUserId=%@&tab=%@&timestamp=%@&key=%@",artWorkId,currentUserId,tab,timestamp,appkey];
    
    NSLog(@"%@",signmsg);
    
    NSString *signmsgMD5 = [MyMD5 md5:signmsg];
    
    // 1.创建请求 http://j.efeiyi.com:8080/app-wikiServer/
    NSString *url = @"http://192.168.1.69:8001/app/investorArtWork.do";
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"artWorkId" : artWorkId,
                           @"tab"       : tab,
                           @"currentUserId":currentUserId,
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    
    [[HttpRequstTool shareInstance] handlerNetworkingPOSTRequstWithServerUrl:url Parameters:json showHUDView:self success:^(id respondObj) {
        
        
        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        NSLog(@"返回结果:%@",jsonStr);
        
        /*
         {"artworkInvestTopList":null,"artworkInvestList":null,
         "artworkAttachmentList":[],
         "artworkCommentList":null,"investNum":0,"resultCode":"0","isPraise":false,"artworkdirection":null,"time":"66日1时2分35秒","resultMsg":"成功",
         "object":{"id":"qydeyugqqiugd7","title":"测试6","brief":"这是一个","description":null,"status":"0","investGoalMoney":1.00,"investStartDatetime":1455005261000,"investEndDatetime":1454314064000,"auctionStartDatetime":1454400455000,"auctionEndDatetime":1462003649000,
         "author":{"id":"icjxkedl0000b6i0","username":"123123","name":"魏立中","pictureUrl":"http://tenant.efeiyi.com/background/蔡水况.jpg","cityId":null,"status":"0","createDatetime":null,"type":"10000",                 "master":
         {"id":"icjxkedl0000b6i0","brief":"版画家，他使得业已消失数百年的明代印刷业老字号十竹斋重新恢复并焕发生机，成为杭州市文化产业传承创新的亮点。","title":"国家级传承人","favicon":"http://tenant.efeiyi.com/background/蔡水况.jpg","birthday":"1968年","level":"1","content":null,"presentAddress":"浙江","backgroundUrl":"background/魏立中.jpg","provinceName":"浙江","theStatus":"1","logoUrl":"logo/魏立中.jpg","masterSpeech":null,"artCategory":null,"titleCertificate":null,"feedback":null,"identityFront":null,"identityBack":null}},
         "createDatetime":1454314046000,"picture_url":"http://tenant.efeiyi.com/background/蔡水况.jpg","step":"31","investsMoney":0,"creationEndDatetime":1458285492000,"type":"3","newCreationDate":null,"auctionNum":null,"newBidingPrice":500.00,"newBiddingDate":null,"sorts":"6","winner":null,"feedback":null,"duration":null,"startingPrice":1000}}
         
         */
        
        
        //        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        //
        //        ArtworkModel *models = [ArtworkModel mj_objectWithKeyValues:modelDict];
        //
        //        NSLog(@"%@",models);
        //
        //        NSLog(@"%@",models.artworkAttachmentList.fileName);
        //        NSLog(@"%@",models.object.author.name);
        
        
        //在主线程刷新UI数据
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [self reloadData];
            
        }];
    }];


}

-(void)loadMoreData{
    
}


#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"projectDetailCell";
    
    ProjectDetailCell *cell = (ProjectDetailCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell) {
        
        cell = [[ProjectDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@",@(indexPath.row)];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 487;
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 60.f;
//    
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com