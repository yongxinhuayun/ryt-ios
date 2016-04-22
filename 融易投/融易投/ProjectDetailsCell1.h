//
//  ProjectDetailsCell1.h
//  融易投
//
//  Created by efeiyi on 16/4/20.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProjectDetailsModel,ProjectDetailsResultModel;

@interface ProjectDetailsCell1 : UITableViewCell

@property (nonatomic, strong) ProjectDetailsResultModel *model;


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewFlowLayout;


@property (weak, nonatomic) IBOutlet UILabel *labelInfo1;
@property (weak, nonatomic) IBOutlet UILabel *labelInfo2;
@property (weak, nonatomic) IBOutlet UILabel *labelInfo3;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UIView *imagesView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@end
