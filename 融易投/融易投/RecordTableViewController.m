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

@end

@implementation RecordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

// 滚动


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
