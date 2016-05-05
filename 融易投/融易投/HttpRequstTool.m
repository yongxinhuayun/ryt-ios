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
-(void)handlerNetworkingPOSTRequstWithServerUrl:(NSString *)server_url  Parameters:(id )param showHUDView:(UIView *)view  success:(requstSuccessBlock )successBlock
{
    if (!server_url)
    {
        return;
    }
    if (view)
    {
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
        successBlock(responseObject);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        if (view)
        {
            [MBProgressHUD hideHUDForView:view animated:YES];
        }
    }];
}

-(void)handlerNetworkingPOSTRequstWithServerUrl:(NSString *)server_url  Parameters:(id )param constructingBodyWithBlock:(id)constructingBodyWithBlock showHUDView:(UIView *)view  success:(requstSuccessBlock )successBlock{

    if (!server_url)
    {
        return;
    }
    if (view) {
        
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
    

    [self.sessionManager POST:requstURL.absoluteString parameters:param constructingBodyWithBlock:constructingBodyWithBlock progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:view animated:YES];
        successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        if (view) {
            
            [MBProgressHUD hideHUDForView:view animated:YES];
        }
        
    }];
}

-(void)handlerNetworkingGETRequstWithServerUrl:(NSString *)server_url  Parameters:(NSDictionary *)param showHUDView:(UIView *)view  success:(requstSuccessBlock )successBlock
{
    
    if (!server_url)
    {
        return;
    }
    if (view)
    {
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
