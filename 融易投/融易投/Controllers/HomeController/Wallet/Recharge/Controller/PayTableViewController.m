//
//  PayTableViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/30.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "PayTableViewController.h"

#import "BeeCloud.h"

@interface PayTableViewController () <UIAlertViewDelegate,BeeCloudDelegate>

@property (strong, nonatomic) BCBaseResp *orderList;
@property (strong, nonatomic) NSString *billTitle;


@end

@implementation PayTableViewController

- (void)viewWillAppear:(BOOL)animated {
#pragma mark - 设置delegate
    [BeeCloud setBeeCloudDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavBar];
    
    self.orderList = nil;
}

// 设置导航条
-(void)setUpNavBar
{
    //设置导航条标题
    self.navigationItem.title = @"充值";
}



#pragma mark - Table view data source


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) { //支付宝支付
        
        [self ALiDoPay];
        
    }else { //微信支付
        
        [self WXDoPay];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//微信、支付宝、银联、百度钱包
- (void)WXDoPay{
    
    NSString *billno = [self genBillNo];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"value",@"key", nil];
    /**
     按住键盘上的option键，点击参数名称，可以查看参数说明
     **/
    BCPayReq *payReq = [[BCPayReq alloc] init];
    payReq.channel = PayChannelWxApp; //支付渠道
    payReq.title = @"微信支付";//订单标题
    payReq.totalFee = @"10";//订单价格
    payReq.billNo = billno;//商户自定义订单号
    payReq.scheme = @"payDemo";//URL Scheme,在Info.plist中配置; 支付宝必有参数
    payReq.billTimeOut = 300;//订单超时时间
    payReq.viewController = self; //银联支付和Sandbox环境必填
    payReq.optional = dict;//商户业务扩展参数，会在webhook回调时返回
    
    [BeeCloud sendBCReq:payReq];
}
- (void)ALiDoPay{
    
    NSString *billno = [self genBillNo];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"value",@"key", nil];
    /**
     按住键盘上的option键，点击参数名称，可以查看参数说明
     **/
    BCPayReq *payReq = [[BCPayReq alloc] init];
    payReq.channel = PayChannelAliApp; //支付渠道
    payReq.title = @"支付宝支付";//订单标题
    payReq.totalFee = @"10";//订单价格
    payReq.billNo = billno;//商户自定义订单号
    payReq.scheme = @"payDemo";//URL Scheme,在Info.plist中配置; 支付宝必有参数
    payReq.billTimeOut = 300;//订单超时时间
    payReq.viewController = self; //银联支付和Sandbox环境必填
    payReq.optional = dict;//商户业务扩展参数，会在webhook回调时返回
    
    [BeeCloud sendBCReq:payReq];
}

#pragma mark - BCPay回调

- (void)onBeeCloudResp:(BCBaseResp *)resp {
    
    switch (resp.type) {
            
        case BCObjsTypePayResp:
        {
            // 支付请求响应
            BCPayResp *tempResp = (BCPayResp *)resp;
            
            if (tempResp.resultCode == 0) {
                
                //微信、支付宝、银联支付成功
                [self showAlertView:resp.resultMsg];
                
            } else {
                //支付取消或者支付失败
                [self showAlertView:[NSString stringWithFormat:@"%@ : %@",tempResp.resultMsg, tempResp.errDetail]];
            }
        }
            break;
        case BCObjsTypeQueryBillsResp:
        {
            BCQueryBillsResp *tempResp = (BCQueryBillsResp *)resp;
            if (resp.resultCode == 0) {
                if (tempResp.count == 0) {
                    [self showAlertView:@"未找到相关订单信息"];
                } else {
                    self.orderList = tempResp;
                    [self performSegueWithIdentifier:@"queryResult" sender:self];
                }
            } else {
                [self showAlertView:[NSString stringWithFormat:@"%@ : %@",tempResp.resultMsg, tempResp.errDetail]];
            }
        }
            break;
        case BCObjsTypeQueryRefundsResp:
        {
            BCQueryRefundsResp *tempResp = (BCQueryRefundsResp *)resp;
            if (resp.resultCode == 0) {
                if (tempResp.count == 0) {
                    [self showAlertView:@"未找到相关订单信息"];
                } else {
                    self.orderList = tempResp;
                    [self performSegueWithIdentifier:@"queryResult" sender:self];
                }
            } else {
                [self showAlertView:[NSString stringWithFormat:@"%@ : %@",tempResp.resultMsg, tempResp.errDetail]];
            }
        }
            break;
    }
}

#pragma mark - 弹框提示
- (void)showAlertView:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alert show];
}

#pragma mark - 生成订单号
- (NSString *)genBillNo {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    
    return [formatter stringFromDate:[NSDate date]];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
