//
//  CollectionViewCell.h
//  类似微信发朋友圈图片
//
//  Created by CuiJianZhou on 16/2/1.
//  Copyright © 2016年 CJZ. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol CollectionViewCellDelegate <NSObject>
//
//- (void)didImageViewClick;
//
//@end


@interface CollectionViewCell : UICollectionViewCell

- (id)initWithFrame:(CGRect)frame;

@property (strong, nonatomic) UIView *controllerView;
@property (strong, nonatomic) UIImage *image;
//@property (assign, nonatomic) id <CollectionViewCellDelegate>delegate;

@end
