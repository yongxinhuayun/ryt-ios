//
//  HHHeaderView.h
//  HHHorizontalPagingView
//
//  Created by Huanhoo on 15/7/16.
//  Copyright (c) 2015年 Huanhoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHHeaderView : UIView

//@property (nonatomic, weak) IBOutlet UIImageView *headerImageView;

@property (nonatomic, weak) IBOutlet UIView *segmentView;
@property (weak, nonatomic) IBOutlet UIView *headerImageView;


+ (HHHeaderView *)headerView;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com