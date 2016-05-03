//
//  ArtUserFollowedMyModel.h
//  融易投
//
//  Created by efeiyi on 16/5/3.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserMyModel.h"
#import "FollowerMyModel.h"

@interface ArtUserFollowedMyModel : NSObject

/** 项目id */
@property (nonatomic ,strong) NSString *ID;

/** 用户 */
@property (nonatomic ,strong) UserMyModel *user;

/** 粉丝 */
@property (nonatomic ,strong) FollowerMyModel *follower;

/** 状态 */
@property (nonatomic ,strong) NSString *status;

/** 类型 */
@property (nonatomic ,strong) NSString *type;

/** 创作开始时间 */
@property (nonatomic ,assign) NSInteger createDatetime;

@end
