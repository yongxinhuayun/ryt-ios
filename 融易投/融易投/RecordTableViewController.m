//
//  RecordTableViewController.m
//  融易投
//
//  Created by dongxin on 16/5/3.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "RecordTableViewController.h"
#import "RecordTableViewCell.h"
#import "TopRecordTableViewCell.h"

@interface RecordTableViewController ()


//-----------------------联动属性-----------------------
@property(nonatomic,assign) BOOL isfoot;
//-----------------------联动属性-----------------------

@end

@implementation RecordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isfoot = YES;
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"RecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"RecordCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TopRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"TopRecordCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else{
        return 20;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   
    UIView *header = [[UIView alloc] init];
    header.frame = CGRectMake(0, 0, tableView.width, 80);
    header.backgroundColor = [UIColor whiteColor];
    
    
    if (section ==0) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"touzimingxingbang"]];
        imgView.center = header.center;
        imgView.height = 59;
        imgView.width = 266;
        [header addSubview:imgView];
    }else{
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zuixintouzijilu"]];
        imgView.center = header.center;
        imgView.height = 15;
                [header addSubview:imgView];
    }
    return header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TopRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopRecordCell" forIndexPath:indexPath];
        return cell;
    }else{
        RecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordCell"                                                                    forIndexPath:indexPath];
        if (indexPath.row <= 2) {
            NSLog(@"%@",indexPath);
            cell.topIcon.hidden = NO;
            cell.topIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"top%ld",(long)indexPath.row + 1]];
        }
        else{
            cell.topIcon.hidden = YES;
            NSLog(@"%@",indexPath);
        }
        return cell;
    }
    

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{
    if (indexPat.section ==0) {
        return 200;
    }else{
        return 60;
    }
}

//-----------------------联动-----------------------
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 80; //sectionHeaderHeight
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
    CGPoint offset = scrollView.contentOffset;
    NSLog(@"(%f,%f)",offset.x,offset.y);
    UIScrollView *superView = (UIScrollView *)scrollView.superview.superview.superview.superview;
    
            NSLog(@"topHeight = %f,y = %f",self.topHeight,superView.contentOffset.y);
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
    CGFloat zeroY = superView.contentOffset.y + scrollView.contentOffset.y;
    if (self.isfoot && scrollView.contentOffset.y > 0) {
     superView.contentOffset = CGPointMake(0, superView.contentOffset.y + scrollView.contentOffset.y);
        scrollView.contentOffset = CGPointZero;
    }
    if (!self.isfoot && scrollView.contentOffset.y < 0) {
        superView.contentOffset = CGPointMake(0, superView.contentOffset.y + scrollView.contentOffset.y);
    }
    if (superView.contentOffset.y < self.topHeight && scrollView.contentOffset.y >0) {
        superView.contentOffset = CGPointMake(0, superView.contentOffset.y + scrollView.contentOffset.y);
        scrollView.contentOffset = CGPointZero;
    }
    if(superView.contentOffset.y < self.topHeight && scrollView.contentOffset.y <= 0){
       CGFloat y = scrollView.contentOffset.y / 10;
        zeroY = superView.contentOffset.y + y;
        
        if (zeroY < 0) {
            [superView setContentOffset:CGPointZero animated:YES];
        }else{
            superView.contentOffset = CGPointMake(0, superView.contentOffset.y + y);
        }
//        if (scrollView.contentOffset.y > -10) {
//            if (zeroY < 0) {
//                [superView setContentOffset:CGPointZero animated:YES];
//            }else{
//                superView.contentOffset = CGPointMake(0, superView.contentOffset.y + scrollView.contentOffset.y);
//            }
//        }else{
//            superView.contentOffset = CGPointMake(0, superView.contentOffset.y + y);
//            if (scrollView.contentOffset.y <= -100) {
//                [superView setContentOffset:CGPointMake(0, superView.contentOffset.y + y) animated:YES];
//            }else
//            {
//                
//                if (zeroY < 0) {
//                    superView.contentOffset = CGPointZero;
//                }else{
//                 [superView setContentOffset:CGPointMake(0, superView.contentOffset.y + y) animated:YES];
//                }
//           
//            }
//        }
    }
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
