//
//  FinanceDetailModel.h
//  融易投
//
//  Created by efeiyi on 16/4/14.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface FinanceDetailModel : NSObject

/** 关注人数 */
@property (nonatomic ,assign) NSInteger followedNum;

/** 投资者数量 */
@property (nonatomic ,assign) NSInteger investsNum;
/** 融资金额 */
@property (nonatomic ,assign) NSInteger investsMoney;


/** 存放着author和master的数据（里面都是author模型和master模型） */
@property (strong, nonatomic) NSMutableArray *artWorkList;




@end
