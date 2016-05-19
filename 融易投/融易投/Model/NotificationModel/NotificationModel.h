//
//  NotificationModel.h
//  融易投
//
//  Created by dongxin on 16/4/8.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserMyModel.h"

@interface NotificationModel : NSObject

/** 通知内容 */
@property (nonatomic ,copy) NSString *content;


/** 通知时间 */
@property (nonatomic ,copy) NSString *createDatetime;

/** 通知者id */
@property (nonatomic ,copy) NSString *ID;

/** 发送者信息 */
@property (nonatomic ,strong) UserMyModel *fromUser;
/** 接受者信息 */
@property (nonatomic ,strong) UserMyModel *targetUser;

/** 是否已读 */
@property(nonatomic,copy) NSString *isWatch;
@property(nonatomic,copy) NSString *status;


@end
