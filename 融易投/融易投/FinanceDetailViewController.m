//
//  FinanceDetailViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/11.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "FinanceDetailViewController.h"

#import "navTitleButton.h"

#import "ProjectDetailViewController.h"
#import "ProjectScheduleViewController.h"
#import "UserCommentViewController.h"
#import<QuartzCore/QuartzCore.h>

@interface FinanceDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *DxTableView;
    UITableViewCell *cell;
    UIImageView *cellImageView;
    NSArray *_arr;
    
}
/** 标题栏 */
@property (nonatomic, strong) UIView *titlesView;

/** 当前被点中的按钮 */
@property (nonatomic, weak) navTitleButton *clickedTitleButton;

/** 下划线 */
@property (nonatomic, strong) UIView *underlineView;

/** 用来显示所有子控制器view的scrollView */
@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic,strong)NSArray *arrIndexPath;

@property (nonatomic,strong)UIScrollView *scrollCellView;
@end

@implementation FinanceDetailViewController

static NSString *ID1 = @"projectDetailCell";
static NSString *ID2 = @"projectScheduleCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    
    
    
    [self setUpNav];
    NSLog(@"");
    //    DxTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,self.view.bounds.size.width,self.view.bounds.size.height+1000) style:UITableViewStylePlain];
    //    DxTableView.delegate = self;
    //    DxTableView.dataSource =self;
    //    //DxTableView.backgroundColor = [UIColor grayColor];
    //    [self.view addSubview:DxTableView];
}

-(void)setUpNav
{
    //    UIButton *releaseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    [releaseButton setTitle:@"分享" forState:normal];
    //    [releaseButton addTarget:self action:@selector(releaseInfo:) forControlEvents:UIControlEventTouchUpInside];
    //    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
    //    self.navigationItem.rightBarButtonItem = releaseButtonItem;
    //
    //    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    [leftButton setTitle:@"返回" forState:normal];
    //    [leftButton addTarget:self action:@selector(leftInfo:) forControlEvents:UIControlEventTouchUpInside];
    //    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    //    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    self.navigationItem.title = @"项目详情";
}

-(void)releaseInfo:(id)send_id
{
    NSLog(@"详情界面的导航按钮");
}
-(void)leftInfo:(id)send_id
{
    NSLog(@"详情界面的导航按钮牛");
}

/**
 * 添加子控制器
 */
- (void)setUpChildVcs
{
    //    [self addChildViewController:[[ProjectDetailViewController alloc] init]];
    //    [self addChildViewController:[[ProjectScheduleViewController alloc] init]];
    //    [self addChildViewController:[[UserCommentViewController alloc] init]];
    
}

//添加scrollView
-(void)setUpScrollView
{
    
}

//添加标题栏
-(void)setUpTitlesView
{
    UIView *titlesView = [[UIView alloc] init];
    
    self.titlesView = titlesView;
    
    titlesView.frame = CGRectMake(0, SSStatusMaxH, self.view.width, SSTitlesViewH);
    
    //    titlesView.backgroundColor = [UIColor whiteColor];
    //2.9 设置标题栏为半透明的
    //    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    
    [cell addSubview:titlesView];
    
    //2.1 运行程序,发现titlesView添加到了tableView,但是我们这里需要时用不同的UIViewController,所以把之前的控制器UITableViewController改成UIViewController
    
    //2.2 添加所有的标题按钮
    [self setUpTitleButtons];
    
    //3. 添加底部的下划线
    [self setUpUnderline];
    
    
}

-(void)setUpTitleButtons
{
    NSArray *titles = @[@"项目详情", @"项目进度", @"用户评论"];
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
        
        // titleButton.titleLabel.backgroundColor = BSRandomColor;
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

-(void)btnClick:(UIBarButtonItem *)barButton
{
    SSFunc;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellID";
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    NSLog(@"=====%lu",indexPath.row);
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    if (indexPath.section == 1) {
        
        cell.textLabel.text = @"我爱你董鑫";
        
    }else if(indexPath.section == 0){
        cell.textLabel.text = @"董鑫我爱你";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        return 650;
    }else if (indexPath.section == 1){
        return 900;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] init];//我在sectionHeader中建立了一个View
    // view.frame= CGRectMake(0, 0, 320, 30);
    if (section ==0){               //判断为哪个section
        [self sectionView];
    }
    
    if (section == 1){       //这个和上一个一样，我没写全
        
        UITapGestureRecognizer *tapg1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sj_tap:)];
        UIButton *label1 =[[UIButton alloc] initWithFrame:CGRectMake(10, 0, 40, 30)];
        UIButton *label2 =[[UIButton alloc] initWithFrame:CGRectMake(60, 0,  50, 30)];
        UIButton *label3 =[[UIButton alloc] initWithFrame:CGRectMake(130, 0, 50, 30)];
        UIButton *label4 =[[UIButton alloc] initWithFrame:CGRectMake(200, 0, 50, 30)];
        UIButton *label5 =[[UIButton alloc] initWithFrame:CGRectMake(270, 0,  50, 30)];
        
        [label1 setTitle:@"1111" forState:UIControlStateNormal];
        [label2 setTitle:@"2222" forState:UIControlStateNormal];
        [label3 setTitle:@"3333" forState:UIControlStateNormal];
        [label4 setTitle:@"4444" forState:UIControlStateNormal];
        [label5 setTitle:@"5555" forState:UIControlStateNormal];
        
        [label1 addTarget:self action:@selector(lable1View) forControlEvents:UIControlEventTouchUpInside];
        [label2 addTarget:self action:@selector(lable2View) forControlEvents:UIControlEventTouchUpInside];
        [label3 addTarget:self action:@selector(lable3View) forControlEvents:UIControlEventTouchUpInside];
        [label4 addTarget:self action:@selector(lable4View) forControlEvents:UIControlEventTouchUpInside];
        [label5 addTarget:self action:@selector(lable5View) forControlEvents:UIControlEventTouchUpInside];
        
        [view addGestureRecognizer:tapg1];
        view.backgroundColor = [UIColor greenColor];
        
        [view addSubview:label1];
        [view addSubview:label2];
        [view addSubview:label3];
        [view addSubview:label4];
        [view addSubview:label5];
    }
    return view;
}

/**********************************  不要删除：根据文字的个数调整 label 的高度
 
 NSString *text =[[NSString alloc]init];
 text = @"输入文本内容";
 CGSize size = CGSizeMake(280, 180);
 UIFont *fonts = [UIFont systemFontOfSize:14.0];
 CGSize msgSie = [text sizeWithFont:fonts constrainedToSize:size lineBreakMode: NSLineBreakByCharWrapping];
 UILabel *textLabel  = [[UILabel alloc] init];
 [textLabel setFont:[UIFont boldSystemFontOfSize:14]];
 textLabel.frame = CGRectMake(20,70, 280,msgSie.height);
 textLabel.text = text;
 textLabel.lineBreakMode = NSLineBreakByCharWrapping;//实现文字多行显示
 textLabel.numberOfLines = 0;
 [self.view addSubview:textLabel];
 ********************************************************/

-(void)lable1View
{
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 900)];
    //view1.backgroundColor = [UIColor redColor];
    [cell addSubview:view1];
    UILabel *Introducelable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width, 30)];
    Introducelable.text = @"项目介绍";
    Introducelable.layer.borderWidth = 2;
    Introducelable.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [view1 addSubview:Introducelable];
    
    UILabel *lableIntroduce = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, self.view.bounds.size.width-20, 300)];
    lableIntroduce.layer.borderWidth = 2;
    lableIntroduce.layer.borderColor = [UIColor lightGrayColor].CGColor;
    lableIntroduce.text = @"苍茫之境，铜是人类最早使用的金属。早在史前时代，人们就开始采掘露天铜矿，拥有这样一款精巧绝伦的雕，若是自己把玩，则个人的品位和气质更加凸显，若是送于他人，也显得别出心裁，诚意十足！";
    lableIntroduce.numberOfLines=0;
    lableIntroduce.backgroundColor = [UIColor redColor];
    [view1 addSubview:lableIntroduce];
    
    UILabel *makeIntroduces = [[UILabel alloc]initWithFrame:CGRectMake(10, 380, self.view.bounds.size.width, 30)];
    makeIntroduces.text = @"制作说明";
    
    makeIntroduces.layer.borderWidth = 2;
    makeIntroduces.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    //makeIntroduces.backgroundColor = [UIColor blueColor];
    [view1 addSubview:makeIntroduces];
    
    UILabel *makeIntroduce = [[UILabel alloc]initWithFrame:CGRectMake(10, 410, self.view.bounds.size.width-20, 200)];
    makeIntroduce.text = @"苍茫之境，铜是人类最早使用的金属。早在史前时代，人们就开始采掘露天铜矿，拥有这样一款精巧绝伦的雕，若是自己把玩，则个人的品位和气质更加凸显，若是送于他人，也显得别出心裁，诚意十足！";
    makeIntroduce.numberOfLines=0;
    makeIntroduce.layer.borderWidth = 2;
    makeIntroduce.layer.borderColor = [UIColor lightGrayColor].CGColor;
    makeIntroduce.backgroundColor = [UIColor blueColor];
    [view1 addSubview:makeIntroduce];
    
    UILabel *makeDiploma = [[UILabel alloc]initWithFrame:CGRectMake(10, 670, self.view.bounds.size.width, 30)];
    //makeDiploma.backgroundColor = [UIColor yellowColor];
    
    makeDiploma.layer.borderWidth = 2;
    makeDiploma.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    makeDiploma.text = @"融资解惑";
    [view1 addSubview:makeDiploma];
    
    UILabel *makeDiplomas = [[UILabel alloc]initWithFrame:CGRectMake(10, 710, self.view.bounds.size.width-20, 300)];
    makeDiplomas.text = @"苍茫之境，铜是人类最早使用的金属。早在史前时代，人们就开始采掘露天铜矿，拥有这样一款精巧绝伦的雕，若是自己把玩，则个人的品位和气质更加凸显，若是送于他人，也显得别出心裁，诚意十足！";
    makeDiplomas.numberOfLines=0;
    makeDiplomas.layer.borderWidth = 2;
    makeDiplomas.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    makeDiplomas.backgroundColor = [UIColor yellowColor];
    [view1 addSubview:makeDiplomas];
    NSLog(@"1111");
}

-(void)lable2View
{
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 320)];
    view2.backgroundColor = [UIColor greenColor];
    [cell addSubview:view2];
    NSLog(@"2222");
}

-(void)lable3View
{
    UIView * view3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 320)];
    view3.backgroundColor = [UIColor blueColor];
    [cell addSubview:view3];
    
    NSLog(@"3333");
}
-(void)lable4View
{
    UIView *view4 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 320)];
    view4.backgroundColor = [UIColor brownColor];
    [cell addSubview:view4];
    NSLog(@"4444");
}
-(void)lable5View
{
    UIView *view5 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 320)];
    view5.backgroundColor = [UIColor grayColor];
    [cell addSubview:view5];
    NSLog(@"5555");
}
- (void)sj_tap:(UIGestureRecognizer*)sender //注意与平时的不同

{
    NSLog(@"dddddddd");
    
    
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"涿州";
    }else {
        return @"222";
    }
}
-(void)sectionView
{
    UIImageView *section0Image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height/2)];
    section0Image.backgroundColor = [UIColor redColor];
    [section0Image setImage:[UIImage imageNamed:@"1.png"]];
    [self.view addSubview:section0Image];
    
    UIImageView *IconIamge = [[UIImageView alloc]initWithFrame:CGRectMake(20,self.view.bounds.size.height/2+20,30,30)];
    IconIamge.backgroundColor = [UIColor redColor];
    [self.view addSubview:IconIamge];
    
    
    UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(70, self.view.bounds.size.height/2+20, 50, 30)];
    labelName.text = @"董鑫1233";
    labelName.backgroundColor = [UIColor redColor];
    [self.view addSubview:labelName];
    
    
    UILabel *labelExplaue = [[UILabel alloc]initWithFrame:CGRectMake(110, self.view.bounds.size.height/2+20, 200, 30)];
    labelExplaue.text = @"| 铜雕技艺国家级传承人";
    labelExplaue.backgroundColor = [UIColor greenColor];
    [self.view addSubview:labelExplaue];
    
    
    UILabel *lableDetailed = [[UILabel alloc]initWithFrame:CGRectMake(10, self.view.bounds.size.height/2,self.view.bounds.size.width-20,200)];
    lableDetailed.numberOfLines = 0;
    //lableDetailed.backgroundColor = [UIColor blueColor];
    lableDetailed.text =@"苍茫之境，铜是人类最早使用的金属。早在史前时代，人们就开始采掘露天铜矿，拥有这样一款精巧绝伦的雕，若是自己把玩，则个人的品位和气质更加凸显，若是送于他人，也显得别出心裁，诚意十足！";
    [self.view addSubview:lableDetailed];
    
    UILabel *numberInvestment = [[UILabel alloc]initWithFrame:CGRectMake(10, self.view.bounds.size.height/2+150, 50, 30)];
    numberInvestment.text = @"100";
    numberInvestment.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:numberInvestment];
    
    UILabel *numberInvestments = [[UILabel alloc]initWithFrame:CGRectMake(10, self.view.bounds.size.height/2+170, 70, 30)];
    numberInvestments.text = @"投资人数";
    numberInvestments.backgroundColor = [UIColor redColor];
    [self.view addSubview:numberInvestments];
    
    UILabel *remianHour = [[UILabel alloc]initWithFrame:CGRectMake(100, self.view.bounds.size.height/2+150, 70, 30)];
    remianHour.text = @"23时24分24秒";
    remianHour.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:remianHour];
    
    UILabel *remianHours = [[UILabel alloc]initWithFrame:CGRectMake(100, self.view.bounds.size.height/2+170, 70, 30)];
    remianHours.text = @"投资人数";
    remianHours.backgroundColor = [UIColor redColor];
    [self.view addSubview:remianHours];
    
    UILabel *remiaprojectScheduleHour = [[UILabel alloc]initWithFrame:CGRectMake(180, self.view.bounds.size.height/2+150, 70, 30)];
    remiaprojectScheduleHour.text = @"======";
    remiaprojectScheduleHour.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:remiaprojectScheduleHour];
    
    UILabel *remiaprojectScheduleHours = [[UILabel alloc]initWithFrame:CGRectMake(180, self.view.bounds.size.height/2+170, 70, 30)];
    remiaprojectScheduleHours.text = @"项目进度";
    remiaprojectScheduleHours.backgroundColor = [UIColor redColor];
    [self.view addSubview:remiaprojectScheduleHours];
    
    UILabel *goalMoneny = [[UILabel alloc]initWithFrame:CGRectMake(270, self.view.bounds.size.height/2+150, 70, 30)];
    goalMoneny.text = @"1000";
    goalMoneny.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:goalMoneny];
    
    UILabel *goalMonenys = [[UILabel alloc]initWithFrame:CGRectMake(270, self.view.bounds.size.height/2+170, 70, 30)];
    goalMonenys.text = @"目标金额";
    goalMonenys.backgroundColor = [UIColor redColor];
    [self.view addSubview:goalMonenys];
}
-(void)loadData
{
    
}


@end
