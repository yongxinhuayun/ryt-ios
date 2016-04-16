//
//  ArtWorkListModel.h
//  融易投
//
//  Created by efeiyi on 16/4/14.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AuthorDetailModels.h"

@interface ArtWorkListModel : NSObject


/** 项目背景图 */
@property (nonatomic ,strong) NSString *picture_url;


/** 融资目标金额 */
@property (nonatomic ,assign) NSInteger investGoalMoney;

/** 融资开始时间 */
@property (nonatomic ,assign) NSInteger investStartDatetime;
/** 融资结束时间/创作开始时间 */
@property (nonatomic ,assign) NSInteger investEndDatetime;

/** 拍卖开始时间 */
@property (nonatomic ,assign) NSInteger auctionStartDatetime;
/** 拍卖结束时间 */
@property (nonatomic ,assign) NSInteger auctionEndDatetime;

/** 作者信息 */
@property (nonatomic, strong) AuthorDetailModels *author;



@end
