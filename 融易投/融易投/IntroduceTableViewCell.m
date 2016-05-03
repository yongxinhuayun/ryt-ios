//
//  IntroduceTableViewCell.m
//  融易投
//
//  Created by dongxin on 16/5/3.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "IntroduceTableViewCell.h"
#import "ImageListViewCellCollectionViewCell.h"
@interface IntroduceTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@end
@implementation IntroduceTableViewCell

- (void)awakeFromNib {
    
    self.imageListView.delegate = self;
    self.imageListView.dataSource = self;
    self.imageListView.bounces = NO;
    [self.imageListView registerNib:[UINib nibWithNibName:@"ImageListViewCellCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ImageListCell"];
    self.flowLayout.itemSize = CGSizeMake(375, 200);
    long i = [self.imageListView numberOfItemsInSection:0];
//    self.imageListView.contentSize = CGSizeMake(375, self.flowLayout.itemSize.height * i);
    self.imageListView.height = self.flowLayout.itemSize.height * i;
    [self.imageListView sizeToFit];
    self.flowLayout.minimumInteritemSpacing = 0;
    self.flowLayout.minimumLineSpacing = 10;
    
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageListViewCellCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageListCell" forIndexPath:indexPath];
//    UICollectionViewCell *cell = [[UICollectionViewCell alloc] init];
    cell.backgroundColor = [UIColor redColor];
    return  cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
