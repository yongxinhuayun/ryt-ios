//
//  DiscoveryTableViewController.m
//  融易投
//
//  Created by efeiyi on 16/3/30.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "RankTableViewController.h"
#import "navTitleButton.h"

#import "InvestorTableViewController.h"
#import "ArtistTableViewController.h"

@interface RankTableViewController ()<UIScrollViewDelegate>

/** 标题栏 */
@property (nonatomic, strong) UIView *titlesView;
/** 当前被点中的按钮 */
@property (nonatomic, weak) navTitleButton *clickedTitleButton;
/** 下划线 */
@property (nonatomic, strong) UIView *underlineView;
/** 用来显示所有子控制器view的scrollView */
@property (nonatomic, weak) UIScrollView *scrollView;
@end

@implementation RankTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //把设置导航条的代码抽取到一个方法中
    //要想到设置统一控件的属性,应该抽取到一个方法中
    [self setUpNavBar];
    //4.添加所有子控制器
    [self setUpChildVcs];
    //设置精华界面的骨架
    //1. 添加scrollView
    [self setUpScrollView];
    //2. 添加标题栏
    [self setUpTitlesView];
    [self addChildVcViewIntoScrollView];
}

// 添加子控制器
- (void)setUpChildVcs
{
    [self addChildViewController:[[InvestorTableViewController alloc] init]];
    [self addChildViewController:[[ArtistTableViewController alloc] init]];
}

//添加scrollView
-(void)setUpScrollView
{
    //5.1 不要自动调整scrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    //创建scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    //    scrollView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    //4.4 设置分页
    scrollView.pagingEnabled = YES;
    //7.1 设置代理
    scrollView.delegate = self;
    //4.1 添加子控制器的view到scrollView中
    NSInteger count = self.childViewControllers.count;
    //4.3 设置scrollView的滚动范围
    scrollView.contentSize = CGSizeMake(count * scrollView.width, 0);
}

//添加标题栏
-(void)setUpTitlesView
{
    UIView *titlesView = [[UIView alloc] init];
    self.titlesView = titlesView;
    titlesView.frame = CGRectMake(0, 0, self.view.width, SSTitlesViewH);
    titlesView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titlesView];
    //2.2 添加所有的标题按钮
    [self setUpTitleButtons];
    //3. 添加底部的下划线
    [self setUpUnderline];
}

-(void)setUpTitleButtons
{
    NSArray *titles = @[@"投资者排行", @"艺术家排行"];
    NSInteger index = titles.count;
    //2.3 设置按钮尺寸,要想拿到titlesView需设置成成员属性
    //    CGFloat titleButtonW = self.titlesView.width / 5;
    CGFloat titleButtonW = self.titlesView.width / index;
    CGFloat titleButtonH = self.titlesView.height;
    
    //2.4 遍历添加所有标题按钮
    for (NSInteger i = 0; i < index; i++) {
        navTitleButton *titleButton = [navTitleButton buttonWithType:UIButtonTypeCustom];
        titleButton.tag= i;
        titleButton.frame = CGRectMake(i * titleButtonW, 0, titleButtonW, titleButtonH);
        [titleButton setTitle:titles[i] forState:UIControlStateNormal];
        [titleButton setTintColor:[UIColor whiteColor]];
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.titlesView addSubview:titleButton];
        
    }
}

-(void)titleClick:(navTitleButton *)titleButton
{
    self.clickedTitleButton.selected = NO;
    titleButton.selected = YES;
    self.clickedTitleButton = titleButton;
    //添加动画
    [UIView animateWithDuration:0.25 animations:^{
        self.underlineView.width = titleButton.titleLabel.width + SSMargin;
        self.underlineView.centerX = titleButton.centerX;
        NSInteger index = titleButton.tag;
        CGPoint contentOffset = self.scrollView.contentOffset;
        contentOffset.x = index * SSScreenW; // 只修改x值,不要去修改y值
        //        contentOffset.y = 0; 注意:如果修改了y值,可能会把之前的覆盖掉
        self.scrollView.contentOffset = contentOffset;
    } completion:^(BOOL finished) {
        [self addChildVcViewIntoScrollView];
    }];
}

-(void)addChildVcViewIntoScrollView
{
    /*
     //方法一:我们是传递按钮可同样能拿到按钮的索引
     //方法二:也可以直接计算scrollView的偏移量除以scrollView的宽度,就是按钮对应的tag值
     NSInteger index = self.scrollView.contentOffset.x / self.scrollView.width;
     
     UIViewController *childVC = self.childViewControllers[index];
     
     //这句话可写可不写,因为即使多次调用,子控制器的view也是同一个view,并不会创建多个view
     // 如果子控制器的view已经添加过了,就直接返回
     //    if (childVC.view.superview) return;
     //    if (childVC.view.window) return;
     //    if (childVC.isViewLoaded) return;
     if ([self.scrollView.subviews containsObject:childVC.view]) return;
     
     //4.2 设置frame
     childVC.view.x = i * self.scrollView.width;
     childVC.view.y = 0;
     childVC.view.width = self.scrollView.width;
     childVC.view.height = self.scrollView.height;
     
     [self.scrollView addSubview:childVC.view];
     */
    
    //13. 取出对应位置的子控制器
    NSUInteger index = self.scrollView.contentOffset.x / self.scrollView.width;
    UIViewController *childVc = self.childViewControllers[index];
    
    if (childVc.view.superview) return;
    
    // 13.5 设置子控制器view的frame
    childVc.view.frame = self.scrollView.bounds;
    
    // 添加子控制器view到scrollView
    [self.scrollView addSubview:childVc.view];
    
    //13.4
    //    childVc.view.frame = CGRectMake(self.scrollView.bounds.origin.x, self.scrollView.bounds.origin.y, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    
    //13.3
    //    childVc.view.x = self.scrollView.bounds.origin.x; //本质上scrollView的contentOffset偏移量是bounds在移动,所以这两个值是相等的
    //    childVc.view.y = self.scrollView.bounds.origin.y;
    //    childVc.view.width = self.scrollView.bounds.size.width;
    //    childVc.view.height = self.scrollView.bounds.size.height;
    
    //13.2
    //    childVc.view.x = self.scrollView.contentOffset.x;
    //    childVc.view.y = self.scrollView.contentOffset.y; //注意:scrollView没有y方法的偏移量,所以这里这样写,也没错
    //    childVc.view.width = self.scrollView.width;
    //    childVc.view.height = self.scrollView.height;
    
    //13.1
    //    childVc.view.y = 0;
    //    childVc.view.x = self.scrollView.contentOffset.x;
    //    childVc.view.width = self.scrollView.width;
    //    childVc.view.height = self.scrollView.height;
    
    
    
}

#pragma mark - <UIScrollViewDelegate>
/**
 * scrollView滚动完毕\静止的时候调用这个代理方法
 * 前提:用户拖拽scrollView, 手松开以后继续滚动
 */
//7. 监听子控制器view的滚动,当滚动完成的时候,对应的标题按钮也滚动对应的位置
//监听scrollView的滚动,设置代理,实现代理方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    /*
     NSInteger index = scrollView.contentOffset.x / scrollView.width;
     
     // 11.添加子控制器的view到UIScrollView
     //方式一:
     
     navTitleButton *titleButton = [self.titlesView viewWithTag:index];
     
     [self titleClick:titleButton];
     
     // 添加子控制器的view到UIScrollView
     [self addChildVcViewIntoScrollView];
     
     //这么写,有bug,当我们程序一加载默认选中的是第0个控制器view,当我们滚动scrollView到其他控制器时候创建新的控制器的view,但是当我们再次滚动第0个按钮对应的控制器的view时程序报错
     //因为我们这里传过来的是标题栏而不是按钮,当我们滚动第0个控制器的时候,默认第0个控制器view的tag为0,viewWithTag的底层实现是,先查找自己的tag是否满足,如果不满足再去遍历自的子控件,查找对应的tag.所以我们滚动第0个控制器时,返回的是标题栏本身,而不是标题按钮,所以提示错误,UIView中找不到setSelected:方法
     */
    /*
     -[UIView setSelected:]: unrecognized selector sent to instance 0x7fabf4278ca0
     *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[UIView setSelected:]: unrecognized selector sent to instance 0x7fabf4278ca0'
     */
    
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    
    navTitleButton *titleButton = self.titlesView.subviews[index];
    
    //方式二:因为滚动子控制器view相当于点击了标题按钮(标题按钮的监听方法中已经实现了滚动,所以我们可以直接调用按钮的监听方法)
    [self titleClick:titleButton];
    // 添加子控制器的view到UIScrollView
    //    [self addChildVcViewIntoScrollView]; 这句话可写可不写,标题按钮的监听方法中已经实现了将子控制器的view添加到UIScrollView
}

//11. 方式一这么写的错误解释
//这里按照先遍历出自己的子控件在遍历其他控件的顺序,模拟viewWithTag:方法的底层实现
//这里不清楚是先遍历出自己的子控件还是先遍历所有控件然后没有对用的tag时在遍历控件子控件
//@implementation UIView
//
//- (UIView *)viewWithTag:(NSInteger)tag
//{
//    // 如果自己的tag符合要求,返回自己
//    if (self.tag == tag) return self;
//
//    // 遍历子控件,直到找到符合要求的子控件为止
//    for (UIView *subview in self.subviews) {
//        UIView *tempView = [subview viewWithTag:tag];
//        if (tempView) return tempView;
//    }
//
//    // 没有符合要求的控件
//    return nil;
//}
//@end

// 添加底部的下划线
-(void)setUpUnderline
{
    //3.1 添加下划线
    UIView *underlineView = [[UIView alloc] init];
    underlineView.height = 2;
    //    underlineView.width = 100;
    underlineView.y = self.titlesView.height - underlineView.height;
    underlineView.x = 0;
    underlineView.backgroundColor = [UIColor blackColor];
    
    //3.2 运行程序我们发现能添加下划线.但是我们希望点击按钮的时候,下划线跟这个点击按钮移动并且的宽度跟按钮的文字是一样宽度
    
    [self.titlesView addSubview:underlineView];
    
    // 3.3 默认选中第一个按钮
    
    //我们先拿到按钮,直接取第一个按钮就可以了
    navTitleButton *firstTitleButton = self.titlesView.subviews.firstObject;
    // 切换按钮状态
    //    self.clickedTitleButton.selected = NO; 这句不写也没事,应该刚开始self.clickedTitleButton没有选中的按钮
    firstTitleButton.selected = YES; // 新点击的按钮
    self.clickedTitleButton = firstTitleButton;
    
    // 下划线的宽度 == 按钮文字的宽度
    [firstTitleButton.titleLabel sizeToFit]; // 通过这句代码计算按钮内部label的宽度
    underlineView.width = firstTitleButton.titleLabel.width + SSMargin;
    // 下划线的位置
    underlineView.centerX = firstTitleButton.centerX;
    
    self.underlineView = underlineView;
}

// 设置导航条
-(void)setUpNavBar
{
    self.navigationItem.title = @"排行";
}

-(void)btnClick:(UIBarButtonItem *)barButton
{
    SSFunc;
}

@end
