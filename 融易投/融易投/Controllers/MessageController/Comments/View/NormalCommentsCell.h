//
//  NormalCommentsCell.h
//  融易投
//
//  Created by 李鹏飞 on 16/5/18.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserCommentListModel;
@interface NormalCommentsCell : UITableViewCell
@property(nonatomic,strong) UserCommentListModel *commentModel;
@end
