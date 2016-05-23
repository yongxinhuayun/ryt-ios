//
//  RYTLoginManager.h
//  融易投
//
//  Created by 李鹏飞 on 16/5/22.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserAccount;
@interface RYTLoginManager : NSObject


+(instancetype)shareInstance;

/**
 * 用户登录信息
 * 只读属性，防止外部赋值
 * 用户信息赋值一次
 */
@property(nonatomic,readonly) UserAccount *user;

/**
 * 判断用户身份,访客或者登录
 * 如果是访客，禁用一些功能，并弹出登录窗口
 * 只读属性，不能在外部修改
 */
@property (nonatomic,readonly,assign) BOOL isVisitor;

/**
 * 访客用户被禁止一些功能
 * 访客用户触发被禁止的功能时，提示用户登录
 */
-(BOOL)showLoginViewIfNeed;

/**
 *  如果用户登录成功
 * 1. 保存用户信息
 * 2. 每次重新登录时，要向服务器注册极光 ID
 * 3. 全局通知用户登录成功
 */
-(void)loginSuccess;

/**
 * 保存用户信息
 */
-(void)saveUser;

/**
 *  注销、退出登录
 */
-(BOOL)doLogout;
@end
