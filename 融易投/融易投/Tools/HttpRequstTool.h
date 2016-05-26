//
//  HttpRequstTool.h
//  podTest
//
//  Created by meng on 16/3/26.
//  Copyright © 2016年 meng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef void(^requstSuccessBlock)(id respondObj);

typedef void(^constructingBodyWithBlock)(id formData);
typedef void(^updateProgressBlock)(id progress);

typedef enum {
    POST,
    GET
} RequestType;
@interface HttpRequstTool : NSObject

+(HttpRequstTool *)shareInstance;

/**
 *  不需要传递加密的参数
 */
-(void)handlerNetworkingPOSTRequstWithServerUrl:(NSString *)server_url  Parameters:(id )param showHUDView:(UIView *)view  success:(requstSuccessBlock )successBlock;
/**
 *  需要传递加密的参数
 */
-(void)handlerNetworkingPOSTRequstWithBaseUrl:(NSString *)base_url  Parameters:(id )param showHUDView:(UIView *)view  success:(requstSuccessBlock )successBlock;
/**
 *  POST上传文件
 */
-(void)handlerNetworkingPOSTRequstWithServerUrl:(NSString *)server_url  Parameters:(id )param constructingBodyWithBlock:(constructingBodyWithBlock)constructingBodyWithBlock showHUDView:(UIView *)view progress:(updateProgressBlock )progressBlock success:(requstSuccessBlock )successBlock;

-(void)handlerNetworkingGETRequstWithServerUrl:(NSString *)server_url  Parameters:(NSDictionary *)param showHUDView:(UIView *)view  success:(requstSuccessBlock )successBlock;
-(void)loadData:(RequestType)type serverUrl:(NSString *)urlStr parameters:(NSDictionary *)parameters showHUDView:(UIView *)view andBlock:(void(^)(id respondObj))success;

@end
