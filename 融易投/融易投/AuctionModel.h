//
//  AuctionModel.h
//  融易投
//
//  Created by efeiyi on 16/4/6.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "authorModel.h"

@interface AuctionModel : NSObject

/** 项目背景图 */
@property (nonatomic ,strong) NSString *picture_url;

/** 创作标题 */
@property (nonatomic ,strong) NSString *title;

/** 创作简介 */
@property (nonatomic ,strong) NSString *descriptions;

/** 大阶段 */
@property (nonatomic ,copy) NSString *type;

/** 小阶段 */
@property (nonatomic ,copy) NSString *step;

/** 拍卖开始时间 */
@property (nonatomic ,assign) NSInteger auctionStartDatetime;

/** 拍卖结束时间 */
@property (nonatomic ,assign) NSInteger auctionEndDatetime;

/** 最新竞价价格 */
@property (nonatomic ,assign) NSInteger newBidingPrice;

/** 最新出价时间 */
@property (nonatomic ,assign) NSInteger bewBiddingDate;

/** 作者信息 */
@property (nonatomic, strong) authorModel *author;


@end
