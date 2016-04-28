//
//  CycleView.h
//  test
//
//  Created by dongxin on 16/4/26.
//  Copyright © 2016年 lipengfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CycleView : UIView

@property(nonatomic,strong) NSArray *titleArray;
@property(nonatomic,strong) NSArray *controllers;
@property(nonatomic,strong) UIView *line;
@property(nonatomic,strong) UIView *headerView;
@property(nonatomic,strong) UIScrollView *bottomScrollView;
@end
