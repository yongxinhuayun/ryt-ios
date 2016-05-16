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

@interface FinanceHeader ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet UIView *investors;

@end

@implementation FinanceHeader

- (IBAction)a:(id)sender {
    NSLog(@"asdf");
}

- (void)drawRect:(CGRect)rect {
    [self setupProgressView];
    [self setupCollectionView];

}
-(void)setupProgressView{
    Progress *progress = [[Progress alloc] init];
    progress.frame = self.progressView.bounds;
    //    p.progress = 0.8;
    self.progress = progress;
    [self.progressView addSubview:progress];
}
-(void)setupCollectionView{
    self.artworkInvestList.dataSource = self;
    self.artworkInvestList.delegate = self;
    self.artworkInvestList.backgroundColor = [UIColor whiteColor];
    self.artworkInvestList.showsHorizontalScrollIndicator = NO;
    [self.artworkInvestList registerNib:[UINib nibWithNibName:@"investorListCell" bundle:nil] forCellWithReuseIdentifier:@"investorCell"];
    
    self.flowLayout.minimumInteritemSpacing = 10;
    self.flowLayout.minimumLineSpacing = 0;
    self.flowLayout.itemSize = CGSizeMake(40, 40);
    
//    for (int i = 0; i < 5; i ++) {
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame = CGRectMake(40 * i + 10, 0, 40, 40);
//        [btn setTitle:@"头像" forState:(UIControlStateNormal)];
//        [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
//        [btn addTarget:self action:@selector(clickBtn) forControlEvents:(UIControlEventTouchUpInside)];
//        [self.investors addSubview:btn];
//    }

}
-(void)clickBtn{
    NSLog(@"点击了头像");
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    investorListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"investorCell" forIndexPath:indexPath];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",indexPath);
}
@end
