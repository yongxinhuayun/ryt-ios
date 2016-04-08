//
//  InvestorTableViewCell.h
//  融易投
//
//  Created by efeiyi on 16/4/7.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InvestorModel;

@interface InvestorTableViewCell : UITableViewCell

@property (nonatomic, strong) InvestorModel *model;

@property (weak, nonatomic) IBOutlet UILabel *RankLabel;

@end
