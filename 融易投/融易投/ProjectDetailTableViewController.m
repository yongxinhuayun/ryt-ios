//
//  ProjectDetailTableViewController.m
//  融易投
//
//  Created by dongxin on 16/5/3.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "ProjectDetailTableViewController.h"
#import "IntroduceTableViewCell.h"
#import "InstructionCell.h"
#import "ProjectDetailsResultModel.h"
#import "ProjectDetailsModel.h"
#import "ArtworkAttachmentListModel.h"
#import "ArtworkModel.h"
#import "ArtworkdirectionModel.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>

@interface ProjectDetailTableViewController ()
@property(nonatomic,strong)NSMutableArray *imgList;
@property(nonatomic,strong)ProjectDetailsModel *model;

//-----------------------联动属性-----------------------
@property(nonatomic,assign) BOOL isfoot;
//-----------------------联动属性-----------------------
@end

@implementation ProjectDetailTableViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"IntroduceTableViewCell" bundle:nil] forCellReuseIdentifier:@"IntroduceCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"InstructionCell" bundle:nil] forCellReuseIdentifier:@"InstructionCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 500;
    [self improveTableView];
    //替换模型中对应的key
    [ProjectDetailsModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"descriptions":@"description",
                 };
    }];
    //模型中有个数组属性artworkAttachmentList，数组里面又要装着ArtworkAttachmentListModel模型
    [ProjectDetailsModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"artworkAttachmentList" : @"ArtworkAttachmentListModel",
                 };
    }];
    [self loadData];
}

-(void)loadData
{
    //参数
    NSLog(@"-----%@",self.artWorkId); //imyuxey8ze7lp8h5 ---in5z7r5f2w2f73so
    NSString *currentUserId = @"imhipoyk18s4k52u";
    NSString *timestamp = [MyMD5 timestamp];
    NSString *appkey = MD5key;
    NSString *signmsg = [NSString stringWithFormat:@"artWorkId=%@&currentUserId=%@&timestamp=%@&key=%@",self.artWorkId,currentUserId,timestamp,appkey];
    NSLog(@"%@",signmsg);
    NSString *signmsgMD5 = [MyMD5 md5:signmsg];
    // 1.创建请求 http://j.efeiyi.com:8080/app-wikiServer/
    NSString *url = [[NSString alloc] init];
    if (self.isFinance) {
        url = @"http://192.168.1.41:8080/app/artWorkCreationView.do";
    }else
    {
        url = @"http://192.168.1.41:8080/app/investorArtWorkView.do";
    }
    // 3.设置请求体
    NSDictionary *json = @{
                           @"artWorkId" : self.artWorkId,
                           @"currentUserId":currentUserId,
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    
    [[HttpRequstTool shareInstance] handlerNetworkingPOSTRequstWithServerUrl:url Parameters:json showHUDView:self.view success:^(id respondObj) {
         NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        //        NSLog(@"%@",modelDict);
        //字典数组 -> 模型数组
        NSLog(@"%@",modelDict);
        ProjectDetailsResultModel *dict = [ProjectDetailsResultModel mj_objectWithKeyValues:modelDict];
        self.imgList = dict.object.artworkAttachmentList;
        self.model = dict.object;
        //在主线程刷新UI数据
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tableView reloadData];
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        IntroduceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IntroduceCell" forIndexPath:indexPath];
        cell.introduceLabel.text = self.model.artWork.brief;
        cell.imgArray = self.imgList;
        [cell imgArray:self.imgList];
        return  cell;
    }else{
//         (indexPath.row == 1)
       InstructionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InstructionCell" forIndexPath:indexPath];
        if (indexPath.section == 1) {
            cell.instructionLabel.text = self.model.artworkdirection.make_instru;
        }else{
            cell.instructionLabel.text = self.model.artworkdirection.financing_aq;
        }
        return cell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 需要通过模型计算cell的高度
    if (indexPath.section == 0) {
        return [self.model cellHeight:cellBrief];
    }else if (indexPath.section == 1){
        return [self.model cellHeight:(cellInstru)];
    }else{
        return [self.model cellHeight:(cellAQ)];
    }

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

        if (section == 0) {
            return @"项目介绍";
        }else if (section == 1){
            return @"创作过程说明";
        }else{
            return @"融资解惑";
        }
}

-(void)improveTableView
{
    self.tableView.tableHeaderView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc]init];  //删除多余的行
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {  //防止分割线显示不
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
}

//-----------------------联动-----------------------
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//去掉UItableview headerview黏性(sticky)
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 25; //sectionHeaderHeight
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
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


-(NSMutableArray *)imgList{
    if (!_imgList) {
        _imgList = [NSMutableArray array];
    }
    return _imgList;
}

-(ProjectDetailsModel *)model{
    if (!_model) {
        _model = [[ProjectDetailsModel alloc] init];
    }
    return _model;
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}

@end
