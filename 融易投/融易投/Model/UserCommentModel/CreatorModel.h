//
//  CreatorModel.h
//  融易投
//
//  Created by efeiyi on 16/4/21.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MasterMyModel;
@interface CreatorModel : NSObject


/** id */
@property (nonatomic ,copy) NSString* ID;

/**评论内容 */
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *username;
/** 评论者 */
@property (nonatomic ,copy) NSString *pictureUrl;
@property (nonatomic ,assign) NSInteger createDatetime;
/** 图片 */
@property (nonatomic ,strong) MasterMyModel *master;

@end
