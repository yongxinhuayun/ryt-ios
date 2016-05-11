//
//  imageViewController.h
//  类似微信发朋友圈图片
//
//  Created by CuiJianZhou on 16/2/2.
//  Copyright © 2016年 CJZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface imageViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *imageArray;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (strong, nonatomic) UIImage *image;
@property (assign, nonatomic) NSInteger imageCount;

@end
