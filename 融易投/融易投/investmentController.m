//
//  investmentController.m
//  融易投
//
//  Created by 李鹏飞 on 16/5/25.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import "investmentController.h"
#import "HttpRequstTool.h"
#import "ResultModel.h"
#import <MJExtension.h>
#import "PointView.h"
#import <MBProgressHUD.h>

@interface investmentController ()<UITextFieldDelegate,PointViewDelegate>
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
// 蒙版
@property(nonatomic,strong) UIView *maskView;
@property (nonatomic,strong) PointView *pointView;
// 项目需要融资的总金额

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
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = [NSString stringWithFormat:@"投资最低2元"];
            [hud hide:YES afterDelay:2];
            [self.moneyTextField becomeFirstResponder];
        }
    }
}

// 投资
- (IBAction)clickTZBtn:(id)sender {
    NSLog(@"投资");
    // 如果输入框中有数字，优先选取用户输入的投资金额
    if (self.moneyTextField.text.length > 0) {
        // 用户输入的金额
        NSInteger money = [self.moneyTextField.text integerValue];
        // 确保用户输入的金额大于2元
        if (money > 2) {
            // 如果用户输入的金额大于2元，开始投资
            [self TZ:money];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = [NSString stringWithFormat:@"投资最低2元"];
            [hud hide:YES afterDelay:2];
        }
    }else{
        NSInteger tag = self.preButton.tag - 2000;
        //用户没有全包
        NSInteger money = 0;
        if (tag < 999) {
            money = tag;
        }else{
            //用户全包
            money = self.investGoalMoney;
        }
        NSLog(@"用户投资了%ld元",money);
        [self TZ:money];
    }
}



/*
 * 投资，返回状态码
 * 100013 : 您好，你最多投资X元
 * 100014 : 投资金额最多X元
 * 100015 : 账户余额不足，请充值
 * 100016 : 该项目已经下架或已被冻结
 * 100017 : 非常抱歉，该项目目前不能投资
 */
-(void)TZ:(NSInteger)money{
    NSInteger price = money;
    NSString *userId = self.userId;
    NSString *artworkId = self.artworkId;
    //判断用户余额是否充足
    NSDictionary *json = @{
                           @"price" : [NSString stringWithFormat:@"%ld",price],
                           @"userId" : userId,
                           @"artworkId" : artworkId
                           };
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:@"artworkInvest.do" parameters:json showHUDView:self.view andBlock:^(id respondObj) {
        NSString *jsonStr = [[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonStr);
        ResultModel *result = [ResultModel mj_objectWithKeyValues:respondObj];
        NSInteger resultCode = result.resultCode.integerValue;
        if (resultCode == 0) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = [NSString stringWithFormat:@"投资成功"];
            [hud hide:YES afterDelay:2];
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TZSUCESS" object:nil];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = [NSString stringWithFormat:@"%@",result.resultMsg];
            [hud hide:YES afterDelay:2];

        }
        
    }];
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


-(UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.frame = [UIScreen mainScreen].bounds;
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.5;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchupMaskView)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

-(PointView *)pointView{
    if (!_pointView) {
        _pointView = [[[NSBundle mainBundle] loadNibNamed:@"PointView" owner:nil options:nil] lastObject];
        _pointView.center = [UIApplication sharedApplication].keyWindow.center;
        _pointView.width = 223;
        _pointView.height = 161;
        _pointView.delegate = self;
    }
    return _pointView;
}

-(void)touchupMaskView{
    [self removeMaskViewFromWindow];
}

// 点击充值按钮
-(void)clickRecharge{
    // 用户点击了充值按钮，跳转到充值界面
}

// 点击关闭按钮
-(void)clickClose{
    //移除蒙版
    [self removeMaskViewFromWindow];
}

-(void)removeMaskViewFromWindow{
    [UIView animateWithDuration:0.2 animations:^{
        self.maskView.alpha = 0;
        self.pointView.alpha = 0;
    } completion:^(BOOL finished) {
        self.maskView.alpha = 0.5;
        self.pointView.alpha = 1;
        [self.maskView removeFromSuperview];
        [self.pointView removeFromSuperview];
    }];
}

-(void)addMaskViewToWindow{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.pointView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
