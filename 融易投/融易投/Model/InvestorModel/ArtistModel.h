//
//  ArtistModel.h
//  融易投
//
//  Created by efeiyi on 16/4/7.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArtistModel : NSObject

/*
 *  艺术家的id
 */
@property(nonatomic,copy) NSString *author_id;

/*
 * 艺术家姓名 
 */
@property (nonatomic ,strong) NSString *truename;

/*
 * invest_goal_money
 */
@property (nonatomic,assign) NSInteger invest_goal_money;

/*
 * turnover
 */
@property(nonatomic,copy) NSString *turnover;

/*
 *  头像
 */
@property(nonatomic,copy) NSString *picture;
@end
