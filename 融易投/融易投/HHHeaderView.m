//
//  HHHeaderView.m
//  HHHorizontalPagingView
//
//  Created by Huanhoo on 15/7/16.
//  Copyright (c) 2015年 Huanhoo. All rights reserved.
//

#import "HHHeaderView.h"

@implementation HHHeaderView

+ (HHHeaderView *)headerView {
    HHHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"HHHeaderView" owner:self options:nil][0];
    return headerView;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com