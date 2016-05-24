//
//  RYTLoginManager.m
//  融易投
//
//  Created by 李鹏飞 on 16/5/22.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import "RYTLoginManager.h"
#import "UserMyModel.h"
#import "AppDelegate.h"
#import "LognController.h"
#import "RegViewController.h"
#import "CommonTabBarViewController.h"
#import "CommonNavigationController.h"
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
            _user = [UserMyModel new];
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
         UIViewController *vc = [self loginVC];
        [[AppDelegate shareAppDelegate].tabBarController presentViewController:vc animated:YES completion:nil];
        return YES;
    }
    return NO;
}

-(UIViewController *)loginVC{
    LognController *login = [[LognController alloc] init];
    CommonNavigationController *nav = [[CommonNavigationController alloc]initWithRootViewController:login];
    return nav;
}

-(BOOL)showRegViewIfNeed{
    if ([RYTLoginManager shareInstance].isVisitor) {
        UIViewController *vc = [self regVC];
        [[AppDelegate shareAppDelegate].tabBarController presentViewController:vc animated:YES completion:nil];
        return YES;
    }
    return NO;
}

-(UIViewController *)regVC{
    RegViewController *login = [[RegViewController alloc] init];
    CommonNavigationController *nav = [[CommonNavigationController alloc]initWithRootViewController:login];
    return nav;
}




//-(void)showLoginVC{
//    
//    UIViewController *vc = [self loginVC];
//   
//    [[AppDelegate shareAppDelegate].tabBarController presentViewController:vc animated:YES completion:nil];
//}

-(void)loginSuccess:(UserMyModel *)user{
    _isVisitor = NO;
    [self saveUser:user];
}

-(void)saveUser:(UserMyModel *)user{
    
    _user = user;
    
    //归档
    //获取temp文件夹路径
    NSString *tempPath = NSTemporaryDirectory();
    //拼接文件名
    NSString *filePath = [tempPath stringByAppendingPathComponent:@"userMyModel.plist"];
    
    //file:文件全路径
    [NSKeyedArchiver archiveRootObject:user toFile:filePath];
}

-(UserMyModel *)takeUser{

    //获取temp文件夹路径
    NSString *tempPath = NSTemporaryDirectory();
    //拼接文件名
    NSString *filePath = [tempPath stringByAppendingPathComponent:@"userMyModel.plist"];
    
    //解档
    UserMyModel *userMyModel = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    return userMyModel;
}





////注册登录通知
//-(void)addObser{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doLogout) name:<#(nullable NSString *)#> object:<#(nullable id)#>]
//}


-(void)doLogout{
    
    //获取temp文件夹路径
    NSString *tempPath = NSTemporaryDirectory();
    //拼接文件名
    NSString *filePath = [tempPath stringByAppendingPathComponent:@"userMyModel.plist"];
    
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    [mgr removeItemAtPath:filePath error:nil];
}


@end
