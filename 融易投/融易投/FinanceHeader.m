//
//  FinanceHeader.m
//  融易投
//
//  Created by dongxin on 16/4/29.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "FinanceHeader.h"
#import "Progress.h"

@interface FinanceHeader ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@end

@implementation FinanceHeader


- (void)drawRect:(CGRect)rect {

}
-(void)setupProgressView{
    Progress *progress = [[Progress alloc] init];
    progress.frame = self.progressView.bounds;
    //    p.progress = 0.8;
    self.progress = progress;
    [self.progressView addSubview:progress];
}
-(void)setupCollectionView{

    self.artworkInvestList.delegate = self;
    self.artworkInvestList.backgroundColor = [UIColor whiteColor];
    self.artworkInvestList.dataSource = self;
    self.flowLayout.minimumInteritemSpacing = 10;
    self.flowLayout.minimumLineSpacing = 10;
    self.flowLayout.itemSize = CGSizeMake(24, 24);
    self.artworkInvestList.showsHorizontalScrollIndicator = NO;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}

@end
