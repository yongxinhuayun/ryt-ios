//
//  ImageCollectionViewCell.h
//  融易投
//
//  Created by efeiyi on 16/4/20.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageModel,ArtworkAttachmentListModel;

@interface ImageCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) ArtworkAttachmentListModel *model;

@end
