//
//  InvestorModel.h
//  融易投
//
//  Created by efeiyi on 16/4/7.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InvestorModel : NSObject

@property(nonatomic,copy) NSString *user_id;
/** 投资者姓名 */
@property (nonatomic ,strong) NSString *truename;
/** 投资价格 */
@property (nonatomic ,assign) NSInteger price;
@property(nonatomic,assign) NSInteger rois;
@property(nonatomic,copy) NSString *username;
@property(nonatomic,copy) NSString *picture;



@end
