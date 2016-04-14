//
//  TestViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/13.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "TestViewController.h"

#import "ReleaseViewController.h"
#import "UITableView+Improve.h"
#import "UIImage+ReSize.h"
#import "HeaderContent.h"
#import "ImagePickerChooseView.h"
#import "AGImagePickerController.h"
#import "ShowImageViewController.h"


#import "HMEmotionTextView.h"
#import "HMComposeToolbar.h"
#import "HMComposePhotosView.h"

#import "MBProgressHUD+MJ.h"

#import "HMEmotion.h"
#import "HMEmotionKeyboard.h"

#import "DSComposePhotosView.h"
#import "JKImagePickerController.h"
//#import <Masonry.h>
#import <SVProgressHUD.h>

@interface TestViewController () <UITextViewDelegate,UIGestureRecognizerDelegate,HMComposeToolbarDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,JKImagePickerControllerDelegate>

@property (nonatomic,weak)UITextView *reportStateTextView;
@property (nonatomic,weak)UILabel *pLabel;
@property (nonatomic,weak)UIButton *addPictureButton;
@property (nonatomic,weak)ImagePickerChooseView *IPCView;
@property (nonatomic,strong)AGImagePickerController *imagePicker;

@property (nonatomic , weak) DSComposePhotosView *photosView2;

//imagePicker队列
@property (nonatomic,strong)NSMutableArray *imagePickerArray;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0/255 green:149.0/255 blue:135.0/255 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //    [self.tableView improveTableView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyboardDismiss:)];
    tap.delegate = self;
    //    [self.tableView addGestureRecognizer:tap];
    [self.view addGestureRecognizer:tap];
    
    [self initHeaderView];
}

#define textViewHeight 100
#define pictureHW (screenWidth - 5*padding)/4
#define MaxImageCount 9
#define deleImageWH 25 // 删除按钮的宽高
//大图特别耗内存，不能把大图存在数组里，存类型或者小图

-(void)initHeaderView
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectZero];
    headView.backgroundColor = [UIColor orangeColor];
    
    UITextView *reportStateTextView = [[UITextView alloc]initWithFrame:CGRectMake(padding, padding + 64, screenWidth - 2*padding, textViewHeight)];
    reportStateTextView.text = self.reportStateTextView.text;  //防止用户已经输入了文字状态
    reportStateTextView.returnKeyType = UIReturnKeyDone;
    reportStateTextView.font = [UIFont systemFontOfSize:15];
    self.reportStateTextView = reportStateTextView;
    self.reportStateTextView.delegate = self;
    [headView addSubview:reportStateTextView];
    
    UILabel *pLabel = [[UILabel alloc]initWithFrame:CGRectMake(padding+5, 2 * padding+ 64, screenWidth, 10)];
    pLabel.text = @"这一刻的想法...";
    pLabel.backgroundColor = [UIColor redColor];
    
    pLabel.hidden = [self.reportStateTextView.text length];
    pLabel.font = [UIFont systemFontOfSize:15];
    pLabel.textColor = [UIColor colorWithRed:152/255.0 green:152/255.0 blue:152/255.0 alpha:1];
    self.pLabel = pLabel;
    [headView addSubview:pLabel];
    
    NSInteger imageCount = [self.imagePickerArray count];
    for (NSInteger i = 0; i < imageCount; i++) {
        UIImageView *pictureImageView = [[UIImageView alloc]initWithFrame:CGRectMake(padding + (i%4)*(pictureHW+padding), CGRectGetMaxY(reportStateTextView.frame) + padding +(i/4)*(pictureHW+padding), pictureHW, pictureHW)];
        //用作放大图片
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
        [pictureImageView addGestureRecognizer:tap];
        
        //添加删除按钮
        UIButton *dele = [UIButton buttonWithType:UIButtonTypeCustom];
        dele.frame = CGRectMake(pictureHW - deleImageWH + 5, -10, deleImageWH, deleImageWH);
        [dele setImage:[UIImage imageNamed:@"deletePhoto"] forState:UIControlStateNormal];
        [dele addTarget:self action:@selector(deletePic:) forControlEvents:UIControlEventTouchUpInside];
        [pictureImageView addSubview:dele];
        
        pictureImageView.tag = imageTag + i;
        pictureImageView.userInteractionEnabled = YES;
        pictureImageView.image = [UIImage imageWithCGImage:((ALAsset *)[self.imagePickerArray objectAtIndex:i]).thumbnail];
        [headView addSubview:pictureImageView];
    }
    if (imageCount < MaxImageCount) {
        UIButton *addPictureButton = [[UIButton alloc]initWithFrame:CGRectMake(padding + (imageCount%4)*(pictureHW+padding), CGRectGetMaxY(reportStateTextView.frame) + padding +(imageCount/4)*(pictureHW+padding), pictureHW, pictureHW)];
        [addPictureButton setBackgroundImage:[UIImage imageNamed:@"addPictures"] forState:UIControlStateNormal];
        [addPictureButton addTarget:self action:@selector(addPicture) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:addPictureButton];
        self.addPictureButton = addPictureButton;
    }
    
    NSInteger headViewHeight = 120 + (10 + pictureHW)*([self.imagePickerArray count]/4 + 1);
    headView.frame = CGRectMake(0, 0, screenWidth, headViewHeight);
    //    self.tableView.tableHeaderView = headView;
    [self.view addSubview:headView];
}

#pragma mark - addPicture
-(void)addPicture
{
    if ([self.reportStateTextView isFirstResponder]) {
        [self.reportStateTextView resignFirstResponder];
    }
    //    self.tableView.scrollEnabled = NO;
//    [self initImagePickerChooseView];
    
    [self openAlbum];
}

#pragma mark - gesture method
-(void)tapImageView:(UITapGestureRecognizer *)tap
{
    
//    self.navigationController.navigationBarHidden = YES;
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    ShowImageViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ShowImage"];
//    vc.clickTag = tap.view.tag;
//    vc.imageViews = self.imagePickerArray;
//    [self.navigationController pushViewController:vc animated:YES];
    
    [self openAlbum];
}

#pragma mark - keyboard method
-(void)keyboardDismiss:(UITapGestureRecognizer *)tap
{
    [self.reportStateTextView resignFirstResponder];
}

// 删除图片
-(void)deletePic:(UIButton *)btn
{
    if ([(UIButton *)btn.superview isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)(UIButton *)btn.superview;
        [self.imagePickerArray removeObjectAtIndex:(imageView.tag - imageTag)];
        [imageView removeFromSuperview];
    }
    [self initHeaderView];
}

#define IPCViewHeight 120
-(void)initImagePickerChooseView
{
    ImagePickerChooseView *IPCView = [[ImagePickerChooseView alloc]initWithFrame:CGRectMake(0, screenHeight - 64, screenWidth, IPCViewHeight) andAboveView:self.view];
    //IPCView.frame = CGRectMake(0, screenHeight - IPCViewHeight - 64, screenWidth, IPCViewHeight);
    [IPCView setImagePickerBlock:^{
        self.imagePicker = [[AGImagePickerController alloc] initWithFailureBlock:^(NSError *error) {
            
            if (error == nil)
            {
                [self dismissViewControllerAnimated:YES completion:^{}];
                [self.IPCView disappear];
            } else
            {
                NSLog(@"Error: %@", error);
                
                // Wait for the view controller to show first and hide it after that
                double delayInSeconds = 0.5;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self dismissViewControllerAnimated:YES completion:^{}];
                });
            }
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
            
        } andSuccessBlock:^(NSArray *info) {
            [self.imagePickerArray addObjectsFromArray:info];
            [self dismissViewControllerAnimated:YES completion:^{}];
            [self.IPCView disappear];
            [self initHeaderView];
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        }];
        
        self.imagePicker.maximumNumberOfPhotosToBeSelected = 9 - [self.imagePickerArray count];
        
        [self presentViewController:self.imagePicker animated:YES completion:^{}];
    }];
    [UIView animateWithDuration:0.25f animations:^{
        IPCView.frame = CGRectMake(0, screenHeight - IPCViewHeight-64, screenWidth, IPCViewHeight);
    } completion:^(BOOL finished) {
    }];
    [self.view addSubview:IPCView];
    self.IPCView = IPCView;
    
    
    
    //不能添加约束，因为会导致frame暂时为0，后面的tableview cellfor......不会执行
    //添加约束
    /*self.IPCView.translatesAutoresizingMaskIntoConstraints = NO;
     NSArray *IPCViewConstraintH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_IPCView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_IPCView)];
     [self.view addConstraints:IPCViewConstraintH];
     
     NSArray *IPCViewConstraintV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_IPCView(60)]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_IPCView)];
     [self.view addConstraints:IPCViewConstraintV];*/
    
    
    
    [self.IPCView addImagePickerChooseView];
}

-(NSMutableArray *)imagePickerArray
{
    if (!_imagePickerArray) {
        _imagePickerArray = [[NSMutableArray alloc]init];
    }
    return _imagePickerArray;
}
#pragma mark - UIGesture Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

#pragma mark - Text View Delegate
-(void)textViewDidChange:(UITextView *)textView
{
    self.pLabel.hidden = [textView.text length];
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([@"\n" isEqualToString:text])
    {
        if ([self.reportStateTextView.text length]) {
            [self.reportStateTextView resignFirstResponder];
        }
        else
        {
            return NO;
        }
    }
    return YES;
}


/**
 *  打开照相机
 */
- (void)openCamera
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}


/**
 *  打开相册
 */
- (void)openAlbum
{
    
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 9;
    imagePickerController.selectedAssetArray = self.photosView2.assetsArray;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark - JKImagePickerControllerDelegate
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source
{
    self.photosView2.assetsArray = [NSMutableArray arrayWithArray:assets];
    
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        if ([self.photosView2.assetsArray count] > 0){
            
            self.photosView2.addButton.hidden = NO;
        }
        
        [self.photosView2.collectionView reloadData];
    }];
}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}



@end
