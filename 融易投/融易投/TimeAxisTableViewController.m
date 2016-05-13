//
//  TimeAxisTableViewController.m
//  融易投
//
//  Created by lipengfei on 16/5/12.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import "TimeAxisTableViewController.h"
#import "FinanceTimeCell.h"
#import "CreationTimeCell.h"
#import "PMTimeCell.h"

NSString * const financeCell = @"financeCell";
NSString * const creation = @"creationCell";
NSString * const pmCell = @"pmCell";
@interface TimeAxisTableViewController ()

@end

@implementation TimeAxisTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"FinanceTimeCell" bundle:nil] forCellReuseIdentifier:financeCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"CreationTimeCell" bundle:nil] forCellReuseIdentifier:creation];
    [self.tableView registerNib:[UINib nibWithNibName:@"PMTimeCell" bundle:nil] forCellReuseIdentifier:pmCell];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        FinanceTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:financeCell];
        return cell;
    }else if (indexPath.section == 1){
        CreationTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:creation];
        return cell;
    }else {
        PMTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:pmCell];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
    

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
