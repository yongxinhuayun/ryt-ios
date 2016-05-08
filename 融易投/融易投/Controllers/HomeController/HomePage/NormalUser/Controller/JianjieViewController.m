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

#import <MJExtension.h>

@interface JianjieViewController ()
@property (weak, nonatomic) IBOutlet UIView *WeiBianjiView;
@property (weak, nonatomic) IBOutlet UIView *YiBianJiView;
@property (weak, nonatomic) IBOutlet UITextView *textView;



@end

@implementation JianjieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self loadData];
}

-(void)loadData
{
    //参数
    NSString *userId = @"ieatht97wfw30hfd";
   
    NSString *timestamp = [MyMD5 timestamp];
    NSString *appkey = MD5key;
    
    NSString *signmsg = [NSString stringWithFormat:@"timestamp=%@&userId=%@&key=%@",timestamp,userId,appkey];
    NSLog(@"%@",signmsg);
    
    NSString *signmsgMD5 = [MyMD5 md5:signmsg];
    
    NSLog(@"signmsgMD5=%@",signmsgMD5);
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"userId":userId,
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    
    NSString *url = @"http://192.168.1.41:8080/app/intro.do";
    
    [[HttpRequstTool shareInstance] handlerNetworkingPOSTRequstWithServerUrl:url Parameters:json showHUDView:self.view success:^(id respondObj) {
        
//        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
//        NSLog(@"返回结果:%@",jsonStr);
        
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        
        JianJieModel *model = [JianJieModel mj_objectWithKeyValues:modelDict];
        
        if (model.userBrief == nil) {
            
            self.YiBianJiView.hidden = YES;
            self.WeiBianjiView.hidden = NO;
        }else {
        
            self.YiBianJiView.hidden = NO;
            self.WeiBianjiView.hidden = YES;
            
            self.textView.text = model.userBrief;
        }
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
