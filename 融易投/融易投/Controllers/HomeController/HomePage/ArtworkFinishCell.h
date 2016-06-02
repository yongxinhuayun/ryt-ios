//
//  ArtworkFinishCell.h
//  融易投
//
//  Created by 李鹏飞 on 16/6/2.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ArtworkFinishCellDelegate <NSObject>

-(void)deleteImage:(NSIndexPath *)indexPath;

@end

@interface ArtworkFinishCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (weak,nonatomic) id<ArtworkFinishCellDelegate> delegate;

@end
