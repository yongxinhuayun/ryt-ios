//
//  NotificationModel.h
//  融易投
//
//  Created by dongxin on 16/4/8.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FromUserModel.h"

@interface NotificationModel : NSObject

/** 通知内容 */
@property (nonatomic ,strong) NSString *content;

/** 通知时间 */
@property (nonatomic ,strong) NSString *createDatetime;

/** 通知者id */
@property (nonatomic ,strong) NSString *ID;

//接受者信息
@property (nonatomic ,strong) FromUserModel *fromUser;



@end
