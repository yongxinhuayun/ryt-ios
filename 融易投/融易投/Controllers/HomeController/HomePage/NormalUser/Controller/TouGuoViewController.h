//
//  TouGuoViewController.h
//  融易投
//
//  Created by efeiyi on 16/5/4.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PageInfoModel;
@interface TouGuoViewController : UITableViewController

@property(nonatomic,assign) CGFloat topHeight;

@property (nonatomic ,strong)PageInfoModel *model;

@property (nonatomic ,strong)NSString *userId;

@end
