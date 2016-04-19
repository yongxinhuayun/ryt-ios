//
//  HHContentScrollView.m
//  HHHorizontalPagingView
//
//  Created by Huanhoo on 15/7/16.
//  Copyright (c) 2015年 Huanhoo. All rights reserved.
//

#import "HHContentScrollView.h"

#import "ProjectDetailView.h"

@implementation HHContentScrollView

+ (HHContentScrollView *)contentScrollView {
    HHContentScrollView *scrollView = [[HHContentScrollView alloc] init];
    
    ProjectDetailView *projectDetailView = [ProjectDetailView projectDetailView];
    [scrollView addSubview:projectDetailView];
    
    scrollView.backgroundColor = [UIColor grayColor];
    
    scrollView.contentSize = CGSizeMake(SSScreenW, SSScreenH);
    return scrollView;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com