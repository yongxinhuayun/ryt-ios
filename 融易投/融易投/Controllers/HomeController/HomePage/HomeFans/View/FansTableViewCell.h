//
//  FansTableViewCell.h
//  融易投
//
//  Created by efeiyi on 16/6/2.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import <UIKit/UIKit.h>

//遵守cell的协议,点击cell的头像进行跳转
@protocol FansMyTableViewCellDelegate <NSObject>
-(void)clickUserIcon:(NSIndexPath *)indexPath;
@end

@class PageInfoListMyModel;

@interface FansTableViewCell : UITableViewCell

@property (nonatomic, strong) PageInfoListMyModel *model;

@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,weak) id<FansMyTableViewCellDelegate>delegate;

@end
