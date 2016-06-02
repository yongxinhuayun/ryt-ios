//
//  AddImageCell.m
//  融易投
//
//  Created by 李鹏飞 on 16/6/2.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import "AddImageCell.h"

@implementation AddImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)clickAddImageBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(clickAddPhotoBtn)]) {
        [self.delegate clickAddPhotoBtn];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
