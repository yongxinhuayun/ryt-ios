//
//  FinanceTableViewCell.h
//  融易投
//
//  Created by efeiyi on 16/4/5.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FinanceModel;

@interface FinanceTableViewCell : UITableViewCell

+(instancetype) financeCell;

@property (nonatomic, strong) FinanceModel *model;

@end
