//
//  ReleaseViewController.m
//  融易投
//
//  Created by dongxin on 16/4/13.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "ReleaseViewController.h"
#import "UITableView+Improve.h"
#import "UIImage+ReSize.h"
#import "HeaderContent.h"
#import "ImagePickerChooseView.h"
#import "AGImagePickerController.h"
#import "ShowImageViewController.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

#import "ReleaseProjectCell1.h"
#import "ReleaseProjectCell2.h"

#import "SettingFooterView.h"



@interface ReleaseViewController ()
<UITextViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,weak)UITextView *reportStateTextView;
@property (nonatomic,weak)UILabel *pLabel;
@property (nonatomic,weak)UIButton *addPictureButton;
@property (nonatomic,weak)ImagePickerChooseView *IPCView;
@property (nonatomic,strong)AGImagePickerController *imagePicker;

//imagePicker队列
@property (nonatomic,strong)NSMutableArray *imagePickerArray;

@property (nonatomic,strong)ReleaseProjectCell1 *cell1;
@property (nonatomic,strong)ReleaseProjectCell2 *cell2;

@end

@implementation ReleaseViewController

static NSString *ID1 = @"ReleaseProjectCell1";
static NSString *ID2 = @"ReleaseProjectCell2";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航条
    [self setUpNavBar];
    
    //删除多余的分割线
    [self.tableView improveTableView];

    //添加手势,隐藏键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss:)];
    
    tap.delegate = self;
    
    [self.tableView addGestureRecognizer:tap];
    
    //初始化头部视图
    [self initHeaderView];
    
    //注册创建cell ,这样注册就不用在XIB设置ID
    [self.tableView registerNib:[UINib nibWithNibName:@"ReleaseProjectCell1" bundle:nil] forCellReuseIdentifier:ID1];
    
       [self.tableView registerNib:[UINib nibWithNibName:@"ReleaseProjectCell2" bundle:nil] forCellReuseIdentifier:ID2];
    
}

// 设置导航条
-(void)setUpNavBar
{
    //设置导航条标题
    self.navigationItem.title = @"发起新项目";
}


#define textViewHeight 100
#define pictureHW (screenWidth - 5*padding)/4
#define MaxImageCount 9
#define deleImageWH 25 // 删除按钮的宽高
//大图特别耗内存，不能把大图存在数组里，存类型或者小图

-(void)initHeaderView
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectZero];
    
    //项目介绍
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(padding + 5, padding, 200, 10)];
    nameLabel.text = @"项目介绍";
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textColor = [UIColor blackColor];
    [headView addSubview:nameLabel];
    
    NSInteger headViewHeight = CGRectGetMaxY(nameLabel.frame);
    
    
    UITextView *reportStateTextView = [[UITextView alloc]initWithFrame:CGRectMake(padding, headViewHeight + padding, screenWidth - 2 * padding, textViewHeight)];
    reportStateTextView.text = self.reportStateTextView.text;  //防止用户已经输入了文字状态
    reportStateTextView.returnKeyType = UIReturnKeyDone;
    reportStateTextView.font = [UIFont systemFontOfSize:15];
    self.reportStateTextView = reportStateTextView;
    self.reportStateTextView.delegate = self;
    [headView addSubview:reportStateTextView];
    
    UILabel *pLabel = [[UILabel alloc]initWithFrame:CGRectMake(padding + 5, headViewHeight + padding * 2, screenWidth, 10)];
    pLabel.text = @"请填写项目的说明内容...";
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
    
    headViewHeight = 120 + (10 + pictureHW)*([self.imagePickerArray count]/4 + 1);
    headView.frame = CGRectMake(0, 0, screenWidth, headViewHeight);
    
    self.tableView.tableHeaderView = headView;
}

#pragma mark - addPicture
-(void)addPicture
{
    if ([self.reportStateTextView isFirstResponder]) {
        [self.reportStateTextView resignFirstResponder];
    }
    
//    self.tableView.scrollEnabled = NO;
    [self initImagePickerChooseView];
}

#pragma mark - gesture method
-(void)tapImageView:(UITapGestureRecognizer *)tap
{
//    self.navigationController.navigationBarHidden = YES;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ReleaseViewController" bundle:[NSBundle mainBundle]];
    ShowImageViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ShowImage"];
    vc.clickTag = tap.view.tag;
    vc.imageViews = self.imagePickerArray;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - keyboard method
-(void)dismiss:(UITapGestureRecognizer *)tap
{
    [self.reportStateTextView resignFirstResponder];
    [self.cell1.textView resignFirstResponder];
    [self.cell2.textView resignFirstResponder];
}

// 删除图片
-(void)deletePic:(UIButton *)btn
{
    if ([(UIButton *)btn.superview isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)(UIButton *)btn.superview;
        NSLog(@"tag = %ld",(long)imageView.tag);
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
     self.pLabel.hidden = [textView.text length];
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
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ReleaseProjectCell1 *cell1 = [tableView dequeueReusableCellWithIdentifier:ID1];
    self.cell1 = cell1;
    ReleaseProjectCell2 *cell2 = [tableView dequeueReusableCellWithIdentifier:ID2];
     self.cell2 = cell2;

    if (indexPath.section == 0) {


        return cell1;
        
    } else {
        

        
         return cell2;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    SettingFooterView *footerView = [SettingFooterView settingFooterView];
    [footerView.tuiChuBtn setTitle:@"完成" forState:UIControlStateNormal];
    
    [footerView.tuiChuBtn addTarget:self action:@selector(tuiChuLogn) forControlEvents:UIControlEventTouchUpInside];
    
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 1) {
        
        return 92;
    }
    
    return 0;
}

-(void)tuiChuLogn{
    
    SSLog(@"完成");
    
    [self sendStatusWithImage];
}


- (void)sendStatusWithImage
{
    //参数
    NSString *description = self.reportStateTextView.text;
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    NSInteger count = 0;
    
    for (UIImage *image in self.imagePickerArray) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        formatter.dateFormat = @"yyyyMMddHHmmssSSS";
        
        NSString *fileName = [NSString stringWithFormat:@"%@%@.png",[formatter stringFromDate:[NSDate date]],@(count)];
        
        NSLog(@"%@",fileName);
        
        [tempArray addObject:fileName];

        count++;
}
    
    NSArray *file = tempArray.copy;

    NSString *make_instru = self.cell1.textView.text;
    
    NSString *financing_aq = self.cell2.textView.text;
    
    NSString *artworkId = [[NSUserDefaults standardUserDefaults]objectForKey:@"artworkId"];
    
    NSString *timestamp = [MyMD5 timestamp];
    
    NSString *appkey = MD5key;
    
    
    NSString *signmsg = [NSString stringWithFormat:@"artworkId=%@&timestamp=%@&key=%@",artworkId,timestamp,appkey];
    
    NSString *signmsgMD5 = [MyMD5 md5:signmsg];
    
    NSString *url = @"http://192.168.1.41:8085/app/initNewArtWork2.do";
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"description" : description,
                           @"make_instru":make_instru,
                           @"financing_aq":financing_aq,
                           @"file"        :file,
                           @"artworkId"   : artworkId,
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    // 设置请求格式
    manger.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    [manger POST:url parameters:json constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSInteger imgCount = 0;
        
         for (int i = 0; i < self.imagePickerArray.count; i++) {
            
            UIImage *image  =  [UIImage imageWithCGImage:((ALAsset *)[self.imagePickerArray objectAtIndex:i]).thumbnail];
            
            NSData *data = UIImageJPEGRepresentation(image, 1.0);
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            formatter.dateFormat = @"yyyyMMddHHmmssSSS";
            
            NSString *fileName = [NSString stringWithFormat:@"%@%@.png",[formatter stringFromDate:[NSDate date]],@(imgCount)];
            
            NSLog(@"%@",fileName);
            
            [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"application/octet-stream"];
            
            imgCount++;
            
            NSLog(@"%ld",imgCount);
            
        }
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        SSLog(@"---%@---%@",[responseObject class],aString);
        
        //[SVProgressHUD showSuccessWithStatus:@"发布成功" maskType:SVProgressHUDMaskTypeBlack];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        SSLog(@"%@",error);
        
        //[SVProgressHUD showSuccessWithStatus:@"发布失败" maskType:SVProgressHUDMaskTypeBlack];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
