//
//  JianjieViewController.m
//  融易投
//
//  Created by efeiyi on 16/5/5.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "JianjieViewController.h"

#import "BianJiJianJieViewController.h"
#import "JianJieModel.h"
#import "PageInfoModel.h"

#import <MJExtension.h>

@interface JianjieViewController ()
@property (weak, nonatomic) IBOutlet UIView *WeiBianjiView;
@property (weak, nonatomic) IBOutlet UIView *YiBianJiView;
@property (weak, nonatomic) IBOutlet UIButton *bianjiBtn;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation JianjieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //判断是别人看自己,还是自己看自己
    //保存登录用户信息
    UserMyModel *model = TakeLoginUserModel;
    NSString *userId = model.ID;
    
    if (![self.userId isEqualToString:userId]) {
        
        self.YiBianJiView.hidden = NO;
        self.bianjiBtn.hidden = YES;
        self.WeiBianjiView.hidden = YES;
    }else {
    
        self.YiBianJiView.hidden = YES;
        self.bianjiBtn.hidden = NO;
        self.WeiBianjiView.hidden = NO;
    }

    [self loadData];
    
    //4.跟新我的界面的数据控制器
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMeViewDataController) name:UpdateJianJieViewDataControllerNotification object:nil];
}

-(void)updateMeViewDataController{
    
    //获取用户信息数据
    [self loadData];
}

-(void)loadData
{
    //参数
    NSString *userId = self.userId;
   
     NSString *url = @"intro.do";
    // 3.设置请求体
    NSDictionary *json = @{ 
                           @"userId":userId
                           };
    
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:url parameters:json showHUDView:nil andBlock:^(id respondObj) {
        
        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        NSLog(@"返回结果:%@",jsonStr);
        
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        
        JianJieModel *model = [JianJieModel mj_objectWithKeyValues:modelDict[@"userBrief"]];
        
        //在主线程刷新UI数据
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{

            if (model.content == nil) {
                
                self.YiBianJiView.hidden = YES;
                self.WeiBianjiView.hidden = NO;
            }else {
                
                self.YiBianJiView.hidden = NO;
                self.WeiBianjiView.hidden = YES;
                
                self.textView.text = model.content;
                self.textView.userInteractionEnabled = NO;
            }
        }];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (IBAction)bianJiJianJieBtnClick:(id)sender {
    
    BianJiJianJieViewController *vc = [[BianJiJianJieViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}




@end
