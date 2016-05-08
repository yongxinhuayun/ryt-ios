//
//  MyHomeViewController.h
//  融易投
//
//  Created by efeiyi on 16/5/4.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "BaseScrollViewController.h"

@interface MyHomeViewController :BaseScrollViewController

@property(nonatomic,strong)CycleView *cycleView;
@property(nonatomic,strong)NSMutableArray *titleArray;
@property(nonatomic,strong)NSMutableArray *controllersView;

@end
