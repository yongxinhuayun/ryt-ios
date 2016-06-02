//
//  ArtworkFinishCell.m
//  融易投
//
//  Created by 李鹏飞 on 16/6/2.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import "ArtworkFinishCell.h"


@implementation ArtworkFinishCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)deleteImage:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(deleteImage:)]) {
        [self.delegate deleteImage:self.indexPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
}

@end
