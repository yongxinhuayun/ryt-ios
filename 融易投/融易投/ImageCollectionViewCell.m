//
//  ImageCollectionViewCell.m
//  融易投
//
//  Created by efeiyi on 16/4/20.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "ImageCollectionViewCell.h"

#import "ImageModel.h"
#import "ArtworkAttachmentListModel.h"

#import "UIImageView+WebCache.h"

@interface ImageCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

@implementation ImageCollectionViewCell

- (void)awakeFromNib {

    
}

-(void)setModel:(ArtworkAttachmentListModel *)model{

    _model = model;
    
//    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.fileName] placeholderImage:nil];
    self.iconView.image = [UIImage imageNamed:@"headerImage"];
}

@end
