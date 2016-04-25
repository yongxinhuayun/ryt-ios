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

@interface EditingInfoViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong,nonatomic) NSString *createPath;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;

@end

@implementation EditingInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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
            [self.navigationController pushViewController:editingNickNameVC animated:YES];
            
        }else if (indexPath.row == 1){
            
            EditingSignatureViewController *editingSignatureVC = [[EditingSignatureViewController alloc] init];
            [self.navigationController pushViewController:editingSignatureVC animated:YES];
            
        }else if (indexPath.row == 2){
            
            [self editingSex];
        }
    
    }
}

-(void)editingIcon{

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

//实现相机的代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //移除原来的图片
    self.iconImageView.image = nil;
    
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
    
    self.iconImageView.image = newImage;
    
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

-(void)editingSex{

    //创建UIAlertController是为了让用户去选择照片来源,拍照或者相册.
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:0];
    
    UIAlertAction *menAction = [UIAlertAction actionWithTitle:@"男" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        self.sexLabel.text = @"男";
        
    }];
    
    UIAlertAction *womenAction = [UIAlertAction actionWithTitle:@"女" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        self.sexLabel.text = @"女";
    }];
    
    UIAlertAction *keepSecretAction = [UIAlertAction actionWithTitle:@"保密" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
       self.sexLabel.text = @"保密";
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

@end
