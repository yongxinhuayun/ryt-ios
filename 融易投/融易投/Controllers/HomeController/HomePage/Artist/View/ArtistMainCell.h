//
//  MyArtworkCell.h
//  融易投
//
//  Created by efeiyi on 16/4/25.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ArtworkListModel;

@interface ArtistMainCell : UITableViewCell

@property (nonatomic, strong) ArtworkListModel *model;

//对控制器就行实现按钮监听
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;

@end
