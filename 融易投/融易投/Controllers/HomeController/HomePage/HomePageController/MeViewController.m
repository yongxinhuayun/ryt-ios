//
//  MeViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/29.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "MeViewController.h"

#import "LognController.h"
#import "RegViewController.h"
#import "ForgetPasswordViewController.h"
#import "CompleteUserInfoController.h"

#import "SettingTableViewController.h"

#import <WechatShortVideoController.h>

#import "ApplyforArtViewController.h"
#import "ComposeProjectViewController.h"


#import "EditingInfoViewController.h"

#import "ArtistUserHomeViewController.h"

#import "WalletViewController.h"

#import "IdeaRetroactionViewController.h"

#import "ReleaseViewController.h"

#import "FocusMyViewController.h"

#import "MeHeaderView.h"

#import <MJExtension.h>


#import "CommonUserHomeViewController.h"

#import "ArtistUserHomeViewController.h"

#import "MeTableViewCell.h"
#import "BQLAuthEngine.h"


@interface MeViewController ()
{
    BQLAuthEngine *_bqlAuthEngine;
}

@property (strong, nonatomic) MeHeaderView *meheaderView;

@property (nonatomic ,strong) PageInfoModel *model;

@property (nonatomic ,strong) RYTLoginManager *manger;

@end

@implementation MeViewController

static NSString *ID = @"MeTableViewCell";

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //加载头部视图数据
    //设置头部视图
    MeHeaderView *meheaderView = [MeHeaderView meHeaderView];

    self.meheaderView = meheaderView;
    
    self.tableView.tableHeaderView = self.meheaderView;
    
    //点击头像跳转编辑资料视图
    [self jumpeditingInfoVc];
    
    //点击关注跳转关注视图
    [self jumpFocusVc];
    
    //点击跳转粉丝界面
    [self jumpFansVc];

    if (![self.manger isVisitor]) {
        
        //获取用户信息数据
        [self loadData];
    }

    //设置导航条
    [self setUpNavBar];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //初始化微信类
    _bqlAuthEngine = [[BQLAuthEngine alloc] init];
    
    [UserMyModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        
        return @{
                 @"ID"          :@"id",
                 };
    }];
    
    //注册创建cell ,这样注册就不用在XIB设置ID
    [self.tableView registerNib:[UINib nibWithNibName:@"MeTableViewCell" bundle:nil] forCellReuseIdentifier:ID];

    //去除多余的线
    [self improveTableView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)improveTableView
{
    self.tableView.tableFooterView = [[UIView alloc]init];  //删除多余的行
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {  //防止分割线显示不
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
}

-(void)jumpeditingInfoVc{
    
    __weak MeViewController *weakself=self;
    
    self.meheaderView.editingInfoBlcok = ^{
        
        RYTLoginManager *manger = [RYTLoginManager shareInstance];
        
        if ([manger isVisitor]) {
            
            [manger showLoginViewIfNeed];
            
            return;
        }

        UIStoryboard *editingInfoStoryBoard = [UIStoryboard storyboardWithName:NSStringFromClass([EditingInfoViewController class]) bundle:nil];
        EditingInfoViewController *editingInfoVC = [editingInfoStoryBoard instantiateInitialViewController];
        
        editingInfoVC.userModel = weakself.model;
        
        [weakself.navigationController pushViewController:editingInfoVC animated:YES];
    };
}

-(void)jumpFocusVc{
    
    __weak MeViewController *weakself=self;
    
    self.meheaderView.focusBlcok = ^{
        
        RYTLoginManager *manger = [RYTLoginManager shareInstance];
        
        if ([manger isVisitor]) {
            
            [manger showLoginViewIfNeed];
            
            return;
        }
        
        FocusMyViewController *focusVC = [[FocusMyViewController alloc] init];
        
        [weakself.navigationController pushViewController:focusVC animated:YES];
    };
    
}

-(void)jumpFansVc{
    
    __weak MeViewController *weakself=self;
    
    self.meheaderView.fansBlcok = ^{
        
//        FocusViewController *focusVC = [[FocusViewController alloc] init];
//        [weakself.navigationController pushViewController:focusVC animated:YES];
        
    };
    
}

// 设置导航条
-(void)setUpNavBar
{
    //设置导航条标题
    self.navigationItem.title = @"我的";
    
    //设置导航条按钮
    UIButton *navButton = [UIButton buttonWithType:UIButtonTypeCustom];
    navButton.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [navButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [navButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];

    RYTLoginManager *manger = [RYTLoginManager shareInstance];
    self.manger = manger;
    
    //有值代表着登录,没值就是游客
    SSLog(@"%@",self.model.user.master);
    
    if ([manger isVisitor]) {
        
        [navButton setTitle:@"申请为艺术家" forState:UIControlStateNormal];
        
        //运行程序,发现按钮没有出现导航条上面,因为没有设置尺寸
        [navButton sizeToFit];
        
         [navButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        
    }else {
    
        //艺术家用户
        if (self.model.user.master) {
            
            [navButton setTitle:@"发起项目" forState:UIControlStateNormal];
            
            //运行程序,发现按钮没有出现导航条上面,因为没有设置尺寸
            [navButton sizeToFit];
            
            [navButton addTarget:self action:@selector(releaseProject) forControlEvents:UIControlEventTouchUpInside];
        }else {
            
            [navButton setTitle:@"申请为艺术家" forState:UIControlStateNormal];
            
            //运行程序,发现按钮没有出现导航条上面,因为没有设置尺寸
            [navButton sizeToFit];
            
            [navButton addTarget:self action:@selector(applyforArt) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:navButton];
    
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    
    //设置导航条按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
    [rightButton sizeToFit];
    [rightButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;

}
-(void)share{
    
    SSLog(@"share");
    
    UIImage *thumb = [UIImage imageNamed:@"wait.png"];
    [_bqlAuthEngine authShareToWeChatWithLink:@"专访张小龙：产品之上的世界观" Description:@"微信的平台化发展方向是否真的会让这个原本简洁的产品变得臃肿？在国际化发展方向上，微信面临的问题真的是文化差异壁垒吗？腾讯高级副总裁、微信产品负责人张小龙给出了自己的回复。" ThumbImage:thumb Url:@"http://tech.qq.com/zt2012/tmtdecode/252.htm" Scene:ShareToWXSceneSession Success:^(id response) {
        
        // 成功授权、在这里你可以提示用户已分享成功、并进行下面的操作
        NSLog(@"success:%@",response);
        
    } Failure:^(NSError *error) {
        
        // 错误返回授权错误码，请自行对照错误码查看错误原因
        NSLog(@"failure:%@",error);
    }];
    
}

-(void)login{
    
    [self.manger showLoginViewIfNeed];
}

-(void)releaseProject{
    
    ComposeProjectViewController *releaseProject = [[ComposeProjectViewController alloc] init];
    
    [self.navigationController pushViewController:releaseProject animated:YES];
    
}

-(void)applyforArt{
    
    ApplyforArtViewController *applyforArt = [[ApplyforArtViewController alloc] init];
    
    [self.navigationController pushViewController:applyforArt animated:YES];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     MeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (indexPath.row == 0) { //第0组
        
        cell.image.image = [UIImage imageNamed:@"wodezhuye"];
       
        cell.title.text = @"我的主页";
        
    }else if (indexPath.row == 1){
        
        cell.image.image = [UIImage imageNamed:@"qianbao"];
        cell.title.text = @"钱包";
        
    }else if (indexPath.row == 2){
        
        cell.image.image = [UIImage imageNamed:@"paimaipaihang"];
        cell.title.text = @"拍卖订单";
        
    }else if (indexPath.row == 3){
        cell.image.image = [UIImage imageNamed:@"shezhi"];
        cell.title.text = @"设置";
    }else if (indexPath.row == 4){
        
        cell.image.image = [UIImage imageNamed:@"yijianfankui"];
        cell.title.text = @"意见反馈";
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) { //第0组
        
        if ([self.manger isVisitor]) {
        
            [self.manger showLoginViewIfNeed];
            
        }else {
        
            //艺术家用户
            if (self.model.user.master) {
                
                ArtistUserHomeViewController *artistHomeVC = [[ArtistUserHomeViewController alloc] init];

                artistHomeVC.model = self.model;
                
                [self.navigationController pushViewController:artistHomeVC animated:YES];
                
            }else{ //普通用户
                
                CommonUserHomeViewController *myHomeVC = [[CommonUserHomeViewController alloc] init];
                
                myHomeVC.model = self.model;
                
                [self.navigationController pushViewController:myHomeVC animated:YES];
            }
            
        }
    }else if (indexPath.row == 1){
        
        if ([self.manger isVisitor]) {
            
            [self.manger showLoginViewIfNeed];
            
        }else {
            
            UIStoryboard *walletStoryBoard = [UIStoryboard storyboardWithName:NSStringFromClass([WalletViewController class]) bundle:nil];
            WalletViewController *walletVC = [walletStoryBoard instantiateInitialViewController];
            [self.navigationController pushViewController:walletVC animated:YES];

        }
        
    }else if (indexPath.row == 2){
        
        CommonUserHomeViewController *myHomeVC = [[CommonUserHomeViewController alloc] init];
        
        myHomeVC.model = self.model;
        
        [self.navigationController pushViewController:myHomeVC animated:YES];
        
    }else if (indexPath.row == 3){
        
        UIStoryboard *settingStoryBoard = [UIStoryboard storyboardWithName:NSStringFromClass([SettingTableViewController class]) bundle:nil];
        SettingTableViewController *settingVC = [settingStoryBoard instantiateInitialViewController];
        [self.navigationController pushViewController:settingVC animated:YES];
        
        //    SettingTableViewController *settingVC = [[SettingTableViewController alloc] init];
        //    [self.navigationController pushViewController:settingVC animated:YES];
        
        
    }else if (indexPath.row == 4){
        
        IdeaRetroactionViewController *ideaRetroactionVC = [[IdeaRetroactionViewController alloc] init];
        [self.navigationController pushViewController:ideaRetroactionVC animated:YES];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 49;
}

-(void)loadData
{
    //参数
    //有值代表着登录,没值就是游客
    UserMyModel *model = TakeLoginUserModel;
    
    NSString *userId = model.ID;

    if (userId == nil) {
        
        userId = @"";
        
        SSLog(@"%@",userId);
        
        return;
    }
    
    NSString *pageSize = @"20";
    NSString *pageIndex = @"1";
    //flag为1是自己看自己,为2时是看别人,还需要传递otheruserId
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"userId":userId,
                           @"pageSize" : pageSize,
                           @"pageIndex" : pageIndex
                           };
    NSString *url = @"my.do";
    
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:url parameters:json showHUDView:nil andBlock:^(id respondObj) {
        
        
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        
        PageInfoModel *model = [PageInfoModel mj_objectWithKeyValues:modelDict[@"pageInfo"]];
        
        //保存模型,赋值给控制器
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            self.model = model;
            
            //给xib赋值数据的时候,在viewDidLoad方法老是赋值为nil,所以只好写在这里
            
            //设置头部视图
            //            MeHeaderView *meheaderView = [MeHeaderView meHeaderView];
            //保存从xib获取的模型数据
            self.meheaderView.model = self.model;
            
            //点击头像跳转编辑资料视图
            [self jumpeditingInfoVc];
            
            //点击关注跳转关注视图
            [self jumpFocusVc];
            
            //点击跳转粉丝界面
            [self jumpFansVc];
            
            [self setUpNavBar];
        }];

    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
