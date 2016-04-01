//
//  CompleteUserInfoController.m
//  融易投
//
//  Created by efeiyi on 16/3/31.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "CompleteUserInfoController.h"
#import "UIImageView+WebCache.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

#import "HTTPSessionManager.h"

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
    
    //设置默认的头像
    NSURL *url = [NSURL URLWithString:@"http://e.hiphotos.baidu.com/image/pic/item/9825bc315c6034a852fd0096c81349540923768d.jpg"];
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:url options:kNilOptions progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        // expectedSize 下载的图片的总大小
        // receivedSize 已经接受的大小
        NSLog(@"expectedSize = %ld, receivedSize = %ld", expectedSize, receivedSize);
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        NSLog(@"%@", image);
        self.imageView.image = image;
    }];
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
    
//    static let filePath = "userAccount.plist".cachesDir()
    
    [self writeImageToCaches:newImage];

}
-(void)test{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *createPath = [NSString stringWithFormat:@"%@/Image", pathDocuments];
    NSString *createDir = [NSString stringWithFormat:@"%@/MessageQueueImage", pathDocuments];
    
    // 判断文件夹是否存在，如果不存在，则创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createDirectoryAtPath:createDir withIntermediateDirectories:YES attributes:nil error:nil];
    } else {
        NSLog(@"FileDir is exists.");
    }
    self.createPath = createPath;
}

-(void)writeImageToCaches:(UIImage *)newImage{

    // 获取cache文件夹
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *createPath = [NSString stringWithFormat:@"%@", cachePath];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    // 判断文件夹是否存在，如果不存在，则创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        NSLog(@"%@",createPath);
    } else {
        NSLog(@"FileDir is exists.");
    }
    
    NSData *data = UIImagePNGRepresentation(newImage);
    ///Users/Library/Developer/CoreSimulator/Devices/6583B10A-003B-4C06-A734-73D83653D51B/data/Containers/Data/Application/51302A6F-2EE6-407B-A0CF-A26E54941DD3/Library/Caches/imageCache/iconImage/icon.png
    
    [data writeToFile:[NSString stringWithFormat:@"%@.png",createPath] atomically:YES];

    NSLog(@"11111111%@",NSHomeDirectory());
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
    
    

}

-(void)loadData
{
    //时间
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a =[date timeIntervalSince1970] * 1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    
    NSArray *strArray = [timeString componentsSeparatedByString:@"."];
    
    NSLog(@"%@",strArray.firstObject);
    
    //参数
    NSString *username = self.usernameTextField.text;
    NSString *nickname = self.nicknameTextField.text;
    
    NSString *headPortrait = [NSString stringWithFormat:@"%@.png",self.createPath];
    
    NSString *sex = @"1";
    NSString *timestamp = strArray.firstObject;
    NSString *appkey = @"BL2QEuXUXNoGbNeHObD4EzlX+KuGc70U";
    
    NSLog(@"username=%@,password=%@,timestamp=%@",username,nickname,timestamp);
    
    NSArray *arra = @[@"username",@"password",@"timestamp"];
    NSArray *sortArr = [arra sortedArrayUsingSelector:@selector(compare:)];
    NSLog(@"%@",sortArr);
    
    NSString *signmsg = [NSString stringWithFormat:@"headPortrait=%@$nickname=%@$sex=%@&timestamp=%@&username=%@&key=%@",headPortrait,nickname,sex,timestamp,username,appkey];
    NSLog(@"%@",signmsg);
    
    NSString *signmsgMD5 = [self md5:signmsg];
    
    //对key进行自然排序
    //    for (NSString *s in [dict allKeys]) {
    //        NSLog(@"value: %@", s);
    //    }
    
    NSLog(@"signmsgMD5=%@",signmsgMD5);
    
    // 1.创建请求 http://j.efeiyi.com:8080/app-wikiServer/
    NSURL *url = [NSURL URLWithString:@"http://j.efeiyi.com:8080/app-wikiServer/app/completeUserInfo.do"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    // 2.设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"username" : username,
                           @"nickname" : nickname,
                           @"headPortrait":headPortrait,
                           @"sex"      : sex,
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    
    //    NSData --> NSDictionary
    // NSDictionary --> NSData
    NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPBody = data;
    
    // 4.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSString *obj =  [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",obj);
        
    }];
}

-(NSString *)md5:(NSString *)inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

@end
