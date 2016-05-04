//
//  RecordTableViewController.m
//  融易投
//
//  Created by dongxin on 16/5/3.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "RecordTableViewController.h"
#import "RecordTableViewCell.h"

@interface RecordTableViewController ()


//-----------------------联动属性-----------------------
@property(nonatomic,assign) BOOL canScroll;
@property(nonatomic,assign) BOOL isfoot;
//-----------------------联动属性-----------------------

@end

@implementation RecordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isfoot = YES;
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"RecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"RecordCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordCell" forIndexPath:indexPath];
    if (indexPath.row <= 2) {
        NSLog(@"%@",indexPath);
        cell.topIcon.hidden = NO;
        cell.line.hidden = YES;
        cell.topIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"top%ld",(long)indexPath.row + 1]];
        if (indexPath.row == 2) {
            cell.line.hidden = NO;
        }
    }
    else{
        cell.topIcon.hidden = YES;
        cell.line.hidden = YES;
                NSLog(@"%@",indexPath);
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{
    return 60;
}

//-----------------------联动-----------------------
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    NSLog(@"(%f,%f)",offset.x,offset.y);
    UIScrollView *superView = (UIScrollView *)scrollView.superview.superview.superview.superview;
    NSLog(@"%@",[scrollView.superview class]);
    if (superView.contentOffset.y >= self.topHeight) {
        self.isfoot = NO;
        superView.contentOffset = CGPointMake(0, self.topHeight);
        scrollView.scrollEnabled = YES;
    }
    if (superView.contentOffset.y <= 0) {
        self.isfoot = YES;
        superView.contentOffset = CGPointMake(0, 0);
        scrollView.scrollEnabled = YES;
    }
    NSLog(@"bool = %d",self.isfoot);
    if (self.isfoot && scrollView.contentOffset.y > 0) {
        superView.contentOffset = CGPointMake(0, superView.contentOffset.y + scrollView.contentOffset.y);
        scrollView.contentOffset = CGPointZero;
    }
    if (!self.isfoot && scrollView.contentOffset.y < 0) {
        superView.contentOffset = CGPointMake(0, superView.contentOffset.y + scrollView.contentOffset.y);
        scrollView.contentOffset = CGPointZero;
    }
    NSLog(@"x= %f,y = %f",scrollView.contentOffset.x,scrollView.contentOffset.y);
}
//-----------------------联动-----------------------


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
