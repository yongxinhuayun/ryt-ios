//
//  EditingNickNameViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/25.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "EditingNickNameViewController.h"

#import <SVProgressHUD.h>
#import <MJExtension.h>

@interface EditingNickNameViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nickNameTF;

@end

@implementation EditingNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpNavBar];
   
    [self setUpTextField];
}

-(void)setUpTextField{

    
    self.nickNameTF.delegate = self;
    
    [self.nickNameTF addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    
    if ([self.nickNameTF.placeholder isEqualToString:@"请输入昵称"]) {
        
        self.nickNameTF.text = self.nickName;
    }
}

-(void)textChange
{
    if (self.nickNameTF.text.length > 10) {
        
        [SVProgressHUD showErrorWithStatus:@"最多输入10个字"];
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];

}

// 设置导航条
-(void)setUpNavBar
{
    //设置导航条标题
    self.navigationItem.title = @"编辑签名";
    
    
    //设置导航条按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    
    //运行程序,发现按钮没有出现导航条上面,因为没有设置尺寸
    [rightButton sizeToFit];
    
    [rightButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
}

-(void)save{
    
    // 传值:调用block
    if (_valueBlcok) {
        _valueBlcok(self.nickNameTF.text);
    }
    
    //参数
    UserMyModel *model = TakeLoginUserModel;
    NSString *userId = model.ID;
    NSString *type = @"11";
    NSString *content = self.nickNameTF.text;
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"userId":userId,
                           @"type" : type,
                           @"content" : content
                           };
    NSString *url = @"editProfile.do";
    
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:url parameters:json showHUDView:nil andBlock:^(id respondObj) {
        
//        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
//        NSLog(@"返回结果:%@",jsonStr);
        
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        
        UserMyModel *model = [UserMyModel mj_objectWithKeyValues:modelDict[@"userInfo"]];
        [MBProgressHUD hideHUD];
        if (model) {
            [MBProgressHUD showSuccess:@"修改昵称成功"];
            //发送通知,修改我的界面的数据
            [[NSNotificationCenter defaultCenter] postNotificationName:UpdateMeViewDataControllerNotification object:self];
            //保存模型,赋值给控制器
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
        }
    }];
}

@end
