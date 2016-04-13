//
//  CollectionViewCell.m
//  类似微信发朋友圈图片
//
//  Created by CuiJianZhou on 16/2/1.
//  Copyright © 2016年 CJZ. All rights reserved.
//

#import "CollectionViewCell.h"

@interface CollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@end


@implementation CollectionViewCell

- (void)awakeFromNib {
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didImageView)];
//    self.imageV.userInteractionEnabled = YES;
//    [self.imageV addGestureRecognizer:tap];
    
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self = [[[NSBundle mainBundle]loadNibNamed:@"CollectionViewCell" owner:nil options:nil]lastObject];
    }
    
    return self;

}

//- (void)didImageView {
//    
//    NSLog(@"dfsfsd");
//    
//    if ([self.delegate respondsToSelector:@selector(didImageViewClick)]) {
//        
//        [self.delegate didImageViewClick];
//    }
//
//    
//}

//赋值
-(void)setImage:(UIImage *)image {
    
    _image = image;
    self.imageV.image = _image;
}


@end
