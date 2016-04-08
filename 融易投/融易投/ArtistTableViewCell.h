//
//  ArtistTableViewCell.h
//  融易投
//
//  Created by efeiyi on 16/4/7.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ArtistModel;

@interface ArtistTableViewCell : UITableViewCell


@property (nonatomic, strong) ArtistModel *model;

//排行控件
@property (weak, nonatomic) IBOutlet UILabel *RankLabel;

@end
