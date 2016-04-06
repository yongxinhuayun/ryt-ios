//
//  authorModel.h
//  融易投
//
//  Created by efeiyi on 16/4/5.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface authorModel : NSObject

/**
 *  objectList里面author这个key对应的数据
 */

/** 描述 */
@property (nonatomic ,strong) NSString *descriptions;

/** 项目作者简介 */
@property (nonatomic ,strong) NSString *username;

/** 项目作者真是姓名 */
@property (nonatomic ,strong) NSString *name;

/** 头像 */
@property (nonatomic ,strong) NSString *pictureUrl;

@end
