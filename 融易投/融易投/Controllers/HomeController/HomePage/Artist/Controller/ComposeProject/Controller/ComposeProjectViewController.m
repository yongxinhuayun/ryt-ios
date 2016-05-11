//
//  ComposeProjectViewController.m
//  融易投
//
//  Created by efeiyi on 16/5/10.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "ComposeProjectViewController.h"

#import "ReleaseViewController.h"

#import "ArtWorkIdModel.h"
#import <MJExtension.h>

#import "FabuProjectView.h"


#import <SVProgressHUD.h>

@interface ComposeProjectViewController ()<UITextViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong,nonatomic) FabuProjectView *composeProjectView;
@property (strong,nonatomic) NSString *createPath;


@end

@implementation ComposeProjectViewController

-(UIScrollView *)scrollView{

    if (_scrollView == nil) {
        
        _scrollView = [[UIScrollView alloc] init];
    }
    return  _scrollView;
}

BOOL isPop = NO;

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    if (isPop) {
        
        isPop = NO;
        [self.navigationController popViewControllerAnimated:NO];
    }
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.scrollView.frame = CGRectMake(0, 0, SSScreenW, SSScreenH);

    
    FabuProjectView *composeProjectView = [FabuProjectView composeProjectView];
    composeProjectView.frame = CGRectMake(0, 0, SSScreenW, SSScreenH + 200);
    self.composeProjectView = composeProjectView;
    
    
    
    CGFloat height = CGRectGetMaxY(composeProjectView.nextBtn.frame);
    
    self.scrollView.contentSize = CGSizeMake(0, height + SSMargin);
    self.scrollView.delegate = self;
    self.scrollView.scrollEnabled = YES;
    
//    [self.view addSubview:nextBtn];
//    [self.view bringSubviewToFront:nextBtn];
//    [self.view insertSubview:nextBtn belowSubview:self.view];
//    [self.scrollView addSubview:nextBtn];
    
    [composeProjectView.nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.scrollView addSubview:composeProjectView];
    
    
    [self.view addSubview:self.scrollView];
    

    
    [self setUpNavBar];
    
    [self setupTextView];
    
    
    //设置图片能够点击
    //记住:UIImageView默认情况下是不能接收事件的,如果要执行点击方法,必须把默认的User interaction Enable 改成yes
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    
    [self.composeProjectView.imageView addGestureRecognizer:tapGesture];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

// 添加输入控件
- (void)setupTextView
{
    //让textView在左上角出现光标
//    self.automaticallyAdjustsScrollViewInsets = false;
    
    //设置placeholderLabel隐藏
    self.composeProjectView.placeholderLabel.hidden = [self.composeProjectView.progectTextView.text length];
    
    //添加边框
//    self.progectTextView.layer.backgroundColor = [[UIColor clearColor] CGColor];
//    
//    self.progectTextView.layer.borderColor = [[UIColor colorWithRed:226.0/255.0 green:226.0/255.0 blue:226.0/255.0 alpha:1.0]CGColor];
//    
//    self.progectTextView.layer.borderWidth = 1.0;
//    
//    self.progectTextView.layer.cornerRadius = 8.0f;
//    
//    [self.progectTextView.layer setMasksToBounds:YES];
    
    
    self.composeProjectView.progectTextView.delegate = self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.composeProjectView.projectTextField resignFirstResponder];
    [self.composeProjectView.progectTextView resignFirstResponder];
    [self.composeProjectView.projecTotaltTextField resignFirstResponder];
    [self.composeProjectView.projectTimeTextField resignFirstResponder];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    [self.composeProjectView.projectTextField resignFirstResponder];
    [self.composeProjectView.progectTextView resignFirstResponder];
    [self.composeProjectView.projecTotaltTextField resignFirstResponder];
    [self.composeProjectView.projectTimeTextField resignFirstResponder];
}

#pragma mark - Text View Delegate
-(void)textViewDidChange:(UITextView *)textView
{
    self.composeProjectView.placeholderLabel.hidden = [textView.text length];
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([@"\n" isEqualToString:text])
    {
        if ([self.composeProjectView.progectTextView.text length]) {
            [self.composeProjectView.progectTextView resignFirstResponder];
        }
        else
        {
            return NO;
        }
    }
    return YES;
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


// 设置导航条
-(void)setUpNavBar
{
    //设置导航条标题
    self.navigationItem.title = @"发起新项目";
    
    
}

- (void)nextBtnClick:(UIButton *)btn{
    
    if ([self panduanWeiKong]) {
        
        
        [self loadData];

    }
}



-(BOOL)panduanWeiKong {

    BOOL isSpace = YES;
    
    //判断是否填写了项目标题
    if ([self.composeProjectView.projectTextField.text isEqualToString:@""]) {
        
        [SVProgressHUD showInfoWithStatus:@"项目标题不能为空"];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        
        isSpace = NO;
    }
    
    //判断是否填写了项目简介
    if (!(self.composeProjectView.progectTextView.text.length > 0)) {
        
        [SVProgressHUD showInfoWithStatus:@"项目简介不能为空"];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        
        isSpace = NO;
    }
    
    //判断是否填写了创作时长
    if ([self.composeProjectView.projectTimeTextField.text isEqualToString:@""]) {
        
        [SVProgressHUD showInfoWithStatus:@"创作时长不能为空"];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        
        isSpace = NO;
    }
    
    //判断是否填写了融资金额
    if ([self.composeProjectView.projecTotaltTextField.text isEqualToString:@""]) {
        
        [SVProgressHUD showInfoWithStatus:@"融资金额不能为空"];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        
        isSpace = NO;
    }
    
    //判断是否上传了图片
    if (self.composeProjectView.imageView.contentMode != UIViewContentModeScaleToFill) {
        
        [SVProgressHUD showInfoWithStatus:@"请上传项目的效果图或参考图"];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        
        isSpace = NO;
    }

    return isSpace;
}

-(void)loadData
{
    
    //参数
    //    NSString *projectTitle =  self.projectTextField.text;
    //
    //    NSString *title = [projectTitle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSString *title =  self.composeProjectView.projectTextField.text;
    NSString *brief = self.composeProjectView.progectTextView.text;
    NSString *duration = self.composeProjectView.projectTimeTextField.text;
    NSString *userId = @"imhfp1yr4636pj49";
    NSString *picture_url = self.createPath;
    NSString *investGoalMoney = self.composeProjectView.projecTotaltTextField.text;
    
    NSString *timestamp = [MyMD5 timestamp];
    NSString *appkey = MD5key;
    
    NSString *signmsg = [NSString stringWithFormat:@"duration=%@&investGoalMoney=%@&timestamp=%@&title=%@&userId=%@&key=%@",duration,investGoalMoney,timestamp,title,userId,appkey];
    
    NSLog(@"%@",signmsg);
    
    NSString *signmsgMD5 = [MyMD5 md5:signmsg];
    
    // 1.创建请求 http://j.efeiyi.com:8080/app-wikiServer/
    NSString *url = @"http://192.168.1.41:8080/app/initNewArtWork.do";
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"title" : title,
                           @"brief" : brief,
                           @"duration":duration,
                           @"userId"   : userId,
                           @"picture_url":picture_url,
                           @"investGoalMoney"  : investGoalMoney,
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    // 设置请求格式
    manger.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    [manger POST:url parameters:json constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:self.createPath] name:@"picture_url" fileName:@"picture_url.jpg" mimeType:@"application/octet-stream" error:nil];
        
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        SSLog(@"%@",aString);
        //{"artworkId":"imyapayc1rttrjbz","resultCode":"0","resultMsg":"成功"}
        
        ArtWorkIdModel *artWorkId = [ArtWorkIdModel mj_objectWithKeyValues:responseObject];
        
        // 3.打印MJUser模型的属性
        NSLog(@"artworkId = %@",artWorkId.artworkId);
        
        [[NSUserDefaults standardUserDefaults] setObject:artWorkId.artworkId forKey:@"artworkId"];
        
//        [SVProgressHUD showSuccessWithStatus:@"发布成功" maskType:SVProgressHUDMaskTypeBlack];
        
        [SVProgressHUD showInfoWithStatus:@"发布成功"];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        
        //在主线程刷新UI数据
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [SVProgressHUD dismiss];
            
          
                UIStoryboard *releaseStoryBoard = [UIStoryboard storyboardWithName:NSStringFromClass([ReleaseViewController class]) bundle:nil];
                ReleaseViewController *releaseVC = [releaseStoryBoard instantiateInitialViewController];
                isPop = YES;
                
                [self.navigationController pushViewController:releaseVC animated:YES];
    
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        SSLog(@"%@",error);
        
//        [SVProgressHUD showSuccessWithStatus:@"发布失败 " maskType:SVProgressHUDMaskTypeBlack];
        
        [SVProgressHUD showInfoWithStatus:@"发布失败"];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        
        //在主线程刷新UI数据
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [SVProgressHUD dismiss];
            
        }];
    }];
    
    
}

//实现相机的代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //移除原来的图片
    self.composeProjectView.imageView.image = nil;
    
    //保存被选中图片
    //UIImagePickerControllerEditedImage
    UIImage *selctedImage = info[UIImagePickerControllerOriginalImage];
    
    //取消modal
    [self dismissViewControllerAnimated:self completion:nil];
    
    //    self.drawView.image = selctedImage;
    //    SSLog(@"%@",selctedImage);
    
    UIImage *newImage = [self drawImageWith:selctedImage imageWidth:SSScreenW - 2 * SSMargin];
    //    NSLog(@"newImage = %d",);
    
    
    //    NSData *data = UIImagePNGRepresentation(newImage);
    //    NSString *filename = @"image";
    self.composeProjectView.imageView.contentMode = UIViewContentModeScaleToFill;
    self.composeProjectView.imageView.image = newImage;
    
    selctedImage = nil;
    
    self.createPath = [self writeImageToCaches:newImage];
    
    //    SSLog(@"%@",self.createPath);
}

-(NSString *)writeImageToCaches:(UIImage *)newImage{
    
    // 获取cache文件夹
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *createPath = [NSString stringWithFormat:@"%@/", cachePath];
    
    NSString *iconName = @"picture_url.png";
    NSString *path = [NSString stringWithFormat:@"%@%@",createPath,iconName];
    
    SSLog(@"%@",path);
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    // 判断文件夹是否存在，如果不存在，则创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        SSLog(@"%@",path);
        
    } else {
        SSLog(@"FileDir is exists.");
    }
    
    NSData *data = UIImagePNGRepresentation(newImage);
    
    [data writeToFile:[NSString stringWithFormat:@"%@",path] atomically:YES];
    
    return path;
}

// 将指定图片按照指定的宽度缩放
-(UIImage *)drawImageWith:(UIImage *)image imageWidth:(CGFloat)imageWidth{
    
    CGFloat imageHeight = (image.size.height / image.size.width) * imageWidth;
    CGSize size = CGSizeMake(imageWidth, imageHeight);
    
    // 1.开启图形上下文
    UIGraphicsBeginImageContext(size);
    // 2.绘制图片
    [image drawInRect:CGRectMake(0, 0, imageWidth, imageHeight)];
    // 3.从上下文中取出图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 4.关闭上下文
    return newImage;
}




@end
