//
//  FollowerMyModel.h
//  融易投
//
//  Created by efeiyi on 16/5/3.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FollowerMyModel : NSObject

/** id */
@property (nonatomic ,strong) NSString *ID;

/** 名称 */
@property (nonatomic ,strong) NSString *name;

/** 名称 */
@property (nonatomic ,strong) NSString *username;

/** 图片 */
@property (nonatomic ,strong) NSString *pictureUrl;

/** 性别 */
@property (nonatomic ,strong) NSString *sex;

/** userBrief */
@property (nonatomic ,strong) UserBriefMyModel *userBrief;

/** 艺术家身份 */
@property (nonatomic ,strong) MasterMyModel *master;


@end
