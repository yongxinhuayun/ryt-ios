//
//  AuctionTableViewCell.h
//  融易投
//
//  Created by efeiyi on 16/4/6.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AuctionModel;

@interface AuctionTableViewCell : UITableViewCell

+(instancetype) auctionCell;

@property (nonatomic, strong) AuctionModel *model;

/** 拍卖后-整体 */
@property (weak, nonatomic) IBOutlet UIView *auctionAfterView;

/** 拍卖中-整体 */
@property (weak, nonatomic) IBOutlet UIView *auctingView;

/** 拍卖前-整体 */
@property (weak, nonatomic) IBOutlet UIView *auctionBeforeView;

//自动计算cell的高度
-(CGFloat)cellHeight;

@end
