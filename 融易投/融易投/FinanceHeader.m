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
#import "MoreInvestorCell.h"
#import "RecordModel.h"
#import "UserMyModel.h"

@interface FinanceHeader ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet UIView *investors;
@property(nonatomic,assign) NSInteger investorCount;
@property(nonatomic,assign) BOOL isMax;

@end

@implementation FinanceHeader

- (void)drawRect:(CGRect)rect {
    [self setupProgressView];
    [self setupCollectionView];
    NSInteger count = (SSScreenW - 22 * 2) / 45;
    self.investorCount = count;

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
    [self.artworkInvestList registerNib:[UINib nibWithNibName:@"MoreInvestorCell" bundle:nil] forCellWithReuseIdentifier:@"MoreInvestorCell"];
    self.artworkInvestList.pagingEnabled = YES;
    self.flowLayout.minimumInteritemSpacing = 0;
    self.flowLayout.minimumLineSpacing = 6;

    self.flowLayout.itemSize = CGSizeMake(40 ,40);
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}
- (IBAction)clickUserIcon:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(jumpToUserHome)]) {
        [self.delegate jumpToUserHome];
    }
}



-(void)setInvestPeople:(NSMutableArray *)investPeople{
    _investPeople = investPeople;
    [self isMaxNum];
    [self.artworkInvestList reloadData];
}

-(void)isMaxNum{
    if (self.investPeople.count == 0) {
        self.isMax = NO;
    }
    if (self.investPeople.count > self.investorCount) {
        self.isMax = YES;
    }else{
        self.isMax = NO;
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.investPeople.count == 0) {
        return 0;
    }else if (self.investPeople.count > self.investorCount) {
        return self.investorCount;
    }else{
        return self.investPeople.count;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.isMax) {
        investorListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"investorCell" forIndexPath:indexPath];
        NSDictionary *model1 = self.investPeople[indexPath.row];
        
        NSString *pricUrl = [[NSString stringWithString:model1[@"pictureUrl"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [cell.userPicture ss_setHeader:[NSURL URLWithString:pricUrl]];
        return cell;
    }else{
        if (indexPath.row < self.investorCount - 1) {
            investorListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"investorCell" forIndexPath:indexPath];
            NSDictionary *model1 = self.investPeople[indexPath.row];
            
            NSString *pricUrl = [[NSString stringWithString:model1[@"pictureUrl"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [cell.userPicture ss_setHeader:[NSURL URLWithString:pricUrl]];
            return cell;
        }else{
            MoreInvestorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MoreInvestorCell" forIndexPath:indexPath];
            return cell;
        }
    }

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    // 如果点击的是用户的头像，跳转到用户的主页
    // 如果点击的是更多，滑动到顶部，并且选中投资记录
    if (!self.isMax) {
        NSDictionary *model1 = self.investPeople[indexPath.row];
        //拿到用户的ID，进行跳转
        if ([self.delegate respondsToSelector:@selector(jumpToUserHomeByIndexPath:)]) {
            [self.delegate jumpToUserHomeByIndexPath:indexPath];
        }
    }else{
        if (indexPath.row < self.investorCount - 1) {
            // 在这里，说明点击的是用户的头像
            if ([self.delegate respondsToSelector:@selector(jumpToUserHomeByIndexPath:)]) {
                [self.delegate jumpToUserHomeByIndexPath:indexPath];
            }
        }else{
            // 在这里，说明点击的是更多
            if ([self.delegate respondsToSelector:@selector(scrollToRecordAndTop)]) {
                [self.delegate scrollToRecordAndTop];
            }
        }
    }
}
@end
