//
//  MBProgressHUD+YXL.h
//  SocialApplications
//
//  Created by Yexinglong on 14-10-5.
//  Copyright (c) 2014年 Yexinglong. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (YXL)
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

/**
 *  对勾
 */
+ (void)showSuccess:(NSString *)success;
/**
 *  错误
 */
+ (void)showError:(NSString *)error;
/**
 *  菊花
 */
+ (void)showMessage:(NSString *)message;
/**
 *  hide掉模盖,如果遇上block就用上面的
 */
+ (void)hideHUD;

@end
