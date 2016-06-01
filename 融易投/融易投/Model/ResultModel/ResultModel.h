//
//  ResultModel.h
//  融易投
//
//  Created by 李鹏飞 on 16/6/1.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResultModel : NSObject

/*
 * 状态码
 */
@property(nonatomic,copy) NSString *resultCode;

/*
 * 状态信息
 */
@property(nonatomic,copy) NSString *resultMsg;

@end
