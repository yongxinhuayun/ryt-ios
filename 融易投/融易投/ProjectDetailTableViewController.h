//
//  ProjectDetailTableViewController.h
//  融易投
//
//  Created by dongxin on 16/5/3.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectDetailTableViewController : UITableViewController
@property(nonatomic,copy)NSString *artWorkId;
@property(nonatomic,assign) CGFloat topHeight;
@property(nonatomic,assign) BOOL isFinance;
@end
