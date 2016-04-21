//
//  ProjectDetailsModel.h
//  融易投
//
//  Created by efeiyi on 16/4/20.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ArtworkAttachmentListModel.h"
#import "ArtworkModel.h"
#import "ArtworkdirectionModel.h"

@interface ProjectDetailsModel : NSObject

/** 项目文件列表 */
@property (nonatomic ,strong) ArtworkAttachmentListModel *artworkAttachmentList;

/** 项目详情 */
@property (nonatomic ,strong) ArtworkModel *artWork;

/**制作解惑，说明 */
@property (nonatomic ,strong) ArtworkdirectionModel *artworkdirection;

/** 剩余时间 */
@property (nonatomic ,strong) NSString *time;

/** 投资人数 */
@property (nonatomic ,assign) NSInteger investNum;

/** 是否点赞 */
@property (nonatomic ,assign) BOOL isPraise;



/**** 辅助属性 ****/

/** 所有图片 */
@property (nonatomic ,strong) NSMutableArray *images;


/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;


-(CGFloat)cellHeight;
@end
