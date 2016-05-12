//
//  DetailFinanceViewController.m
//  融易投
//
//  Created by dongxin on 16/4/28.
//  Copyright © 2016年 dongxin. All rights reserved.
//



#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#import "CycleView.h"
#import "FinanceHeader.h"
#import "DetailFinanceViewController.h"
#import "UIImageView+WebCache.h"
#import "FinanceModel.h"
#import "RecordTableViewController.h"
#import "ProjectDetailsViewController.h"
#import "UserCommentViewController.h"
#import "ProjectDetailTableViewController.h"
#import "authorModel.h"
#import "navTitleButton.h"
#import "FinanceFooterView.h"
#import "UIImageView+WebCache.h"
#import "PostCommentController.h"
#import <MJExtension.h>
#import "ProjectDetailsModel.H"
#import "ArtworkModel.h"

@interface DetailFinanceViewController ()<UIScrollViewDelegate,FinanceFooterViewDelegate>
@property(nonatomic,strong) FinanceHeader *financeHeader;
@property(nonatomic,assign) BOOL isFirstIn;
@property(nonatomic,strong)ProjectDetailsModel *projModel;
@property(nonatomic,strong)FinanceFooterView *financeFooter;
@end

@implementation DetailFinanceViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    if (self.isFirstIn) {
        [self setupUI];
        [self loadData];
        
        
    }
}

-(void)loadView{
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirstIn = YES;
    [ArtworkModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"descriptions":@"description",
                 @"ID"          :@"id",
                 };
    }];
}
-(void)loadData{
    // 3.设置请求体
    NSString *userId = @"imhipoyk18s4k52u";
    NSString *urlStr = @"http://192.168.1.41:8085/app/investorArtWorkView.do";
    NSDictionary *json = @{
                           @"artWorkId" : self.artworkId,
                           @"currentUserId": userId,
                           };
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:urlStr parameters:json showHUDView:self.view andBlock:^(id respondObj) {
        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        NSLog(@"返回结果:%@",jsonStr);
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            //            NSDictionary *dict = modelDict[@"object"];
            ProjectDetailsModel *project = [ProjectDetailsModel mj_objectWithKeyValues:modelDict[@"object"]];
            self.projModel = project;
            self.artworkModel = project.artWork;
            [self loadDataToController];
            [self addFooterView];
        }];
    }];
}

-(void)loadData:(NSString *)urlStr parameters:(NSDictionary *)parameters andBlock:(void(^)(id respondObj))success{
    NSString *timestamp = [MyMD5 timestamp];
    NSString *appkey = MD5key;
    NSMutableString *strM = [NSMutableString string];
    NSArray *keys = [parameters allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    for (NSString *dictKey in sortedArray) {
        if (dictKey == sortedArray.lastObject) {
            [strM appendFormat:@"%@=%@",dictKey,parameters[dictKey]];
        }else{
            [strM appendFormat:@"%@=%@&",dictKey,parameters[dictKey]];
        }
    }
    [strM appendFormat:@"&timestamp=%@&key=%@",timestamp,appkey];
    NSString *signmsgMD5 = [MyMD5 md5:strM];
    NSDictionary *temp = @{
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    NSMutableDictionary *p = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [p addEntriesFromDictionary:temp];
    [[HttpRequstTool shareInstance] handlerNetworkingPOSTRequstWithServerUrl:urlStr Parameters:p showHUDView:self.view success:^(id respondObj) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            success(respondObj);
        }];
    }];
}

//加载数据
-(void)loadDataToController{
    //加载图片
    NSString *urlStr = [[NSString stringWithFormat:@"%@",self.artworkModel.picture_url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *picUrl = [NSURL URLWithString:urlStr];
    [self.financeHeader.imgView sd_setImageWithURL:picUrl];
    //加载用户信息
    // 存放在financeHeader中
    //头像userPicture
    authorModel *author = self.artworkModel.author;
    urlStr = [[NSString stringWithFormat:@"%@",author.pictureUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    picUrl = [NSURL URLWithString:urlStr];
    
    [self.financeHeader.userPicture ss_setHeader:picUrl];
    //用户真实姓名：userName
    self.financeHeader.userName.text = author.name;
    if (author.name == nil) {
        self.financeHeader.userName.text = @"匿名";
    }
    //用户头衔userTitle
    self.financeHeader.userTitle.text = author.username;
    //项目描述brief
    self.financeHeader.userContent.text = self.artworkModel.brief;
//     融资目标金额 investGoalMoney;
    self.financeHeader.investGoalMoney.text = [NSString stringWithFormat:@"%ld",(long)self.artworkModel.investGoalMoney];
    //MARK:TODO
    //融资开始时间 investStartDatetime;
    //融资结束时间/创作开始时间 investEndDatetime;
    //融资金额百分比 = 已融金额 / 目标金额
    self.financeHeader.investsMoney.text = [NSString stringWithFormat:@"%ld",(long)self.artworkModel.investsMoney];
    CGFloat value = self.artworkModel.investsMoney / self.artworkModel.investGoalMoney;
    self.financeHeader.progress.progress = value;
    self.financeHeader.progressLabel.text = [NSString stringWithFormat:@"%d%%",(int)(value * 100)];
//    投资人数 investorsNum;
    self.financeHeader.investNum.text =[NSString stringWithFormat:@"%ld",self.projModel.investNum];
}

-(void)setupUI{
    FinanceHeader *tView = [[[NSBundle mainBundle] loadNibNamed:@"FinanceHeader" owner:nil options:nil] lastObject];
    self.financeHeader = tView;
    self.financeHeader.width = ScreenWidth;
    self.topview.height = tView.height;
    tView.backgroundColor = [UIColor whiteColor];
    tView.width = ScreenWidth;
    [self.topview addSubview:self.financeHeader];
    self.middleView.frame = CGRectMake(0, CGRectGetHeight(self.topview.frame), ScreenWidth, ScreenHeight - CGRectGetMaxY(self.navigationController.navigationBar.frame));
    self.middleView.backgroundColor = [UIColor blueColor];
    self.cycleView.frame = self.middleView.bounds;
    self.cycleView.titleArray = self.titleArray;
    //添加控制器view
                [self addControllersToCycleView];
    [self.middleView addSubview:self.cycleView];
    //添加控制器视图 到scrollView中
    self.backgroundScrollView.contentSize = CGSizeMake(ScreenWidth,self.topview.height + self.middleView.height);
    self.backgroundScrollView.delegate = self;
}

//添加子控制器
-(void)addControllersToCycleView{
    //添加控制器view
    ProjectDetailTableViewController * pro1 = [[ProjectDetailTableViewController alloc] init];
    pro1.artWorkId = self.artworkId;
    pro1.topHeight = self.topview.height - 64;
    [self.controllersView addObject:pro1.view];
    [self addChildViewController:pro1];
    
    UserCommentViewController * userComment = [[UserCommentViewController alloc] init];
    userComment.artWorkId = self.artworkId;
    userComment.topHeight = self.topview.height - 64;
    [self.controllersView addObject:userComment.view];
    [self addChildViewController:userComment];

    RecordTableViewController * record1 = [[RecordTableViewController alloc] init];
    record1.ID = self.artworkId;
    record1.topHeight = self.topview.height - 64;
    [self.controllersView addObject:record1.view];
    [self addChildViewController:record1];
    
    self.cycleView.controllers = self.controllersView;
    int count = 0;
    for(UIView *vi in self.cycleView.controllers){
        vi.frame = CGRectMake(ScreenWidth * count, 0, ScreenWidth, self.cycleView.bottomScrollView.frame.size.height - 44);
        [self.cycleView.bottomScrollView addSubview:vi];
        count++;
    }
}
//设置底部按钮
- (void)addFooterView {
    CGFloat y = SSScreenH - 44;
    CGFloat w = SSScreenW;
    CGFloat h = 44;
    FinanceFooterView *bottomView = [[[NSBundle mainBundle] loadNibNamed:@"FinanceFooterView" owner:nil options:nil] lastObject];
    bottomView.delegate = self;
    bottomView.widthConstraint.constant = 170;
    NSString *num = [NSString stringWithFormat:@" %ld",self.artworkModel.praiseNUm];
    [bottomView.zan setTitle:num forState:(UIControlStateNormal)];
    bottomView.zan.selected = self.projModel.isPraise;
    bottomView.frame = CGRectMake(0, y, w, h);
    [self.view addSubview:bottomView];
}

//跳转到评论页面
-(void)jumpPLController{
    PostCommentController * postComment = [[PostCommentController alloc] init];
    postComment.title = @"评论";
    postComment.artworkId = self.artworkModel.ID;
    postComment.currentUserId = @"imhipoyk18s4k52u";
    postComment.messageId = self.artworkModel.ID;
    self.isFirstIn = NO;
    [self.navigationController pushViewController:postComment animated:YES];
}

-(void)jumpTZController{
    
    self.isFirstIn = NO;
}

//点赞
-(void)clickZan:(UIButton *)zan{
    NSString *userId = @"18701526255";
    NSString *urlStr = @"http://192.168.1.41:8085/app/artworkPraise.do";
    NSDictionary *json = @{
                           @"artworkId" : self.artworkId,
                           @"currentUserId": userId,
                           };
    [self loadData:urlStr parameters:json andBlock:^(id respondObj) {
        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        NSLog(@"返回结果:%@",jsonStr);
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        NSString *str = modelDict[@"resultMsg"];
        if ([str isEqualToString:@"成功"]) {
            UILabel *numLabel = [[UILabel alloc] initWithFrame:zan.frame];
            numLabel.center = zan.center;
            numLabel.textAlignment = NSTextAlignmentCenter;
            numLabel.text = @"+1";
            numLabel.textColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.7];
            [zan addSubview:numLabel];
            [UIView animateWithDuration:0.6 animations:^{
                CGFloat x = numLabel.centerX;
                CGPoint p = CGPointMake(x, 0);
                numLabel.center = p;
                numLabel.alpha = 0;
            } completion:^(BOOL finished) {
                [numLabel removeFromSuperview];
            }];
            NSString *zanNum = [NSString stringWithFormat:@" %ld",self.artworkModel.praiseNUm + 1];
            [zan setTitle:zanNum forState:(UIControlStateNormal)];
        }
    }];
}
//懒加载
-(CycleView *)cycleView{
    if (!_cycleView) {
        _cycleView = [[CycleView alloc] init];
        _cycleView.backgroundColor = [UIColor redColor];
    }
    return _cycleView;
}

-(NSMutableArray *)titleArray{
    if (!_titleArray) {
        NSArray *array = @[@"项目详情",@"用户评论",@"投资记录"];
        _titleArray = [NSMutableArray arrayWithArray:array];
    }
    return _titleArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSMutableArray *)controllersView{
    if (!_controllersView) {
        _controllersView = [NSMutableArray arrayWithCapacity:self.titleArray.count];
    }
    return _controllersView;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
