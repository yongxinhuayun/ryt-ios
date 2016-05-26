//
//  ComposeWorksViewController.m
//  融易投
//
//  Created by efeiyi on 16/5/12.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import "ComposeWorksViewController.h"
#import "TimeFiled.h"

#import <SVProgressHUD.h>

@interface ComposeWorksViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;

@property (weak, nonatomic) IBOutlet UITextField *workName;
@property (weak, nonatomic) IBOutlet TimeFiled *creatTime;

@property (weak, nonatomic) IBOutlet UITextField *materialText;

@end

@implementation ComposeWorksViewController

- (IBAction)btnClick:(id)sender {
    
    
    //创建UIAlertController是为了让用户去选择照片来源,拍照或者相册.
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:0];
    //设置选择图片的截取框
    //    imagePickerController.allowsEditing = YES;
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"可售" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        self.subLabel.text = @"可售";
        
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"已售" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        self.subLabel.text = @"已售";
        
    }];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"非卖品" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        self.subLabel.text = @"非卖品";
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action)
                                   {
                                       //这里可以不写代码
                                   }];
    
    
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addAction:action3];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
 }




- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.image = self.workImage;
    
    [self setUpNavBar];
}

// 设置导航条
-(void)setUpNavBar
{
    //设置导航条标题
    self.navigationItem.title = @"发布作品";
    
    //设置导航条按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    
    //运行程序,发现按钮没有出现导航条上面,因为没有设置尺寸
    [leftButton sizeToFit];
    
    [leftButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    
    //设置导航条按钮
    //设置导航条按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    [rightButton setTitle:@"发布" forState:UIControlStateNormal];
    
    //运行程序,发现按钮没有出现导航条上面,因为没有设置尺寸
    [rightButton sizeToFit];
    
    [rightButton addTarget:self action:@selector(fabu:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

-(void)cancel:(UIButton *)btn{
    
    SSLog(@"cancel");
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)fabu:(UIButton *)btn{
    
    SSLog(@"fabu");
    
    [self fabuToData];
}

-(void)fabuToData
{
    //参数
    NSString *name = self.workName.text;
    NSString *material = self.materialText.text;
    
    UserMyModel *userModel = TakeLoginUserModel;
    NSString *currentUserId = userModel.ID;

    NSString *createYear = self.creatTime.text;
    
    NSString *type = nil; //0:非卖品 1:可售 2:已售
    if ([self.subLabel.text isEqualToString:@"可售"]) {
        type = @"1";
    }else if ([self.subLabel.text isEqualToString:@"已售"]) {
        type = @"2";
    }else{
    
         type = @"0";
    }
    
   
    NSString *pictureUrl = self.createPath;
    NSString *timestamp = [MyMD5 timestamp];
    NSString *appkey = MD5key;
    
    NSString *signmsg = [NSString stringWithFormat:@"createYear=%@&currentUserId=%@&material=%@&name=%@&timestamp=%@&type=%@&key=%@",createYear,currentUserId,material,name,timestamp,type,appkey];
    
    NSString *signmsgMD5 = [MyMD5 md5:signmsg];

    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"name":name,
                           @"material" : material,
                           @"currentUserId" : currentUserId,
                           @"type":type,
                           @"pictureUrl":pictureUrl,
                           @"createYear":createYear,
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    
    NSString *url = @"http://192.168.1.75:8001/app/saveMasterWork.do";
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    // 设置请求格式
    manger.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
//    [manger POST:<#(nonnull NSString *)#> parameters:<#(nullable id)#> constructingBodyWithBlock:<#^(id<AFMultipartFormData>  _Nonnull formData)block#> progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:<#^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)success#> failure:<#^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)failure#>]
    
    [manger POST:url parameters:json constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:self.createPath] name:@"pictureUrl" fileName:@"pictureUrl.jpg" mimeType:@"application/octet-stream" error:nil];
        
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
//        NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        
//        SSLog(@"%@",aString);
        
        
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
            
        }];
    }];
     
    
    /*
    NSString *url = @"saveMasterWork.do";
    
    [[HttpRequstTool shareInstance] handlerNetworkingPOSTRequstWithServerUrl:url Parameters:json constructingBodyWithBlock:^(id formData) {
        
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:self.createPath] name:@"pictureUrl" fileName:@"pictureUrl.jpg" mimeType:@"application/octet-stream" error:nil];
        
    } showHUDView:nil success:^(id respondObj) {
        
//        NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        SSLog(@"%@",aString);
        [SVProgressHUD showInfoWithStatus:@"发布成功"];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        
        //在主线程刷新UI数据
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [SVProgressHUD dismiss];
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
     */

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
