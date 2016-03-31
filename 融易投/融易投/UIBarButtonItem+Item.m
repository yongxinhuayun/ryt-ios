//
//  UIBarButtonItem+Item.m
//  融易投
//
//  Created by efeiyi on 16/3/30.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "UIBarButtonItem+Item.h"
//111
@implementation UIBarButtonItem (Item)

+ (UIBarButtonItem *)itemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(nullable id)target action:(nullable SEL)action
{
    //设置导航条按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highImage forState:UIControlStateHighlighted];
    
    //运行程序,发现按钮没有出现导航条上面,因为没有设置尺寸
    [button sizeToFit];
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return barButton;
    
    //改成类方法
    
}

+ (UIBarButtonItem *)itemWithImage:(UIImage *)image selImage:(UIImage *)selImage target:(nullable id)target action:(nullable SEL)action
{
    //设置导航条按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:selImage forState:UIControlStateSelected];
    
    //运行程序,发现按钮没有出现导航条上面,因为没有设置尺寸
    [button sizeToFit];
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return barButton;
    
    //改成类方法
    
}

+ (UIBarButtonItem *)backItemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(nullable id)target action:(nullable SEL)action norColor:(UIColor *)norColor highColor:(UIColor *)highColor title:(NSString *)title
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 设置标题
    [backButton setTitle:title forState:UIControlStateNormal];
    
    // 设置图片
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton setImage:highImage forState:UIControlStateHighlighted];
    
    // 设置标题颜色
    [backButton setTitleColor:norColor forState:UIControlStateNormal];
    [backButton setTitleColor:highColor forState:UIControlStateHighlighted];
    
    // 自适应尺寸:自动根据按钮图片和文字计算按钮大小
    [backButton sizeToFit];
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    //运行程序,发现按钮有点靠右,修改返回按钮的位置
    //设置按钮内容内边距
//    backButton.contentEdgeInsets = UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
//    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    //运行程序,发现右边的文字显示不出来了,所以我们可以让返回按钮直接往左边移动-20的位置
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);

    return [[UIBarButtonItem alloc] initWithCustomView:backButton];
}


@end
