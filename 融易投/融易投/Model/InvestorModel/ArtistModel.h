//
//  ArtistModel.h
//  融易投
//
//  Created by efeiyi on 16/4/7.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArtistModel : NSObject

/** 投资者姓名 */
@property (nonatomic ,strong) NSString *truename;

/** 投资价格 */
@property (nonatomic ,assign) NSInteger bidding_rate;
@property(nonatomic,copy) NSString *picture;
@end
