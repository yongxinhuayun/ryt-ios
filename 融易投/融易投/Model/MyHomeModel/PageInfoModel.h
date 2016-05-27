//
//  InvestProjectModel.h
//  融易投
//
//  Created by efeiyi on 16/5/4.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserMyModel.h"

@interface PageInfoModel : NSObject

/**  */
@property (nonatomic ,strong) NSMutableArray *artworks;

/**  */
@property (nonatomic ,assign) NSInteger sumInvestment;

/**  */
@property (nonatomic ,assign) NSInteger yield;

/**  */
@property (nonatomic ,strong) UserMyModel *user;
@property(nonatomic,copy) NSString *followStatus;
/** 粉丝数 */
@property (nonatomic ,assign) NSInteger followNum;

/** 赞过的 */
@property (nonatomic ,assign) NSInteger num;

@end
