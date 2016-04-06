//
//  WeiXinController.m
//  融易投
//
//  Created by dongxin on 16/4/5.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "WeiXinController.h"

#import "WXApi.h"


@interface WeiXinController ()

@end

@implementation WeiXinController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值";
    NSLog(@"111111111111");
    
}

//支付宝充值
//- (void)alipayTap
//{
//    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"10023", @"qtype", K_CHAT_USERNAME, @"_username", K_MD5_PASSWORD, @"_userpwd", _myHeartModel._id, @"_cid", nil];
//    [dic addEntriesFromDictionary:[TimeAndSecretDic timeAndSecretDic]];
//    [[HTTPRequest shareRequest] POSTExp:@"" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
//        if ([[[responseObject objectForKey:@"result"] stringValue] isEqualToString:@"0"]) {
//            //支付宝
//            NSString *partner = @"2088811682058579";
//            NSString *seller = @"2088811682058579";
//            NSString *privateKey = PartnerPrivKey;
//            
//            Order *order = [[Order alloc] init];
//            order.partner = partner;
//            order.seller = seller;
//            order.tradeNO = [responseObject objectForKey:@"_ordersNo"];
//            order.productName = @"商品描述";
//            order.productDescription = @"商品描述";
//            order.amount = _myHeartModel._czMoney;
//            order.notifyURL =  @"http://ajy.9500.cn:8080/inf/rzfb.inf";
//            
//            NSString *orderSpec = [order description];
//            
//            id<DataSigner> singer = CreateRSADataSigner(privateKey);
//            NSString *signedString = [singer signString:orderSpec];
//            
//            NSString *orderString = nil;
//            if (signedString != nil) {
//                orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                               orderSpec, signedString, @"RSA"];
//                [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"ChatScheme" callback:^(NSDictionary *resultDic) {
//                    NSLog(@"%@", resultDic);
//                }];
//            }
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
//    
//    
//}
//
////微信钱包充值
//- (void)weChatTap
//{
//    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"10024", @"qtype", K_CHAT_USERNAME, @"_username", K_MD5_PASSWORD, @"_userpwd", _myHeartModel._id, @"_cid", nil];
//    [dic addEntriesFromDictionary:[TimeAndSecretDic timeAndSecretDic]];
//    [[HTTPRequest shareRequest] POSTExp:@"" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"  responject   %@", responseObject);
//        if ([[[responseObject objectForKey:@"result"] stringValue] isEqualToString:@"0"]) {
//            [WXApi registerApp:@"wx6c6d642595245402" withDescription:@""];
//            
//            //创建支付签名对象
//            payRequsestHandler *req = [[payRequsestHandler alloc] init];
//            //初始化支付签名对象
//            [req init:APP_ID mch_id:MCH_ID];
//            //设置密钥
//            [req setKey:PARTNER_ID];
//            
//            //获取到实际调起微信支付的参数后，在app端调起支付
//            
//            //            NSLog(@"%@", _myHeartModel._czMoney);
//            //            NSLog(@"%@", [responseObject objectForKey:@"_ordersNo"]);
//            
//            NSMutableDictionary *dict = [req sendPay_demo:[responseObject objectForKey:@"_ordersNo"] price:_myHeartModel._czMoney];
//            
//            if(dict == nil){
//                //错误提示
//                NSString *debug = [req getDebugifo];
//                
//                [self alert:@"提示信息" msg:debug];
//                
//                NSLog(@"%@\n\n",debug);
//            }else{
//                NSLog(@"%@\n\n",[req getDebugifo]);
//                //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
//                
//                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
//                
//                //调起微信支付
//                PayReq* req             = [[PayReq alloc] init];
//                req.openID              = [dict objectForKey:@"appid"];
//                req.partnerId           = [dict objectForKey:@"partnerid"];
//                req.prepayId            = [dict objectForKey:@"prepayid"];
//                NSLog(@"%@", [dict objectForKey:@"prepayid"]);
//                //                req.prepayId            = [responseObject objectForKey:@"_prepay_id"];
//                req.nonceStr            = [dict objectForKey:@"noncestr"];
//                req.timeStamp           = stamp.intValue;
//                req.package             = [dict objectForKey:@"package"];
//                req.sign                = [dict objectForKey:@"sign"];
//                
//                [WXApi sendReq:req];
//            }
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
//    
//    //    NSLog(@"微信钱包");
//    
//    
//}
//
////生成随机订单号
//- (NSString *)generateTradeNO
//{
//    static int kNumber = 15;
//    
//    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
//    NSMutableString *resultStr = [[NSMutableString alloc] init];
//    srand((int)time(0));
//    for (int i = 0; i < kNumber; i++)
//    {
//        unsigned index = rand() % [sourceStr length];
//        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
//        [resultStr appendString:oneStr];
//    }
//    return resultStr;
//}
//
////客户端提示信息
//- (void)alert:(NSString *)title msg:(NSString *)msg
//{
//    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    
//    [alter show];
//}
//
//- (void)onResp:(BaseResp *)resp {
//    if ([resp isKindOfClass:[PayResp class]]) {
//        PayResp *response = (PayResp *)resp;
//        switch (response.errCode) {
//            case WXSuccess:
//                //服务器端查询支付通知或查询API返回的结果再提示成功
//                NSLog(@"支付成功");
//                break;
//            default:
//                NSLog(@"支付失败， retcode=%d",resp.errCode);
//                break;
//        }
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
