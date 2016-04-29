//
//  BaseScrollViewController.h
//  融易投
//
//  Created by dongxin on 16/4/26.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CycleView;

@interface BaseScrollViewController : UIViewController
@property(nonatomic,strong) UIScrollView *backgroundScrollView;
@property(nonatomic,strong) UIView *topview;
@property(nonatomic,strong) UIView *middleView;
@property(nonatomic,strong) UIView *bottmView;

//@property(nonatomic,strong)CycleView *cycleView;
//@property(nonatomic,strong)NSMutableArray *titleArray;
//@property(nonatomic,strong)NSMutableArray *controllersView;
//@property(nonatomic,assign)CGFloat topHight;
@end
