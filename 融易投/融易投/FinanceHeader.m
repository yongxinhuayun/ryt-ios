//
//  FinanceHeader.m
//  融易投
//
//  Created by dongxin on 16/4/29.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "FinanceHeader.h"

@interface FinanceHeader ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@end

@implementation FinanceHeader

- (void)drawRect:(CGRect)rect {
    self.artworkInvestList.delegate = self;
    self.artworkInvestList.backgroundColor = [UIColor whiteColor];
    self.artworkInvestList.dataSource = self;
//    self.userContent
//    CGFloat maxW = self.userContent.frame.size.width;
//    CGFloat maxH = self.userContent.frame.size.height;
//    CGFloat lineW = maxH / 3;
//    CGFloat lineH = 2;
//    
//    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, lineW, lineH)];
//    line1.backgroundColor = [UIColor redColor];
//    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, lineH, lineW)];
//    line2.backgroundColor = [UIColor redColor];
//    [self.userContent addSubview:line1];
//    [self.userContent addSubview:line2];
//    
//    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(maxW - lineW, maxH - lineH, lineW,lineH)];
//    line3.backgroundColor = [UIColor redColor];
//    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(maxW - lineH, maxH - lineW, lineH,lineW)];
//    line4.backgroundColor = [UIColor redColor];
//    [self.userContent addSubview:line3];
//    [self.userContent addSubview:line4];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 0;
}

@end
