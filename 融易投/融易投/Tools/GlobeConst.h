//
//  GlobeConst.h
//  融易投
//
//  Created by efeiyi on 16/4/2.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobeConst : NSObject

/** 全局统一的请求路径 */
UIKIT_EXTERN NSString *const baseUrl;

/** 导航栏最大的Y值 */
UIKIT_EXTERN CGFloat const SSStatusMaxH;

/** 导航栏最大的Y值 */
UIKIT_EXTERN CGFloat const SSNavMaxY;

/** 标题栏的高度 */
UIKIT_EXTERN CGFloat const SSTitlesViewH;

/** 全局统一的间距 */
UIKIT_EXTERN CGFloat const SSMargin;

/** UITabBar的高度 */
UIKIT_EXTERN CGFloat const SSTabBarH;

/** 通知：点击融资项目跳转对应融资项目的详情页 */
UIKIT_EXTERN NSString * const ProjectDetailsArtWorkIdNotification;

/** 通知：切换控制器 */
UIKIT_EXTERN NSString * const ChangeRootViewControllerNotification;

/** 通知：跟新我的控制器的界面 */
UIKIT_EXTERN NSString * const UpdateMeViewDataControllerNotification;
/** 通知：跟新简介控制器的界面  */
UIKIT_EXTERN NSString * const UpdateJianJieViewDataControllerNotification;

@end
