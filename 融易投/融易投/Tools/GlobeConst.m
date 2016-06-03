//
//  GlobeConst.m
//  融易投
//
//  Created by efeiyi on 16/4/2.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "GlobeConst.h"

@implementation GlobeConst

/** 全局统一的请求路径 */
//NSString *const baseUrl = @"http://api.budejie.com/api/api_open.php";

/** 导航栏最大的Y值 */
CGFloat const SSStatusMaxH = 20;

/** 导航栏最大的Y值 */
CGFloat const SSNavMaxY = 64;

/** 标题栏的高度 */
CGFloat const SSTitlesViewH = 49;

/** 全局统一的间距 */
CGFloat const SSMargin = 10;

/** UITabBar的高度 */
CGFloat const SSTabBarH = 49;


/** 通知：点击融资项目跳转对应融资项目的详情页  */
NSString * const ProjectDetailsArtWorkIdNotification = @"ProjectDetailsArtWorkIdNotification";



NSString * const ChangeRootViewControllerNotification = @"ChangeRootViewControllerNotification";


NSString * const UpdateMeViewDataControllerNotification = @"UpdateMeViewDataControllerNotification";

NSString * const UpdateJianJieViewDataControllerNotification = @"UpdateJianJieViewDataControllerNotification";

NSString * const UpdateFocusAndFansNotification = @"UpdateFocusAndFansNotification";

NSString * const SenduserIdNotification = @"SenduserId";


@end
