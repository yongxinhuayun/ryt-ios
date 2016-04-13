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
#import <SVProgressHUD.h>


@interface ReleaseProjectViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet HMEmotionTextView *progectTextView;
@property (weak, nonatomic) IBOutlet UITextField *projectTextField;

@property (weak, nonatomic) IBOutlet UITextField *projecTotaltTextField;
@property (weak, nonatomic) IBOutlet UITextField *projectTimeTextField;


@property (strong,nonatomic) NSString *createPath;

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
    
//    [self loadData];
    
    // 弹出发微博控制器
    HMComposeViewController *compose = [[HMComposeViewController alloc] init];
    
    [self.navigationController pushViewController:compose animated:YES];
}


-(void)loadData
{
    //参数
    
    NSString *projectTitle =  self.projectTextField.text;
    
    NSString *title = [projectTitle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
    NSString *url = @"http://192.168.1.69:8001/app/initNewArtWork.do";
    
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
        
        SSLog(@"%@---%@",[responseObject class],aString);
        
        [SVProgressHUD showSuccessWithStatus:@"发布成功" maskType:SVProgressHUDMaskTypeBlack];

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        SSLog(@"%@",error);
        
         [SVProgressHUD showSuccessWithStatus:@"发布失败 " maskType:SVProgressHUDMaskTypeBlack];
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





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
