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

#import "UIImageView+WebCache.h"

@interface DetailFinanceViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong) FinanceHeader *financeHeader;
@end

@implementation DetailFinanceViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
   [self setupUI];
    [self loadDataToController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

//加载数据
-(void)loadDataToController{
    //加载图片
    NSString *urlStr = [[NSString stringWithFormat:@"%@",self.financeModel.picture_url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *picUrl = [NSURL URLWithString:urlStr];
    [self.financeHeader.imgView sd_setImageWithURL:picUrl];
    //加载用户信息
    // 存放在financeHeader中
    //头像userPicture
    authorModel *author = self.financeModel.author;
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
    self.financeHeader.userContent.text = self.financeModel.brief;
//     融资目标金额 investGoalMoney;
    self.financeHeader.investGoalMoney.text = [NSString stringWithFormat:@"%ld",(long)self.financeModel.investGoalMoney];
    //MARK:TODO
    //融资开始时间 investStartDatetime;
    //融资结束时间/创作开始时间 investEndDatetime;
    //融资金额百分比 = 已融金额 / 目标金额
    self.financeHeader.investsMoney.text = [NSString stringWithFormat:@"%ld",(long)self.financeModel.investsMoney];
    CGFloat value = self.financeModel.investsMoney / self.financeModel.investGoalMoney;
    self.financeHeader.progress.progress = value;
    self.financeHeader.progressLabel.text = [NSString stringWithFormat:@"%d%%",(int)(value * 100)];
//    投资人数 investorsNum;
    self.financeHeader.investNum.text =[NSString stringWithFormat:@"%ld",self.financeModel.investorsNum];
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

-(void)addControllersToCycleView{
    //添加控制器view
    ProjectDetailTableViewController * pro1 = [[ProjectDetailTableViewController alloc] init];
    pro1.artWorkId = self.financeModel.ID;
    pro1.topHeight = self.topview.height - 64;
    [self.controllersView addObject:pro1.view];
    [self addChildViewController:pro1];
    
    UserCommentViewController * userComment = [[UserCommentViewController alloc] init];
    userComment.artWorkId = self.financeModel.ID;
    userComment.topHeight = self.topview.height - 64;
    [self.controllersView addObject:userComment.view];
    [self addChildViewController:userComment];

    RecordTableViewController * record1 = [[RecordTableViewController alloc] init];
    record1.ID = self.financeModel.ID;
    record1.topHeight = self.topview.height - 64;
    [self.controllersView addObject:record1.view];
    [self addChildViewController:record1];
    
    self.cycleView.controllers = self.controllersView;
    int count = 0;
    for(UIView *vi in self.cycleView.controllers){
        vi.frame = CGRectMake(ScreenWidth * count, 0, ScreenWidth, self.cycleView.bottomScrollView.frame.size.height);
        [self.cycleView.bottomScrollView addSubview:vi];
        count++;
    }
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
