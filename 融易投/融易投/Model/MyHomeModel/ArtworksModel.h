//
//  ArtworksModel.h
//  融易投
//
//  Created by efeiyi on 16/5/4.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserMyModel;
@interface ArtworksModel : NSObject

/** id */
@property (nonatomic ,strong) NSString *ID;

/** 名称 */
@property (nonatomic ,strong) NSString *title;

/** 名称 */
@property (nonatomic ,strong) NSString *brief;

/** 图片 */
@property (nonatomic ,strong) NSString *picture_url;

/** 项目进度 */
@property (nonatomic ,strong) NSString *step;

/**  */
@property (nonatomic ,assign) NSInteger goalMoney;

/**  */
@property (nonatomic ,assign) NSInteger praise;


/** 赞过的 */
@property (nonatomic ,strong) NSString *num;

/**  */
@property (nonatomic ,strong) UserMyModel *user;

/**** 辅助属性 ****/
/** 是否被点过赞 */
@property (nonatomic, assign) BOOL is_zan;


@end
