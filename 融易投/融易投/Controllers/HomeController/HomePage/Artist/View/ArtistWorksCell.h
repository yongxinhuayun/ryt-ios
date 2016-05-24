//
//  ArtistWorksCell.h
//  融易投
//
//  Created by efeiyi on 16/5/6.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MasterWorkListModel,PageInfoModel;

@interface ArtistWorksCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *shanchuBtn;

@property (nonatomic, strong) MasterWorkListModel *model;

//根据此模型判断是否是自己看自己
@property (nonatomic ,strong)PageInfoModel *userModel;

@end
