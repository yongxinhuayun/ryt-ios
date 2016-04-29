//
//  CycleView.m
//  test
//
//  Created by dongxin on 16/4/26.
//  Copyright © 2016年 lipengfei. All rights reserved.
//

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#import "CycleView.h"
#import "UIView+Frame.h"

@interface CycleView ()<UIScrollViewDelegate>
@property(nonatomic,assign) int prePage;
@property(nonatomic,assign) int currentPage;
@property(nonatomic,assign) CGFloat btnWidth;
@end
@implementation CycleView

- (void)drawRect:(CGRect)rect {
    // Drawing code
    //添加标题按钮
    [self addTitleButtons];
    
    [self addScrollView];
    
    [self addObserver:self forKeyPath:@"currentPage" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (self.prePage != self.currentPage) {
        UIButton * btn =[self.headerView viewWithTag:self.currentPage + 1000];
        [self moveLine:btn];
    }
}

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"currentPage"];
}

// 添加按钮显示标题
//    titleArray 标题
-(void)addTitleButtons{
    self.btnWidth = ScreenWidth / self.titleArray.count;
    CGFloat btnHeight = 30;
    for (int i = 0; i < self.titleArray.count; i++) {
        UIButton *titleBtn = [[UIButton alloc] init];
        titleBtn.frame = CGRectMake(self.btnWidth * i, 0, self.btnWidth, btnHeight);
        titleBtn.titleLabel.text = self.titleArray[i];
        [titleBtn setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [[titleBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [titleBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        titleBtn.tag = i + 1000;
         [titleBtn addTarget:self action:@selector(clickTitleBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.headerView addSubview:titleBtn];
    }
    [self addSubview:self.headerView];
    [self.headerView addSubview:self.line];
}
-(void)clickTitleBtn:(UIButton *)sender{
    
    self.prePage = self.currentPage;
    long i = sender.tag - 1000;
    [self moveLine:sender];
    // 点击按钮，滚动到对应视图
    [self.bottomScrollView setContentOffset:CGPointMake(i*ScreenWidth, 0) animated:YES];
    self.currentPage = (int)i;
    
}

-(void)moveLine:(UIButton *)sender{
    [UIView animateWithDuration:0.3 animations:^{
        self.line.x = sender.x;
    }];
}
-(void)addScrollView{
    [self addSubview:self.bottomScrollView];
}

//懒加载

-(UIScrollView *)bottomScrollView{
    if (!_bottomScrollView) {
        _bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, self.height - self.headerView.height)];
        _bottomScrollView.backgroundColor = [UIColor grayColor];

        _bottomScrollView.delegate = self;
        _bottomScrollView.contentSize = CGSizeMake(self.controllers.count * _bottomScrollView.width, self.height - self.headerView.height);
        _bottomScrollView.pagingEnabled = YES;
        _bottomScrollView.bounces = NO;
        _bottomScrollView.showsHorizontalScrollIndicator = NO;
        
    }
    return _bottomScrollView;
}
-(UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        CGFloat btnWidth = ScreenWidth / self.titleArray.count;
        CGFloat y = CGRectGetMaxY(self.headerView.frame);
        _line.frame = CGRectMake(0, y - 2, btnWidth, 2);
        _line.backgroundColor = [UIColor blackColor];
    }
    return _line;
}
-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.prePage = self.currentPage;;
    CGFloat x = scrollView.contentOffset.x;
    self.currentPage = x / ScreenWidth;
}
@end
