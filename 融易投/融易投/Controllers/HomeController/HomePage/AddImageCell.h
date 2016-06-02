//
//  AddImageCell.h
//  融易投
//
//  Created by 李鹏飞 on 16/6/2.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddImageCellDelegate <NSObject>

-(void)clickAddPhotoBtn;
@end

@interface AddImageCell : UITableViewCell

@property (nonatomic,weak) id<AddImageCellDelegate> delegate;

@end
