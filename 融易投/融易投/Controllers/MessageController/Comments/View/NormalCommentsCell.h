//
//  NormalCommentsCell.h
//  融易投
//
//  Created by 李鹏飞 on 16/5/18.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserCommentListModel;
@protocol CommentsDelegate <NSObject>
-(void)postUserComments:(UserCommentListModel *) commentModel;
-(void)jumpToDetailController:(UserCommentListModel*) commentModel;
@end


@interface NormalCommentsCell : UITableViewCell
@property(nonatomic,strong) UserCommentListModel *commentModel;
@property(nonatomic,weak) id<CommentsDelegate>delegate;
@end
