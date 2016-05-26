//
//  PrivateLetterController.m
//  融易投
//
//  Created by 李鹏飞 on 16/5/19.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import "PrivateLetterController.h"
#import "PrivateLetterViewController.h"
#import "CommonNavigationController.h"
#import "MessageResultModel.h"

#import "PrivateLetterCell.h"
#import "UserMyModel.h"
#import "PrivateLetterModel.h"
#import "UITableView+Improve.h"
#import <MJExtension.h>

@interface PrivateLetterController ()
@property(nonatomic,copy) NSString *lastPageNum;
@property(nonatomic,strong)NSMutableArray *letters;

@end

@implementation PrivateLetterController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self loadData];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [ self loadData];
    self.title = @"私信";
    
    [self.tableView setSeparatorColor:[UIColor colorWithRed:242.0 / 255.0 green:242.0 / 255.0 blue:242.0 / 255.0 alpha:1.0]];
    [self.tableView registerNib:[UINib nibWithNibName:@"PrivateLetterCell" bundle:nil] forCellReuseIdentifier:@"PrivateCell"];
    [UserMyModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return [NSDictionary dictionaryWithObject:@"id" forKey:@"ID"];
    }];
    [MessageResultModel mj_setupObjectClassInArray:^NSDictionary *{
        return [NSDictionary dictionaryWithObject:@"PrivateLetterModel" forKey:@"objectList"];
    }];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView improveTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLetterWindow:) name:@"PRIVATE_LETTER" object:nil];
}

-(void)updateLetterWindow:(NSNotification *)notification{
    // 接收到 用户的通知，修改
    [self loadData];
}
-(void)loadData{
    NSString * pageNum = @"1";
    self.lastPageNum = pageNum;
    NSString* pageSize = @"20";
    // 3.设置请求体
    NSDictionary *json = @{
                           @"userId" : [[RYTLoginManager shareInstance] takeUser].ID,
                           @"pageNum" : pageNum,
                           @"pageSize" :pageSize,
                           @"type"     :@"2"
                           };
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:@"information.do" parameters:json showHUDView:self.view andBlock:^(id respondObj) {
        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        NSLog(@"返回结果:%@",jsonStr);
        MessageResultModel *resultModel = [MessageResultModel mj_objectWithKeyValues:respondObj];
        self.letters = [NSMutableArray array];
//        self.letters = resultModel.objectList;
        [self.letters addObjectsFromArray:resultModel.objectList];
        //在主线程刷新UI数据
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.letters.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 15)];
//    headerView.backgroundColor = [UIColor whiteColor];
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.height, headerView.width, 1)];
//    line.backgroundColor = [UIColor colorWithRed:242.0 / 255.0 green:242.0 / 255.0 blue:242.0 / 255.0 alpha:1.0];
//    [headerView addSubview:line];
//    
//    return headerView;
//}

//static CGFloat Headerheight = 15;
//-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return Headerheight;
//}
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (scrollView == self.tableView)
//    {
//        CGFloat sectionHeaderHeight = Headerheight; //sectionHeaderHeight
//        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//        }
//    }
//}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PrivateLetterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PrivateCell" forIndexPath:indexPath];
    PrivateLetterModel *letterModel = self.letters[indexPath.row];
    cell.letterModel = letterModel;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PrivateLetterViewController *p = [[PrivateLetterViewController alloc] init];
   PrivateLetterModel *letter = self.letters[indexPath.row];
    p.userId = [[RYTLoginManager shareInstance] takeUser].ID;
    p.fromUserId = letter.fromUser.ID;
    [self.navigationController pushViewController:p animated:YES];
}

-(NSMutableArray *)letters{
    if (!_letters) {
        _letters = [NSMutableArray array];
    }
    return _letters;
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
