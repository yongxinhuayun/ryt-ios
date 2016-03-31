//
//  BSHTTPSessionManager.m
//  01-BuDeJie
//
//  Created by 1 on 15/12/25.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "HTTPSessionManager.h"

@implementation HTTPSessionManager

- (instancetype)initWithBaseURL:(NSURL *)url
           sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    if (self = [super initWithBaseURL:url sessionConfiguration:configuration]) {
//        self.attemptsToRecreateUploadTasksForBackgroundSessions = YES;
//        self.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//        
//        AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
//        [serializer setValue:@"iPhone6s" forHTTPHeaderField:@"Phone"];
//        self.requestSerializer = serializer;
    }
    return self;
}

@end
