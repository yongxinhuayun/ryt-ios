//
//  HMComposeViewController.m
//  黑马微博
//
//  Created by apple on 14-7-7.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMComposeViewController.h"
#import "HMEmotionTextView.h"
#import "HMComposeToolbar.h"
#import "HMComposePhotosView.h"
//#import "HMAccountTool.h"
//#import "HMAccount.h"
#import "MBProgressHUD+MJ.h"
//#import "HMStatusTool.h"
#import "HMEmotion.h"
#import "HMEmotionKeyboard.h"

#import "DSComposePhotosView.h"
#import "JKImagePickerController.h"
//#import <Masonry.h>

@interface HMComposeViewController () <HMComposeToolbarDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,JKImagePickerControllerDelegate>

@property (nonatomic, weak) HMEmotionTextView *textView;
@property (nonatomic, weak) HMComposeToolbar *toolbar;
@property (nonatomic, weak) HMComposePhotosView *photosView;
@property (nonatomic, strong) HMEmotionKeyboard *kerboard;


@property (nonatomic , weak) DSComposePhotosView *photosView2;


@property (nonatomic, weak) HMEmotionTextView *produceText;
@property (nonatomic, weak) HMEmotionTextView *disabuseText;


/**
 *  是否正在切换键盘
 */
@property (nonatomic, assign, getter = isChangingKeyboard) BOOL changingKeyboard;


@end

@implementation HMComposeViewController

#pragma mark - 初始化方法
- (HMEmotionKeyboard *)kerboard
{
    if (!_kerboard) {
        self.kerboard = [HMEmotionKeyboard keyboard];
        self.kerboard.width = HMScreenW;
        self.kerboard.height = 216;
    }
    return _kerboard;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置导航条内容
    [self setupNavBar];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"项目介绍";
    label.frame = CGRectMake(10, -250, self.view.width, self.view.height);
    [self.view addSubview:label];
    
    // 添加输入控件
    [self setupTextView];
    
    //设置其他输入框
    [self setupProduceText];
    //
    [self setupDisabuseText];

    
    // 添加工具条
    [self setupToolbar];
    
    // 添加显示图片的相册控件
//    [self setupPhotosView];
    [self setupPhotosView2];
    

    //设置完成按钮
    [self setupCompleteBtn];

    // 监听表情选中的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelected:) name:HMEmotionDidSelectedNotification object:nil];
    // 监听删除按钮点击的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidDeleted:) name:HMEmotionDidDeletedNotification object:nil];
}

-(void)setupCompleteBtn{
    
    UIButton *completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    completeBtn.backgroundColor = [UIColor orangeColor];
    
    [completeBtn addTarget:self action:@selector(completeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    
    completeBtn.frame = CGRectMake(SSScreenW * 0.5, 500, 50, 50);
//    [completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(30);
//        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
//        make.height.equalTo(@50);
//        make.width.equalTo(@100);
//    }];
    
    [self.view addSubview:completeBtn];
    
}

-(void)completeBtnClick{

    SSLog(@"完成");
    
    [self loadData];

}

-(void)loadData
{
    
    if (self.photosView.images.count) {
        [self sendStatusWithImage];
    } else {
        [self sendStatusWithoutImage];
    }
    
    // 2.关闭控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}




//// 添加显示图片的相册控件
//- (void)setupPhotosView
//{
//    HMComposePhotosView *photosView = [[HMComposePhotosView alloc] init];
//    photosView.width = self.textView.width;
//    photosView.height = self.textView.height;
//    photosView.y = 70;
//    [self.textView addSubview:photosView];
//    self.photosView = photosView;
//}

// 添加显示图片的相册控件
- (void)setupPhotosView2 {
    
    DSComposePhotosView *photosView = [[DSComposePhotosView alloc] init];
    photosView.width = self.textView.width;
    photosView.height = self.textView.height;
    photosView.y = 70;
    [photosView.addButton addTarget:self action:@selector(addButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
//    photosView.addButton.hidden = YES;
    [self.textView addSubview:photosView];
    self.photosView2 = photosView;
}

- (void)addButtonClicked {
    
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 9;
    imagePickerController.selectedAssetArray = self.photosView2.assetsArray;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
    NSLog(@"button clicked");
}


// 添加工具条
- (void)setupToolbar
{
    // 1.创建
    HMComposeToolbar *toolbar = [[HMComposeToolbar alloc] init];
    toolbar.width = self.view.width;
    toolbar.delegate = self;
    toolbar.height = 44;
    self.toolbar = toolbar;
    
    // 2.显示
    toolbar.y = self.view.height - toolbar.height;
    [self.view addSubview:toolbar];
}

// 添加输入控件
- (void)setupTextView
{
    // 1.创建输入控件
    HMEmotionTextView *textView = [[HMEmotionTextView alloc] init];
    textView.alwaysBounceVertical = YES; // 垂直方向上拥有有弹簧效果
    
    textView.backgroundColor = [UIColor redColor];
    
    textView.frame = CGRectMake(0, 100, self.view.width, 200);
//    textView.frame = self.view.bounds;
    textView.delegate = self;
    [self.view addSubview:textView];
    self.textView = textView;
    
    // 2.设置提醒文字（占位文字）
    textView.placehoder = @"请填写项目说明内容...";
    
    // 3.设置字体
    textView.font = [UIFont systemFontOfSize:15];
    
    // 4.监听键盘
    // 键盘的frame(位置)即将改变, 就会发出UIKeyboardWillChangeFrameNotification
    // 键盘即将弹出, 就会发出UIKeyboardWillShowNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 键盘即将隐藏, 就会发出UIKeyboardWillHideNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)setupProduceText{
    
    // 1.创建输入控件
    HMEmotionTextView *produceText = [[HMEmotionTextView alloc] init];
    //    produceText.alwaysBounceVertical = YES; // 垂直方向上拥有有弹簧效果
    
    produceText.backgroundColor = [UIColor blueColor];
    
    self.produceText = produceText;
    
    produceText.frame = CGRectMake(0, 300, self.view.width, 50);
    //    produceText.frame = self.view.bounds;
    produceText.delegate = self;
    [self.view addSubview:produceText];
    self.textView = produceText;
    
    // 2.设置提醒文字（占位文字）
    produceText.placehoder = @"制作过程说明";
    
    // 3.设置字体
    produceText.font = [UIFont systemFontOfSize:15];
}

-(void)setupDisabuseText{
    
    // 1.创建输入控件
    HMEmotionTextView *disabuseText = [[HMEmotionTextView alloc] init];
    //    disabuseText.alwaysBounceVertical = YES; // 垂直方向上拥有有弹簧效果
    
    disabuseText.backgroundColor = [UIColor greenColor];
    
    self.disabuseText = disabuseText;
    
    disabuseText.frame = CGRectMake(0, 350, self.view.width, 50);
    //    textView.frame = self.view.bounds;
    disabuseText.delegate = self;
    [self.view addSubview:disabuseText];
    self.textView = disabuseText;
    
    // 2.设置提醒文字（占位文字）
    disabuseText.placehoder = @"融资解惑";
    
    // 3.设置字体
    disabuseText.font = [UIFont systemFontOfSize:15];
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  view显示完毕的时候再弹出键盘，避免显示控制器view的时候会卡住
 */
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 成为第一响应者（叫出键盘）
    [self.textView becomeFirstResponder];
}

// 设置导航条内容
- (void)setupNavBar
{
//    NSString *name = [HMAccountTool account].name;
//    if (name) {
//        // 构建文字
//        NSString *prefix = @"发微博";
//        NSString *text = [NSString stringWithFormat:@"%@\n%@", prefix, name];
//        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
//        [string addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:[text rangeOfString:prefix]];
//        [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:[text rangeOfString:name]];
//        
//        // 创建label
//        UILabel *titleLabel = [[UILabel alloc] init];
//        titleLabel.attributedText = string;
//        titleLabel.numberOfLines = 0;
//        titleLabel.textAlignment = NSTextAlignmentCenter;
//        titleLabel.width = 100;
//        titleLabel.height = 44;
//        self.navigationItem.titleView = titleLabel;
//    } else {
//        self.title = @"发微博";
//    }
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回上一步" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleBordered target:self action:@selector(send)];
//    self.navigationItem.rightBarButtonItem.enabled = NO;
}

#pragma mark - 私有方法
/**
 *  取消
 */
//- (void)cancel
//{
//    // 2.关闭控制器
//    [self.navigationController popViewControllerAnimated:YES];
//}

/**
 *  发送
 */
- (void)send
{
    // 1.发表微博
    if (self.photosView.images.count) {
        [self sendStatusWithImage];
    } else {
        [self sendStatusWithoutImage];
    }
    
    // 2.关闭控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  发表有图片的微博
 */
- (void)sendStatusWithImage
{
//    // 1.获得请求管理者
//    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
//    
//    // 2.封装请求参数
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"access_token"] = [HMAccountTool account].access_token;
//    params[@"status"] = self.textView.text;
//    
//    // 3.发送POST请求
//    [mgr POST:@"https://upload.api.weibo.com/2/statuses/upload.json" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        
//#warning 目前新浪开放的发微博接口 最多 只能上传一张图片
//        UIImage *image = [self.photosView.images firstObject];
//        
//        NSData *data = UIImageJPEGRepresentation(image, 1.0);
//        
//        // 拼接文件参数
//        [formData appendPartWithFileData:data name:@"pic" fileName:@"status.jpg" mimeType:@"image/jpeg"];
//        
//    } success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
//        [MBProgressHUD showSuccess:@"发表成功"];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [MBProgressHUD showError:@"发表失败"];
//    }];
    
    //参数
//    NSString *title = @"123";
//    NSString *brief = @"间谍飞哥那就搞公安人";
//    NSString *duration = @"24";
//    NSString *userId = @"";
//    NSString *picture_url = @"";
//    NSString *investGoalMoney = @"";
//    
//    NSString *timestamp = [MyMD5 timestamp];
//    NSString *appkey = MD5key;
//    
//    NSString *signmsg = [NSString stringWithFormat:@"title=%@&sex=%@&timestamp=%@&username=%@&key=%@",title,sex,timestamp,username,appkey];
//    
//    NSString *signmsgMD5 = [MyMD5 md5:signmsg];
//    
//    // 1.创建请求 http://j.efeiyi.com:8080/app-wikiServer/
//    NSString *url = @"http://192.168.1.69:8001/app/completeUserInfo.do";
//    
//    // 3.设置请求体
//    NSDictionary *json = @{
//                           @"username" : @"18513234278",
//                           @"nickname" : nickname,
//                           @"headPortrait":headPortrait,
//                           @"sex"      : sex,
//                           @"timestamp" : timestamp,
//                           @"signmsg"   : signmsgMD5
//                           };
//    
//    //     [HttpRequstTool shareInstance];
//    
//    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
//    
//    // 设置请求格式
//    manger.requestSerializer = [AFJSONRequestSerializer serializer];
//    // 设置返回格式
//    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
//    
//    
//    [manger POST:url parameters:json constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        
//        [formData appendPartWithFileURL:[NSURL fileURLWithPath:self.createPath] name:@"headPortrait" fileName:@"headPortrait.jpg" mimeType:@"application/octet-stream" error:nil];
//        
//        
//    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        
//        NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        
//        SSLog(@"上传成功---%@---%@",[responseObject class],aString);
//        
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//        SSLog(@"%@",error);
//    }];

}


// 图文混排 ： 图片和文字混合在一起排列

/**
 *  发表没有图片的微博
 */
- (void)sendStatusWithoutImage
{
//    // 1.封装请求参数
//    HMSendStatusParam *param = [HMSendStatusParam param];
//    param.status = self.textView.realText;
//    
//    // 2.发微博
//    [HMStatusTool sendStatusWithParam:param success:^(HMSendStatusResult *result) {
//        [MBProgressHUD showSuccess:@"发表成功"];
//    } failure:^(NSError *error) {
//        [MBProgressHUD showError:@"发表失败"];
//    }];
}

#pragma mark - 键盘处理
/**
 *  键盘即将隐藏
 */
- (void)keyboardWillHide:(NSNotification *)note
{
    if (self.isChangingKeyboard) return;
    
    // 1.键盘弹出需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        self.toolbar.transform = CGAffineTransformIdentity;
    }];
}

/**
 *  键盘即将弹出
 */
- (void)keyboardWillShow:(NSNotification *)note
{
        // 1.键盘弹出需要的时间
        CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        // 2.动画
        [UIView animateWithDuration:duration animations:^{
            // 取出键盘高度
            CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
            CGFloat keyboardH = keyboardF.size.height;
            self.toolbar.transform = CGAffineTransformMakeTranslation(0, - keyboardH);
        }];
}

#pragma mark - UITextViewDelegate
/**
 *  当用户开始拖拽scrollView时调用
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

/**
 *  当textView的文字改变就会调用
 */
- (void)textViewDidChange:(UITextView *)textView
{
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
}

#pragma mark - HMComposeToolbarDelegate
/**
 *  监听toolbar内部按钮的点击
 */
- (void)composeTool:(HMComposeToolbar *)toolbar didClickedButton:(HMComposeToolbarButtonType)buttonType
{
    switch (buttonType) {
        case HMComposeToolbarButtonTypeCamera: // 照相机
            [self openCamera];
            break;
            
        case HMComposeToolbarButtonTypePicture: // 相册
            [self openAlbum];
            break;
            
        case HMComposeToolbarButtonTypeEmotion: // 表情
            [self openEmotion];
            break;
            
        default:
            break;
    }
}

/**
 *  打开照相机
 */
- (void)openCamera
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}


/**
 *  打开相册
 */
- (void)openAlbum
{
    
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 9;
    imagePickerController.selectedAssetArray = self.photosView2.assetsArray;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

/**
 *  打开表情
 */
- (void)openEmotion
{
    // 正在切换键盘
    self.changingKeyboard = YES;
    
    if (self.textView.inputView) { // 当前显示的是自定义键盘，切换为系统自带的键盘
        self.textView.inputView = nil;
        
        // 显示表情图片
        self.toolbar.showEmotionButton = YES;
    } else { // 当前显示的是系统自带的键盘，切换为自定义键盘
        // 如果临时更换了文本框的键盘，一定要重新打开键盘
        self.textView.inputView = self.kerboard;
        
        // 不显示表情图片
        self.toolbar.showEmotionButton = NO;
    }
    
    // 关闭键盘
    [self.textView resignFirstResponder];
    
#warning 记录是否正在更换键盘
    // 更换完毕完毕
    self.changingKeyboard = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 打开键盘
        [self.textView becomeFirstResponder];
    });
}

/**
 *  当表情选中的时候调用
 *
 *  @param note 里面包含了选中的表情
 */
- (void)emotionDidSelected:(NSNotification *)note
{
    HMEmotion *emotion = note.userInfo[HMSelectedEmotion];
    
    // 1.拼接表情
    [self.textView appendEmotion:emotion];
    
    // 2.检测文字长度
    [self textViewDidChange:self.textView];
}

/**
 *  当点击表情键盘上的删除按钮时调用
 */
- (void)emotionDidDeleted:(NSNotification *)note
{
    // 往回删
    [self.textView deleteBackward];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 1.取出选中的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    UIImage *newImage = [self drawImageWith:image imageWidth:100];
    
    // 2.添加图片到相册中
    [self.photosView addImage:newImage];
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

#pragma mark - JKImagePickerControllerDelegate
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source
{
    self.photosView2.assetsArray = [NSMutableArray arrayWithArray:assets];
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        if ([self.photosView2.assetsArray count] > 0){
            
            self.photosView2.addButton.hidden = NO;
        }
        [self.photosView2.collectionView reloadData];
    }];
}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
