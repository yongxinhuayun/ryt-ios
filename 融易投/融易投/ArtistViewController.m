//
//  ArtistViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/12.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "ArtistViewController.h"

#import "SettingTableViewController.h"


#import <WechatShortVideoController.h>

#import "ReleaseViewController.h"

#import "ReleaseVideoViewController.h"

#import "DemoTableViewController.h"
#import "XIBHeaderView.h"

#import "XCLPageView.h"
#import "XCLSegmentView.h"
#import "ArtistViewHeaderView.h"

@interface ArtistViewController ()<WechatShortVideoDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,XCLPageViewDelegate, XCLSegmentViewDelegate>
{
    NSURL *urlVideo;
}


@property (weak  , nonatomic) IBOutlet XCLPageView *pageView;
@property (strong, nonatomic) XIBHeaderView *headerView;

@end

@implementation ArtistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航条
    [self setUpNavBar];
    
    DemoTableViewController *controller1 = [[DemoTableViewController alloc] initWithItemCount:50];
    
    DemoTableViewController *controller2 = [[DemoTableViewController alloc] initWithItemCount:100];
    
    DemoTableViewController *controller3 = [[DemoTableViewController alloc] initWithItemCount:100];
    
    self.headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ArtistViewHeaderView class]) owner:self options:nil] firstObject];
    
    
    [self.headerView.segmentView setTitles:@[@"投过的", @"赞过的",@"简介"]];
    self.headerView.segmentView.delegate = self;
    self.headerView.segmentView.font = [UIFont systemFontOfSize:14];
    self.headerView.segmentView.normalColor = [UIColor blackColor];
    self.headerView.segmentView.selectedColor = [UIColor blackColor];
    self.headerView.segmentView.indicator.backgroundColor = self.headerView.segmentView.selectedColor;
    self.headerView.segmentView.indicatorEdgeInsets = UIEdgeInsetsMake(self.headerView.segmentView.bounds.size.height - 2, 10, 0, 10);
    self.headerView.segmentView.selectedSegmentIndex = 0;
    
    self.pageView.delegate = self;
    [self.pageView setParentViewController:self childViewControllers:@[controller1, controller2,controller3]];
    [self.pageView setHeaderView:self.headerView defaultHeight:352 minHeight:self.headerView.segmentView.bounds.size.height];
    [self.pageView setIndex:0];

}

// 设置导航条
-(void)setUpNavBar
{
    //设置导航条标题
    self.navigationItem.title = @"我的";
    
    
}

//上传视频
- (IBAction)updata:(id)sender {
    
    [self loadData];
}

//发布动态
- (IBAction)publishStateBtnClick:(id)sender {
    
    
    //创建UIAlertController是为了让用户去选择照片来源,拍照或者相册.
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:0];
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
    //设置选择图片的截取框
    //    imagePickerController.allowsEditing = YES;
    
    UIAlertAction *videoAction = [UIAlertAction actionWithTitle:@"视频" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
//        WechatShortVideoController *wechatShortVideoController = [[WechatShortVideoController alloc] init];
//        wechatShortVideoController.delegate = self;
//        [self presentViewController:wechatShortVideoController animated:YES completion:^{}];
        
        ReleaseVideoViewController *videoVc = [[ReleaseVideoViewController alloc] init];
        
        [self presentViewController:videoVc animated:YES completion:^{}];
    }];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }];
    
    UIAlertAction *picAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {

        UIStoryboard *settingStoryBoard = [UIStoryboard storyboardWithName:NSStringFromClass([ReleaseViewController class]) bundle:nil];
        ReleaseViewController *settingVC = [settingStoryBoard instantiateInitialViewController];
        [self presentViewController:settingVC animated:YES completion:nil];

    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action)
                                   {
                                       //这里可以不写代码
                                   }];
    [self presentViewController:alertController animated:YES completion:nil];
    
    //用来判断来源 Xcode中的模拟器是没有拍摄功能的,当用模拟器的时候我们不需要把拍照功能加速
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        [alertController addAction:videoAction];
        [alertController addAction:cancelAction];
        [alertController addAction:photoAction];
        [alertController addAction:picAction];
    }
    
    else {
        [alertController addAction:videoAction];
        [alertController addAction:picAction];
        [alertController addAction:cancelAction];
    }

    
}


-(void)loadData
{
    //参数
    NSString *projectTitle = @"你妹";
    
    NSString *title = [projectTitle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSString *userId = @"imhfp1yr4636pj49";
    NSString *picture_url = urlVideo;
    
    NSLog(@"%@",picture_url);
    
    NSString *artworkId = @"imyj2dw936qyh35t";
    
    NSString *timestamp = [MyMD5 timestamp];
    
    NSString *appkey = MD5key;
    
    NSString *signmsg = [NSString stringWithFormat:@"artworkId=%@&timestamp=%@&key=%@",artworkId,timestamp,appkey];
    
    NSLog(@"%@",signmsg);
    
    NSString *signmsgMD5 = [MyMD5 md5:signmsg];
    
    // 1.创建请求 http://j.efeiyi.com:8080/app-wikiServer/
    NSString *url = @"http://192.168.1.69:8001/app/releaseArtworkDynamic.do";
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"content" : title,
                           @"file" : picture_url,
                           @"type": @"1",
                           @"artworkId"   : artworkId,
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    // 设置请求格式
    manger.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    [manger POST:url parameters:json constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        
        //_fileName = [NSString stringWithFormat:@"output-%@.mp4",[formater stringFromDate:[NSDate date]]];
        
        // [formData appendPartWithFileURL:_filePathURL name:@"file" fileName:_fileName mimeType:dict[@"contenttype"] error:nil];
        
        NSDateFormatter* formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyyMMddHHmmss"];
        NSString*_fileName = [NSString stringWithFormat:@"output-%@.mp4",[formater stringFromDate:[NSDate date]]];
        //NSURL *urlStr = [NSURL URLWithString:]
        
        [formData appendPartWithFileURL:urlVideo name:@"file" fileName:@"ii.mov" mimeType:@"application/octet-stream" error:nil];
        
        
        
        //          [formData appendPartWithFileURL:[NSURL URLWithString:picture_url] name:@"file" fileName:@"ii.mov" mimeType:@"application/octet-stream" error:nil];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        SSLog(@"%@---%@",[responseObject class],aString);
        
        //        [SVProgressHUD showSuccessWithStatus:@"发布成功" maskType:SVProgressHUDMaskTypeBlack];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        SSLog(@"%@",error);
        
        //        [SVProgressHUD showSuccessWithStatus:@"发布失败 " maskType:SVProgressHUDMaskTypeBlack];
    }];
    
    
}

-(void)finishWechatShortVideoCapture:(NSURL *)filePath{
    urlVideo = filePath;
    NSLog(@"urlVideo%@ ",urlVideo);
    NSLog(@"1111111111$%@",filePath);
}


#pragma mark - XCLSegmentViewDelegate

- (void)segmentView:(XCLSegmentView *)segmentView clickedAtIndex:(NSUInteger)index
{
    [self.pageView setIndex:index];
}

#pragma mark - XCLPageViewDelegate

- (void)pageViewDidScroll:(XCLPageView *)pageView
{
    CGFloat pageWidth = pageView.scrollView.contentSize.width/self.headerView.segmentView.titles.count;
    self.headerView.segmentView.indicatorPosition = pageView.scrollView.contentOffset.x / (pageWidth * (self.headerView.segmentView.titles.count - 1));
}

- (void)pageView:(XCLPageView *)pageView scrollDidEndAtIndex:(NSUInteger)index
{
    self.headerView.segmentView.selectedSegmentIndex = index;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
