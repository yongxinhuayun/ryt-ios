////
////  ApplyforArtISTViewController.m
////  融易投
////
////  Created by efeiyi on 16/4/27.
////  Copyright © 2016年 dongxin. All rights reserved.
////
//
//#import "ApplyforArtistViewController.h"
//
//#import "UITableView+Improve.h"
//#import "UIImage+ReSize.h"
//#import "HeaderContent.h"
//#import "ImagePickerChooseView.h"
//#import "AGImagePickerController.h"
//#import "ShowImageViewController.h"
//
//#import <CommonCrypto/CommonDigest.h>
//#import <CommonCrypto/CommonHMAC.h>
//
//#import "ApplyHeaderView.h"
//
//@interface ApplyforArtistViewController ()<UITextViewDelegate,UIGestureRecognizerDelegate>
//
//@property (nonatomic,weak)UITextField *nameTextView;
//@property (nonatomic,weak)UITextField *phoneTextView;
//@property (nonatomic,weak)UILabel *identityCardInfoLabel;
//@property (nonatomic,weak)UILabel *pLabel;
//@property (nonatomic,weak)UIButton *addPictureButton;
//@property (nonatomic,weak)ImagePickerChooseView *IPCView;
//@property (nonatomic,strong)AGImagePickerController *imagePicker;
//
////imagePicker队列
//@property (nonatomic,strong)NSMutableArray *imagePickerArray;
//
//@end
//
//@implementation ApplyforArtistViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    [self setUpNavBar];
//
//    //添加手势,取消编辑状态
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyboardDismiss:)];
//    
//    tap.delegate = self;
//    
//    [self.view addGestureRecognizer:tap];
//    
//    //初始化头部输入框
//    [self initHeaderView];
//}
//
//// 设置导航条
//-(void)setUpNavBar
//{
//    //设置导航条标题
//    self.navigationItem.title = @"发布动态";
//    
//    
//    //设置导航条按钮
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    
//    [rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
//    
//    [rightButton setTitle:@"发送" forState:UIControlStateNormal];
//    
//    //运行程序,发现按钮没有出现导航条上面,因为没有设置尺寸
//    [rightButton sizeToFit];
//    
//    [rightButton addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//    
//    self.navigationItem.rightBarButtonItem = rightBarButton;
//    
//}
//
//-(void)send{
//    
//    
//    SSLog(@"发布");
//    
//    //    [self.navigationController popViewControllerAnimated:YES];
//}
//
//
//#define textViewHeight 100
//#define pictureHW (screenWidth - 5*padding)/4
//#define MaxImageCount 9
//#define deleImageWH 25 // 删除按钮的宽高
////大图特别耗内存，不能把大图存在数组里，存类型或者小图
//
//-(void)initHeaderView
//{
//    UIView *headView = [[UIView alloc] initWithFrame:CGRectZero];
//    
//    ApplyHeaderView *view1 = [ApplyHeaderView applyHeaderView];
//    view1.frame = CGRectMake(0, 0, SSScreenW, 167);
//    
//    [headView addSubview:view1];
//    
//    NSInteger imageCount = [self.imagePickerArray count];
//    for (NSInteger i = 0; i < imageCount; i++) {
//        UIImageView *pictureImageView = [[UIImageView alloc]initWithFrame:CGRectMake(padding + (i%4)*(pictureHW+padding), CGRectGetMaxY(view1.frame) + padding +(i/4)*(pictureHW+padding), pictureHW, pictureHW)];
//        //用作放大图片
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
//        [pictureImageView addGestureRecognizer:tap];
//        
//        //添加删除按钮
//        UIButton *dele = [UIButton buttonWithType:UIButtonTypeCustom];
//        dele.frame = CGRectMake(pictureHW - deleImageWH + 5, -10, deleImageWH, deleImageWH);
//        [dele setImage:[UIImage imageNamed:@"deletePhoto"] forState:UIControlStateNormal];
//        [dele addTarget:self action:@selector(deletePic:) forControlEvents:UIControlEventTouchUpInside];
//        [pictureImageView addSubview:dele];
//        
//        pictureImageView.tag = imageTag + i;
//        pictureImageView.userInteractionEnabled = YES;
//        pictureImageView.image = [UIImage imageWithCGImage:((ALAsset *)[self.imagePickerArray objectAtIndex:i]).thumbnail];
//        [headView addSubview:pictureImageView];
//    }
//    if (imageCount < MaxImageCount) {
//        UIButton *addPictureButton = [[UIButton alloc]initWithFrame:CGRectMake(padding + (imageCount%4)*(pictureHW+padding), CGRectGetMaxY(view1.frame) + padding +(imageCount/4)*(pictureHW+padding), pictureHW, pictureHW)];
//        [addPictureButton setBackgroundImage:[UIImage imageNamed:@"addPictures"] forState:UIControlStateNormal];
//        [addPictureButton addTarget:self action:@selector(addPicture) forControlEvents:UIControlEventTouchUpInside];
//        
//        [headView addSubview:addPictureButton];
//        self.addPictureButton = addPictureButton;
//    }
//    
//    NSInteger headViewHeight = 120 + (10 + pictureHW)*([self.imagePickerArray count]/4 + 1);
//    headView.frame = CGRectMake(0, 0, screenWidth, headViewHeight);
//    
//    self.view = headView;
//}
//
//#pragma mark - addPicture
//-(void)addPicture
//{
//    if ([self.identityCardInfoLabel isFirstResponder]) {
//        [self.identityCardInfoLabel resignFirstResponder];
//    }
//    
//    [self initImagePickerChooseView];
//}
//
//#pragma mark - gesture method
//-(void)tapImageView:(UITapGestureRecognizer *)tap
//{
//    self.navigationController.navigationBarHidden = YES;
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    ShowImageViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ShowImage"];
//    vc.clickTag = tap.view.tag;
//    vc.imageViews = self.imagePickerArray;
//    [self.navigationController pushViewController:vc animated:YES];
//}
//
//#pragma mark - keyboard method
//-(void)keyboardDismiss:(UITapGestureRecognizer *)tap
//{
//    [self.identityCardInfoLabel resignFirstResponder];
//}
//
//// 删除图片
//-(void)deletePic:(UIButton *)btn
//{
//    if ([(UIButton *)btn.superview isKindOfClass:[UIImageView class]]) {
//        UIImageView *imageView = (UIImageView *)(UIButton *)btn.superview;
//        [self.imagePickerArray removeObjectAtIndex:(imageView.tag - imageTag)];
//        [imageView removeFromSuperview];
//    }
//    [self initHeaderView];
//}
//
//#define IPCViewHeight 120
//-(void)initImagePickerChooseView
//{
//    ImagePickerChooseView *IPCView = [[ImagePickerChooseView alloc]initWithFrame:CGRectMake(0, screenHeight - 64, screenWidth, IPCViewHeight) andAboveView:self.view];
//    //IPCView.frame = CGRectMake(0, screenHeight - IPCViewHeight - 64, screenWidth, IPCViewHeight);
//    [IPCView setImagePickerBlock:^{
//        self.imagePicker = [[AGImagePickerController alloc] initWithFailureBlock:^(NSError *error) {
//            
//            if (error == nil)
//            {
//                [self dismissViewControllerAnimated:YES completion:^{}];
//                [self.IPCView disappear];
//            } else
//            {
//                NSLog(@"Error: %@", error);
//                
//                // Wait for the view controller to show first and hide it after that
//                double delayInSeconds = 0.5;
//                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                    [self dismissViewControllerAnimated:YES completion:^{}];
//                });
//            }
//            
//            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
//            
//        } andSuccessBlock:^(NSArray *info) {
//            [self.imagePickerArray addObjectsFromArray:info];
//            [self dismissViewControllerAnimated:YES completion:^{}];
//            [self.IPCView disappear];
//            [self initHeaderView];
//            
//            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
//        }];
//        
//        self.imagePicker.maximumNumberOfPhotosToBeSelected = 9 - [self.imagePickerArray count];
//        
//        [self presentViewController:self.imagePicker animated:YES completion:^{}];
//    }];
//    
//    [UIView animateWithDuration:0.25f animations:^{
//        IPCView.frame = CGRectMake(0, screenHeight - IPCViewHeight-64, screenWidth, IPCViewHeight);
//    } completion:^(BOOL finished) {
//    }];
//    [self.view addSubview:IPCView];
//    self.IPCView = IPCView;
//
//    
//    
//    [self.IPCView addImagePickerChooseView];
//}
//
//-(NSMutableArray *)imagePickerArray
//{
//    if (!_imagePickerArray) {
//        _imagePickerArray = [[NSMutableArray alloc]init];
//    }
//    return _imagePickerArray;
//}
//
//
//#pragma mark - UIGesture Delegate
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
//    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
//        return NO;
//    }
//    return  YES;
//}
//
//#pragma mark - Text View Delegate
//-(void)textViewDidChange:(UITextView *)textView
//{
//    self.pLabel.hidden = [textView.text length];
//}
//
//
//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    if ([@"\n" isEqualToString:text])
//    {
//        if ([self.identityCardInfoLabel.text length]) {
//            [self.identityCardInfoLabel resignFirstResponder];
//        }
//        else
//        {
//            return NO;
//        }
//    }
//    return YES;
//}
//
//
//
//
//
//
//
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//
//@end
