//
//  HttpRequstTool.m
//  podTest
//
//  Created by meng on 16/3/26.
//  Copyright © 2016年 meng. All rights reserved.
//

#import "HttpRequstTool.h"
#import <AFNetworkActivityIndicatorManager.h>
#import <MBProgressHUD.h>


static HttpRequstTool *requstTool=nil ;

@interface HttpRequstTool ()

@property(strong,nonatomic) AFHTTPSessionManager *sessionManager;

@end

@implementation HttpRequstTool
static  NSString *basePath = @"http://192.168.1.75:8080/app/";
//static  NSString *basePath = @"http://192.168.1.75:8001/app/";

//static  NSString *basePath = @"http://192.168.1.41:8080/app/";
//static  NSString *basePath = @"http://192.168.1.41:8080/app/";
// 阿里云服务器
//static NSString *basePath = @"http://craft.efeiyi.com/app-wikiServer/app/";
+(HttpRequstTool *)shareInstance
{
    if (!requstTool ) {
        requstTool=[[HttpRequstTool alloc] init];
        requstTool.sessionManager=[AFHTTPSessionManager manager];
//          requstTool.sessionManager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];
        
        [[AFNetworkActivityIndicatorManager sharedManager ] setEnabled:YES];
    }
    return  requstTool;
}


// 按字母顺序拼接字典中的字符串
-(NSString *)appendStringWithDictionary:(NSDictionary *)dictionary{
    NSMutableString *strM = [NSMutableString string];
    NSArray *keys = [dictionary allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    for (NSString *dictKey in sortedArray) {
        if (dictKey == sortedArray.lastObject) {
            [strM appendFormat:@"%@=%@",dictKey,dictionary[dictKey]];
        }else{
            [strM appendFormat:@"%@=%@&",dictKey,dictionary[dictKey]];
        }
    }
    return [strM copy];
}

// POST请求
-(void)loadData:(RequestType)type serverUrl:(NSString *)urlStr parameters:(NSDictionary *)parameters showHUDView:(UIView *)view andBlock:(void(^)(id respondObj))success{
    NSMutableString *url = [NSMutableString stringWithString:basePath];
    [url appendString:urlStr];
    NSString *timestamp = [MyMD5 timestamp];
    NSString *appkey = MD5key;
    NSMutableString *strM = [NSMutableString string];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [dict setValue:timestamp forKey:@"timestamp"];
    [strM appendString:[self appendStringWithDictionary:dict]];
    [strM appendFormat:@"&key=%@",appkey];
    NSString *signmsgMD5 = [MyMD5 md5:strM];
    NSDictionary *temp = @{
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    NSMutableDictionary *parDictionary = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [parDictionary addEntriesFromDictionary:temp];
    if (type == POST) {
        [self handlerNetworkingPOSTRequstWithServerUrl:url Parameters:parDictionary showHUDView:view success:^(id respondObj) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                success(respondObj);
            }];
        }];
    }else{
        [self  handlerNetworkingGETRequstWithServerUrl:urlStr Parameters:parDictionary showHUDView:view success:^(id respondObj) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                success(respondObj);
            }];
        }];
    }
}

/**
 *  需要传递加密的参数
 */
-(void)handlerNetworkingPOSTRequstWithServerUrl:(NSString *)server_url  Parameters:(id )param showHUDView:(UIView *)view  success:(requstSuccessBlock )successBlock
{
    if (!server_url){
        return;
    }
    if (view){
        [MBProgressHUD hideHUD];
        [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
//    __weak HttpRequstTool *weakself=self;
    NSURL *requstURL=[NSURL URLWithString: server_url];
        NSLog(@"参数:%@",param);
    NSLog(@"%@",requstURL);
    // 设置请求格式
    self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    self.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.sessionManager POST:requstURL.absoluteString parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:view animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            successBlock(responseObject);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {        
        NSLog(@"%@",error);
        if (view){
            [MBProgressHUD hideHUDForView:view animated:YES];
        }
    }];
}

/**
 *  不需要传递加密的参数
 */
-(void)handlerNetworkingPOSTRequstWithBaseUrl:(NSString *)base_url  Parameters:(id )param showHUDView:(UIView *)view  success:(requstSuccessBlock )successBlock
{
    if (!base_url){
        return;
    }
    if (view){
        [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    NSMutableString *url = [NSMutableString stringWithString:basePath];
    [url appendString:base_url];
    //    __weak HttpRequstTool *weakself=self;
    NSURL *requstURL=[NSURL URLWithString: url];
    NSLog(@"参数:%@",param);
    NSLog(@"%@",requstURL);
    // 设置请求格式
    self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    self.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.sessionManager POST:requstURL.absoluteString parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:view animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            successBlock(responseObject);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        if (view){
            [MBProgressHUD hideHUDForView:view animated:YES];
        }
    }];
}

/**
 *  POST上传文件
 */
-(void)handlerNetworkingPOSTRequstWithServerUrl:(NSString *)server_url  Parameters:(id )param constructingBodyWithBlock:(constructingBodyWithBlock)constructingBodyWithBlock showHUDView:(UIView *)view progress:(updateProgressBlock )progressBlock success:(requstSuccessBlock )successBlock{
    if (!server_url){
        return;
    }
    if (view){
        [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    NSMutableString *url = [NSMutableString stringWithString:basePath];
    [url appendString:server_url];
    //    __weak HttpRequstTool *weakself=self;
    NSURL *requstURL=[NSURL URLWithString: url];
    NSLog(@"参数:%@",param);
    NSLog(@"%@",requstURL);
    // 设置请求格式
    self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    self.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
//    [self.sessionManager POST:requstURL.absoluteString parameters:param constructingBodyWithBlock:constructingBodyWithBlock progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [MBProgressHUD hideHUDForView:view animated:YES];
//        successBlock(responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//        if (view){
//            [MBProgressHUD hideHUDForView:view animated:YES];
//        }
//    }];
    
//    [self.sessionManager POST:requstURL.absoluteString parameters:param  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        constructingBodyWithBlock(formData);
//    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [MBProgressHUD hideHUDForView:view animated:YES];
//        successBlock(responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//        if (view){
//            [MBProgressHUD hideHUDForView:view animated:YES];
//        }
//    }];
    
    [self.sessionManager POST:requstURL.absoluteString parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        constructingBodyWithBlock(formData);
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progressBlock(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:view animated:YES];
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        if (view){
            [MBProgressHUD hideHUDForView:view animated:YES];
        }
    }];
}

-(void)handlerNetworkingGETRequstWithServerUrl:(NSString *)server_url  Parameters:(NSDictionary *)param showHUDView:(UIView *)view  success:(requstSuccessBlock )successBlock{
    if (!server_url){
        return;
    }
    if (view){
        [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    __weak HttpRequstTool *weakself=self;
    NSURL *requstURL=[NSURL URLWithString: server_url];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
    NSData *base64Data = [jsonData base64EncodedDataWithOptions:0];
    NSString * paramStr=[[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
    [self
     .sessionManager GET:requstURL.absoluteString parameters:paramStr success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         successBlock(responseObject);
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [MBProgressHUD showHUDAddedTo:view animated:YES];
     }];
}

@end
