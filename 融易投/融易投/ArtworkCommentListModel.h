//
//  ArtworkCommentListModel.h
//  融易投
//
//  Created by efeiyi on 16/4/21.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class  CreatorModel;
@class ArtworkMessageModel;

@interface ArtworkCommentListModel : NSObject
/** id */
@property (nonatomic ,copy) NSString *ID;
@property (nonatomic ,copy) NSString *content;
@property (nonatomic,strong) ArtworkMessageModel *artworkMessage;
@property (nonatomic,strong) ArtworkCommentListModel *fatherComment;
/** 创建时间 */
@property (nonatomic ,strong) CreatorModel *creator;
@property (nonatomic ,assign) NSInteger createDatetime;
@property (nonatomic,assign) CGFloat cellHeight;
@end
