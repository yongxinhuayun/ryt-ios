//
//  MessageTableViewController.m
//  融易投
//
//  Created by efeiyi on 16/3/30.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "MessageTableViewController.h"
#import "CommentsTableController.h"
#import "NotificationController.h"
#import "PrivateLetterViewController.h"
#import "PrivateLetterController.h"

#import "MessageModel.h"
#import <MJExtension.h>

@interface MessageTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tzBridge;
@property (weak, nonatomic) IBOutlet UILabel *plBridge;
@property (weak, nonatomic) IBOutlet UILabel *sxBridge;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tzNumConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *plNumConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sxNumConstraint;

@property(nonatomic,strong) MessageModel *messageModel;

@end

@implementation MessageTableViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadDataToController];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
}

// 设置导航条
-(void)setUpNavBar{
    //设置导航条标题
    self.navigationItem.title = @"消息";
    [self.tableView setContentInset:UIEdgeInsetsMake(-25, 0, 0, 0)];
    [self.tableView setSeparatorColor:[UIColor colorWithRed:224.0 / 255.0 green:225.0 / 255 blue:226.0 / 255.0 alpha:1.0]];
    
}

-(void)loadDataToController{
    UserMyModel *model = TakeLoginUserModel;
    NSString *userId = model.ID;
    if (userId) {
        NSDictionary *json = @{
                               @"userId": userId
                               };
        [[HttpRequstTool shareInstance] loadData:POST serverUrl:@"informationList.do" parameters:json showHUDView:self.view andBlock:^(id respondObj) {
            //        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
            //        NSLog(@"返回结果:%@",jsonStr);
            MessageModel *model = [MessageModel mj_objectWithKeyValues:respondObj];
            self.messageModel = model;
            [self isHidden];
            [self.tableView reloadData];
        }];
    }

}

-(void)isHidden{
    if (self.messageModel.noticeNum == 0) {
        self.tzBridge.hidden = YES;
    }else{
        self.tzBridge.hidden = NO;
        self.tzBridge.text = [NSString stringWithFormat:@"%ld",self.messageModel.noticeNum];
        if (self.messageModel.noticeNum > 99) {
            self.tzNumConstraint.constant = 24;
            self.tzBridge.text = @"99+";
        }else if (self.messageModel.noticeNum > 9){
            self.tzNumConstraint.constant = 18;
        }
    }
    if (self.messageModel.commentNum == 0) {
        self.plBridge.hidden = YES;
    }else{
        self.plBridge.hidden = NO;
        self.plBridge.text =[NSString stringWithFormat:@"%ld",self.messageModel.commentNum];
        if (self.messageModel.commentNum > 99) {
            self.plNumConstraint.constant = 24;
            self.plBridge.text = @"99+";
        }else if (self.messageModel.commentNum > 9){
            self.plNumConstraint.constant = 18;
        }
    }
    if (self.messageModel.messageNum == 0) {
        self.sxBridge.hidden = YES;
    }else{
        self.sxBridge.hidden = NO;
        self.sxBridge.text = [NSString stringWithFormat:@"%ld",self.messageModel.messageNum];
        if (self.messageModel.messageNum > 99) {
            self.sxNumConstraint.constant = 24;
            self.sxBridge.text = @"99+";
        }else if (self.messageModel.messageNum > 9){
            self.sxNumConstraint.constant = 18;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[RYTLoginManager shareInstance] showLoginViewIfNeed]) {
    }else{
        if (indexPath.section == 0) {
            
            NotificationController *NoController = [NotificationController new];
            [self.navigationController pushViewController:NoController animated:YES];
            
        } else if (indexPath.section == 1) {
            
            CommentsTableController *commentsController = [CommentsTableController new];
            [self.navigationController pushViewController:commentsController animated:YES];
            
        } else if (indexPath.section == 2) {
            
            PrivateLetterController *privateLetterVC = [[PrivateLetterController alloc] init];
            [self.navigationController pushViewController:privateLetterVC animated:YES];
        }
    }

}

//懒加载
-(MessageModel *)messageModel{
    if (!_messageModel) {
        _messageModel = [[MessageModel alloc] init];
    }
    return _messageModel;
}
@end
