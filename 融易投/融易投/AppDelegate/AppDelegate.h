//
//  AppDelegate.h
//  融易投
//
//  Created by dongxin on 16/3/30.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommonTabBarViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong)CommonTabBarViewController *tabBarController;
+(instancetype)shareAppDelegate;
@end

