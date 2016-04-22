//
//  ArtworkCommentListModel.h
//  融易投
//
//  Created by efeiyi on 16/4/21.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class  CreatorModel;


@interface ArtworkCommentListModel : NSObject

/** id */
@property (nonatomic ,copy) NSString *ID;


@property (nonatomic ,copy) NSString *content;


@property (nonatomic ,copy) NSString *fatherComment;

/** 创建时间 */
@property (nonatomic ,strong) CreatorModel *creator;

@property (nonatomic ,assign) NSInteger createDatetime;

@end
