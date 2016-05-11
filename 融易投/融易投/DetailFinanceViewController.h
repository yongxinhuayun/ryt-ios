//
//  DetailFinanceViewController.h
//  融易投
//
//  Created by dongxin on 16/4/28.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "BaseScrollViewController.h"
@class FinanceModel,ArtworkModel;

@interface DetailFinanceViewController : BaseScrollViewController
@property(nonatomic,strong)CycleView *cycleView;
@property(nonatomic,strong)NSMutableArray *titleArray;
@property(nonatomic,strong)NSMutableArray *controllersView;
@property(nonatomic,strong)ArtworkModel *artworkModel;
@property(nonatomic,copy) NSString *artworkId;
@end
