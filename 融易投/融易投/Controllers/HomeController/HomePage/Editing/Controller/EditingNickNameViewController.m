//
//  EditingNickNameViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/25.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "EditingNickNameViewController.h"

#import <SVProgressHUD.h>

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
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
