//
//  DetailCreationViewController.h
//  融易投
//
//  Created by dongxin on 16/4/28.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "BaseScrollViewController.h"
@class ArtworkModel;
@interface DetailCreationViewController : BaseScrollViewController

@property(nonatomic,strong)CycleView *cycleView;
@property(nonatomic,strong)NSMutableArray *titleArray;
@property(nonatomic,strong)NSMutableArray *controllersView;
@property(nonatomic,copy) NSString *artworkId;
//@property(nonatomic,copy)NSString *creationID;
@end
