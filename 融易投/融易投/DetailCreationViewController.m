//
//  DetailCreationViewController.m
//  融易投
//
//  Created by dongxin on 16/4/28.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#import "CycleView.h"
#import "TopView.h"
#import "DetailCreationViewController.h"
#import "ProjectDetailTableViewController.h"
#import "UserCommentViewController.h"
#import "RecordTableViewController.h"
#import "FinanceFooterView.h"
#import "PostCommentController.h"
#import "TopView.h"
#import "ProjectDetailsModel.h"
#import "ProjectDetailsResultModel.h"
#import "ArtworkModel.h"
#import "authorModel.h"
#import <MJExtension.h>
#import "TimeAxisTableViewController.h"
#import <UIImageView+WebCache.h>

@interface DetailCreationViewController ()<FinanceFooterViewDelegate,UIScrollViewDelegate>
@property(nonatomic,strong) TopView *tpView;
@property(nonatomic,strong)ProjectDetailsModel *projModel;
@property(nonatomic,strong)ArtworkModel *artworkModel;
@property(nonatomic,assign) BOOL isFirstIn;
@end
@implementation DetailCreationViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    if (self.isFirstIn) {
        [self setupUI];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirstIn = YES;
    [ProjectDetailsModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"artworkAttachmentList" : @"ArtworkAttachmentListModel",
                 };
    }];
    [ArtworkModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"descriptions":@"description",
                 @"ID"          :@"id",
                 };
    }];
    [self loadData];
}


-(void)loadData{
    // 3.设置请求体
    NSString *urlStr = @"artWorkCreationView.do";
    NSString *userId = [[RYTLoginManager shareInstance] takeUser].ID;
    NSDictionary *json = [NSDictionary dictionary];
    if (userId) {
        json = @{
                 @"artWorkId" : self.artworkId,
                 @"currentUserId": userId,
                 };
    }else{
        json = @{
                 @"artWorkId" : self.artworkId,
                 };
    }
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:urlStr parameters:json showHUDView:self.view andBlock:^(id respondObj) {
        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        NSLog(@"返回结果:%@",jsonStr);
        dispatch_async(dispatch_get_main_queue(), ^{
//        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
            ProjectDetailsResultModel *project = [ProjectDetailsResultModel mj_objectWithKeyValues:respondObj];
            self.projModel = project.object;
            self.artworkModel = self.projModel.artwork;
            [self loadDataToController];
            [self addFooterView];
        });
    }];
}

//加载数据
-(void)loadDataToController{
//    //加载图片
    NSString *urlStr = [[NSString stringWithFormat:@"%@",self.artworkModel.picture_url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *picUrl = [NSURL URLWithString:urlStr];
    [self.tpView.imgView sd_setImageWithURL:picUrl];
    self.tpView.titleLabel.text = self.artworkModel.title;
    //加载用户信息
    // 存放在tpView中
    //头像userPicture
    authorModel *author = self.artworkModel.author;
    urlStr = [[NSString stringWithFormat:@"%@",author.pictureUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    picUrl = [NSURL URLWithString:urlStr];
//
    [self.tpView.userPicture ss_setHeader:picUrl];
    //用户真实姓名：userName
    self.tpView.userName.text = author.name;
    if (author.name == nil) {
        self.tpView.userName.text = @"匿名";
    }
    //用户头衔userTitle
    self.tpView.userTitle.text = author.username;
    //项目描述brief
    self.tpView.brief.text = self.artworkModel.descriptions;
//        MARK:TODO
    //融资结束时间/创作开始时间 investEndDatetime;
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:self.artworkModel.investEndDatetime / 1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd日"];
    self.tpView.finishedTime.text =  [dateFormatter stringFromDate:endDate];
}

-(void)setupUI{
    TopView *tView = [[[NSBundle mainBundle] loadNibNamed:@"TopView" owner:nil options:nil] lastObject];
    self.tpView = tView;
    self.tpView.width = ScreenWidth;
    self.topview.height = tView.height;
    self.topview.width = ScreenWidth;
    tView.backgroundColor = [UIColor whiteColor];
    tView.width = ScreenWidth;
    [self.topview addSubview:self.tpView];
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
    [self.view bringSubviewToFront:self.topview];
}

//添加子控制器
-(void)addControllersToCycleView{
    //添加控制器view
//    TimeAxisTableViewController *time = [[TimeAxisTableViewController alloc] init];
//    [self.controllersView addObject:time.view];
//    [self addChildViewController:time];
    
    ProjectDetailTableViewController * pro1 = [[ProjectDetailTableViewController alloc] init];
    pro1.artWorkId = self.artworkId;
    
    pro1.isFinance = NO;
    pro1.topHeight = self.topview.height - 64;
    [self.controllersView addObject:pro1.view];
    [self addChildViewController:pro1];
    
    UserCommentViewController * userComment = [[UserCommentViewController alloc] init];
    userComment.artWorkId = self.artworkId;
    userComment.topHeight = self.topview.height - 64;
    [self.controllersView addObject:userComment.view];
    [self addChildViewController:userComment];
//
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
    bottomView.widthConstraint.constant = 0;
    NSString *num = [NSString stringWithFormat:@" %ld",self.artworkModel.praiseNUm];
    [bottomView.zan setTitle:num forState:(UIControlStateNormal)];
    bottomView.zan.selected = self.projModel.isPraise;
    bottomView.delegate = self;
    bottomView.frame = CGRectMake(0, y, w, h);
    [self.view addSubview:bottomView];
}

//-(void)jumpPLController{
//    PostCommentController * postComment = [[PostCommentController alloc] init];
//    postComment.title = @"评论";
//    //    financeModel
//    //    @property(nonatomic,copy) NSString *artworkId;
//    //    @property(nonatomic,copy) NSString *currentUserId;
//    //    @property(nonatomic,copy) NSString *messageId;
//    //    @property(nonatomic,copy) NSString *fatherCommentId;
////    postComment.artworkId = self.financeModel.ID;
//    postComment.currentUserId = @"khsadkovihso";
////    postComment.messageId = self.financeModel.ID;
//    [self.navigationController pushViewController:postComment animated:YES];
//}
//跳转到评论页面
-(void)jumpPLController{
    PostCommentController * postComment = [[PostCommentController alloc] init];
    postComment.title = @"评论";
    postComment.artworkId = self.artworkId;
    postComment.currentUserId = @"imhipoyk18s4k52u";
    self.isFirstIn = NO;
    [self.navigationController pushViewController:postComment animated:YES];
}

-(void)jumpTZController{
    
//    self.isFirstIn = NO;
}

//点赞
-(void)clickZan:(UIButton *)zan{
    
    RYTLoginManager *manager =  [RYTLoginManager shareInstance];
    if ([manager showLoginViewIfNeed]) {
    }else{
        NSString *userId = [[RYTLoginManager shareInstance] takeUser].ID;
        NSString *urlStr = @"artworkPraise.do";
        NSDictionary *json = @{
                               @"artworkId" : self.artworkId,
                               @"currentUserId": userId,
                               };
        [[HttpRequstTool shareInstance] loadData:POST serverUrl:urlStr parameters:json showHUDView:self.view andBlock:^(id respondObj) {
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
}

-(CycleView *)cycleView{
    if (!_cycleView) {
        _cycleView = [[CycleView alloc] init];
        _cycleView.backgroundColor = [UIColor redColor];
    }
    return _cycleView;
}

-(NSMutableArray *)titleArray{
    if (!_titleArray) {
        //@"项目进度"
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
