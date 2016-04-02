//
//  AuctionTableViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/2.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "AuctionTableViewController.h"

@interface AuctionTableViewController ()

@end

@implementation AuctionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //内边距的顶部应该是导航条的最大值64加上标题栏的高度
    //    UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
    //    self.tableView.contentInset = UIEdgeInsetsMake(BSNavMaxY + BSTitlesViewH, 0, 0, 0);
    //    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(BSNavMaxY + BSTitlesViewH, 0, 0, 0);
    //运行程序,发现系统帮我们自动调整scrollView的内边距,所以在精华控制器中设置automaticallyAdjustsScrollViewInsets = NO即可
    
    //设置tableView的内边距---实现全局穿透让tableView向上移动64 + 标题栏的高度35/向下移动tabBar的高度49
    //运行程序,发现底部一致到了tabBar的最下面,我们应该设置成子控制器的view的显示范围为tabBar的上面
    //同样,tabBar的高度我们也可能项目中都会用到,写在常量文件中
    self.tableView.contentInset = UIEdgeInsetsMake(SSStatusMaxH + SSTitlesViewH, 0, SSTabBarH, 0);
    //运行程序,发现滚动条上部分被标题栏和导航栏挡住了,这样会对会用造成一定的假象,造成对内容的多少判断不准确
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(SSStatusMaxH + SSTitlesViewH, 0, SSTabBarH, 0);

    
    //因为每个控制器都需要设置,所以把代码拷贝到其他控制器中
}

#pragma mark - 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //程序一运行就只加载一次背景颜色,如果不这么写,一滚动就会变颜色
    static UIColor *cellBgColor = nil;
    if (cellBgColor == nil) {
        cellBgColor = SSRandomColor;
    }
    
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = cellBgColor;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %zd", self.class, indexPath.row];
    
    return cell;
}
@end
