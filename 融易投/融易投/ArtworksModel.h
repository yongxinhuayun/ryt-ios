//
//  ArtworksModel.h
//  融易投
//
//  Created by efeiyi on 16/5/4.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

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

/** 图片 */
@property (nonatomic ,strong) NSString *truename;

@end
