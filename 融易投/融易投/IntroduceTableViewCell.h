//
//  IntroduceTableViewCell.h
//  融易投
//
//  Created by dongxin on 16/5/3.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntroduceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *imageListView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@end
