//
//  ArtworkCommentListModel.h
//  融易投
//
//  Created by efeiyi on 16/4/21.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CreatorModel.h"
#import "ArtworkMessageModel.h"


@interface ArtworkCommentListModel : NSObject


/** id */
@property (nonatomic ,strong) NSString *ID;


@property (nonatomic ,strong) NSString *content;


@property (nonatomic ,strong) NSString *fatherComment;

/** 创建时间 */
@property (nonatomic ,strong) CreatorModel *creator;

@property (nonatomic ,assign) NSInteger createDatetime;



@end
