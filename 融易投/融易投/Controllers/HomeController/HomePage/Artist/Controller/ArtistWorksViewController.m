//
//  FocusMyArtistTableViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/29.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "ArtistWorksViewController.h"

#import "ArtistWorksCell.h"

#import "PageInfoModel.h"
#import "ArtworksModel.h"

#import <MJExtension.h>

#import "CommonHeader.h"
#import "CommonFooter.h"

#import "FaBuHeaderView.h"

#import "CoverHUDView.h"

#import "ComposeWorksViewController.h"

@interface ArtistWorksViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) NSMutableArray *models;

/** 用来加载下一页数据 */
@property (nonatomic, strong) NSString *lastPageIndex;

@property (nonatomic, strong) CoverHUDView *cover;

@property (strong,nonatomic) NSString *createPath;


//-----------------------联动属性-----------------------
@property(nonatomic,assign) BOOL isfoot;
//-----------------------联动属性-----------------------

@end

@implementation ArtistWorksViewController

static NSString *ID1 = @"ArtistWorksCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isfoot = YES;
    
    self.lastPageIndex = @"1";
    
    
//    self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
//    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(44, 0, 0, 0);
    
    //注册创建cell ,这样注册就不用在XIB设置ID
    [self.tableView registerNib:[UINib nibWithNibName:@"ArtistWorksCell" bundle:nil] forCellReuseIdentifier:ID1];
    
    [PageInfoModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"artworks" : @"ArtworksModel",
                 };
    }];
    
//    [self loadNewData];
//    
//    //设置刷新控件
//    [self setUpRefresh];
//    
}
-(void)setUpRefresh
{
    //    CommonHeader *header = [CommonHeader headerWithRefreshingBlock:^{
    //
    //        [self loadNewData];
    //
    //    }];
    //
    //    self.tableView.mj_header = header;
    
    //让程序一开始就加载数据
    //    [self.tableView.mj_header beginRefreshing];
    
    
    //同样,自定义上拉刷新
    self.tableView.mj_footer = [CommonFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    //要是其他控制器也需要,直接把上面的拷贝到其他控制器就可以了
}

-(void)loadNewData
{
    //8.2 取消之前的请求
    [self.tableView.mj_header endRefreshing];
    
    self.lastPageIndex = @"1";
    //参数
    NSString *userId = @"ieatht97wfw30hfd";
    
    NSString *pageSize = @"20";
    NSString *pageIndex = @"1";
    //flag为1是自己看自己,为2时是看别人,还需要传递otheruserId
    NSString *timestamp = [MyMD5 timestamp];
    NSString *appkey = MD5key;
    
    NSString *signmsg = [NSString stringWithFormat:@"pageIndex=%@&pageSize=%@&timestamp=%@&userId=%@&key=%@",pageIndex,pageSize,timestamp,userId,appkey];
    NSLog(@"%@",signmsg);
    
    NSString *signmsgMD5 = [MyMD5 md5:signmsg];
    
    NSLog(@"signmsgMD5=%@",signmsgMD5);
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"userId":userId,
                           @"pageSize" : pageSize,
                           @"pageIndex" : pageIndex,
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    
    NSString *url = @"http://192.168.1.41:8080/app/myArtwork.do";
    
    [[HttpRequstTool shareInstance] handlerNetworkingPOSTRequstWithServerUrl:url Parameters:json showHUDView:self.view success:^(id respondObj) {
        
        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        NSLog(@"返回结果:%@",jsonStr);

        
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        
        PageInfoModel *model = [PageInfoModel mj_objectWithKeyValues:modelDict[@"pageInfo"]];
        
        self.models = model.artworks;
        
        //在主线程刷新UI数据
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [self.tableView reloadData];
            
        }];
    }];
}

-(void)loadMoreData
{
    //8.2 取消之前的请求
    [self.tableView.mj_footer endRefreshing];
    
    //参数
    int newPageIndex = self.lastPageIndex.intValue + 1;
    
    self.lastPageIndex = [NSString stringWithFormat:@"%d",newPageIndex];
    
    NSLog(@"newPageIndex%@",self.lastPageIndex);
    
    NSLog(@"%d",newPageIndex);
    
    //参数
    NSString *userId = @"ieatht97wfw30hfd";
    NSString *pageSize = @"20";
    NSString *pageIndex = [NSString stringWithFormat:@"%d",newPageIndex];
    NSString *timestamp = [MyMD5 timestamp];
    NSString *appkey = MD5key;
    
    NSString *signmsg = [NSString stringWithFormat:@"pageIndex=%@&pageSize=%@&timestamp=%@&userId=%@&key=%@",pageIndex,pageSize,timestamp,userId,appkey];
    NSLog(@"%@",signmsg);
    
    NSString *signmsgMD5 = [MyMD5 md5:signmsg];
    
    NSLog(@"signmsgMD5=%@",signmsgMD5);
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"userId":userId,
                           @"pageSize" : pageSize,
                           @"pageIndex" : pageIndex,
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    
    NSString *url = @"http://192.168.1.41:8080/app/myArtwork.do";
    
    [[HttpRequstTool shareInstance] handlerNetworkingPOSTRequstWithServerUrl:url Parameters:json showHUDView:self.view success:^(id respondObj) {
        
        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        NSLog(@"返回结果:%@",jsonStr);
        
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        
        PageInfoModel *model = [PageInfoModel mj_objectWithKeyValues:modelDict[@"pageInfo"]];
        
        NSArray *moreModels = model.artworks;
        
        //拼接数据
        [self.models addObjectsFromArray:moreModels];
        
        //在主线程刷新UI数据
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [self.tableView reloadData];
            
        }];
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    return self.models.count;
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ArtistWorksCell *cell = [tableView dequeueReusableCellWithIdentifier:ID1];
    
    [cell.shanchuBtn addTarget:self action:@selector(shanchuZuoPin:) forControlEvents:UIControlEventTouchUpInside];
    
//    ArtworksModel *model = self.models[indexPath.row];
//    
//    cell.model = model;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 84;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    FaBuHeaderView *headerView = [FaBuHeaderView faBuHeaderView];
    
    [headerView.fabuBtn addTarget:self action:@selector(fabuZuoPin:) forControlEvents:UIControlEventTouchUpInside];
    
    return  headerView;
}

-(void)fabuZuoPin:(UIButton *)btn{
    
    SSLog(@"fabuZuoPin");
    
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
    //保存被选中图片
    UIImage *selctedImage = info[UIImagePickerControllerOriginalImage];
    
    UIImage *workImage = [self drawImageWith:selctedImage imageWidth:SSScreenW - 2 * SSMargin];
    
   
    selctedImage = nil;
    
    self.createPath = [self writeImageToCaches:workImage];
    
    //取消modal
    [self dismissViewControllerAnimated:self completion:nil];
    
    ComposeWorksViewController *vc = [[ComposeWorksViewController alloc] init];
    vc.workImage = workImage;
    vc.createPath = self.createPath;
    
    [self.navigationController pushViewController:vc animated:NO];
//    [self presentViewController:vc animated:YES completion:nil];
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


-(void)shanchuZuoPin:(UIButton *)btn{

    SSLog(@"shanchuZuoPin");

    
    //创建遮盖
    CoverHUDView *cover = [CoverHUDView coverHUDView];
    self.cover = cover;
    
    [cover.quxiaoBtn addTarget:self action:@selector(quxiaoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cover.quedingBtn addTarget:self action:@selector(quedingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];//都为0代表是黑色
    //    cover.alpha = 0.7 这么写的话,里面的子控件会都是半透明的
    cover.bounds = [UIApplication sharedApplication].keyWindow.bounds;
    //设置圆角距
    cover.subView.layer.cornerRadius = 5;
    cover.subView.alpha = 0.001;
    cover.center = [UIApplication sharedApplication].keyWindow.center;
    
    [[UIApplication sharedApplication].keyWindow addSubview:cover];
    
    [UIView animateWithDuration:0.25 animations:^{
        cover.subView.alpha = 1.0;
    }];
    
}

-(void)quxiaoBtnClick:(UIButton *)btn{
    
    [self.cover removeFromSuperview];
}

-(void)quedingBtnClick:(UIButton *)btn{
    
    SSLog(@"quedingBtnClick");
    
    [self.cover removeFromSuperview];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        
        
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 222;
}

//-----------------------联动-----------------------
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 80; //sectionHeaderHeight
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
    CGPoint offset = scrollView.contentOffset;
    UIScrollView *superView = (UIScrollView *)scrollView.superview.superview.superview.superview;
    if (superView.contentOffset.y >= self.topHeight) {
        self.isfoot = NO;
        superView.contentOffset = CGPointMake(0, self.topHeight);
        scrollView.scrollEnabled = YES;
    }
    if (superView.contentOffset.y < -64) {
        self.isfoot = YES;
        superView.contentOffset = CGPointMake(0, -64);
        scrollView.scrollEnabled = YES;
    }
    //    NSLog(@"bool = %d",self.isfoot);
    CGFloat zeroY = superView.contentOffset.y + scrollView.contentOffset.y;
    if (self.isfoot && scrollView.contentOffset.y > 0) {
        superView.contentOffset = CGPointMake(0, superView.contentOffset.y + scrollView.contentOffset.y);
        scrollView.contentOffset = CGPointZero;
    }
    if (!self.isfoot && scrollView.contentOffset.y < 0) {
        superView.contentOffset = CGPointMake(0, superView.contentOffset.y + scrollView.contentOffset.y);
    }
    if (superView.contentOffset.y < self.topHeight && scrollView.contentOffset.y >0) {
        superView.contentOffset = CGPointMake(0, superView.contentOffset.y + scrollView.contentOffset.y);
        scrollView.contentOffset = CGPointZero;
    }
    if(superView.contentOffset.y < self.topHeight && scrollView.contentOffset.y <= 0){
        CGFloat y = scrollView.contentOffset.y / 10;
        zeroY = superView.contentOffset.y + y;
        
        if (zeroY < 0) {
            [superView setContentOffset:CGPointMake(0, -64) animated:YES];
        }else{
            superView.contentOffset = CGPointMake(0, superView.contentOffset.y + y);
        }
    }
}
//-----------------------联动-----------------------

@end
