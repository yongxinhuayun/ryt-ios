//
//  XMGNewFeatureViewController.m
//  网易彩票
//
//  Created by 王梦思 on 15/10/30.
//  Copyright © 2015年 王梦思. All rights reserved.
//

#import "NewFeatureViewController.h"

#import "NewFeatureCell.h"

#import "UIView+Frame.h"

@interface NewFeatureViewController ()

@property(nonatomic, assign) CGFloat lastOffsetX;


@end

@implementation NewFeatureViewController

static NSString *ID = @"cell";

// 使用UICollectionView步骤
//1.设置流水布局
//2.UICollectionViewCell只能注册
//3.必须自定义UICollectionViewCell

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    self.collectionView.bounces = NO;
    
    //注册
    [self.collectionView registerClass:[NewFeatureCell class] forCellWithReuseIdentifier:ID];
    
    //8.开启分页模式
    self.collectionView.pagingEnabled = YES;
}

-(instancetype)init
{
    //设置流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    //设置cell的尺寸
    layout.itemSize = [UIScreen mainScreen].bounds.size;
    //设置每一行的间距
    layout.minimumLineSpacing = 0;
    //设置每个cell的间距
    layout.minimumInteritemSpacing = 0;
    
    //设置滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    return [self initWithCollectionViewLayout:layout];
    
}

#pragma mark - 数据源
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //7.创建cell
    NewFeatureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    //设置cell的图片
    NSString *imageName = [NSString stringWithFormat:@"guide%ld.jpg",indexPath.item + 1];
    
    cell.image = [UIImage imageNamed:imageName];
    
    [cell setIndexPath:indexPath  count:4];
    
    
    return cell;
    
    
}

@end
