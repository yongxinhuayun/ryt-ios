//
//  UserCommonCell.h
//  融易投
//
//  Created by efeiyi on 16/4/21.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ArtworkCommentListModel.h"

@interface UserCommonCell : UITableViewCell

@property (nonatomic, strong) ArtworkCommentListModel *model;


@property (weak, nonatomic) IBOutlet UIButton *userPic;
@property (weak, nonatomic) IBOutlet UIButton *userName;
@property (weak, nonatomic) IBOutlet UILabel *replyTime;
@property (weak, nonatomic) IBOutlet UILabel *content;


@end
