//
//  MyArtworkCell.h
//  融易投
//
//  Created by efeiyi on 16/4/25.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ArtistMainCellDelegate <NSObject>
@required
-(void)PostDynamic:(UIButton *)sender indexPath:(NSIndexPath *)indexPath;
-(void)FinishCreation:(UIButton *)sender indexPath:(NSIndexPath *)indexPath;
@end

@class ArtworkListModel;

@interface ArtistMainCell : UITableViewCell

@property (nonatomic, strong) ArtworkListModel *model;

//对控制器就行实现按钮监听
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property(weak ,nonatomic) id<ArtistMainCellDelegate>delegate;
@end
