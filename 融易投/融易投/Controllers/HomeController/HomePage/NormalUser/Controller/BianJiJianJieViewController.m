//
//  BianJiJianJieViewController.m
//  融易投
//
//  Created by efeiyi on 16/5/5.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "BianJiJianJieViewController.h"

#import "BianJiJianJieModel.h"
#import <MJExtension.h>
#import <SVProgressHUD.h>

@interface BianJiJianJieViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation BianJiJianJieViewController

-(void)viewWillAppear:(BOOL)animated{
    
    //偏移量
//    self.textView.contentInset = UIEdgeInsetsMake(0, 14, 0, 0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.placeholderLabel.text = @"还没有填写简介...\n简介示例说明:\n1982年生于山西\n2005年毕业于山西美术学院油画系\n现居北京\n个人作品展:\n2007年 \"看上去很美\" 周源个人作品展在北京798唯一艺术中心展出";
    
    //让textView在左上角出现光标
    self.automaticallyAdjustsScrollViewInsets = false;

    //设置placeholderLabel隐藏
    self.placeholderLabel.hidden = [self.textView.text length];
    
    self.textView.delegate = self;
    
    [self setUpNavBar];
}

// 设置导航条
-(void)setUpNavBar
{
    //设置导航条标题
//    self.navigationItem.title = @"钱包";
    
    //设置导航条按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    
    //运行程序,发现按钮没有出现导航条上面,因为没有设置尺寸
    [leftButton sizeToFit];
    
    [leftButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = leftBarButton;

    
    //设置导航条按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    
    //运行程序,发现按钮没有出现导航条上面,因为没有设置尺寸
    [rightButton sizeToFit];
    
    [rightButton addTarget:self action:@selector(publish) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
}

-(void)publish{

//    SSLog(@"publish");
    
    [self loadData];
    

}

-(void)loadData
{
    //参数
    UserMyModel *model = TakeLoginUserModel;
    NSString *userId = model.ID;
    NSString *type = @"2"; //1 签名 2 简介
    NSString *content = self.textView.text;
    
    NSString *timestamp = [MyMD5 timestamp];
    NSString *appkey = MD5key;
    
    NSString *signmsg = [NSString stringWithFormat:@"timestamp=%@&type=%@&userId=%@&key=%@",timestamp,type,userId,appkey];
    
    NSString *signmsgMD5 = [MyMD5 md5:signmsg];
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"userId":userId,
                           @"type":type,
                           @"content":content,
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    
    NSString *url = @"saveUserBrief.do";
    
    [[HttpRequstTool shareInstance] handlerNetworkingPOSTRequstWithBaseUrl:url Parameters:json showHUDView:self.view success:^(id respondObj) {
        
        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        NSLog(@"返回结果:%@",jsonStr);
        
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        
        BianJiJianJieModel *model = [BianJiJianJieModel mj_objectWithKeyValues:modelDict];
        
        
        [SVProgressHUD showInfoWithStatus:model.resultMsg];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        
        //在主线程刷新UI数据
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [SVProgressHUD dismiss];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        
    }];
}


-(void)cancel{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Text View Delegate
-(void)textViewDidChange:(UITextView *)textView
{
    self.placeholderLabel.hidden = [textView.text length];
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([@"\n" isEqualToString:text])
    {
        if ([self.textView.text length]) {
            [self.textView resignFirstResponder];
        }
        else
        {
            return NO;
        }
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
