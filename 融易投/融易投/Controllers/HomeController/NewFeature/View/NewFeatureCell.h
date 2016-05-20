//
//  XMGNewFeatureCell.h
//  网易彩票
//
//  Created by 王梦思 on 15/10/30.
//  Copyright © 2015年 王梦思. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewFeatureCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;

//2.添加方法
-(void)setIndexPath:(NSIndexPath *)indexPath count:(int)count;

@end
