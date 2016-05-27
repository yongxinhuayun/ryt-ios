//
//  EditingSignatureViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/25.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "EditingSignatureViewController.h"

#import <SVProgressHUD.h>
#import <MJExtension.h>

@interface EditingSignatureViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *signatureTF;

@end

@implementation EditingSignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpNavBar];
    
    
    [self setUpTextField];
    
    
    
}

-(void)setUpTextField{

    self.signatureTF.delegate = self;
    
    [self.signatureTF addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    
    if ([self.signatureTF.placeholder isEqualToString:@"请编辑个性签名"]) {
        
        self.signatureTF.text = self.singature;
    }

}

-(void)textChange
{
    if (self.signatureTF.text.length > 30) {
        
        [SVProgressHUD showErrorWithStatus:@"最多输入30个字"];
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
        _valueBlcok(self.signatureTF.text);
    }
    
    //参数
    UserMyModel *model = TakeLoginUserModel;
    NSString *userId = model.ID;
    NSString *type = @"13";
    NSString *content = self.signatureTF.text;
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"userId":userId,
                           @"type" : type,
                           @"content" : content
                           };
    NSString *url = @"editProfile.do";
    
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:url parameters:json showHUDView:nil andBlock:^(id respondObj) {
        
        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        NSLog(@"返回结果:%@",jsonStr);
        
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        
        UserMyModel *model = [UserMyModel mj_objectWithKeyValues:modelDict[@"userInfo"]];
        [MBProgressHUD hideHUD];
        if (model) {
            [MBProgressHUD showSuccess:@"修改个性签名成功"];
            //保存模型,赋值给控制器
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
        }
    }];
}


@end
