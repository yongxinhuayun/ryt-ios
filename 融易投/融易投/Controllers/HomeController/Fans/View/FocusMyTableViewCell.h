//
//  FocusMyTableViewCell.h
//  融易投
//
//  Created by efeiyi on 16/4/29.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>


//遵守cell的协议,点击cell的头像进行跳转
@protocol focusMyTableViewCellDelegate <NSObject>
-(void)clickUserIcon:(NSIndexPath *)indexPath;
@end

@class PageInfoListMyModel;

@interface FocusMyTableViewCell : UITableViewCell

@property (nonatomic, strong) PageInfoListMyModel *model;

@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,weak) id<focusMyTableViewCellDelegate>delegate;

@end
