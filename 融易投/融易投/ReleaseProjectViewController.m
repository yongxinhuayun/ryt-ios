//
//  ReleaseProjectViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/12.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "ReleaseProjectViewController.h"

#import "HMEmotionTextView.h"
#import "HMComposeViewController.h"


@interface ReleaseProjectViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet HMEmotionTextView *progectTextView;
@property (weak, nonatomic) IBOutlet UITextField *projectTextField;

@property (weak, nonatomic) IBOutlet UITextField *projecTotaltTextField;
@property (weak, nonatomic) IBOutlet UITextField *projectTimeTextField;

@end

@implementation ReleaseProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavBar];
    
    [self setupTextView];
    
    
    //设置图片能够点击
    //记住:UIImageView默认情况下是不能接收事件的,如果要执行点击方法,必须把默认的User interaction Enable 改成yes
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    
    [self.imageView addGestureRecognizer:tapGesture];
}

// 添加输入控件
- (void)setupTextView
{
    self.progectTextView.delegate = self;
    
    // 2.设置提醒文字（占位文字）
    self.progectTextView.placehoderColor = [UIColor blackColor];
     self.progectTextView.placehoder = @"输入项目介绍，100字以内";
    
    self.progectTextView.alwaysBounceVertical = YES;
    
    // 3.设置字体
   self.progectTextView.font = [UIFont systemFontOfSize:15];
}






-(void)tap {
    
    //创建UIAlertController是为了让用户去选择照片来源,拍照或者相册.
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:0];
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
    //设置选择图片的截取框
    //    imagePickerController.allowsEditing = YES;
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"从相册选取" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action)
                                   {
                                       //这里可以不写代码
                                   }];
    [self presentViewController:alertController animated:YES completion:nil];
    
    //用来判断来源 Xcode中的模拟器是没有拍摄功能的,当用模拟器的时候我们不需要把拍照功能加速
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [alertController addAction:photoAction];
    }
    
    else {
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
    }
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.progectTextView endEditing:YES];
    [self.projectTextField endEditing:YES];
    [self.projectTimeTextField endEditing:YES];
    [self.projecTotaltTextField endEditing:YES];
}


// 设置导航条
-(void)setUpNavBar
{
    //设置导航条标题
    self.navigationItem.title = @"发起新项目";
    

}
- (IBAction)nextBtnClick:(id)sender {
    
    // 弹出发微博控制器
    HMComposeViewController *compose = [[HMComposeViewController alloc] init];
    
    [self.navigationController pushViewController:compose animated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
