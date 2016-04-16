//
//  ArtworkModel.h
//  融易投
//
//  Created by efeiyi on 16/4/16.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ArtworkAttachmentListModel.h"
#import "ArtworkCommentListModel.h"
#import "ArtworkdirectionModel.h"
#import "ArtworkobjectModel.h"

@interface ArtworkModel : NSObject

/** 用户上传项目图片附件 */
@property (nonatomic ,strong) ArtworkAttachmentListModel *artworkAttachmentList;

/** 用户上传项目图片附件 */
@property (nonatomic ,strong) ArtworkCommentListModel *artworkCommentList;

/** 用户上传项目图片附件 */
@property (nonatomic ,strong) ArtworkdirectionModel *fileName;

/** 用户上传项目图片附件 */
@property (nonatomic ,strong) ArtworkobjectModel *object;

@end
