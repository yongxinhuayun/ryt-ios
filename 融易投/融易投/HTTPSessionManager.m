//
//  BSHTTPSessionManager.m
//  01-BuDeJie
//
//  Created by 1 on 15/12/25.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "HTTPSessionManager.h"

//@implementation HTTPSessionManager
//
//- (instancetype)initWithBaseURL:(NSURL *)url
//           sessionConfiguration:(NSURLSessionConfiguration *)configuration
//{
//    if (self = [super initWithBaseURL:url sessionConfiguration:configuration]) {
////        self.attemptsToRecreateUploadTasksForBackgroundSessions = YES;
////        self.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
////        
////        AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
////        [serializer setValue:@"iPhone6s" forHTTPHeaderField:@"Phone"];
////        self.requestSerializer = serializer;
//    }
//    return self;
//}
//
//+(instancetype)shareManager
//{
//    
//    static HTTPSessionManager *_instance;
//    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        
//        //斜杠加不加都是可以的
//        //定义一个含有协议头和服务器主机地址的url
//        NSURL *url = [NSURL URLWithString:@"http://192.168.1.69:8001/"];
//        
//        _instance = [[self alloc] initWithBaseURL:url];
//        
//        _instance.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain", nil];
//    });
//    
//    return _instance;
//}

//@end
