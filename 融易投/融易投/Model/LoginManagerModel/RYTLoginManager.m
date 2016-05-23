//
//  RYTLoginManager.m
//  融易投
//
//  Created by 李鹏飞 on 16/5/22.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import "RYTLoginManager.h"
#import "UserAccount.h"
#import "AppDelegate.h"
#import "LognController.h"
#import "CommonTabBarViewController.h"
@implementation RYTLoginManager

+(instancetype)shareInstance{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

-(instancetype)init{
    if (self = [super init]) {
        // user 只可以在这里初始化
        //
        if (!_user) {
            _user = [UserAccount new];
        }
        //判断是否为访客，如果用户的id为空，说明是访客
        if (!_user.ID) {
            _isVisitor = YES;
        }
        //注册登录通知
    }
    return self;
}

-(BOOL)showLoginViewIfNeed{
    if ([RYTLoginManager shareInstance].isVisitor) {
        [[AppDelegate shareAppDelegate].tabBarController presentViewController:[[LognController alloc] init] animated:YES completion:nil];
        return YES;
    }
    return NO;
}

-(void)loginSuccess{
    _isVisitor = NO;
    [self saveUser];
}

-(void)saveUser{
    
}

////注册登录通知
//-(void)addObser{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doLogout) name:<#(nullable NSString *)#> object:<#(nullable id)#>]
//}
-(BOOL)doLogout{
    return NO;
}


@end
