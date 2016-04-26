//
//  AddressViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/26.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "AddressViewController.h"

@interface AddressViewController ()  <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *receiverTF;
@property (weak, nonatomic) IBOutlet UITextField *numberTF;

@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UITextField *addressDetailTF;


@end

@implementation AddressViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    [self setUpNavBar];
    
    self.addressTF.delegate = self;
}

// 设置导航条
-(void)setUpNavBar
{
    //设置导航条标题
    self.navigationItem.title = @"新增收货地址";
    
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
    
//    // 传值:调用block
//    if (_valueBlcok) {
//        _valueBlcok(self.nickNameTF.text);
//    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITextFieldDelegate
- (IBAction)selectedBtnClick:(UIButton *)sender {
    
     sender.selected = !sender.selected;
}

// 是否允许改变文本框的文字
// 是否允许用户输入
// 作用:拦截用户的输入
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return NO;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.receiverTF endEditing:YES];
    [self.numberTF endEditing:YES];
    [self.addressTF endEditing:YES];
    [self.addressDetailTF endEditing:YES];
}

@end
