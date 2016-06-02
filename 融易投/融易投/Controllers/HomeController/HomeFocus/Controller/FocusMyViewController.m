//
//  FocusMyViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/29.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "FocusMyViewController.h"

#import "navTitleButton.h"

#import "FocusMyUserTableViewController.h"
#import "FocusMyArtistTableViewController.h"
#import "FocusBasicTableViewController.h"

@interface FocusMyViewController () <UIScrollViewDelegate>

/** 标题栏 */
@property (nonatomic, strong) UIView *titlesView;

/** 当前被点中的按钮 */
@property (nonatomic, weak) navTitleButton *clickedTitleButton;

/** 下划线 */
@property (nonatomic, strong) UIView *underlineView;

/** 用来显示所有子控制器view的scrollView */
@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation FocusMyViewController

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
    
    //默认选中第0个按钮,然后添加按钮对应的子控制器的view到scrollView中
    //为什么直接调用就行呢?
    //因为默认运行程序,默认scrollView的偏移量是0,所以计算的索引就是0,这样就添加了第一个子控制器的view
    [self addChildVcViewIntoScrollView];
    
    
}

/**
 * 添加子控制器
 */
- (void)setUpChildVcs
{
    [self addChildViewController:[[FocusMyArtistTableViewController alloc] init]];
    [self addChildViewController:[[FocusMyUserTableViewController alloc] init]];
    
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
    
    titlesView.frame = CGRectMake(0, SSNavMaxY, self.view.width, SSTitlesViewH);
    
    titlesView.backgroundColor = [UIColor whiteColor];
    //2.9 设置标题栏为半透明的
    //    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    
    [self.view addSubview:titlesView];
    
    //2.1 运行程序,发现titlesView添加到了tableView,但是我们这里需要时用不同的UIViewController,所以把之前的控制器UITableViewController改成UIViewController
    
    //2.2 添加所有的标题按钮
    [self setUpTitleButtons];
    
    //3. 添加底部的下划线
    [self setUpUnderline];
}

-(void)setUpTitleButtons
{
    NSArray *titles = @[@"艺术家", @"用户"];
    NSInteger index = titles.count;
    //2.3 设置按钮尺寸,要想拿到titlesView需设置成成员属性
    //    CGFloat titleButtonW = self.titlesView.width / 5;
    CGFloat titleButtonW = self.titlesView.width / index;
    CGFloat titleButtonH = self.titlesView.height;
    
    //2.4 遍历添加所有标题按钮
    for (NSInteger i = 0; i < index; i++) {
        
        navTitleButton *titleButton = [navTitleButton buttonWithType:UIButtonTypeCustom];
        
        //6.2给标题按钮绑定tag
        titleButton.tag= i;
        
        titleButton.frame = CGRectMake(i * titleButtonW, 0, titleButtonW, titleButtonH);
        
        //2.5 设置标题按钮的标题
        //因为标题是已知的,所以我们可以把标题保存到数组中,然后根据数组中的索引去一一对应各个按钮的标题
        //这样我们就不会把按钮的个数写死了
        [titleButton setTitle:titles[i] forState:UIControlStateNormal];
        [titleButton setTintColor:[UIColor whiteColor]];
        
        //2.6 设置按钮的选中状态
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //        titleButton.titleLabel.backgroundColor = BSRandomColor;
        
        [self.titlesView addSubview:titleButton];
        
    }
}

-(void)titleClick:(navTitleButton *)titleButton
{
    //2.7 先把之前选中的按钮记录一下,定义一个成员属性保存起来
    //因为选中有3中设置颜色的方法,我们这里使用选中状态来设置颜色
    //所以,为了方便,自定义按钮,把设置状态对应选中的颜色直接写在按钮中
    //修改按钮的类型
    self.clickedTitleButton.selected = NO;
    titleButton.selected = YES;
    self.clickedTitleButton = titleButton;
    
    //2.8 运行程序发现当我们长时间点击按钮的时候,颜色办成灰色了,所以我们应该取消高亮状态
    
    //3.2 点击按钮的时候,下划线跟这个点击按钮移动并且的宽度跟按钮的文字是一样宽度
    //我们要想设置宽度,需要先拿到按钮的文字标题,然后把下划线添加成成员属性
    
    //添加动画
    [UIView animateWithDuration:0.25 animations:^{
        
        //        self.underlineView.width = titleButton.titleLabel.width;
        //(这里在2边再加上5的间距,这里加的是10,因为文字是包裹的,所以系统会自动计算,2边就实现了各加5的长度)
        self.underlineView.width = titleButton.titleLabel.width + SSMargin;
        
        self.underlineView.centerX = titleButton.centerX;
        
        //3.3.1 打印下划线的宽度
        //        BSLog(@"%f",self.underlineView.width);
        
        //6. 当点击按钮的时候让子控制器的view也跟着移动,保证按钮的标题跟子控制器的view一致
        //6.1 获取按钮索引的方式一:
        /*
         NSInteger index = [self.titlesView.subviews indexOfObject:titleButton];
         
         //设置contentOffset
         self.scrollView.contentOffset = CGPointMake(index * BSScreenW, 0);
         */
        //6.2 获取按钮索引的方式二:
        //创建按钮的时候给titleButton添加tag,根据tag取出被点击的按钮
        NSInteger index = titleButton.tag;
        //设置contentOffset
        //        self.scrollView.contentOffset = CGPointMake(index * BSScreenW, 0);
        //这样设置contentOffset不好,因为如果我们直接修改,可能会把之前的覆盖掉,所以我们也跟设置frame一样,设置contentOffset
        CGPoint contentOffset = self.scrollView.contentOffset;
        contentOffset.x = index * SSScreenW; // 只修改x值,不要去修改y值
        //        contentOffset.y = 0; 注意:如果修改了y值,可能会把之前的覆盖掉
        self.scrollView.contentOffset = contentOffset;
    } completion:^(BOOL finished) {
        
        //8. 运行程序,我们发现5个子控制器是在程序一运行就加载完成了,这样做要是子控制器的cell很多,那么5个就更多了
        //所以这样造成 资源浪费.所以我们需要用到哪个控制器就加载哪个子控制器的view到UIScrollView
        
        //9. 把之前添加子控制器view到UIScrollView得代码注释掉,实现懒加载加载子控制器view
        [self addChildVcViewIntoScrollView];
        
    }];
}

-(void)addChildVcViewIntoScrollView
{
    //13. 取出对应位置的子控制器
    NSUInteger index = self.scrollView.contentOffset.x / self.scrollView.width;
    FocusBasicTableViewController *childVc = self.childViewControllers[index];
    childVc.userId = self.userId;

    if (childVc.view.superview) return;
    childVc.view.frame = self.scrollView.bounds;
    [self.scrollView addSubview:childVc.view];
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
    
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    
    navTitleButton *titleButton = self.titlesView.subviews[index];
    
    [self titleClick:titleButton];
}


// 添加底部的下划线
-(void)setUpUnderline
{
    //添加下划线
    UIView *underlineView = [[UIView alloc] init];
    underlineView.height = 2;
    //    underlineView.width = 100;
    underlineView.y = self.titlesView.height - underlineView.height;
    underlineView.x = 0;
    underlineView.backgroundColor = [UIColor blackColor];
    
    [self.titlesView addSubview:underlineView];
    
    //我们先拿到按钮,直接取第一个按钮就可以了
    navTitleButton *firstTitleButton = self.titlesView.subviews.firstObject;

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
    self.navigationItem.title = @"关注";
}

-(void)btnClick:(UIBarButtonItem *)barButton
{
    SSFunc;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
