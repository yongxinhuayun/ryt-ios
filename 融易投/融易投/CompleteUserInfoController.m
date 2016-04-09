//
//  CompleteUserInfoController.m
//  融易投
//
//  Created by efeiyi on 16/3/31.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "CompleteUserInfoController.h"
#import "UIImageView+WebCache.h"

#import <AFNetworking.h>
#import "UIImageView+WebCache.h"



@interface CompleteUserInfoController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (weak, nonatomic) IBOutlet UIButton *sexBtn;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (strong,nonatomic) NSString *createPath;

@end

@implementation CompleteUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.usernameTextField resignFirstResponder];
    [self.nicknameTextField resignFirstResponder];
}

- (IBAction)uploadIconBtnClick:(id)sender {
    
    
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

- (IBAction)uploadSexBtnClick:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"性别" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.sexLabel.text = @"男";
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.sexLabel.text = @"女";
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
- (IBAction)completeBtnClick:(id)sender {
    
        [self loadData];
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
    NSLog(@"%@",selctedImage);
    
    UIImage *newImage = [self drawImageWith:selctedImage imageWidth:100];
    //    NSLog(@"newImage = %d",);
    
    
    //    NSData *data = UIImagePNGRepresentation(newImage);
    //    NSString *filename = @"image";
    
    self.imageView.image = newImage;
    
    selctedImage = nil;
    
    self.createPath = [self writeImageToCaches:newImage];
    
}

//-(void)test{
//    NSFileManager *fileManager = [[NSFileManager alloc] init];
//    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *createPath = [NSString stringWithFormat:@"%@/Image", pathDocuments];
//    NSString *createDir = [NSString stringWithFormat:@"%@/MessageQueueImage", pathDocuments];
//    
//    // 判断文件夹是否存在，如果不存在，则创建
//    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
//        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
//        [fileManager createDirectoryAtPath:createDir withIntermediateDirectories:YES attributes:nil error:nil];
//    } else {
//        NSLog(@"FileDir is exists.");
//    }
//    self.createPath = createPath;
//}

-(NSString *)writeImageToCaches:(UIImage *)newImage{
    
    // 获取cache文件夹
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *createPath = [NSString stringWithFormat:@"%@/", cachePath];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    // 判断文件夹是否存在，如果不存在，则创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        NSLog(@"%@",createPath);
        
    } else {
        NSLog(@"FileDir is exists.");
    }
    
    NSData *data = UIImagePNGRepresentation(newImage);
    
    NSString *iconName = @"icon.png";
    NSString *path = [NSString stringWithFormat:@"%@/%@",createPath,iconName];
    
    [data writeToFile:[NSString stringWithFormat:@"%@.png",createPath] atomically:YES];
    
//    NSLog(@"%@",NSHomeDirectory());
//    NSLog(@"%@",self.createPath);
    

    
    return createPath;
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


 -(void)loadData
 {
     //参数
     NSString *username = self.usernameTextField.text;
     NSString *nickname = self.nicknameTextField.text;
     
     NSString *headPortrait = @"image.png";
     NSLog(@"%@",headPortrait);
     
     NSString *sex = @"1";
     NSString *timestamp = [MyMD5 timestamp];
     NSString *appkey = MD5key;
     
     NSString *signmsg = [NSString stringWithFormat:@"nickname=%@&sex=%@&timestamp=%@&username=%@&key=%@",nickname,sex,timestamp,username,appkey];
     
     NSLog(@"%@",signmsg);
     
     NSString *signmsgMD5 = [MyMD5 md5:signmsg];
     
    // 1.创建请求 http://j.efeiyi.com:8080/app-wikiServer/
    NSString *url = @"http://192.168.1.69:8001/app/completeUserInfo.do";
     
     // 3.设置请求体
     NSDictionary *json = @{
                             @"username" : username,
                             @"nickname" : nickname,
                             @"headPortrait":headPortrait,
                             @"sex"      : sex,
                             @"timestamp" : timestamp,
                             @"signmsg"   : signmsgMD5
                        };
     
//     [HttpRequstTool shareInstance];
     
     AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
     
     // 设置请求格式
     manger.requestSerializer = [AFJSONRequestSerializer serializer];
     // 设置返回格式
     manger.responseSerializer = [AFHTTPResponseSerializer serializer];
     
     
     [manger POST:url parameters:json constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
         
         NSString *path = @"111";
         
         [formData appendPartWithFileURL:[NSURL fileURLWithPath:path] name:@"headPortrait" fileName:@"headPortrait.jpg" mimeType:@"application/octet-stream" error:nil];

         
     } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
         
     NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
     
     NSLog(@"上传成功---%@---%@",[responseObject class],aString);

         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         NSLog(@"%@",error);
     }];
     
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
