//
//  ApplyforArtViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/22.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "ApplyforArtViewController.h"

#import "UITableView+Improve.h"
#import "UIImage+ReSize.h"
#import "HeaderContent.h"
#import "ImagePickerChooseView.h"
#import "AGImagePickerController.h"
#import "ShowImageViewController.h"


#import "cityField.h"

@interface ApplyforArtViewController ()<UITextViewDelegate,UIGestureRecognizerDelegate,MBProgressHUDDelegate>

@property (nonatomic,weak)UITextField *nameTextView;
@property (nonatomic,weak)UITextField *phoneTextView;

@property (nonatomic,weak)cityField *districtTextView;
@property (nonatomic,weak) UITextField *addressTextView;
@property (nonatomic,weak) UITextField *artTextView;
@property (nonatomic,weak) UITextField *certificationTF;

@property (nonatomic,weak)UILabel *identityCardInfoLabel;
@property (nonatomic,weak)UILabel *pLabel;

@property (nonatomic,weak)UIButton *addPictureButton;
@property (nonatomic,weak)UIButton *addPictureButton2;
@property (nonatomic,weak)UIButton *addPictureButton3;
@property (nonatomic,weak)UIButton *addPictureButton4;
@property (nonatomic,weak)ImagePickerChooseView *IPCView;
@property (nonatomic,strong)AGImagePickerController *imagePicker;

@property (nonatomic,assign) NSInteger headViewHeight;


@property (nonatomic,copy) NSString *str1;
@property (nonatomic,copy) NSString *str2;
@property (nonatomic,copy) NSString *str3;
@property (nonatomic,copy) NSString *str4;
@property (nonatomic,copy) NSString *str5;
@property (nonatomic,copy) NSString *str6;
@property (nonatomic,copy) NSString *str7;


//imagePicker队列
@property (nonatomic,strong)NSMutableArray *imagePickerArray1;

//imagePicker队列
@property (nonatomic,strong)NSMutableArray *imagePickerArray2;

//imagePicker队列
@property (nonatomic,strong)NSMutableArray *imagePickerArray3;

//imagePicker队列
@property (nonatomic,strong)NSMutableArray *imagePickerArray4;

//提示上传进度
@property(nonatomic,strong) MBProgressHUD *progressHUD;

@end

@implementation ApplyforArtViewController

-(MBProgressHUD *)progressHUD{
    if (!_progressHUD) {
        _progressHUD = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
        self.progressHUD.delegate = self;
        _progressHUD.mode = MBProgressHUDModeDeterminate;
    }
    return _progressHUD;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavBar];
    
    //删除多余行
    [self.tableView improveTableView];
    
    //添加手势,取消编辑状态
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyboardDismiss:)];
    
    tap.delegate = self;
    
    [self.tableView addGestureRecognizer:tap];
    
    //初始化头部输入框
    [self initHeaderView];
}

// 设置导航条
-(void)setUpNavBar
{
    //设置导航条标题
    self.navigationItem.title = @"发布动态";
}

#define textViewHeight 100
#define pictureHW (screenWidth - 5*padding)/4
#define MaxImageCount1 2
#define MaxImageCount2 3
#define MaxImageCount3 3
#define MaxImageCount4 3
#define deleImageWH 25 // 删除按钮的宽高
//大图特别耗内存，不能把大图存在数组里，存类型或者小图

-(void)initHeaderView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectZero];
    
//    //第一个自定义view
//    ApplyHeaderView *view1 = [ApplyHeaderView applyHeaderView];
//    view1.frame = CGRectMake(0, 0, SSScreenW, 171);
//    self.view1 = view1;
//    
//    NSLog(@"%f",view1.width);
//    
//    [headView addSubview:view1];
    
    //真是姓名
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(padding, padding, 200, 10)];
    nameLabel.text = @"真实姓名";
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textColor = [UIColor blackColor];
    [headView addSubview:nameLabel];
    
     NSInteger headViewHeight = CGRectGetMaxY(nameLabel.frame);
    
    
    //真实姓名输入框
    UITextField *nameTextView = [[UITextField alloc] initWithFrame:CGRectMake(padding, headViewHeight + padding, screenWidth - 2 * padding, 30)];
    nameTextView.placeholder = @"您身份证上的姓名";
    nameTextView.borderStyle = UITextBorderStyleRoundedRect;
    self.nameTextView = nameTextView;
    
    [headView addSubview:nameTextView];
    
    headViewHeight = CGRectGetMaxY(nameTextView.frame);
    
    //手机号
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(padding,headViewHeight + padding, 200, 10)];
    phoneLabel.text = @"手机号";
    phoneLabel.font = [UIFont systemFontOfSize:15];
    phoneLabel.textColor = [UIColor blackColor];
    [headView addSubview:phoneLabel];
    
    headViewHeight = CGRectGetMaxY(phoneLabel.frame);
    
    
    //手机号输入框
    UITextField *phoneTextView = [[UITextField alloc] initWithFrame:CGRectMake(padding, headViewHeight + padding, screenWidth - 2 * padding, 30)];
    phoneTextView.placeholder = @"请输入手机号";
    phoneTextView.borderStyle = UITextBorderStyleRoundedRect;
    self.phoneTextView = phoneTextView;
    
    [headView addSubview:phoneTextView];
    
    headViewHeight = CGRectGetMaxY(phoneTextView.frame);
    
    //身份证
    UILabel *identityCardInfoLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(padding, headViewHeight + padding, 150, 10)];
    identityCardInfoLabel1.text = @"请上传本人身份证照片";
    identityCardInfoLabel1.font = [UIFont systemFontOfSize:15];
    identityCardInfoLabel1.textColor = [UIColor blackColor];
    [headView addSubview:identityCardInfoLabel1];

    //身份证
    UILabel *identityCardInfoLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(identityCardInfoLabel1.frame), headViewHeight + padding, 200, 10)];
    identityCardInfoLabel2.text = @"(正反面)";
    identityCardInfoLabel2.font = [UIFont systemFontOfSize:15];
    identityCardInfoLabel2.textColor = [UIColor darkGrayColor];
    [headView addSubview:identityCardInfoLabel2];
    
    headViewHeight = CGRectGetMaxY(identityCardInfoLabel2.frame);
    
    //第一个添加按钮
    NSInteger imageCount = [self.imagePickerArray1 count];
    
    NSLog(@"%ld",imageCount);
    
    for (NSInteger i = 0; i < imageCount; i++) {
        UIImageView *pictureImageView = [[UIImageView alloc]initWithFrame:CGRectMake(padding + (i%4)*(pictureHW+padding), CGRectGetMaxY(identityCardInfoLabel2.frame) + padding +(i/4)*(pictureHW+padding), pictureHW, pictureHW)];
        //用作放大图片
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
        [pictureImageView addGestureRecognizer:tap];
        
        //添加删除按钮
        UIButton *dele = [UIButton buttonWithType:UIButtonTypeCustom];
        dele.frame = CGRectMake(pictureHW - deleImageWH + 5, -10, deleImageWH, deleImageWH);
        [dele setImage:[UIImage imageNamed:@"deletePhoto"] forState:UIControlStateNormal];
        [dele addTarget:self action:@selector(deletePics:) forControlEvents:UIControlEventTouchUpInside];
        [pictureImageView addSubview:dele];
        
        pictureImageView.tag = imageTag + i;
        pictureImageView.userInteractionEnabled = YES;
        pictureImageView.image = [UIImage imageWithCGImage:((ALAsset *)[self.imagePickerArray1 objectAtIndex:i]).thumbnail];
        [headView addSubview:pictureImageView];
    }
    if (imageCount < MaxImageCount1) {
        
        UIButton *addPictureButton = [[UIButton alloc]initWithFrame:CGRectMake(padding + (imageCount%4)*(pictureHW+padding), CGRectGetMaxY(identityCardInfoLabel2.frame) + padding +(imageCount/4)*(pictureHW+padding), pictureHW, pictureHW)];
        [addPictureButton setBackgroundImage:[UIImage imageNamed:@"addPictures"] forState:UIControlStateNormal];
        [addPictureButton addTarget:self action:@selector(addPictures) forControlEvents:UIControlEventTouchUpInside];
        
        [headView addSubview:addPictureButton];
        
        self.addPictureButton = addPictureButton;
    }
    
    //上面的总高度
   headViewHeight = CGRectGetMaxY(identityCardInfoLabel2.frame) + (10 + pictureHW)*([self.imagePickerArray1 count]/4 + 1);
    
    //所在地区
    UILabel *districtLabel = [[UILabel alloc]initWithFrame:CGRectMake(padding+5, headViewHeight + padding, 200, 10)];
    districtLabel.text = @"所在地区";
    districtLabel.font = [UIFont systemFontOfSize:15];
    districtLabel.textColor = [UIColor blackColor];
    [headView addSubview:districtLabel];
    
    headViewHeight = CGRectGetMaxY(districtLabel.frame);
    
    
    //所在地区输入框
    cityField *districtTextView = [[cityField alloc] initWithFrame:CGRectMake(padding, headViewHeight + padding, screenWidth - 2 * padding, 30)];
    districtTextView.placeholder = @"请选择所在城市";
    districtTextView.delegate = self;
    districtTextView.borderStyle = UITextBorderStyleRoundedRect;
    self.districtTextView = districtTextView;
    
    [headView addSubview:districtTextView];
    
    headViewHeight = CGRectGetMaxY(districtTextView.frame);
    
    //第二个自定义view
//    ApplyHeaderView2 *view2 = [ApplyHeaderView2 applyHeaderView2];
//    view2.frame = CGRectMake(0, headViewHeight, SSScreenW, 171);
//    
//    [headView addSubview:view2];
    
    //详细地址
    UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(padding, headViewHeight + padding, 200, 10)];
    addressLabel.text = @"详细地址";
    addressLabel.font = [UIFont systemFontOfSize:15];
    addressLabel.textColor = [UIColor blackColor];
    [headView addSubview:addressLabel];
    
    headViewHeight = CGRectGetMaxY(addressLabel.frame);
    
    
    //详细地址输入框
    UITextField *addressTextView = [[UITextField alloc] initWithFrame:CGRectMake(padding, headViewHeight + padding, screenWidth - 2 * padding, 30)];
    addressTextView.borderStyle = UITextBorderStyleRoundedRect;
    self.addressTextView = addressTextView;
    
    [headView addSubview:addressTextView];
    
    headViewHeight = CGRectGetMaxY(addressTextView.frame);
    
    //艺术类型
    UILabel *artLabel = [[UILabel alloc]initWithFrame:CGRectMake(padding, headViewHeight + padding, 200, 10)];
    artLabel.text = @"艺术类型";
    artLabel.font = [UIFont systemFontOfSize:15];
    artLabel.textColor = [UIColor blackColor];
    [headView addSubview:artLabel];
    
    headViewHeight = CGRectGetMaxY(artLabel.frame);
    
    
    //艺术类型输入框
    UITextField *artTextView = [[UITextField alloc] initWithFrame:CGRectMake(padding, headViewHeight + padding, screenWidth - 2 * padding, 30)];
    artTextView.borderStyle = UITextBorderStyleRoundedRect;
    self.artTextView = artTextView;
    
    [headView addSubview:artTextView];
    
    headViewHeight = CGRectGetMaxY(artTextView.frame);
    
    //请上传您最满意的三张作品照片
    UILabel *worksLabel = [[UILabel alloc]initWithFrame:CGRectMake(padding, headViewHeight + padding, 250, 10)];
    worksLabel.text = @"请上传您最满意的三张作品照片";
    worksLabel.font = [UIFont systemFontOfSize:15];
    worksLabel.textColor = [UIColor blackColor];
    [headView addSubview:worksLabel];
    
    headViewHeight = CGRectGetMaxY(worksLabel.frame);
    
    
    //第二个添加按钮
    NSInteger imageCount2 = [self.imagePickerArray2 count];
    
    for (NSInteger i = 0; i < imageCount2; i++) {
        UIImageView *pictureImageView = [[UIImageView alloc]initWithFrame:CGRectMake(padding + (i%4)*(pictureHW+padding), CGRectGetMaxY(worksLabel.frame) + padding +(i/4)*(pictureHW+padding), pictureHW, pictureHW)];
        //用作放大图片
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView2:)];
        [pictureImageView addGestureRecognizer:tap];
        
        //添加删除按钮
        UIButton *dele = [UIButton buttonWithType:UIButtonTypeCustom];
        dele.frame = CGRectMake(pictureHW - deleImageWH + 5, -10, deleImageWH, deleImageWH);
        [dele setImage:[UIImage imageNamed:@"deletePhoto"] forState:UIControlStateNormal];
        [dele addTarget:self action:@selector(deletePics2:) forControlEvents:UIControlEventTouchUpInside];
        [pictureImageView addSubview:dele];
        
        pictureImageView.tag = imageTag + i;
        pictureImageView.userInteractionEnabled = YES;
        pictureImageView.image = [UIImage imageWithCGImage:((ALAsset *)[self.imagePickerArray2 objectAtIndex:i]).thumbnail];
        [headView addSubview:pictureImageView];
    }
    if (imageCount2 < MaxImageCount2) {
        
        UIButton *addPictureButton2 = [[UIButton alloc]initWithFrame:CGRectMake(padding + (imageCount2%4)*(pictureHW+padding), CGRectGetMaxY(worksLabel.frame) + padding +(imageCount2/4)*(pictureHW+padding), pictureHW, pictureHW)];
        [addPictureButton2 setBackgroundImage:[UIImage imageNamed:@"addPictures"] forState:UIControlStateNormal];
        [addPictureButton2 addTarget:self action:@selector(addPictures2) forControlEvents:UIControlEventTouchUpInside];
        
        [headView addSubview:addPictureButton2];
        
        self.addPictureButton2 = addPictureButton2;
    }
    
    //上面的总高度
    headViewHeight = CGRectGetMaxY(worksLabel.frame) + (10 + pictureHW)*([self.imagePickerArray2 count]/4 + 1);
    
    //工作室照片
    UILabel *roomLabel = [[UILabel alloc]initWithFrame:CGRectMake(padding+5, headViewHeight + padding, 165, 10)];
//    UILabel *roomLabel = [[UILabel alloc] init];
//    roomLabel.x = padding+5;
//    roomLabel.y = headViewHeight + padding;
//    [roomLabel sizeToFit];
    roomLabel.text = @"请上传本人(工作室)照片";
    roomLabel.font = [UIFont systemFontOfSize:15];
    roomLabel.textColor = [UIColor blackColor];
    [headView addSubview:roomLabel];

    
    //最多3张
    UILabel *roomInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(roomLabel.frame), headViewHeight + padding, 200, 10)];
    roomInfoLabel.text = @"(最多3张)";
    roomInfoLabel.font = [UIFont systemFontOfSize:15];
    roomInfoLabel.textColor = [UIColor darkGrayColor];
    [headView addSubview:roomInfoLabel];
    
    headViewHeight = CGRectGetMaxY(roomInfoLabel.frame);
    
    //第三个添加按钮
    NSInteger imageCount3 = [self.imagePickerArray3 count];
    
    for (NSInteger i = 0; i < imageCount3; i++) {
        UIImageView *pictureImageView = [[UIImageView alloc]initWithFrame:CGRectMake(padding + (i%4)*(pictureHW+padding), CGRectGetMaxY(roomInfoLabel.frame) + padding +(i/4)*(pictureHW+padding), pictureHW, pictureHW)];
        //用作放大图片
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView3:)];
        [pictureImageView addGestureRecognizer:tap];
        
        //添加删除按钮
        UIButton *dele = [UIButton buttonWithType:UIButtonTypeCustom];
        dele.frame = CGRectMake(pictureHW - deleImageWH + 5, -10, deleImageWH, deleImageWH);
        [dele setImage:[UIImage imageNamed:@"deletePhoto"] forState:UIControlStateNormal];
        [dele addTarget:self action:@selector(deletePics3:) forControlEvents:UIControlEventTouchUpInside];
        [pictureImageView addSubview:dele];
        
        pictureImageView.tag = imageTag + i;
        pictureImageView.userInteractionEnabled = YES;
        pictureImageView.image = [UIImage imageWithCGImage:((ALAsset *)[self.imagePickerArray3 objectAtIndex:i]).thumbnail];
        [headView addSubview:pictureImageView];
    }
    if (imageCount3 < MaxImageCount3) {
        
        UIButton *addPictureButton3 = [[UIButton alloc]initWithFrame:CGRectMake(padding + (imageCount3%4)*(pictureHW+padding), CGRectGetMaxY(roomInfoLabel.frame) + padding +(imageCount3/4)*(pictureHW+padding), pictureHW, pictureHW)];
        [addPictureButton3 setBackgroundImage:[UIImage imageNamed:@"addPictures"] forState:UIControlStateNormal];
        [addPictureButton3 addTarget:self action:@selector(addPictures3) forControlEvents:UIControlEventTouchUpInside];
        
        [headView addSubview:addPictureButton3];
        
        self.addPictureButton3 = addPictureButton3;
    }
    
    //上面的总高度
    headViewHeight = CGRectGetMaxY(roomInfoLabel.frame) + (10 + pictureHW)*([self.imagePickerArray3 count]/4 + 1);
    
    //资格认证
    UILabel *certificationLabel = [[UILabel alloc]initWithFrame:CGRectMake(padding+5, headViewHeight + padding, SSScreenW, 10)];
    certificationLabel.text = @"资格认证";
    certificationLabel.font = [UIFont systemFontOfSize:15];
    certificationLabel.textColor = [UIColor blackColor];
    [headView addSubview:certificationLabel];
    
    //上面的总高度
    headViewHeight = CGRectGetMaxY(certificationLabel.frame);
    
    UITextField *certificationTF = [[UITextField alloc] initWithFrame:CGRectMake(padding+5, headViewHeight + padding, SSScreenW - 2 * (padding), 30)];
    certificationTF.placeholder = @"请输入头衔/称号/资格";
    certificationTF.font = [UIFont systemFontOfSize:15];
    certificationTF.textColor = [UIColor blackColor];
    certificationTF.borderStyle = UITextBorderStyleRoundedRect;
    self.certificationTF = certificationTF;
    [headView addSubview:certificationTF];
    
    //上面的总高度
    headViewHeight = CGRectGetMaxY(certificationTF.frame);
    
    //头衔/称号/资格照片
    UILabel *certificationPhotoLabel = [[UILabel alloc]initWithFrame:CGRectMake(padding+5, headViewHeight + padding, SSScreenW, 10)];
    certificationPhotoLabel.text = @"请上传您头衔认证所需的获奖/资格证书 (最多3张)";
    certificationPhotoLabel.font = [UIFont systemFontOfSize:15];
    certificationPhotoLabel.textColor = [UIColor blackColor];
    [headView addSubview:certificationPhotoLabel];

    //上面的总高度
    headViewHeight = CGRectGetMaxY(certificationPhotoLabel.frame);
    
    //第四个添加按钮
    NSInteger imageCount4 = [self.imagePickerArray4 count];
    
    for (NSInteger i = 0; i < imageCount4; i++) {
        UIImageView *pictureImageView = [[UIImageView alloc]initWithFrame:CGRectMake(padding + (i%4)*(pictureHW+padding), CGRectGetMaxY(certificationPhotoLabel.frame) + padding +(i/4)*(pictureHW+padding), pictureHW, pictureHW)];
        //用作放大图片
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView4:)];
        [pictureImageView addGestureRecognizer:tap];
        
        //添加删除按钮
        UIButton *dele = [UIButton buttonWithType:UIButtonTypeCustom];
        dele.frame = CGRectMake(pictureHW - deleImageWH + 5, -10, deleImageWH, deleImageWH);
        [dele setImage:[UIImage imageNamed:@"deletePhoto"] forState:UIControlStateNormal];
        [dele addTarget:self action:@selector(deletePics4:) forControlEvents:UIControlEventTouchUpInside];
        [pictureImageView addSubview:dele];
        
        pictureImageView.tag = imageTag + i;
        pictureImageView.userInteractionEnabled = YES;
        pictureImageView.image = [UIImage imageWithCGImage:((ALAsset *)[self.imagePickerArray4 objectAtIndex:i]).thumbnail];
        [headView addSubview:pictureImageView];
    }
    if (imageCount4 < MaxImageCount4) {
        
        UIButton *addPictureButton4 = [[UIButton alloc]initWithFrame:CGRectMake(padding + (imageCount4%4)*(pictureHW+padding), CGRectGetMaxY(certificationPhotoLabel.frame) + padding +(imageCount4/4)*(pictureHW+padding), pictureHW, pictureHW)];
        [addPictureButton4 setBackgroundImage:[UIImage imageNamed:@"addPictures"] forState:UIControlStateNormal];
        [addPictureButton4 addTarget:self action:@selector(addPictures4) forControlEvents:UIControlEventTouchUpInside];
        
        [headView addSubview:addPictureButton4];
        
        self.addPictureButton4 = addPictureButton4;
    }
    
    //上面的总高度
    headViewHeight = CGRectGetMaxY(certificationPhotoLabel.frame) + (10 + pictureHW)*([self.imagePickerArray4 count]/4 + 1);
    
    //第三个自定义view
//    ApplyHeaderView3 *view3 = [ApplyHeaderView3 applyHeaderView3];
//    view3.frame = CGRectMake(0, headViewHeight, screenWidth, 82);
//    [headView addSubview:view3];
    
    //确认按钮
    UIButton *querenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    querenBtn.frame = CGRectMake(padding, headViewHeight + padding, SSScreenW - 2 * (padding), 30);
    [querenBtn setTitle:@"确认提交" forState:UIControlStateNormal];
    querenBtn.backgroundColor = [UIColor orangeColor];
    [querenBtn addTarget:self action:@selector(querentijiao) forControlEvents:UIControlEventTouchUpInside];
    
    [headView addSubview:querenBtn];
    
    //上面的总高度
    headViewHeight = CGRectGetMaxY(querenBtn.frame);
    
    //描述确认按钮
    UILabel *querenLabel = [[UILabel alloc]initWithFrame:CGRectMake(padding + 50, headViewHeight + padding, 135, 10)];
//    UILabel *querenLabel = [[UILabel alloc] init];
//    querenLabel.x = padding + 200;
//    querenLabel.y = headViewHeight + padding;
//    querenLabel.height = 10;
//    [querenLabel sizeToFit];
    querenLabel.text = @"点击确认提交即表示同意";
    if (iPhone4 || iPhone5) {
        querenLabel.font = [UIFont systemFontOfSize:10];
    }else{
        querenLabel.font = [UIFont systemFontOfSize:12];
    }
    querenLabel.textColor = [UIColor blackColor];
    [headView addSubview:querenLabel];
    
    //描述确认协议按钮
    UIButton *querenInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (iPhone4 || iPhone5) {
       querenInfoBtn.frame = CGRectMake(CGRectGetMaxX(querenLabel.frame) - 33, headViewHeight + 5, 120, 20);
    }else{
        querenInfoBtn.frame = CGRectMake(CGRectGetMaxX(querenLabel.frame) - 20, headViewHeight + 5, 150, 20);
    }
    [querenInfoBtn setTitle:@"《融艺投艺术家协议》" forState:UIControlStateNormal];
    [querenInfoBtn setTitleColor:SSColor(239, 91, 112) forState:UIControlStateNormal];
    if (iPhone4 || iPhone5) {
        querenInfoBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    }else{
        querenInfoBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    [headView addSubview:querenInfoBtn];
    
    //上面的总高度
    headViewHeight = CGRectGetMaxY(querenInfoBtn.frame);

    
    self.headViewHeight = headViewHeight;
    headView.frame = CGRectMake(0, 0, screenWidth, headViewHeight + padding);

    
    self.tableView.tableHeaderView = headView;
}

#pragma mark - addPicture
-(void)addPictures
{
    if ([self.identityCardInfoLabel isFirstResponder]) {
        [self.identityCardInfoLabel resignFirstResponder];
    }
//    self.tableView.scrollEnabled = NO;
    
    [self initImagePickerChooseView];
}

-(void)addPictures2
{
    if ([self.identityCardInfoLabel isFirstResponder]) {
        [self.identityCardInfoLabel resignFirstResponder];
    }
//    self.tableView.scrollEnabled = NO;
    
    [self initImagePickerChooseView2];
}

-(void)addPictures3
{
    if ([self.identityCardInfoLabel isFirstResponder]) {
        [self.identityCardInfoLabel resignFirstResponder];
    }
//    self.tableView.scrollEnabled = NO;
    
    [self initImagePickerChooseView3];
}

-(void)addPictures4
{
    if ([self.identityCardInfoLabel isFirstResponder]) {
        [self.identityCardInfoLabel resignFirstResponder];
    }
//        self.tableView.scrollEnabled = NO;
    
    [self initImagePickerChooseView4];
}

#pragma mark - gesture method
-(void)tapImageView:(UITapGestureRecognizer *)tap
{
    self.navigationController.navigationBarHidden = YES;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ApplyforArtViewController" bundle:[NSBundle mainBundle]];
    ShowImageViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ShowImage1"];
    vc.clickTag = tap.view.tag;
    vc.imageViews = self.imagePickerArray1;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)tapImageView2:(UITapGestureRecognizer *)tap
{
    self.navigationController.navigationBarHidden = YES;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ApplyforArtViewController" bundle:[NSBundle mainBundle]];
    ShowImageViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ShowImage1"];
    vc.clickTag = tap.view.tag;
    vc.imageViews = self.imagePickerArray2;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)tapImageView3:(UITapGestureRecognizer *)tap
{
    self.navigationController.navigationBarHidden = YES;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ApplyforArtViewController" bundle:[NSBundle mainBundle]];
    ShowImageViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ShowImage1"];
    vc.clickTag = tap.view.tag;
    vc.imageViews = self.imagePickerArray3;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)tapImageView4:(UITapGestureRecognizer *)tap
{
    self.navigationController.navigationBarHidden = YES;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ApplyforArtViewController" bundle:[NSBundle mainBundle]];
    ShowImageViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ShowImage1"];
    vc.clickTag = tap.view.tag;
    vc.imageViews = self.imagePickerArray4;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - keyboard method
-(void)keyboardDismiss:(UITapGestureRecognizer *)tap
{
    [self.nameTextView endEditing:YES];
    [self.phoneTextView endEditing:YES];
    [self.districtTextView endEditing:YES];
    [self.addressTextView endEditing:YES];
    [self.certificationTF endEditing:YES];
    [self.districtTextView endEditing:YES];
    [self.artTextView endEditing:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.nameTextView endEditing:YES];
    [self.phoneTextView endEditing:YES];
    [self.districtTextView endEditing:YES];
    [self.addressTextView endEditing:YES];
    [self.districtTextView endEditing:YES];
    [self.artTextView endEditing:YES];
}

// 删除图片
-(void)deletePics:(UIButton *)btn
{
    if ([(UIButton *)btn.superview isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)(UIButton *)btn.superview;

        [self.imagePickerArray1 removeObjectAtIndex:(imageView.tag - imageTag)];
        [imageView removeFromSuperview];
    }
    [self saveData];
    
    [self initHeaderView];
    
    [self takeData];
}

-(void)deletePics2:(UIButton *)btn
{
    if ([(UIButton *)btn.superview isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)(UIButton *)btn.superview;

        [self.imagePickerArray2 removeObjectAtIndex:(imageView.tag - imageTag)];
        [imageView removeFromSuperview];
    }
    [self saveData];
    
    [self initHeaderView];
    
    [self takeData];
}

-(void)deletePics3:(UIButton *)btn
{
    if ([(UIButton *)btn.superview isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)(UIButton *)btn.superview;

        [self.imagePickerArray3 removeObjectAtIndex:(imageView.tag - imageTag)];
        [imageView removeFromSuperview];
    }
    [self saveData];
    
    [self initHeaderView];
    
    [self takeData];
}

-(void)deletePics4:(UIButton *)btn
{
    if ([(UIButton *)btn.superview isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)(UIButton *)btn.superview;

        [self.imagePickerArray4 removeObjectAtIndex:(imageView.tag - imageTag)];
        [imageView removeFromSuperview];
    }
    [self saveData];
    
    [self initHeaderView];
    
    [self takeData];
}

#define IPCViewHeight 120
-(void)initImagePickerChooseView
{
    ImagePickerChooseView *IPCView = [[ImagePickerChooseView alloc]initWithFrame:CGRectMake(0, screenHeight + 64, screenWidth, IPCViewHeight) andAboveView:self.view];
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
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
            
        } andSuccessBlock:^(NSArray *info) {
            
            
            [self.imagePickerArray1 addObjectsFromArray:info];
            
            
            [self dismissViewControllerAnimated:YES completion:^{}];
            [self.IPCView disappear];
            
            [self saveData];
            
            [self initHeaderView];
            
            [self takeData];
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        }];
        
        
        self.imagePicker.maximumNumberOfPhotosToBeSelected = 2 - [self.imagePickerArray1 count];
        
        [self presentViewController:self.imagePicker animated:YES completion:^{}];
    }];
    [UIView animateWithDuration:0.25f animations:^{
        IPCView.frame = CGRectMake(0, screenHeight - IPCViewHeight-64, screenWidth, IPCViewHeight);
    } completion:^(BOOL finished) {
    }];
  [[UIApplication sharedApplication].keyWindow addSubview:IPCView];
    self.IPCView = IPCView;

    [self.IPCView addImagePickerChooseView];
}

#define IPCViewHeight 120
-(void)initImagePickerChooseView2
{
    ImagePickerChooseView *IPCView = [[ImagePickerChooseView alloc]initWithFrame:CGRectMake(0, self.tableView.contentSize.height + 64, screenWidth, IPCViewHeight) andAboveView:self.view];
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
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
            
        } andSuccessBlock:^(NSArray *info) {
            
            
            [self.imagePickerArray2 addObjectsFromArray:info];
            
            
            [self dismissViewControllerAnimated:YES completion:^{}];
            [self.IPCView disappear];
            
            [self saveData];
            
            [self initHeaderView];
            
            [self takeData];
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        }];
        
        NSLog(@"%ld",[self.imagePickerArray2 count]);
        
        self.imagePicker.maximumNumberOfPhotosToBeSelected = 3 - [self.imagePickerArray2 count];
        
        [self presentViewController:self.imagePicker animated:YES completion:^{}];
    }];
    [UIView animateWithDuration:0.25f animations:^{
        IPCView.frame = CGRectMake(0, screenHeight - IPCViewHeight - 64, screenWidth, IPCViewHeight);
    } completion:^(BOOL finished) {
    }];
    
    
    
   [[UIApplication sharedApplication].keyWindow addSubview:IPCView];
    self.IPCView = IPCView;
    
    [self.IPCView addImagePickerChooseView];
}
#define IPCViewHeight 120
-(void)initImagePickerChooseView3
{
    ImagePickerChooseView *IPCView = [[ImagePickerChooseView alloc]initWithFrame:CGRectMake(0, screenHeight + 64, screenWidth, IPCViewHeight) andAboveView:self.view];
    //IPCView.frame = CGRectMake(0, screenHeight - IPCViewHeight - 64, screenWidth, IPCViewHeight);
    [IPCView setImagePickerBlock:^{
        self.imagePicker = [[AGImagePickerController alloc] initWithFailureBlock:^(NSError *error) {
            
            if (error == nil)
            {
                [self dismissViewControllerAnimated:YES completion:^{}];
                [self.IPCView disappear];
            } else
            {
                
                // Wait for the view controller to show first and hide it after that
                double delayInSeconds = 0.5;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self dismissViewControllerAnimated:YES completion:^{}];
                });
            }
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
            
        } andSuccessBlock:^(NSArray *info) {
            
            
            [self.imagePickerArray3 addObjectsFromArray:info];
            
            
            [self dismissViewControllerAnimated:YES completion:^{}];
            [self.IPCView disappear];
            
            [self saveData];
            
            [self initHeaderView];
            
            [self takeData];
            
            
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        }];
        
        
        self.imagePicker.maximumNumberOfPhotosToBeSelected = 3 - [self.imagePickerArray3 count];
        
        [self presentViewController:self.imagePicker animated:YES completion:^{}];
    }];
    [UIView animateWithDuration:0.25f animations:^{
        IPCView.frame = CGRectMake(0, screenHeight - IPCViewHeight -64, screenWidth, IPCViewHeight);
    } completion:^(BOOL finished) {
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:IPCView];
    
    self.IPCView = IPCView;
    
    [self.IPCView addImagePickerChooseView];
}

#define IPCViewHeight 120
-(void)initImagePickerChooseView4
{
    ImagePickerChooseView *IPCView = [[ImagePickerChooseView alloc]initWithFrame:CGRectMake(0, screenHeight + 64, screenWidth, IPCViewHeight) andAboveView:self.view];
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
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
            
        } andSuccessBlock:^(NSArray *info) {
            
            
            [self.imagePickerArray4 addObjectsFromArray:info];
            
            
            [self dismissViewControllerAnimated:YES completion:^{}];
            [self.IPCView disappear];
            
            [self saveData];
            
            [self initHeaderView];
            
            [self takeData];
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        }];
        
        
        self.imagePicker.maximumNumberOfPhotosToBeSelected = 3 - [self.imagePickerArray4 count];
        
        [self presentViewController:self.imagePicker animated:YES completion:^{}];
    }];
    [UIView animateWithDuration:0.25f animations:^{
        IPCView.frame = CGRectMake(0, screenHeight - IPCViewHeight -64, screenWidth, IPCViewHeight);
    } completion:^(BOOL finished) {
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:IPCView];
    
    self.IPCView = IPCView;
    
    [self.IPCView addImagePickerChooseView];
}

-(NSMutableArray *)imagePickerArray1
{
    if (!_imagePickerArray1) {
        _imagePickerArray1 = [[NSMutableArray alloc]init];
    }
    return _imagePickerArray1;
}

-(NSMutableArray *)imagePickerArray2
{
    if (!_imagePickerArray2) {
        _imagePickerArray2 = [[NSMutableArray alloc]init];
    }
    return _imagePickerArray2;
}

-(NSMutableArray *)imagePickerArray3
{
    if (!_imagePickerArray3) {
        _imagePickerArray3 = [[NSMutableArray alloc]init];
    }
    return _imagePickerArray3;
}

-(NSMutableArray *)imagePickerArray4
{
    if (!_imagePickerArray4) {
        _imagePickerArray4 = [[NSMutableArray alloc]init];
    }
    return _imagePickerArray4;
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
        if ([self.identityCardInfoLabel.text length]) {
            [self.identityCardInfoLabel resignFirstResponder];
        }
        else
        {
            return NO;
        }
    }
    return YES;
}

// 是否允许改变文本框的文字
// 是否允许用户输入
// 作用:拦截用户的输入
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return NO;
}

-(void)saveData{
        self.str1 =self.nameTextView.text;
        self.str2 =  self.phoneTextView.text;
        self.str3 =self.districtTextView.text;
        self.str4 = self.addressTextView.text;
        self.str5 = self.certificationTF.text;
        self.str6 =self.districtTextView.text;
        self.str7 = self.artTextView.text;
}

-(void)takeData{
        self.nameTextView.text = self.str1;
        self.phoneTextView.text = self.str2;
        self.districtTextView.text = self.str3;
        self.addressTextView.text = self.str4;
        self.certificationTF.text = self.str5;
        self.districtTextView.text = self.str6;
        self.artTextView.text = self.str7;  
}


-(void)querentijiao{
    
    //参数
    //籍贯
    NSString *province = self.districtTextView.text;
    //详细地址
    NSString *provinceName = self.addressTextView.text;
    
    //艺术类别
     NSString *artCategory = self.artTextView.text;
    //资格认证
     NSString *titleCertificate = self.certificationTF.text;
    
    //当前用户Id
    UserMyModel *model = TakeLoginUserModel;
    NSString *userId = model.ID;
    
    //类型
     NSString *paramType = @"0";
    
    //时间戳
    NSString *timestamp = [MyMD5 timestamp];
    
    //加密
    NSString *appkey = MD5key;
    NSString *signmsg = [NSString stringWithFormat:@"artCategory=%@&paramType=%@&province=%@&provinceName=%@&timestamp=%@&titleCertificate=%@&userId=%@&key=%@",artCategory,paramType,province,provinceName,timestamp,titleCertificate,userId,appkey];
    
    NSString *signmsgMD5 = [MyMD5 md5:signmsg];

    //图片数组
    NSMutableArray *tempArray1 = [NSMutableArray array];
    
    NSInteger count1 = 0;
    
    for (UIImage *image in self.imagePickerArray2) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        formatter.dateFormat = @"yyyyMMddHHmmssSSS";
        
        NSString *fileName = [NSString stringWithFormat:@"%@%@.png",[formatter stringFromDate:[NSDate date]],@(count1)];
        
        NSLog(@"%@",fileName);
        
        [tempArray1 addObject:fileName];
        
        count1++;
    }
    
    NSArray *one = tempArray1.copy;
    
    
    
    NSMutableArray *tempArray2 = [NSMutableArray array];
    NSInteger count2 = 0;
    
    for (UIImage *image in self.imagePickerArray3) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        formatter.dateFormat = @"yyyyMMddHHmmssSSS";
        
        NSString *fileName = [NSString stringWithFormat:@"%@%@.png",[formatter stringFromDate:[NSDate date]],@(count2)];
        
        NSLog(@"%@",fileName);
        
        [tempArray2 addObject:fileName];
        
        count2++;
    }
    
    NSArray *two = tempArray2.copy;
    
    
    NSMutableArray *tempArray3 = [NSMutableArray array];
    NSInteger count3 = 0;
    
    for (UIImage *image in self.imagePickerArray4) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        formatter.dateFormat = @"yyyyMMddHHmmssSSS";
        
        NSString *fileName = [NSString stringWithFormat:@"%@%@.png",[formatter stringFromDate:[NSDate date]],@(count3)];
        
        NSLog(@"%@",fileName);
        
        [tempArray3 addObject:fileName];
        
        count3++;
    }
    
    NSArray *three = tempArray3.copy;
    
    
    NSString *identityFront = @"identityFront.png";
    NSString *identityBack = @"identityBack.png";
    
    NSDictionary *json = @{
                           @"province" : province,
                           @"provinceName" : provinceName,
                           @"artCategory" : artCategory,
                           @"titleCertificate" : titleCertificate,
                           @"userId" : userId,
                           @"paramType" : paramType,
                           @"one"        :one,
                           @"two"        :two,
                           @"three"        :three,
                           @"identityFront" :identityFront,
                           @"identityBack"  :identityBack,
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    /*
    NSString *url = @"http://192.168.1.41:8080/app/applyArtMaster.do";
     
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    // 设置请求格式
    manger.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    [manger POST:url parameters:json constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSInteger imgCount = 0;
        
        //身份证正反面2张图片
//        UIImage *identityFrontImage2 = [UIImage imageWithCGImage:(__bridge CGImageRef _Nonnull)(identityFrontImage)];
        UIImage *identityFrontImage2  =  [UIImage imageWithCGImage:((ALAsset *)[self.imagePickerArray1 objectAtIndex:0]).thumbnail];
        NSLog(@"%@",[self.imagePickerArray1.firstObject class]);
        
         NSData *data1 = UIImageJPEGRepresentation(identityFrontImage2, 1.0);
        NSLog(@"data1 = %@",data1);
         [formData appendPartWithFileData:data1 name:@"identityFront" fileName:identityFront mimeType:@"application/octet-stream"];

//        UIImage *identityBackImage2 = [UIImage imageWithCGImage:(__bridge CGImageRef _Nonnull)(identityBackImage)];
        UIImage *identityBackImage2  =  [UIImage imageWithCGImage:((ALAsset *)[self.imagePickerArray1 objectAtIndex:1]).thumbnail];
        NSData *data2 = UIImageJPEGRepresentation(identityBackImage2, 1.0);
        [formData appendPartWithFileData:data2 name:@"identityBack" fileName:identityBack mimeType:@"application/octet-stream"];
        
        //三张作品图片
        
        for (int i = 0; i < self.imagePickerArray2.count; i++) {
            
            UIImage *image  =  [UIImage imageWithCGImage:((ALAsset *)[self.imagePickerArray2 objectAtIndex:i]).thumbnail];
            
            NSData *data = UIImageJPEGRepresentation(image, 1.0);
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            formatter.dateFormat = @"yyyyMMddHHmmssSSS";
            
            NSString *fileName = [NSString stringWithFormat:@"%@%@.png",[formatter stringFromDate:[NSDate date]],@(imgCount)];
            
            NSLog(@"%@",fileName);
            
            [formData appendPartWithFileData:data name:@"one" fileName:fileName mimeType:@"application/octet-stream"];
        }
        
        for (int i = 0; i < self.imagePickerArray3.count; i++) {
            
            UIImage *image  =  [UIImage imageWithCGImage:((ALAsset *)[self.imagePickerArray3 objectAtIndex:i]).thumbnail];
            
            NSData *data = UIImageJPEGRepresentation(image, 1.0);
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            formatter.dateFormat = @"yyyyMMddHHmmssSSS";
            
            NSString *fileName = [NSString stringWithFormat:@"%@%@.png",[formatter stringFromDate:[NSDate date]],@(imgCount)];
            
            NSLog(@"%@",fileName);
            
            [formData appendPartWithFileData:data name:@"two" fileName:fileName mimeType:@"application/octet-stream"];
        }
        
        for (int i = 0; i < self.imagePickerArray4.count; i++) {
            
            UIImage *image  =  [UIImage imageWithCGImage:((ALAsset *)[self.imagePickerArray4 objectAtIndex:i]).thumbnail];
            
            NSData *data = UIImageJPEGRepresentation(image, 1.0);
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            formatter.dateFormat = @"yyyyMMddHHmmssSSS";
            
            NSString *fileName = [NSString stringWithFormat:@"%@%@.png",[formatter stringFromDate:[NSDate date]],@(imgCount)];
            
            NSLog(@"%@",fileName);
            
            [formData appendPartWithFileData:data name:@"three" fileName:fileName mimeType:@"application/octet-stream"];
        }
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        SSLog(@"---%@---%@",[responseObject class],aString);
        
        
        
        //保存模型,赋值给控制器
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [MBProgressHUD showSuccess:@"申请成功"];
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        SSLog(@"%@",error);
        
        [MBProgressHUD showSuccess:@"申请失败,请重新申请"];
    }];
    */
    
    NSString *url = @"applyArtMaster.do";
    
    [[HttpRequstTool shareInstance] handlerNetworkingPOSTRequstWithServerUrl:url Parameters:json constructingBodyWithBlock:^(id formData) {

        NSInteger imgCount = 0;
        
        //身份证正反面2张图片
        //        UIImage *identityFrontImage2 = [UIImage imageWithCGImage:(__bridge CGImageRef _Nonnull)(identityFrontImage)];
        UIImage *identityFrontImage2  =  [UIImage imageWithCGImage:((ALAsset *)[self.imagePickerArray1 objectAtIndex:0]).thumbnail];
        NSLog(@"%@",[self.imagePickerArray1.firstObject class]);
        
        NSData *data1 = UIImageJPEGRepresentation(identityFrontImage2, 1.0);
        NSLog(@"data1 = %@",data1);
        [formData appendPartWithFileData:data1 name:@"identityFront" fileName:identityFront mimeType:@"application/octet-stream"];
        
        //        UIImage *identityBackImage2 = [UIImage imageWithCGImage:(__bridge CGImageRef _Nonnull)(identityBackImage)];
        UIImage *identityBackImage2  =  [UIImage imageWithCGImage:((ALAsset *)[self.imagePickerArray1 objectAtIndex:1]).thumbnail];
        NSData *data2 = UIImageJPEGRepresentation(identityBackImage2, 1.0);
        [formData appendPartWithFileData:data2 name:@"identityBack" fileName:identityBack mimeType:@"application/octet-stream"];
        
        //三张作品图片
        
        for (int i = 0; i < self.imagePickerArray2.count; i++) {
            
            UIImage *image  =  [UIImage imageWithCGImage:((ALAsset *)[self.imagePickerArray2 objectAtIndex:i]).thumbnail];
            
            NSData *data = UIImageJPEGRepresentation(image, 1.0);
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            formatter.dateFormat = @"yyyyMMddHHmmssSSS";
            
            NSString *fileName = [NSString stringWithFormat:@"%@%@.png",[formatter stringFromDate:[NSDate date]],@(imgCount)];
            
            NSLog(@"%@",fileName);
            
            [formData appendPartWithFileData:data name:@"one" fileName:fileName mimeType:@"application/octet-stream"];
        }
        
        for (int i = 0; i < self.imagePickerArray3.count; i++) {
            
            UIImage *image  =  [UIImage imageWithCGImage:((ALAsset *)[self.imagePickerArray3 objectAtIndex:i]).thumbnail];
            
            NSData *data = UIImageJPEGRepresentation(image, 1.0);
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            formatter.dateFormat = @"yyyyMMddHHmmssSSS";
            
            NSString *fileName = [NSString stringWithFormat:@"%@%@.png",[formatter stringFromDate:[NSDate date]],@(imgCount)];
            
            NSLog(@"%@",fileName);
            
            [formData appendPartWithFileData:data name:@"two" fileName:fileName mimeType:@"application/octet-stream"];
        }
        
        for (int i = 0; i < self.imagePickerArray4.count; i++) {
            
            UIImage *image  =  [UIImage imageWithCGImage:((ALAsset *)[self.imagePickerArray4 objectAtIndex:i]).thumbnail];
            
            NSData *data = UIImageJPEGRepresentation(image, 1.0);
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            formatter.dateFormat = @"yyyyMMddHHmmssSSS";
            
            NSString *fileName = [NSString stringWithFormat:@"%@%@.png",[formatter stringFromDate:[NSDate date]],@(imgCount)];
            
            NSLog(@"%@",fileName);
            
            [formData appendPartWithFileData:data name:@"three" fileName:fileName mimeType:@"application/octet-stream"];
        }
    } showHUDView:nil progress:^(id progress) {
        NSProgress *p = (NSProgress *)progress;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            float total = p.totalUnitCount;
            float completed = p.completedUnitCount;
            float i = completed / total;
            self.progressHUD.progress = i;
            if (i == 1) {
                self.progressHUD.labelText = [NSString stringWithFormat:@"发布成功"];
                self.progressHUD.mode = MBProgressHUDModeCustomView;
                [self.progressHUD hide:YES afterDelay:1];
                [self.navigationController popViewControllerAnimated:YES];
            }
        });
    } success:^(id respondObj) {
        
        NSString *aString = [[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        
        SSLog(@"---%@---%@",[respondObj class],aString);
        
        //保存模型,赋值给控制器
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [MBProgressHUD showSuccess:@"申请成功"];
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
