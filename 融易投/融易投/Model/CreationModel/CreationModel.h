//
//  CreationModel.h
//  融易投
//
//  Created by efeiyi on 16/4/6.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "authorModel.h"

@interface CreationModel : NSObject

@property(nonatomic,copy) NSString *ID;
/** 项目背景图 */
@property (nonatomic ,strong) NSString *picture_url;

/** 创作标题 */
@property (nonatomic ,strong) NSString *title;

/** 创作简介 */
@property (nonatomic ,strong) NSString *descriptions;

/** 最新创作时间 */
@property (nonatomic ,assign) NSInteger newCreationEmdDatetime;

/** 创作结束时间 */
@property (nonatomic ,assign) NSInteger creationEndDatetime;

/** 作者信息 */
@property (nonatomic, strong) authorModel *author;

@end
