//
//  investmentController.m
//  融易投
//
//  Created by 李鹏飞 on 16/5/25.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import "investmentController.h"

@interface investmentController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *TMoney;
@property (weak, nonatomic) IBOutlet UIButton *FMoeny;
@property (weak, nonatomic) IBOutlet UIButton *TenMoney;
@property (weak, nonatomic) IBOutlet UIButton *TEMoeny;
@property (weak, nonatomic) IBOutlet UIButton *EMoeny;
@property (weak, nonatomic) IBOutlet UIButton *AllMoeny;
// 当前被选中按钮
@property (nonnull,strong) UIButton *preButton;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UIButton *TZBtn;

@end

@implementation investmentController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self theSameButton];
    self.moneyTextField.delegate = self;
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.moneyTextField endEditing:YES];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //当用户选中编辑框的时候，即去选按钮的选中
    self.preButton.selected = NO;
    self.preButton.backgroundColor = [UIColor whiteColor];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
        NSString *money = [NSString stringWithFormat:@"%@%@",textField.text,string];
        [self.TZBtn setTitle:[NSString stringWithFormat:@"投资%@元",money] forState:(UIControlStateNormal)];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    //结束编辑前，判断用户输入的金额是否大于2元，如果小于2元，则提醒用户
    if (textField.text.length > 0) {
        NSInteger money = [textField.text integerValue];
        if (money < 2 && money > 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"投资最低2元" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [self.moneyTextField becomeFirstResponder];
        }
    }
}

// 投资
- (IBAction)clickTZBtn:(id)sender {
    NSLog(@"投资");
    // 获取用户投资金额
    if (self.moneyTextField.text.length > 0) {
        // 用户输入的金额
        NSInteger money = [self.moneyTextField.text integerValue];
        // 确保用户输入的金额大于2元
        if (money > 2) {
            // 如果用户输入的金额大于2元，再执行投资操作
            NSLog(@"用户投资了%ld元",money);
        }
    }else{
        NSInteger tag = self.preButton.tag - 2000;
        //用户没有全包
        NSInteger money = 0;
        if (tag < 999) {
            money = tag;
        }else{
            //用户全包
//            money = ...
        }
        NSLog(@"用户投资了%ld元",money);
    }
}

-(void)theSameButton{
    NSArray *btnArray = @[self.TMoney,self.FMoeny,self.TenMoney,self.TEMoeny,self.EMoeny,self.AllMoeny];
    for (UIButton *btn in btnArray) {
        [btn.layer setMasksToBounds:YES];
        [btn.layer setCornerRadius:8.0]; //设置矩圆角半径
        [btn.layer setBorderWidth:1.0];   //边框宽度
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0, 0, 0,1 });
        [btn.layer setBorderColor:colorref];//边框颜色
        // 选中文字颜色
        [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateSelected)];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        btn.selected = NO;
        if (btn == self.TMoney) {
            btn.selected = YES;
            btn.backgroundColor = [UIColor blackColor];
            self.preButton = btn;
        }
    }
}

-(void)clickBtn:(UIButton *)sender{
    if (!self.moneyTextField.text.length) {
        self.preButton.selected = NO;
        self.preButton.backgroundColor = [UIColor whiteColor];
        sender.selected = !sender.selected;
        if (sender.selected) {
            sender.backgroundColor = [UIColor blackColor];
        }else{
            sender.backgroundColor = [UIColor whiteColor];
        }
        NSInteger tag = sender.tag - 2000;
        if (tag < 999) {
            [self.TZBtn setTitle:[NSString stringWithFormat:@"投资%ld元",tag] forState:(UIControlStateNormal)];
        }else{
            [self.TZBtn setTitle:@"全包" forState:(UIControlStateNormal)];
        }
        self.preButton = sender;
    }
    [self.moneyTextField endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
