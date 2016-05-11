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
#import "CreationModel.h"
#import <UIImageView+WebCache.h>
@interface DetailCreationViewController ()<FinanceFooterViewDelegate,UIScrollViewDelegate>
@property(nonatomic,strong) TopView *tpView;
@end
@implementation DetailCreationViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self setupUI];
    [self loadDataToController];
    [self addFooterView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

//加载数据
-(void)loadDataToController{
//    //加载图片
    NSString *urlStr = [[NSString stringWithFormat:@"%@",self.creationModel.picture_url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *picUrl = [NSURL URLWithString:urlStr];
    [self.tpView.imgView sd_setImageWithURL:picUrl];
    //加载用户信息
    // 存放在tpView中
    //头像userPicture
    authorModel *author = self.creationModel.author;
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
    self.tpView.userTitle.text = self.creationModel.descriptions;
//    //     融资目标金额 investGoalMoney;
//    self.tpView.investGoalMoney.text = [NSString stringWithFormat:@"%ld",(long)self.financeModel.investGoalMoney];
//    //MARK:TODO
//    //融资开始时间 investStartDatetime;
//    //融资结束时间/创作开始时间 investEndDatetime;
//    //融资金额百分比 = 已融金额 / 目标金额
//    self.tpView.investsMoney.text = [NSString stringWithFormat:@"%ld",(long)self.financeModel.investsMoney];
//    CGFloat value = self.financeModel.investsMoney / self.financeModel.investGoalMoney;
//    self.tpView.progress.progress = value;
//    self.tpView.progressLabel.text = [NSString stringWithFormat:@"%d%%",(int)(value * 100)];
//    //    投资人数 investorsNum;
//    self.tpView.investNum.text =[NSString stringWithFormat:@"%ld",self.financeModel.investorsNum];
}

-(void)setupUI{
    TopView *tView = [[[NSBundle mainBundle] loadNibNamed:@"TopView" owner:nil options:nil] lastObject];
    self.tpView = tView;
    self.tpView.width = ScreenWidth;
    self.topview.height = tView.height;
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
}

//添加子控制器
-(void)addControllersToCycleView{
    //添加控制器view
    ProjectDetailTableViewController * pro1 = [[ProjectDetailTableViewController alloc] init];
    pro1.artWorkId = self.creationModel.ID;
    pro1.isFinance = NO;
    pro1.topHeight = self.topview.height - 64;
    [self.controllersView addObject:pro1.view];
    [self addChildViewController:pro1];
    
    UserCommentViewController * userComment = [[UserCommentViewController alloc] init];
    userComment.artWorkId = self.creationModel.ID;
    userComment.topHeight = self.topview.height - 64;
    [self.controllersView addObject:userComment.view];
    [self addChildViewController:userComment];
//
    RecordTableViewController * record1 = [[RecordTableViewController alloc] init];
    record1.ID = self.creationModel.ID;
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
    bottomView.delegate = self;
    bottomView.frame = CGRectMake(0, y, w, h);
    [self.view addSubview:bottomView];
}

-(void)jumpPLController{
    PostCommentController * postComment = [[PostCommentController alloc] init];
    postComment.title = @"评论";
    //    financeModel
    //    @property(nonatomic,copy) NSString *artworkId;
    //    @property(nonatomic,copy) NSString *currentUserId;
    //    @property(nonatomic,copy) NSString *messageId;
    //    @property(nonatomic,copy) NSString *fatherCommentId;
//    postComment.artworkId = self.financeModel.ID;
    postComment.currentUserId = @"khsadkovihso";
//    postComment.messageId = self.financeModel.ID;
    [self.navigationController pushViewController:postComment animated:YES];
}

-(void)jumpTZController{
    
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
        NSArray *array = @[@"项目进度",@"项目详情",@"用户评论",@"投资记录"];
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
