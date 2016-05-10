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


#import <SVProgressHUD.h>

@interface ComposeProjectViewController ()<UITextViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UITextField *projectTextField;
@property (weak, nonatomic) IBOutlet UITextView *progectTextView;

@property (weak, nonatomic) IBOutlet UITextField *projecTotaltTextField;
@property (weak, nonatomic) IBOutlet UITextField *projectTimeTextField;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@property (strong,nonatomic) NSString *createPath;

@end

@implementation ComposeProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.contentSize = CGSizeMake(SSScreenW, 2000);
    self.scrollView.delegate = self;
    self.scrollView.scrollEnabled = YES;
    
    [self setUpNavBar];
    
    [self setupTextView];
    
    
    //设置图片能够点击
    //记住:UIImageView默认情况下是不能接收事件的,如果要执行点击方法,必须把默认的User interaction Enable 改成yes
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    
    [self.imageView addGestureRecognizer:tapGesture];
    
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
    self.placeholderLabel.hidden = [self.progectTextView.text length];
    
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
    
    
    self.progectTextView.delegate = self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.projectTextField resignFirstResponder];
    [self.progectTextView resignFirstResponder];
    [self.projecTotaltTextField resignFirstResponder];
    [self.projectTimeTextField resignFirstResponder];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    [self.projectTextField resignFirstResponder];
    [self.progectTextView resignFirstResponder];
    [self.projecTotaltTextField resignFirstResponder];
    [self.projectTimeTextField resignFirstResponder];
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
        if ([self.progectTextView.text length]) {
            [self.progectTextView resignFirstResponder];
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
- (IBAction)nextBtnClick:(id)sender {
    
    [self loadData];
    
    //这个暂时不用
    //    ComposeViewController *compose = [[ComposeViewController alloc] init];
    //    [self.navigationController pushViewController:compose animated:YES];
    
    // 弹出发微博控制器
    //    HMComposeViewController *compose = [[HMComposeViewController alloc] init];
    //    [self.navigationController pushViewController:compose animated:YES];
    
    //
    UIStoryboard *releaseStoryBoard = [UIStoryboard storyboardWithName:NSStringFromClass([ReleaseViewController class]) bundle:nil];
    ReleaseViewController *releaseVC = [releaseStoryBoard instantiateInitialViewController];
    [self presentViewController:releaseVC animated:YES completion:nil];
    
    
    //    TestViewController *test = [[TestViewController alloc] init];
    //    [self.navigationController pushViewController:test animated:YES];
    
}


-(void)loadData
{
    //参数
    
    //    NSString *projectTitle =  self.projectTextField.text;
    //
    //    NSString *title = [projectTitle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if ([self.projectTextField.text isEqualToString:@""]) {
        
        [SVProgressHUD showInfoWithStatus:@"项目标题不能为空"];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    }
    
    if ([self.progectTextView.text isEqualToString:@""]) {
        
        [SVProgressHUD showInfoWithStatus:@"项目简介不能为空"];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    }
    
    if ([self.projectTimeTextField.text isEqualToString:@""]) {
        
        [SVProgressHUD showInfoWithStatus:@"创作时长不能为空"];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    }
    
    if ([self.projecTotaltTextField.text isEqualToString:@""]) {
        
        [SVProgressHUD showInfoWithStatus:@"融资金额不能为空"];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    }
    
    NSString *title =  self.projectTextField.text;
    NSString *brief = self.progectTextView.text;
    NSString *duration = self.projectTimeTextField.text;
    NSString *userId = @"imhfp1yr4636pj49";
    NSString *picture_url = self.createPath;
    NSString *investGoalMoney = self.projecTotaltTextField.text;
    
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
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        SSLog(@"%@",error);
        
//        [SVProgressHUD showSuccessWithStatus:@"发布失败 " maskType:SVProgressHUDMaskTypeBlack];
        
        [SVProgressHUD showInfoWithStatus:@"发布失败"];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        
        //在主线程刷新UI数据
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [SVProgressHUD dismiss];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
    }];
    
    
}

//实现相机的代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //移除原来的图片
    self.imageView.image = nil;
    
    //保存被选中图片
    //UIImagePickerControllerEditedImage
    UIImage *selctedImage = info[UIImagePickerControllerOriginalImage];
    
    //取消modal
    [self dismissViewControllerAnimated:self completion:nil];
    
    //    self.drawView.image = selctedImage;
    //    SSLog(@"%@",selctedImage);
    
    UIImage *newImage = [self drawImageWith:selctedImage imageWidth:100];
    //    NSLog(@"newImage = %d",);
    
    
    //    NSData *data = UIImagePNGRepresentation(newImage);
    //    NSString *filename = @"image";
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    self.imageView.image = newImage;
    
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
