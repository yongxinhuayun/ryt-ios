//
//  WalletViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/26.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "WalletViewController.h"

#import "WalletTableViewCell.h"

#import "PayTableViewController.h"
#import "WithdrawTableViewController.h"
#import "BillTableViewController.h"

#import "WalletHeaderView.h"
#import "WalletFooterView.h"

@interface WalletViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) WalletFooterView *footrView;

@end

@implementation WalletViewController

static NSString *ID = @"walletCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavBar];
    
    [self setUpTableView];
}

-(void)setUpTableView{

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //同样,tabBar的高度我们也可能项目中都会用到,写在常量文件中
    self.tableView.contentInset = UIEdgeInsetsMake(SSNavMaxY, 0, 0, 0);
    //运行程序,发现滚动条上部分被标题栏和导航栏挡住了,这样会对会用造成一定的假象,造成对内容的多少判断不准确
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(SSNavMaxY, 0, 0, 0);

    
    //注册创建cell ,这样注册就不用在XIB设置ID
    [self.tableView registerNib:[UINib nibWithNibName:@"WalletTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
}

// 设置导航条
-(void)setUpNavBar
{
    //设置导航条标题
    self.navigationItem.title = @"钱包";
    
    //设置导航条按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    [rightButton setImage:[UIImage imageNamed:@"qianbao-caidan"] forState:UIControlStateNormal];
    
    //运行程序,发现按钮没有出现导航条上面,因为没有设置尺寸
    [rightButton sizeToFit];
    
    [rightButton addTarget:self action:@selector(jumpeCheckMore) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
}

-(void)jumpeCheckMore{

    BillTableViewController *bill = [[BillTableViewController alloc] init];
    [self.navigationController pushViewController:bill animated:YES];

}

-(void)jumpeCheckMoreBillVc{
    
    __weak WalletViewController *weakself = self;

    self.footrView.checkMoreBillBlcok = ^{
        
        [weakself jumpeCheckMore];
        
    };
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    WalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    
    return cell;

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    WalletHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"WalletHeaderView" owner:nil options:nil] lastObject];
    
    return headerView;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return  340;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    WalletFooterView *footrView = [[[NSBundle mainBundle] loadNibNamed:@"WalletFooterView" owner:nil options:nil] lastObject];
    
    self.footrView = footrView;
    
    //给block赋值，执行跳转
    [self jumpeCheckMoreBillVc];
    
    return footrView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 45;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//提现
- (IBAction)withdrawBtnClick:(id)sender {
    
    UIStoryboard *payStoryBoard = [UIStoryboard storyboardWithName:NSStringFromClass([WithdrawTableViewController class]) bundle:nil];
    WithdrawTableViewController *withdrawVC = [payStoryBoard instantiateInitialViewController];
    [self.navigationController pushViewController:withdrawVC animated:YES];
}

//充值
- (IBAction)payBtnClick:(id)sender {
    
    UIStoryboard *payStoryBoard = [UIStoryboard storyboardWithName:NSStringFromClass([PayTableViewController class]) bundle:nil];
    PayTableViewController *payVC = [payStoryBoard instantiateInitialViewController];
    [self.navigationController pushViewController:payVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
