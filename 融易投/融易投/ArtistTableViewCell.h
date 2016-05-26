//
//  ArtistTableViewCell.h
//  融易投
//
//  Created by efeiyi on 16/4/7.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ArtistModel,InvestorModel;

@interface ArtistTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *TopBtn;
@property (nonatomic, strong) ArtistModel *artistModel;
@property (nonatomic, strong) InvestorModel *investorModel;

//排行控件
@property (weak, nonatomic) IBOutlet UILabel *RankLabel;

@end
