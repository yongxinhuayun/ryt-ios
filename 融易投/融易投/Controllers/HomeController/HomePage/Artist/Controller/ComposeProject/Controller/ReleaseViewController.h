//
//  ReleaseViewController.h
//  融易投
//
//  Created by dongxin on 16/4/13.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProjectDetailsModel,ArtWorkIdModel;

@interface ReleaseViewController : UITableViewController

@property (nonatomic, strong) ArtWorkIdModel *artWorkIdModel;

@property (nonatomic, strong) ProjectDetailsModel *projectModel;

@property (nonatomic, strong) NSMutableArray *imageArray;

@end
