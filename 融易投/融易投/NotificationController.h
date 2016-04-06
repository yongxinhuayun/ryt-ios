//
//  NotificationController.h
//  融易投
//
//  Created by dongxin on 16/4/6.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *NotificationTbaleView;

@end
