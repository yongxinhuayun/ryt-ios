//
//  CreationTableViewCell.h
//  融易投
//
//  Created by efeiyi on 16/4/6.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CreationModel;

@interface CreationTableViewCell : UITableViewCell

+(instancetype) creationCell;

@property (nonatomic, strong) CreationModel *model;

@end
