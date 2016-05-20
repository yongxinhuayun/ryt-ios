//
//  PrivateLetterModel.h
//  融易投
//
//  Created by 李鹏飞 on 16/5/20.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserMyModel;

@interface PrivateLetterModel : NSObject
@property(nonatomic,copy) NSString *ID;
@property(nonatomic,copy) NSString *content;
@property(nonatomic,strong)UserMyModel *targetUser;
@property(nonatomic,strong)UserMyModel *fromUser;
@property(nonatomic,assign) NSInteger createDatetime;
@property(nonatomic,copy) NSString *isWatch;
@property(nonatomic,copy) NSString *status;
@property(nonatomic,copy) NSString *isRead;
@property(nonatomic,copy) NSString *cid;
@end
