//
//  XMGNewFeatureCell.m
//  网易彩票
//
//  Created by 王梦思 on 15/10/30.
//  Copyright © 2015年 王梦思. All rights reserved.
//

#import "NewFeatureCell.h"

#import "CommonTabBarViewController.h"
#import "LognController.h"
#import "RegViewController.h"

#import "UIView+Frame.h"
#import "StartButton.h"

@interface NewFeatureCell ()

//添加子控件
@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, weak) StartButton *startButton;

@property (nonatomic, weak) UIButton *lognButton;

@property (nonatomic, weak) UIButton *registerButton;

@end

@implementation NewFeatureCell

//4.实现体验按钮的懒加载
-(StartButton *)startButton
{
    if (_startButton == nil) {
        
        StartButton *startButton = [StartButton buttonWithType:UIButtonTypeCustom];
        _startButton = startButton;

        [startButton setImage:[UIImage imageNamed:@"guide_arrow"] forState:UIControlStateNormal];
        
        [startButton setTitle:@"直接进入" forState:UIControlStateNormal];
        [startButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        //自动计算尺寸
        [startButton sizeToFit];
        
        //7.实现点击按钮的监听方法
        [startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
        
        //把按钮添加到视图
        [self.contentView addSubview:startButton];
    }
    return _startButton;
}

-(UIButton *)lognButton{

    if (_lognButton == nil) {
        
        UIButton *lognButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _lognButton = lognButton;
        
        [lognButton setBackgroundImage:[UIImage imageNamed:@"bg_login"] forState:UIControlStateNormal];
        
        [lognButton setTitle:@"登录" forState:UIControlStateNormal];
        [lognButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        //自动计算尺寸
        [lognButton sizeToFit];
        
        //7.实现点击按钮的监听方法
        [lognButton addTarget:self action:@selector(logn) forControlEvents:UIControlEventTouchUpInside];
        
        //把按钮添加到视图
        [self.contentView addSubview:lognButton];

    }
    return _lognButton;
}

-(UIButton *)registerButton{

    if (_registerButton == nil) {
        
        UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerButton = registerButton;
        
        [registerButton setBackgroundImage:[UIImage imageNamed:@"bg_regist"] forState:UIControlStateNormal];
        
        [registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [registerButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        //自动计算尺寸
        [registerButton sizeToFit];
        
        //7.实现点击按钮的监听方法
        [registerButton addTarget:self action:@selector(registe) forControlEvents:UIControlEventTouchUpInside];
        
        //把按钮添加到视图
        [self.contentView addSubview:_registerButton];
        
    }
    return _registerButton;
}


//控件实现懒加载
-(UIImageView *)imageView
{
    if (_imageView == nil) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        
        _imageView = imageView;
        
        //把控件加入到cell的contentView中
        [self.contentView addSubview:imageView];
    }
    return _imageView;
}

//实现image的set方法
-(void)setImage:(UIImage *)image
{
    _image = image;
    
    self.imageView.image = image;

}

//设置子控件imageView的位置
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //子控件imageView的尺寸跟cell一样大
    self.imageView.frame = self.bounds;
    
    //5.设置体验按钮的frame
//    self.startButton.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.95);
    
    if (iPhone6 || iPhone6P) {
        self.startButton.center = CGPointMake(self.width * 0.8, self.height * 0.1);
        self.registerButton.center = CGPointMake(self.width * 0.3, self.height * 0.85);
        self.lognButton.center = CGPointMake(self.width * 0.7, self.height * 0.85);
    }else {
        
        self.startButton.center = CGPointMake(self.width * 0.8, self.height * 0.1);
        self.registerButton.center = CGPointMake(self.width * 0.25, self.height * 0.85);
        self.lognButton.center = CGPointMake(self.width * 0.75, self.height * 0.85);
    }
   
}

//3.实现方法

-(void)setIndexPath:(NSIndexPath *)indexPath count:(int)count
{
    if (indexPath.row == count - 1) {

        //6.当判断是最后一个cell就显示按钮
        self.startButton.hidden = NO;
        self.lognButton.hidden = NO;
        self.registerButton.hidden = NO;
    }else{//否则,隐藏
        
        self.startButton.hidden = YES;
        self.lognButton.hidden = YES;
        self.registerButton.hidden = YES;

    }

}

//8.实现点击按钮的监听方法
-(void)start
{
    //跳转到主框架界面
    //跳转方式:push modal
    //push只能用于导航控制器,所以不能使用
    //modal只能在控制器里面使用,但是现在处于cell中,所以也抛弃
    //如果使用modal,这个新特性会一直存在(新特性设置成窗口的根控制器),但是新特性只要展示完就应该销毁
    
    //所以可以使用切换窗口的根控制器进行跳转,这种方式会把新特性销毁掉,因为没有指针强引用了
    
    //9.创建tabBarVc
    CommonTabBarViewController *tabBarVc = [[CommonTabBarViewController alloc] init];
    
    //切换窗口的根控制器进行跳转
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVc;
    
//    //10.添加跳转动画 -- 使用转场核心动画
//    CATransition *anim = [CATransition animation];
//    
//    anim.type = @"rippleEffect";
//    anim.duration = 1;
//    //把动画添加到主窗口的layer上
//    [[UIApplication sharedApplication].keyWindow.layer addAnimation:anim forKey:nil];

    
    [[NSNotificationCenter defaultCenter] postNotificationName:ChangeRootViewControllerNotification object:self userInfo:@{@"message":@"1"}];
    
}

-(void)logn{

    SSLog(@"logn");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ChangeRootViewControllerNotification object:self userInfo:@{@"message":@"2"}];
}

-(void)registe{
    
    SSLog(@"registe");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ChangeRootViewControllerNotification object:self userInfo:@{@"message":@"3"}];}


@end
