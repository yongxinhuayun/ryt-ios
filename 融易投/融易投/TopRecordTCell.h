//
//  TopRecordTCell.h
//  融易投
//
//  Created by 李鹏飞 on 16/5/17.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RecordCellDelegate <NSObject>
-(void)clickUserBtn:(NSInteger)tag;
-(void)clickUserBtnIcon:(NSIndexPath *)indexPath;

@end

@interface TopRecordTCell : UITableViewCell
@property(nonatomic,weak)id<RecordCellDelegate>delegate;
@property(nonatomic,strong) NSIndexPath *indexPath;
-(void)setupUI:(NSMutableArray *)topList;

@end
