//
//  FinanceHeader.m
//  融易投
//
//  Created by dongxin on 16/4/29.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "FinanceHeader.h"
#import "Progress.h"
#import "investorListCell.h"
#import "RecordModel.h"
#import "UserMyModel.h"

@interface FinanceHeader ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet UIView *investors;

@end

@implementation FinanceHeader

- (void)drawRect:(CGRect)rect {
    [self setupProgressView];
    [self setupCollectionView];

}
-(void)setupProgressView{
    Progress *progress = [[Progress alloc] init];
    progress.frame = self.progressView.bounds;
    self.progress = progress;
    [self.progressView addSubview:progress];
}
-(void)setupCollectionView{
    self.artworkInvestList.dataSource = self;
    self.artworkInvestList.delegate = self;
    self.artworkInvestList.backgroundColor = [UIColor whiteColor];
    self.artworkInvestList.showsHorizontalScrollIndicator = NO;
    [self.artworkInvestList registerNib:[UINib nibWithNibName:@"investorListCell" bundle:nil] forCellWithReuseIdentifier:@"investorCell"];
    self.artworkInvestList.pagingEnabled = YES;
    self.flowLayout.minimumInteritemSpacing = 10;
    self.flowLayout.minimumLineSpacing = 10;

    self.flowLayout.itemSize = CGSizeMake((SSScreenW - 10 *8) / 8,(SSScreenW - 10) / 8 );
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.artworkInvestors.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    investorListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"investorCell" forIndexPath:indexPath];
    RecordModel *model = self.artworkInvestors[indexPath.row];
    NSString *pricUrl = [[NSString stringWithString:model.creator.pictureUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [cell.userPicture ss_setHeader:[NSURL URLWithString:pricUrl]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",indexPath);
}
@end
