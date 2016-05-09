//
//  ArtworkListModel.h
//  融易投
//
//  Created by efeiyi on 16/5/9.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserMyModel.h"

@interface ArtworkListModel : NSObject

/** id */
@property (nonatomic ,strong) NSString *ID;

/** 名称 */
@property (nonatomic ,strong) NSString *title;

/** 名称 */
@property (nonatomic ,strong) NSString *brief;

/**  */
@property (nonatomic ,strong) NSString *description;

/** 图片 */
@property (nonatomic ,strong) NSString *picture_url;

/** 项目进度 */
@property (nonatomic ,strong) NSString *step;

/** 投资金额 */
@property (nonatomic ,assign) NSInteger investGoalMoney;

/** 赞过的 */
@property (nonatomic ,assign) NSInteger praiseNUm;


/** 赞过的 */
@property (nonatomic ,assign) NSInteger num;

/**  */
@property (nonatomic ,strong) UserMyModel *author;

@end
