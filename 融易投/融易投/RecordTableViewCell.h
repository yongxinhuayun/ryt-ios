//
//  RecordTableViewCell.h
//  融易投
//
//  Created by dongxin on 16/5/3.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopRecordTCell.h"
@class RecordModel;
@interface RecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *userIcon;

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *investTime;
@property(nonatomic,weak) id<RecordCellDelegate>delegate;
@property(nonatomic,strong) NSIndexPath *indexPath;
@property(nonatomic,strong) RecordModel *model;

@end
