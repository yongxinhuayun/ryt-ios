//
//  ChartMessage.m
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//

#import "ChartMessage.h"
#import "PrivateLetterModel.h"
#import "UserMyModel.h"
#import <UIImageView+WebCache.h>

@implementation ChartMessage

-(void)setLetterModel:(PrivateLetterModel *)letterModel{
    NSString *userId = TakeUserID;
    _letterModel = letterModel;
    NSString *iconStr =[letterModel.fromUser.pictureUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.icon = iconStr;
    if ([letterModel.fromUser.ID isEqualToString:userId] ) {
        self.messageType = kMessageTo;
    }else{
        self.messageType = kMessageFrom;
    }
    self.content = letterModel.content;
}
-(void)setDict:(NSDictionary *)dict
{
    _dict=dict;

    self.icon=dict[@"icon"];
//    self.time=dict[@"time"];
    self.content=dict[@"content"];
    self.messageType=[dict[@"type"] intValue];
}
@end
