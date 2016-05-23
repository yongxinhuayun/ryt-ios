//
//  CommonNavigationController.h
//  融易投
//
//  Created by efeiyi on 16/3/30.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommonNavigationDelegate <NSObject>

@optional
-(void)beforeBack;

@end
@interface CommonNavigationController : UINavigationController

@property(nonatomic,weak) id<CommonNavigationDelegate> commonDelegate;
@end
