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
