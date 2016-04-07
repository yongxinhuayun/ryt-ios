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

@interface HttpRequstTool : NSObject
+(HttpRequstTool *)shareInstance;
-(void)handlerNetworkingPOSTRequstWithServerUrl:(NSString *)server_url  Parameters:(id )param showHUDView:(UIView *)view  success:(requstSuccessBlock )successBlock;
-(void)handlerNetworkingGETRequstWithServerUrl:(NSString *)server_url  Parameters:(NSDictionary *)param showHUDView:(UIView *)view  success:(requstSuccessBlock )successBlock;

@end
