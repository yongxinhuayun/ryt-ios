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

@interface DetailFinanceViewController ()
@property(nonatomic,strong) FinanceHeader *financeHeader;
@end

@implementation DetailFinanceViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self setupUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //显示数据
    NSString *urlStr = [[NSString stringWithFormat:@"%@",self.financeModel.picture_url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *picture_urlURL = [NSURL URLWithString:urlStr];
    

    //    NSLog(@"%@",picture_urlURL);
    
//    [self.bgImageView sd_setImageWithURL:picture_urlURL];
    
}

-(void)setupUI{
    FinanceHeader *tView = [[[NSBundle mainBundle] loadNibNamed:@"FinanceHeader" owner:nil options:nil] lastObject];
    self.financeHeader = tView;
    self.topview.height = tView.height;
    tView.backgroundColor = [UIColor whiteColor];
    tView.width = ScreenWidth;
    [self.topview addSubview:self.financeHeader];
    self.middleView.frame = CGRectMake(0, CGRectGetHeight(self.topview.frame), ScreenWidth, ScreenHeight - CGRectGetMaxY(self.navigationController.navigationBar.frame));
    self.middleView.backgroundColor = [UIColor blueColor];
    //    CycleView *cycleView = [[CycleView alloc] initWithFrame:self.middleView.bounds];
    self.cycleView.frame = self.middleView.bounds;
    self.cycleView.titleArray = self.titleArray;
    //添加控制器view
    [self addControllersToCycleView];
    [self.middleView addSubview:self.cycleView];
    //添加控制器视图 到scrollView中
    self.backgroundScrollView.contentSize = CGSizeMake(ScreenWidth,self.topview.height + self.middleView.height);
}

-(void)addControllersToCycleView{
    
    //添加控制器view
    RecordTableViewController * record1 = [[RecordTableViewController alloc] init];
    [self.controllersView addObject:record1.view];
    [self addChildViewController:record1];
    UserCommentViewController * userComment = [[UserCommentViewController alloc] init];
    [self.controllersView addObject:userComment.view];
    [self addChildViewController:userComment];
//   ProjectDetailsViewController
    ProjectDetailsViewController * pro = [[ProjectDetailsViewController alloc] init];
    [self.controllersView addObject:pro.view];
    [self addChildViewController:pro];
//    ProjectDetailTableViewController
    ProjectDetailTableViewController * pro1 = [[ProjectDetailTableViewController alloc] init];
    [self.controllersView addObject:pro1.view];
    [self addChildViewController:pro1];
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
        NSArray *array = @[@"项目详情",@"项目流程",@"用户评论",@"投资记录"];
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
