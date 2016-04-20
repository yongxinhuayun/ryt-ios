//
//  ProjectDetailsResultModel.h
//  融易投
//
//  Created by efeiyi on 16/4/20.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ProjectDetailsModel.h"

@interface ProjectDetailsResultModel : NSObject


/** 存放着某一页微博数据（里面都是Status模型） */
@property (strong, nonatomic) ProjectDetailsModel *object;

/** 存放着一堆的广告数据（里面都是MJAd模型） */
@property (strong, nonatomic) NSString *resultMsg;

/** 存放着一堆的广告数据（里面都是MJAd模型） */
@property (strong, nonatomic) NSString *resultCode;

@end
