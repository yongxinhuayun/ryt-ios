//
//  FinanceViewController.h
//  融易投
//
//  Created by dongxin on 16/4/27.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "BaseScrollViewController.h"
#import "CycleView.h"

@interface FinanceViewController : BaseScrollViewController
@property(nonatomic,strong)CycleView *cycleView;
@property(nonatomic,strong)NSMutableArray *titleArray;
@property(nonatomic,strong)NSMutableArray *controllersView;
@property(nonatomic,assign)CGFloat topHight;


@end
