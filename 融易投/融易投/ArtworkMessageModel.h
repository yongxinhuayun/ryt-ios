//
//  ArtworkMessageModel.h
//  融易投
//
//  Created by efeiyi on 16/4/21.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ArtworkMessageCreatorModel.h"
#import "ArtworkMessageCreatorModel.h"


@class CreatorModel;
@class MasterModel;
@interface ArtworkMessageModel : NSObject
/** id */
@property (nonatomic ,strong) NSString *ID;
/**评论内容 */
@property (nonatomic ,strong) NSString *content;
/** 评论者 */
@property(nonatomic,strong) CreatorModel *creator;
/** 创建时间 */
@property (nonatomic ,assign) NSInteger createDatetime;
@property (nonatomic ,strong) NSString *status;
@property (nonatomic ,strong) NSMutableArray *artworkMessageAttachments;
@property(nonatomic,strong) MasterModel *master;

@end

