//
//  CreationModel.h
//  融易投
//
//  Created by efeiyi on 16/4/6.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "authorModel.h"
#import "MasterModel.h"

@interface CreationModel : NSObject

@property(nonatomic,copy) NSString *ID;
/** 项目背景图 */
@property (nonatomic ,strong) NSString *picture_url;
/** 主题 */
@property (nonatomic ,strong) NSString *title;
/** 简介 */
@property (nonatomic ,strong) NSString *brief;
/** 创作时间 */
@property (nonatomic ,strong) NSString *duration;
/** 描述  这个需要改变一下key值*/
@property (nonatomic ,strong) NSString *descriptions;
/** 融资目标金额 */
@property (nonatomic ,assign) NSInteger investGoalMoney;
@property(nonatomic,assign)NSInteger investsMoney;
/** 融资开始时间 */
@property (nonatomic ,assign) NSInteger investStartDatetime;
/** 融资结束时间/创作开始时间 */
@property (nonatomic ,assign) NSInteger investEndDatetime;
/** 拍卖开始时间 */
@property (nonatomic ,assign) NSInteger auctionStartDatetime;
/** 拍卖结束时间 */
@property (nonatomic ,assign) NSInteger auctionEndDatetime;
/** author信息 */
@property (nonatomic, strong) authorModel *author;
@property(nonatomic,copy) NSString *step;
@property(nonatomic,assign) NSInteger praiseNUm;
@property(nonatomic,assign)NSInteger  commentNum;
@property (nonatomic ,assign) NSInteger newCreationEmdDatetime;
/** 创作结束时间 */
@property (nonatomic ,assign) NSInteger creationEndDatetime;

@end
