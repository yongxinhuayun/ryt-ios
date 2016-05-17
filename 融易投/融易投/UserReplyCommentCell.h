//
//  UserReplyCommentCell.h
//  融易投
//
//  Created by dongxin on 16/5/6.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ArtworkCommentListModelDelegate <NSObject>
-(void)clickUserIcon:(NSIndexPath *)indexPath;
-(void)clickfatherIcon:(NSIndexPath *)indexPath;
-(void)clickUserIconOrName:(NSIndexPath *)indexPath;

@end

@class ArtworkCommentListModel;
@interface UserReplyCommentCell : UITableViewCell
@property(nonatomic,strong)ArtworkCommentListModel *model;
@property(nonatomic,assign)CGFloat cellHeight;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,weak) id<ArtworkCommentListModelDelegate>delegate;
@end
