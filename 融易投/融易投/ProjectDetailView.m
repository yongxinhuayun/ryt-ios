//
//  ProjectDetailView.m
//  融易投
//
//  Created by efeiyi on 16/4/18.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "ProjectDetailView.h"

@implementation ProjectDetailView

+ (ProjectDetailView *)projectDetailView{

    ProjectDetailView *projectDetailView = [[[NSBundle mainBundle] loadNibNamed:@"ProjectDetailView" owner:self options:nil] firstObject];
    
    return projectDetailView;
}

@end
