//
//  UserCommentListModel.h
//  融易投
//
//  Created by 李鹏飞 on 16/5/18.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import <Foundation/Foundation.h>

@class  ArtworkModel,CreatorModel;
@interface UserCommentListModel : NSObject
/** id */
@property (nonatomic ,copy) NSString *ID;
@property (nonatomic ,copy) NSString *content;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *isWatch;
@property (nonatomic,strong) ArtworkModel *artwork;
@property (nonatomic,strong) CreatorModel *creator;
@property (nonatomic,strong) UserCommentListModel *fatherArtworkCommentBean;
@property (nonatomic ,assign) NSInteger createDatetime;
@property (nonatomic,assign) CGFloat cellHeight;

-(CGFloat)cellHeight;
@end
