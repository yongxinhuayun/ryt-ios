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

@interface WalletViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
    
    [rightButton addTarget:self action:@selector(checkMoreDetailClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    WalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    
    return cell;

}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    return 45;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




- (IBAction)checkMoreDetailClick:(id)sender {
    
    
}

- (IBAction)withdrawBtnClick:(id)sender {
    
    
}

- (IBAction)payBtnClick:(id)sender {
    
    UIStoryboard *payStoryBoard = [UIStoryboard storyboardWithName:NSStringFromClass([PayTableViewController class]) bundle:nil];
    PayTableViewController *payVC = [payStoryBoard instantiateInitialViewController];
    [self.navigationController pushViewController:payVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
