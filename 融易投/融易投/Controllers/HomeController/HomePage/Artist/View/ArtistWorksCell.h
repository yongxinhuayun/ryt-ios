//
//  ArtistWorksCell.h
//  融易投
//
//  Created by efeiyi on 16/5/6.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MasterWorkListModel;

@interface ArtistWorksCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *shanchuBtn;

@property (nonatomic, strong) MasterWorkListModel *model;

@end
