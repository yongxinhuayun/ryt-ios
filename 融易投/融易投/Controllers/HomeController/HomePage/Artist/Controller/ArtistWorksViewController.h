//
//  ArtistWorksViewController.h
//  融易投
//
//  Created by efeiyi on 16/5/6.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PageInfoModel;
@interface ArtistWorksViewController : UITableViewController

@property(nonatomic,assign) CGFloat topHeight;

@property (nonatomic ,strong)PageInfoModel *userModel;
@end
