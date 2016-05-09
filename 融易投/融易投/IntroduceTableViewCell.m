//
//  IntroduceTableViewCell.m
//  融易投
//
//  Created by dongxin on 16/5/3.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "IntroduceTableViewCell.h"
#import "ImageListViewCellCollectionViewCell.h"
#import "ArtworkAttachmentListModel.h"
#import <UIImageView+WebCache.h>
@interface IntroduceTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@end
@implementation IntroduceTableViewCell

- (void)awakeFromNib {
    self.imageListView.delegate = self;
    self.imageListView.dataSource = self;
    self.imageListView.bounces = NO;
    [self.imageListView registerNib:[UINib nibWithNibName:@"ImageListViewCellCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"imageListCell"];
    self.flowLayout.itemSize = CGSizeMake(375, 200);
    long i = [self.imageListView numberOfItemsInSection:0];
//    self.imageListView.contentSize = CGSizeMake(375, self.flowLayout.itemSize.height * i);
    self.imageListView.height = self.flowLayout.itemSize.height * i +(i - 1)*10;
    [self.imageListView sizeToFit];
    self.flowLayout.minimumInteritemSpacing = 0;
    self.flowLayout.minimumLineSpacing = 10;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.imageListView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imgArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageListViewCellCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageListCell" forIndexPath:indexPath];
//    ImageListViewCellCollectionViewCell *cell = [[ImageListViewCellCollectionViewCell alloc] init];
    ArtworkAttachmentListModel *artModel = [[ArtworkAttachmentListModel alloc] init];
    artModel = self.imgArray[indexPath.row];
    NSString *urlStr = [[NSString stringWithFormat:@"%@",artModel.fileName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UIImageView *imgView = [[UIImageView alloc] init];
    [imgView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"defaultBackground"]];
    cell.imgView.image = imgView.image;
    return  cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)setImgArray:(NSMutableArray *)imgArray
{
    _imgArray = imgArray;
    NSInteger i = 0;
    CGFloat margin = 40;
    [self.imageListView reloadData];
}

-(void)imgArray:(NSMutableArray *)imgList{
    self.imgArray = imgList;
    [self.imageListView reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
