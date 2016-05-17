//
//  MessageModel.h
//  融易投
//
//  Created by 李鹏飞 on 16/5/17.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject
/**通知未读个数**/
@property(nonatomic,assign) NSInteger noticeNum;
/**评论未读个数**/
@property(nonatomic,assign) NSInteger commentNum;
/**私信未读个数**/
@property(nonatomic,assign) NSInteger messageNum;
/**网络请求状态码**/
@property(nonatomic,copy) NSString *resultCode;
/**网络请求状态**/
@property(nonatomic,copy) NSString *resultMsg;
@end
