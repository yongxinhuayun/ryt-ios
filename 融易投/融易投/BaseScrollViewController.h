//
//  BaseScrollViewController.h
//  融易投
//
//  Created by dongxin on 16/4/26.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseScrollViewController : UIViewController
@property(nonatomic,strong) UIScrollView *backgroundScrollView;
@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIView *middleView;
@property(nonatomic,strong) UIView *bottmView;
@end
