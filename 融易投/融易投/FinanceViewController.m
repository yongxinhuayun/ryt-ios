//
//  FinanceViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/16.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "FinanceViewController.h"

#import "navTitleButton.h"

#import "ProjectDetailViewController.h"
#import "ProjectScheduleViewController.h"
#import "UserCommentViewController.h"
#import<QuartzCore/QuartzCore.h>


#import <MJExtension.h>

#import "UIImageView+WebCache.h"

#import "CommonHeader.h"
#import "CommonFooter.h"

#import "ProjectDetailView.h"
#import "ProjectScheduleViewController.h"
#import "UserCommentViewController.h"
#import "InvestRecordViewController.h"

#import "ArtworkModel.h"

#import "HHHorizontalPagingView.h"
#import "HHHeaderView.h"
#import "HHContentTableView.h"
#import "HHContentCollectionView.h"
#import "HHContentScrollView.h"



@interface FinanceViewController ()

/** 底部栏 */
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation FinanceViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //设置导航条
    [self setUpNav];
    
    //设置子视图
    [self setupSubViews];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置底部试图
    [self setupBottomView];
    
}

-(void)setupSubViews{

    //设置tab子视图
    HHHeaderView *headerView                 = [HHHeaderView headerView];
    
    HHContentScrollView *v1 = [HHContentScrollView contentScrollView];
    HHContentScrollView *v2 = [HHContentScrollView contentScrollView];
    HHContentTableView *tableView3           = [HHContentTableView contentTableView];
    HHContentTableView *tableView4           = [HHContentTableView contentTableView];
    
    
    NSMutableArray *buttonArray = [NSMutableArray array];
    
    NSArray *bottomtitles = @[@"项目详情", @"投资流程", @"用户评论",@"投资记录"];
    
    NSInteger index = bottomtitles.count;

    for(int i = 0; i < index; i++) {
        
        UIButton *segmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [segmentButton setBackgroundImage:[UIImage imageNamed:@"button_normal"] forState:UIControlStateNormal];
        [segmentButton setBackgroundImage:[UIImage imageNamed:@"button_selected"] forState:UIControlStateSelected];
        [segmentButton setTitle:bottomtitles[i] forState:UIControlStateNormal];
        [segmentButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        [buttonArray addObject:segmentButton];
    }
    
    HHHorizontalPagingView *pagingView = [HHHorizontalPagingView pagingViewWithHeaderView:headerView headerHeight:282.5 segmentButtons:buttonArray segmentHeight:44 contentViews:@[v1, v2, tableView3,tableView4]];
    
//    pagingView.segmentTopSpace = 0.0;
    
    //    pagingView.segmentButtonSize = CGSizeMake(60., 30.);              //自定义segmentButton的大小
    //    pagingView.segmentView.backgroundColor = [UIColor grayColor];     //设置segmentView的背景色
    
    //设置需放大头图的top约束
    /*
     pagingView.magnifyTopConstraint = headerView.headerTopConstraint;
     [headerView.headerImageView setImage:[UIImage imageNamed:@"headerImage"]];
     [headerView.headerImageView setContentMode:UIViewContentModeScaleAspectFill];
     */
    
    [self.view addSubview:pagingView];

}


-(void)setUpNav
{
    self.navigationItem.title = @"项目详情";
    
    self.navigationController.navigationBarHidden = NO;
}

-(void)setupBottomView{
    
    UIView *bottomView = [[UIView alloc] init];
    
    self.bottomView = bottomView;
    
    bottomView.frame = CGRectMake(0, SSScreenH - 44, self.view.width, 44);
    bottomView.backgroundColor = [UIColor blackColor];
    //2.9 设置标题栏为半透明的
    //    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    
    [self.view addSubview:bottomView];
    
    //2.1 运行程序,发现titlesView添加到了tableView,但是我们这里需要时用不同的UIViewController,所以把之前的控制器UITableViewController改成UIViewController
    
    //2.2 添加所有的标题按钮
    [self setUpTitleButtons];
    
}


-(void)setUpTitleButtons
{
    NSArray *bottomtitles = @[@"点赞", @"评论", @"投资"];
    
    NSInteger index = bottomtitles.count;
    //2.3 设置按钮尺寸,要想拿到titlesView需设置成成员属性
    //    CGFloat titleButtonW = self.titlesView.width / 5;
    CGFloat titleButtonW = self.bottomView.width / index;
    CGFloat titleButtonH = self.bottomView.height;
    
    //2.4 遍历添加所有标题按钮
    for (NSInteger i = 0; i < index; i++) {
        
        navTitleButton *titleButton = [navTitleButton buttonWithType:UIButtonTypeCustom];
        
        //6.2给标题按钮绑定tag
        titleButton.tag= i;
        
        titleButton.frame = CGRectMake(i * titleButtonW, 0, titleButtonW, titleButtonH);
        
        //2.5 设置标题按钮的标题
        //因为标题是已知的,所以我们可以把标题保存到数组中,然后根据数组中的索引去一一对应各个按钮的标题
        //这样我们就不会把按钮的个数写死了
        [titleButton setTitle:bottomtitles[i] forState:UIControlStateNormal];
        [titleButton setTintColor:[UIColor whiteColor]];
        
        //2.6 设置按钮的选中状态
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //        titleButton.titleLabel.backgroundColor = BSRandomColor;
        
        [self.bottomView addSubview:titleButton];
        
    }
}

-(void)titleClick:(navTitleButton *)titleButton
{
    SSLog(@"1111");
    
}




/**********************************  不要删除：根据文字的个数调整 label 的高度
 
 NSString *text =[[NSString alloc]init];
 text = @"输入文本内容";
 CGSize size = CGSizeMake(280, 180);
 UIFont *fonts = [UIFont systemFontOfSize:14.0];
 CGSize msgSie = [text sizeWithFont:fonts constrainedToSize:size lineBreakMode: NSLineBreakByCharWrapping];
 UILabel *textLabel  = [[UILabel alloc] init];
 [textLabel setFont:[UIFont boldSystemFontOfSize:14]];
 textLabel.frame = CGRectMake(20,70, 280,msgSie.height);
 textLabel.text = text;
 textLabel.lineBreakMode = NSLineBreakByCharWrapping;//实现文字多行显示
 textLabel.numberOfLines = 0;
 [self.view addSubview:textLabel];
 ********************************************************/

//加载数据
-(void)loadData
{
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
    
    [[HttpRequstTool shareInstance] handlerNetworkingPOSTRequstWithServerUrl:url Parameters:json showHUDView:self.view success:^(id respondObj) {
        
        
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
        
    
//        //在主线程刷新UI数据
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            
//            [self.tableView reloadData];
//            
//        }];
    }];
}




@end
