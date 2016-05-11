//
//  FinanceModel.h
//  融易投
//
//  Created by efeiyi on 16/4/5.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "authorModel.h"

@interface FinanceModel : NSObject
/**
 *  objectList对应的数据
 */
/** 项目背景图 */
@property (nonatomic ,strong) NSString *picture_url;

/** 项目id */
@property (nonatomic ,strong) NSString *ID;

/** 主题 */
@property (nonatomic ,strong) NSString *title;

/** 项目描述 */
@property (nonatomic ,strong) NSString *brief;

/** 已融资金额*/
@property(nonatomic,assign) NSInteger investsMoney;
/** 融资目标金额 */
@property (nonatomic ,assign) NSInteger investGoalMoney;


/** 融资开始时间 */
@property (nonatomic ,assign) NSInteger investStartDatetime;
/** 融资结束时间/创作开始时间 */
@property (nonatomic ,assign) NSInteger investEndDatetime;

/** 投资人数 */
@property (nonatomic ,assign) NSInteger investorsNum;

/** 作者信息 */
@property (nonatomic, strong) authorModel *author;
@property(nonatomic,assign)NSInteger praiseNUm;
@property(nonatomic,assign) NSInteger commentNum;

/** 回复列表*/
@property(nonatomic,strong) NSMutableArray *artworkComments;
@property(nonatomic,strong) NSMutableArray *artworkAttachment;
@end
