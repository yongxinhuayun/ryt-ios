//
//  BCPayConstant.h
//  BCPaySDK
//
//  Created by Ewenlong03 on 15/7/21.
//  Copyright (c) 2015年 BeeCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef BCPaySDK_BCPayConstant_h
#define BCPaySDK_BCPayConstant_h

static NSString * const kApiVersion = @"3.4.2";//api版本号

static NSString * const kNetWorkError = @"网络请求失败";
static NSString * const kUnknownError = @"未知错误";
static NSString * const kKeyResponseResultCode = @"result_code";
static NSString * const kKeyResponseResultMsg = @"result_msg";
static NSString * const kKeyResponseErrDetail = @"err_detail";

static NSString * const kKeyResponseCodeUrl = @"code_url";
static NSString * const KKeyResponsePayResult = @"pay_result";
static NSString * const kKeyResponseRevertResult = @"revert_status";

static NSUInteger const kBCHostCount = 4;
static NSString * const kBCHosts[] = {@"https://apisz.beecloud.cn",
    @"https://apiqd.beecloud.cn",
    @"https://apibj.beecloud.cn",
    @"https://apihz.beecloud.cn"};

static NSString * const reqApiVersion = @"/2/rest";

//rest api online
static NSString * const kRestApiPay = @"%@%@/bill";
static NSString * const kRestApiRefund = @"%@%@/refund";
static NSString * const kRestApiQueryBills = @"%@%@/bills";
static NSString * const kRestApiQueryRefunds = @"%@%@/refunds";
static NSString * const kRestApiRefundState = @"%@%@/refund/status";
static NSString * const kRestApiQueryBillById = @"%@%@/bill/";
static NSString * const kRestApiQueryRefundById = @"%@%@/refund/";
static NSString * const kRestApiQueryBillsCount = @"%@%@/bills/count";
static NSString * const kRestApiQueryRefundsCount = @"%@%@/refunds/count";

//rest api offline
static NSString * const kRestApiOfflinePay = @"%@%@/offline/bill";
static NSString * const kRestApiOfflineBillStatus = @"%@%@/offline/bill/status";
static NSString * const kRestApiOfflineBillRevert = @"%@%@/offline/bill/";

//paypal accesstoken
static NSString * const kPayPalAccessTokenProduction = @"https://api.paypal.com/v1/oauth2/token";
static NSString * const kPayPalAccessTokenSandbox = @"https://api.sandbox.paypal.com/v1/oauth2/token";

//sandbox
static NSString * const kRestApiSandboxNotify = @"%@%@/notify/";

//Adapter
static NSString * const kAdapterWXPay = @"BCWXPayAdapter";
static NSString * const kAdapterAliPay = @"BCAliPayAdapter";
static NSString * const kAdapterUnionPay = @"BCUnionPayAdapter";
static NSString * const kAdapterPayPal = @"BCPayPalAdapter";
static NSString * const kAdapterOffline = @"BCOfflineAdapter";
static NSString * const kAdapterBaidu = @"BCBaiduAdapter";
static NSString * const kAdapterSandbox = @"BCSandboxAdapter";

/**
 *  BCPay URL type for handling URLs.
 */
typedef NS_ENUM(NSInteger, BCPayUrlType) {
    /**
     *  Unknown type.
     */
    BCPayUrlUnknown,
    /**
     *  WeChat pay.
     */
    BCPayUrlWeChat,
    /**
     *  Alipay.
     */
    BCPayUrlAlipay
};


typedef NS_ENUM(NSInteger, PayChannel) {
    PayChannelNone = 0,
    
    PayChannelWx = 10, //微信
    PayChannelWxApp,//微信APP
    PayChannelWxNative,//微信扫码
    PayChannelWxJsApi,//微信JSAPI(H5)
    PayChannelWxScan,
    
    PayChannelAli = 20,//支付宝
    PayChannelAliApp,//支付宝APP
    PayChannelAliWeb,//支付宝网页即时到账
    PayChannelAliWap,//支付宝手机网页
    PayChannelAliQrCode,//支付宝扫码即时到帐
    PayChannelAliOfflineQrCode,//支付宝线下扫码
    PayChannelAliScan,
    
    PayChannelUn = 30,//银联
    PayChannelUnApp,//银联APP
    PayChannelUnWeb,//银联网页
    
    PayChannelPayPal = 40,
    PayChannelPayPalLive,
    PayChannelPayPalSandbox,
    
    PayChannelBaidu = 50,
    PayChannelBaiduApp,
    PayChannelBaiduWeb,
    PayChannelBaiduWap
};

typedef NS_ENUM(NSInteger, BCErrCode) {
    BCErrCodeSuccess    = 0,    /**< 成功    */
    BCErrCodeCommon     = -1,   /**< 参数错误类型    */
    BCErrCodeUserCancel = -2,   /**< 用户点击取消并返回    */
    BCErrCodeSentFail   = -3,   /**< 发送失败    */
    BCErrCodeUnsupport  = -4,   /**< BeeCloud不支持 */
};

typedef NS_ENUM(NSInteger, BCObjsType) {
    BCObjsTypeBaseReq = 100,
    BCObjsTypePayReq,
    BCObjsTypeQueryBillsReq,
    BCObjsTypeQueryBillByIdReq,
    BCObjsTypeQueryBillsCountReq,
    BCObjsTypeQueryRefundsReq,
    BCObjsTypeQueryRefundByIdReq,
    BCObjsTypeQueryRefundsCountReq,
    BCObjsTypeRefundStatusReq,
    BCObjsTypeOfflinePayReq,
    BCObjsTypeOfflineBillStatusReq,
    BCObjsTypeOfflineRevertReq,
    
    BCObjsTypeBaseResp = 200,
    BCObjsTypePayResp,
    BCObjsTypeQueryBillsResp,
    BCObjsTypeQueryBillByIdResp,
    BCObjsTypeQueryBillsCountResp,
    BCObjsTypeQueryRefundsResp,
    BCObjsTypeQueryRefundByIdResp,
    BCObjsTypeQueryRefundsCountResp,
    BCObjsTypeRefundStatusResp,
    BCObjsTypeOfflinePayResp,
    BCObjsTypeOfflineBillStatusResp,
    BCObjsTypeOfflineRevertResp,
    
    BCObjsTypeBaseResults = 300,
    BCObjsTypeBillResults,
    BCObjsTypeRefundResults,
    
    BCObjsTypePayPal = 400,
    BCObjsTypePayPalVerify
};

typedef NS_ENUM(NSUInteger, BillStatus) {
    BillStatusAll, //所有支付订单
    BillStatusOnlySuccess,//支付成功的订单
    BillStatusOnlyFail //支付失败的订单
};

typedef NS_ENUM(NSUInteger, NeedApproval) {
    NeedApprovalAll,  //所有退款
    NeedApprovalOnlyTrue, //预退款
    NeedApprovalOnlyFalse //非预退款
};

static NSString * const kBCDateFormat = @"yyyy-MM-dd HH:mm";

#endif
