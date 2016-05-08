//
//  UserAccount.h
//  融易投
//
//  Created by efeiyi on 16/4/1.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MasterMyModel.h"


@interface UserAccount : NSObject

/** id */
@property (nonatomic ,strong) NSString *ID;

/** 注册的手机号 */
@property (nonatomic ,strong) NSString *username;

/** 名称 */
@property (nonatomic ,strong) NSString *name;

/** 个性签名 */
@property (nonatomic ,strong) NSString *name2;


/** 图片 */
@property (nonatomic ,strong) MasterMyModel *master;

@end
