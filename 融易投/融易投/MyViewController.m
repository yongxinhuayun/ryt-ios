//
//  MyViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/1.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "MyViewController.h"
#import "test.h"
#import "LognController.h"
#import "RegViewController.h"
#import "ForgetPasswordViewController.h"
#import "CompleteUserInfoController.h"

#import "SettingTableViewController.h"

#import <WechatShortVideoController.h>

#import "ReleaseProjectViewController.h"

#import "ArtistViewController.h"

#import "ApplyforArtViewController.h"

#import "FocusViewController.h"

#import "EditingInfoViewController.h"

#import "ArtistMyViewController.h"

#import "WalletViewController.h"

#import "IdeaRetroactionViewController.h"

#import "ReleaseViewController.h"

#import "ApplyforArtistViewController.h"

#import "FocusMyViewController.h"

#import "MyHeaderView.h"

//#import "WeiXinController.h"
//#import "ALiController.h"

@interface MyViewController () <WechatShortVideoDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *subTableView;


@property (strong, nonatomic) MyHeaderView *mgHeaderView;


@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置导航条
    [self setUpNavBar];
    
    //设置详细视图
    [self setUpTableView];
    
    [self jumpeditingInfoVc];
    
    [self jumpFocusVc];
}


-(void)jumpeditingInfoVc{
    
    __weak MyViewController *weakself=self;
    
    self.mgHeaderView.valueBlcok = ^{
        
        UIStoryboard *editingInfoStoryBoard = [UIStoryboard storyboardWithName:NSStringFromClass([EditingInfoViewController class]) bundle:nil];
        EditingInfoViewController *editingInfoVC = [editingInfoStoryBoard instantiateInitialViewController];
        
        [weakself.navigationController pushViewController:editingInfoVC animated:YES];

    };
    
}

-(void)jumpFocusVc{

    __weak MyViewController *weakself=self;
    
    self.mgHeaderView.valueBlcok = ^{
        
        FocusMyViewController *focusVC = [[FocusMyViewController alloc] init];
        
        [weakself.navigationController pushViewController:focusVC animated:YES];
        
    };

}



// 设置导航条
-(void)setUpNavBar
{
    //设置导航条标题
    self.navigationItem.title = @"我的";
    
    
    //设置导航条按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    [leftButton setTitle:@"申请为艺术家" forState:UIControlStateNormal];
    
    //运行程序,发现按钮没有出现导航条上面,因为没有设置尺寸
    [leftButton sizeToFit];
    
    [leftButton addTarget:self action:@selector(applyforArt) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = leftBarButton;

}

-(void)applyforArt{

    ApplyforArtViewController *applyforArt = [[ApplyforArtViewController alloc] init];
    
    [self.navigationController pushViewController:applyforArt animated:YES];

//    ApplyforArtistViewController *applyforArt = [[ApplyforArtistViewController alloc] init];
//     [self.navigationController pushViewController:applyforArt animated:YES];
}

-(void)setUpTableView{

//    self.subTableView.scrollEnabled = NO;
    

    
    
    //设置tableView的内边距---实现全局穿透让tableView向上移动64 + 标题栏的高度35/向下移动tabBar的高度49
    //运行程序,发现底部一致到了tabBar的最下面,我们应该设置成子控制器的view的显示范围为tabBar的上面
    //同样,tabBar的高度我们也可能项目中都会用到,写在常量文件中
    self.subTableView.contentInset = UIEdgeInsetsMake(SSNavMaxY, 0, 0, 0);
    //运行程序,发现滚动条上部分被标题栏和导航栏挡住了,这样会对会用造成一定的假象,造成对内容的多少判断不准确
    self.subTableView.scrollIndicatorInsets = UIEdgeInsetsMake(SSNavMaxY, 0, 0, 0);


    
    self.subTableView.dataSource = self;
    self.subTableView.delegate = self;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    MyHeaderView *mgHeaderView = [MyHeaderView myHeaderView];
    mgHeaderView.frame = CGRectMake(0, 64, SSScreenW, 300);
    self.mgHeaderView = mgHeaderView;

    return mgHeaderView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 400;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 5;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row == 0) { //第0组
        cell.imageView.image = [UIImage imageNamed:@"wodezhuye"];
        cell.textLabel.text = @"我的主页";

    }else if (indexPath.row == 1){
        
        cell.imageView.image = [UIImage imageNamed:@"qianbao"];
        cell.textLabel.text = @"钱包";
        
    }else if (indexPath.row == 2){
        
        cell.imageView.image = [UIImage imageNamed:@"paimaipaihang"];
        cell.textLabel.text = @"拍卖订单";
        
    }else if (indexPath.row == 3){
        cell.imageView.image = [UIImage imageNamed:@"shezhi"];
        cell.textLabel.text = @"设置";
    }else if (indexPath.row == 4){
        
        cell.imageView.image = [UIImage imageNamed:@"yijianfankui"];
        cell.textLabel.text = @"意见反馈";
    }
       return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) { //第0组
        
        ArtistViewController *artistVC = [[ArtistViewController alloc] init];
        [self.navigationController pushViewController:artistVC animated:YES];
        
        
    }else if (indexPath.row == 1){
        
        UIStoryboard *walletStoryBoard = [UIStoryboard storyboardWithName:NSStringFromClass([WalletViewController class]) bundle:nil];
        WalletViewController *walletVC = [walletStoryBoard instantiateInitialViewController];
        [self.navigationController pushViewController:walletVC animated:YES];

    }else if (indexPath.row == 2){

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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


- (IBAction)loginBtnClick:(id)sender {
    
    LognController *login = [[LognController alloc] init];
    
    [self.navigationController pushViewController:login animated:YES];
}


- (IBAction)CompleteUserInfoBtnClick:(id)sender {
    
    CompleteUserInfoController *userInfo  = [[CompleteUserInfoController alloc] init];
    [self.navigationController pushViewController:userInfo animated:YES];
}


- (IBAction)WeiXinPayBtnThings:(id)sender {
//    WeiXinController *weiXinController = [[WeiXinController alloc]init];
//    [self.navigationController pushViewController:weiXinController animated:YES];
}

- (IBAction)ALiPayBtnThings:(id)sender {
//    ALiController *aLiPayController = [[ALiController alloc]init];
//    [self.navigationController pushViewController:aLiPayController animated:YES];
}

- (IBAction)shortVideo:(id)sender {
    
    WechatShortVideoController *wechatShortVideoController = [[WechatShortVideoController alloc] init];
    wechatShortVideoController.delegate = self;
    [self presentViewController:wechatShortVideoController animated:YES completion:^{}];

}
- (IBAction)releaseProject:(id)sender {

    // 弹出发微博控制器
    ReleaseProjectViewController *releaseProject = [[ReleaseProjectViewController alloc] init];
   
    [self.navigationController pushViewController:releaseProject animated:YES];

}
- (IBAction)artistBtnClick:(id)sender {
    
    // 弹出发微博控制器
//    ArtistViewController *releaseProject = [[ArtistViewController alloc] init];
//    
//    [self.navigationController pushViewController:releaseProject animated:YES];
    
    ArtistMyViewController *releaseProject = [[ArtistMyViewController alloc] init];

    [self.navigationController pushViewController:releaseProject animated:YES];
}


- (IBAction)FocusBtnClick:(id)sender {
    
    
    FocusMyViewController *focusVC = [[FocusMyViewController alloc] init];
    [self.navigationController pushViewController:focusVC animated:YES];
}

- (IBAction)FansBtnClick:(id)sender {
    
    FocusViewController *focusVC = [[FocusViewController alloc] init];
    [self.navigationController pushViewController:focusVC animated:YES];
    
}

- (IBAction)releaseBtnClick:(id)sender {
    
    UIStoryboard *releaseStoryBoard = [UIStoryboard storyboardWithName:NSStringFromClass([ReleaseViewController class]) bundle:nil];
    ReleaseViewController *releaseVC = [releaseStoryBoard instantiateInitialViewController];
//    [self presentViewController:releaseVC animated:YES completion:nil];
    [self.navigationController pushViewController:releaseVC animated:YES];
    

}

@end
