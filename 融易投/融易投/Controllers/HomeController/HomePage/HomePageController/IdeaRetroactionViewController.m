//
//  IdeaRetroactionViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/27.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "IdeaRetroactionViewController.h"

@interface IdeaRetroactionViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation IdeaRetroactionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setUpNavBar];
    
    //让textView在左上角出现光标
    self.automaticallyAdjustsScrollViewInsets = false;
    
    //设置placeholderLabel隐藏
    self.placeholderLabel.hidden = [self.textView.text length];
    
    //添加边框
    self.textView.layer.backgroundColor = [[UIColor clearColor] CGColor];
    
    self.textView.layer.borderColor = [[UIColor colorWithRed:226.0/255.0 green:226.0/255.0 blue:226.0/255.0 alpha:1.0]CGColor];
    
    self.textView.layer.borderWidth = 1.0;
    
    self.textView.layer.cornerRadius = 8.0f;
    
    [self.textView.layer setMasksToBounds:YES];

    
    self.textView.delegate = self;
}

// 设置导航条
-(void)setUpNavBar
{
    //设置导航条标题
    self.navigationItem.title = @"意见反馈";
    
    
    //设置导航条按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    [rightButton setTitle:@"发送" forState:UIControlStateNormal];
    
    //运行程序,发现按钮没有出现导航条上面,因为没有设置尺寸
    [rightButton sizeToFit];
    
    [rightButton addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
}

-(void)send{
    SSLog(@"111");
    
    //参数
    //有值代表着登录,没值就是游客
    UserMyModel *model = TakeLoginUserModel;
    NSString *userId = model.ID;
    
    NSString *content = self.textView.text;
    NSString *email = self.textField.text;
    NSString *timestamp = [MyMD5 timestamp];
    NSString *appkey = MD5key;
    
    NSString *signmsg = [NSString stringWithFormat:@"content=%@&timestamp=%@&userId=%@&key=%@",content,timestamp,userId,appkey];
    
    NSString *signmsgMD5 = [MyMD5 md5:signmsg];
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"userId":userId,
                           @"content" : content,
                           @"email" : email,
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    
    NSString *url = @"feedBack.do";
    
    [[HttpRequstTool shareInstance] handlerNetworkingPOSTRequstWithBaseUrl:url Parameters:json showHUDView:self.view success:^(id respondObj) {
//        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
//        NSLog(@"返回结果:%@",jsonStr);
        
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        
        [MBProgressHUD showSuccess:modelDict[@"resultMsg"]];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
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
