//
//  MyHomeViewController.h
//  融易投
//
//  Created by efeiyi on 16/4/30.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "BaseScrollViewController.h"

@class PageInfoModel;
@interface CommonUserHomeViewController : BaseScrollViewController

@property(nonatomic,strong)CycleView *cycleView;
@property(nonatomic,strong)NSMutableArray *titleArray;
@property(nonatomic,strong)NSMutableArray *controllersView;

@property (nonatomic ,strong)NSString *userId;


@end
