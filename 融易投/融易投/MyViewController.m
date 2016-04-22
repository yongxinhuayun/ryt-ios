//
//  MyViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/1.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "MyViewController.h"

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


//#import "WeiXinController.h"
//#import "ALiController.h"

@interface MyViewController () <WechatShortVideoDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *subTableView;



@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置导航条
    [self setUpNavBar];
    
    //设置详细视图
    [self setUpTableView];
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
    
}

-(void)setUpTableView{

//    self.subTableView.scrollEnabled = NO;
    
    self.subTableView.dataSource = self;
    self.subTableView.delegate = self;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 5;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row == 0) { //第0组
       
            cell.textLabel.text = @"我的主页";

    }else if (indexPath.row == 1){
    cell.textLabel.text = @"钱包";
    }else if (indexPath.row == 2){
        cell.textLabel.text = @"拍卖订单";
    }else if (indexPath.row == 3){
        cell.textLabel.text = @"设置";
    }else if (indexPath.row == 4){
        cell.textLabel.text = @"意见反馈";
    }
       return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) { //第0组
        
    }else if (indexPath.row == 1){

    }else if (indexPath.row == 2){

    }else if (indexPath.row == 3){
        
        
        UIStoryboard *settingStoryBoard = [UIStoryboard storyboardWithName:NSStringFromClass([SettingTableViewController class]) bundle:nil];
        SettingTableViewController *settingVC = [settingStoryBoard instantiateInitialViewController];
        [self.navigationController pushViewController:settingVC animated:YES];
        
        //    SettingTableViewController *settingVC = [[SettingTableViewController alloc] init];
        //    [self.navigationController pushViewController:settingVC animated:YES];


    }else if (indexPath.row == 4){
        

    }
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
    ArtistViewController *releaseProject = [[ArtistViewController alloc] init];
    
    [self.navigationController pushViewController:releaseProject animated:YES];
}


- (IBAction)FocusBtnClick:(id)sender {
    
    
    FocusViewController *focusVC = [[FocusViewController alloc] init];
    [self.navigationController pushViewController:focusVC animated:YES];
}

- (IBAction)FansBtnClick:(id)sender {
    
    
    
}


@end
