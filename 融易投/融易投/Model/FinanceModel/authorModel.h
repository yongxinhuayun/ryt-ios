//
//  authorModel.h
//  融易投
//
//  Created by efeiyi on 16/4/5.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MasterModel.h"

@interface authorModel : NSObject

/**
 *  objectList里面author这个key对应的数据
 */

@property(nonatomic,copy) NSString *ID;
/** 描述 */
@property (nonatomic ,copy) NSString *descriptions;

/** 项目作者简介 */
@property (nonatomic ,copy) NSString *username;

/** 项目作者真是姓名 */
@property (nonatomic ,copy) NSString *name;

/** 头像 */
@property (nonatomic ,copy) NSString *pictureUrl;

/** 创作者信息 */
@property (nonatomic, strong) MasterModel *master;

@end
