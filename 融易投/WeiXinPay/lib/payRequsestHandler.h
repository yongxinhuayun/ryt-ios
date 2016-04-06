

#import <Foundation/Foundation.h>
#import "WXUtil.h"
#import "ApiXml.h"
/*
 // 签名实例
 // 更新时间：2015年3月3日
 // 负责人：李启波（marcyli）
 // 该Demo用于ios sdk 1.4
 
 //微信支付服务器签名支付请求请求类
 //============================================================================
 //api说明：
 //初始化商户参数，默认给一些参数赋值，如cmdno,date等。
 -(BOOL) init:(NSString *)app_id (NSString *)mch_id;
 
 //设置商户API密钥
 -(void) setKey:(NSString *)key;
 
 //生成签名
 -(NSString*) createMd5Sign:(NSMutableDictionary*)dict;
 
 //获取XML格式的数据
 -(NSString *) genPackage:(NSMutableDictionary*)packageParams;
 
 //提交预支付交易，获取预支付交易会话标识
 -(NSString *) sendPrepay:(NSMutableDictionary *);
 
 //签名实例测试
 - ( NSMutableDictionary *)sendPay_demo;
 
 //获取debug信息日志
 -(NSString *) getDebugifo;
 
 //获取最后返回的错误代码
 -(long) getLasterrCode;
 //============================================================================
 */

// 账号帐户资料
//更改商户把相关参数后可测试

#define APP_ID          @"wx54be09189952c0a9"
//#define APP_ID          @"wx6c6d642595245402"               //APPID
//#define APP_SECRET      @"6fb2dbe3a379ead2ca73273c60a961ff" //appsecret
#define APP_SECRET      @"1f0a2535b23b73173526e42522bb4161"
//商户号，填写商户对应参数
#define MCH_ID          @"1260093801"
//商户API密钥，填写相应参数
#define PARTNER_ID      @"1f0a2535b23b73173526e42522bb4161"
//支付结果回调页面  219.239.7.163:8080/inf/rwxzf.inf
#define NOTIFY_URL      @"219.239.7.163:8080/inf/rwxzf.inf"

//#define NOTIFY_URL      @"http://peiban.9500.cn/inf/rwxzf.inf" //@"http://wxpay.weixin.qq.com/pub_v2/pay/notify.v2.php"
//获取服务器端支付数据地址（商户自定义）
#define SP_URL          @"219.239.7.163:8080/inf/rwxzf.inf"

//#define SP_URL          @"http://peiban.9500.cn/inf/rwxzf.inf" //@"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php"


@interface payRequsestHandler : NSObject{
	//预支付网关url地址
    NSString *payUrl;

    //lash_errcode;
    long     last_errcode;
	//debug信息
    NSMutableString *debugInfo;
    NSString *appid,*mchid,*spkey;
}
//初始化函数
-(BOOL) init:(NSString *)app_id mch_id:(NSString *)mch_id;
-(NSString *) getDebugifo;
-(long) getLasterrCode;
//设置商户密钥
-(void) setKey:(NSString *)key;
//创建package签名
-(NSString*) createMd5Sign:(NSMutableDictionary*)dict;
//获取package带参数的签名包
-(NSString *)genPackage:(NSMutableDictionary*)packageParams;
//提交预支付
-(NSString *)sendPrepay:(NSMutableDictionary *)prePayParams;
//签名实例测试
- ( NSMutableDictionary *)sendPay_demo:(NSString*)priceStr order:(NSString*)orderNo;

@end