//
//  MasterWorkModel.h
//  融易投
//
//  Created by efeiyi on 16/5/18.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MasterWorkModel : NSObject

/** 存放着某一页微博数据（里面都是Status模型） */
@property (strong, nonatomic) NSMutableArray *masterWorkList;

@end
