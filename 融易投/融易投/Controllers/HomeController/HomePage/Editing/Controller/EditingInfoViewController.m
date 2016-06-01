//
//  EditingInfoViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/22.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "EditingInfoViewController.h"

#import "EditingNickNameViewController.h"
#import "EditingSignatureViewController.h"
#import "AddressViewController.h"
#import "PageInfoModel.h"
#import <MJExtension.h>

@interface EditingInfoViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,MBProgressHUDDelegate>

@property (strong,nonatomic) NSString *createPath;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;
@property(nonatomic,strong) MBProgressHUD *progressHUD;

@end

@implementation EditingInfoViewController

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
    
    [self setupUserInfo];
}

-(void)setupUserInfo{

    //设置网络上的用户信息
    [self.iconImageView ss_setHeader:[NSURL URLWithString:self.userModel.user.pictureUrl]];
    self.nickNameLabel.text = self.userModel.user.name;
    self.signatureLabel.text = self.userModel.user.signMessage;
    
    if ([self.userModel.user.sex isEqualToString:@"0"]) {
        self.sexLabel.text = @"保密";
    }else if ([self.userModel.user.sex isEqualToString:@"1"]) {
        self.sexLabel.text = @"男";
    }else if ([self.userModel.user.sex isEqualToString:@"2"]) {
        self.sexLabel.text = @"女";
    }
}

// 设置导航条
-(void)setUpNavBar
{
    //设置导航条标题
    self.navigationItem.title = @"编辑资料";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            [self editingIcon];
        }
    }else {
    
        if (indexPath.row == 0) {
            
            EditingNickNameViewController *editingNickNameVC = [[EditingNickNameViewController alloc] init];
            
            //逆传
            editingNickNameVC.valueBlcok = ^(NSString *str){
                
                self.nickNameLabel.text = str;
            };
            
            //顺传
            editingNickNameVC.nickName = self.nickNameLabel.text;
            [self.navigationController pushViewController:editingNickNameVC animated:YES];
            
        }else if (indexPath.row == 1){
            
            EditingSignatureViewController *editingSignatureVC = [[EditingSignatureViewController alloc] init];
            
            //逆传
            editingSignatureVC.valueBlcok = ^(NSString *str){
                
                self.signatureLabel.text = str;
                
            };
            
            //顺传
            editingSignatureVC.singature = self.signatureLabel.text;
            
            [self.navigationController pushViewController:editingSignatureVC animated:YES];
            
        }else if (indexPath.row == 2){
            
            [self editingSex];
        }else if (indexPath.row == 3){
            
//            AddressViewController *addressVC = [[AddressViewController alloc] init];
//            [self.navigationController pushViewController:addressVC animated:YES];
        }
    
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section != 0) {
        return 49;
    }else{
        return 64;
    }
}

-(void)editingIcon{

    //创建UIAlertController是为了让用户去选择照片来源,拍照或者相册.
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:0];
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
    
    //设置选择图片的截取框
    imagePickerController.allowsEditing = YES;
    
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

//实现相机的代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //移除原来的图片
    self.iconImageView.image = nil;
    self.view.layer.cornerRadius = 25;
    self.view.layer.masksToBounds = YES;
    
    //保存被选中图片
    //UIImagePickerControllerEditedImage
    UIImage *selctedImage = info[UIImagePickerControllerOriginalImage];
    
    UIImage *newImage = [self drawImageWith:selctedImage imageWidth:100];

    self.iconImageView.image = newImage;
    
    selctedImage = nil;
    
    self.createPath = [self writeImageToCaches:newImage];
    
    SSLog(@"%@",self.createPath);
    
    [self chageUserPictureUrlToData];
}

-(NSString *)writeImageToCaches:(UIImage *)newImage{
    
    // 获取cache文件夹
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *createPath = [NSString stringWithFormat:@"%@/", cachePath];
    
    NSString *iconName = @"headPortrait.jpg";
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

-(void)editingSex{

    //创建UIAlertController是为了让用户去选择照片来源,拍照或者相册.
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:0];
    
    UIAlertAction *menAction = [UIAlertAction actionWithTitle:@"男" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        self.sexLabel.text = @"男";
        [self chageSexToData:@"1"];
        
    }];
    
    UIAlertAction *womenAction = [UIAlertAction actionWithTitle:@"女" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        self.sexLabel.text = @"女";
         [self chageSexToData:@"2"];
    }];
    
    UIAlertAction *keepSecretAction = [UIAlertAction actionWithTitle:@"保密" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
       self.sexLabel.text = @"保密";
         [self chageSexToData:@"0"];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action)
                                   {
                                       //这里可以不写代码
                                   }];
    
    
    [alertController addAction:menAction];
    [alertController addAction:womenAction];
    [alertController addAction:keepSecretAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)chageSexToData:(NSString *)sex{

    //1 男 2 女
    //参数
    UserMyModel *model = TakeLoginUserModel;
    NSString *userId = model.ID;
    NSString *type = @"14";
    NSString *content = sex;
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"userId":userId,
                           @"type" : type,
                           @"content" : content
                           };
    NSString *url = @"editProfile.do";
    
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:url parameters:json showHUDView:nil andBlock:^(id respondObj) {
        
//        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
//        NSLog(@"返回结果:%@",jsonStr);
        
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        
        UserMyModel *model = [UserMyModel mj_objectWithKeyValues:modelDict[@"userInfo"]];
        [MBProgressHUD hideHUD];
        if (model) {
            [MBProgressHUD showSuccess:@"修改性别成功"];
        }
    }];

}

-(void)chageUserPictureUrlToData{

     //1 男 2 女
     //参数
     UserMyModel *model = TakeLoginUserModel;
     NSString *userId = model.ID;
     NSString *headPortrait = self.createPath;
     NSString *timestamp = [MyMD5 timestamp];
     NSString *appkey = MD5key;
     
     NSString *signmsg = [NSString stringWithFormat:@"timestamp=%@&userId=%@&key=%@",timestamp,userId,appkey];
     
     NSString *signmsgMD5 = [MyMD5 md5:signmsg];
     
     // 3.设置请求体
     NSDictionary *json = @{
                             @"userId":userId,
                             @"headPortrait":headPortrait,
                             @"timestamp":timestamp,
                             @"signmsg"   : signmsgMD5
                             };
     
     NSString *url = @"editPicUrl.do";
    
    [[HttpRequstTool shareInstance] handlerNetworkingPOSTRequstWithServerUrl:url Parameters:json constructingBodyWithBlock:^(id formData) {
        
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:self.createPath] name:@"headPortrait" fileName:@"headPortrait.jpg" mimeType:@"application/octet-stream" error:nil];
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
        
//        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
//        NSLog(@"返回结果:%@",jsonStr);
        
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        
        UserMyModel *model = [UserMyModel mj_objectWithKeyValues:modelDict[@"userInfo"]];
        [MBProgressHUD hideHUD];
        if (model) {
            
            [MBProgressHUD showSuccess:@"修改照片成功"];
            
            //发送通知,修改我的界面的数据
            [[NSNotificationCenter defaultCenter] postNotificationName:UpdateMeViewDataControllerNotification object:self];
            
            //保存模型,赋值给控制器
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                //取消modal
                [self dismissViewControllerAnimated:self completion:nil];
            }];
            
        }
    }];
}


@end
