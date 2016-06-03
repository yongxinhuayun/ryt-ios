//
//  ArtworkFinishedController.m
//  融易投
//
//  Created by 李鹏飞 on 16/6/2.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import "ArtworkFinishedController.h"
#import "ArtworkFinishCell.h"
#import "AddImageCell.h"
#import "UITableView+Improve.h"
#import "HMImagePickerController.h"
#import "ResultModel.h"

#import "SettingFooterView.h"
#import <MJExtension.h>

@interface ArtworkFinishedController ()<AddImageCellDelegate,HMImagePickerControllerDelegate,ArtworkFinishCellDelegate>
/// 选中照片数组
@property (nonatomic,strong) NSMutableArray<UIImage *> *images;
/// 选中资源素材数组，用于定位已经选择的照片
@property (nonatomic,strong) NSMutableArray *selectedAssets;

@property(nonatomic,strong) SettingFooterView *commitBtnView;
// 通过监听count变化，改变按钮的状态
@property(nonatomic,assign) NSInteger imageCount;
@end

@implementation ArtworkFinishedController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上传照片";
    self.imageCount = 0;
    [self addCloseBtn];
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ArtworkFinishCell" bundle:nil] forCellReuseIdentifier:@"ArtworkFinishCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddImageCell" bundle:nil] forCellReuseIdentifier:@"AddImageCell"];
    [self.tableView improveTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addObserver:self forKeyPath: @"imageCount"options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld  context:nil];
}

-(void)addCloseBtn{
    //设置导航条按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.width = 44;
    rightButton.height = 44;
    [rightButton setImage:[UIImage imageNamed:@"zhuce_guanbi"] forState:(UIControlStateNormal)];
    [rightButton setImage:[UIImage imageNamed:@"zhuce_guanbi"] forState:(UIControlStateHighlighted)];
//    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
//    [rightButton setTitle:@"发送" forState:UIControlStateNormal];
    //运行程序,发现按钮没有出现导航条上面,因为没有设置尺寸
    [rightButton sizeToFit];
    [rightButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

-(void)close{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"imageCount"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if (self.images.count != 3) {
        self.commitBtnView.tuiChuBtn.backgroundColor = [UIColor colorWithRed:227.0 / 255.0 green:227.0 / 255.0 blue:227.0 / 255.0 alpha:1.0];
        self.commitBtnView.tuiChuBtn.userInteractionEnabled = NO;
    }else{
        self.commitBtnView.tuiChuBtn.backgroundColor = [UIColor colorWithRed:239.0 / 255.0 green:91.0 / 255.0 blue:112.0 / 255.0 alpha:1.0];
        self.commitBtnView.tuiChuBtn.userInteractionEnabled = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.images.count == 0) {
        return 1;
    }else if(self.images.count < 3 && self.images.count > 0 ){
        return self.images.count + 1;
    }else{
        return self.images.count;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, SSScreenW, 40);
    UILabel *hTitle = [[UILabel alloc] initWithFrame:headerView.bounds];
    hTitle.x = 14;
    hTitle.text = @"请上传已完成作品的正视、俯视、底视照片";
    hTitle.font = [UIFont systemFontOfSize:14];
    hTitle.textColor = [UIColor blackColor];
    [headerView addSubview:hTitle];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 60;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.images.count > indexPath.row) {
        UIImage *img = self.images[indexPath.row];
        ArtworkFinishCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArtworkFinishCell"];
        cell.imgView.image = img;
        cell.indexPath = indexPath;
        cell.delegate = self;
        return cell;
    }else{
        AddImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddImageCell"];
        cell.delegate = self;
        return cell;
    }
}

-(void)deleteImage:(NSIndexPath *)indexPath{
    [self.images removeObjectAtIndex:indexPath.row];
    self.imageCount = self.imageCount - 1;
    [self.selectedAssets removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height -self.tableView.bounds.size.height) animated:YES];
}

-(void)clickAddPhotoBtn{
    NSLog(@"添加图片");
    HMImagePickerController *picker = [[HMImagePickerController alloc] initWithSelectedAssets:self.selectedAssets];
    // 设置图像选择代理
    picker.pickerDelegate = self;
    // 设置目标图片尺寸
    picker.targetSize = CGSizeMake(355, 223);
    // 设置最大选择照片数量
    picker.maxPickerCount = 3;
    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - HMImagePickerControllerDelegate
- (void)imagePickerController:(HMImagePickerController *)picker
      didFinishSelectedImages:(NSArray<UIImage *> *)images
               selectedAssets:(NSArray<PHAsset *> *)selectedAssets {
    
    // 记录图像，方便在 CollectionView 显示
//    self.images = images;
    self.images = [NSMutableArray arrayWithArray:images];
    self.imageCount = self.images.count;
    // 记录选中资源集合，方便再次选择照片定位
//    self.selectedAssets = selectedAssets;
    self.selectedAssets = [NSMutableArray arrayWithArray:selectedAssets];
    
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height -self.tableView.bounds.size.height) animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return self.commitBtnView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > self.imageCount - 1 || self.imageCount == 0) {
        return 88;
    }else{
        return 233;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 40; //sectionHeaderHeight
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

-(void)clickCommitBtn{
    NSString *bundle = [[NSBundle mainBundle] bundlePath];
    // 上传图片
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int count = 0; count < self.images.count;count++) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmssSSS";
        NSString *fileName = [NSString stringWithFormat:@"%@%@.png",[formatter stringFromDate:[NSDate date]],@(count)];
        NSLog(@"%@",fileName);
        [tempArray addObject:fileName];
    }
    NSArray *file = tempArray.copy;
    NSDictionary *json = @{
                           @"file" : file,
                           @"artworkId" : self.artworkId
                           };
    [[HttpRequstTool shareInstance] uploadDataWithServerUrl:@"artworkComplete.do" parameters:json constructingBodyWithBlock:^(id formData) {
        
        for (int i = 0; i < self.images.count; i++) {
            UIImage *image  =  self.images[i];
            NSData *data = UIImageJPEGRepresentation(image, 1.0);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmssSSS";
            
            NSString *fileName = [NSString stringWithFormat:@"%@%@.png",[formatter stringFromDate:[NSDate date]],@(i)];
            [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"application/octet-stream"];
        }
        
    } showHUDView:self.view progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(id respondObj) {
        NSString *str = [[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str);
        ResultModel *result = [ResultModel mj_objectWithKeyValues:respondObj];
        if ([result.resultMsg isEqualToString:@"成功"]) {
            
            [MBProgressHUD showSuccess:@"创作完成"];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        }
    }];
}

-(NSMutableArray<UIImage *> *)images{
    if (!_images) {
        _images = [NSMutableArray arrayWithCapacity:3];
    }
    return _images;
}

-(SettingFooterView *)commitBtnView{
    if (!_commitBtnView) {
        _commitBtnView.backgroundColor = [UIColor whiteColor];
        _commitBtnView = [SettingFooterView settingFooterView];
        [_commitBtnView.tuiChuBtn setTitle:@"提交" forState:(UIControlStateNormal)];
        [_commitBtnView.tuiChuBtn addTarget:self action:@selector(clickCommitBtn) forControlEvents:(UIControlEventTouchUpInside)];
        _commitBtnView.tuiChuBtn.backgroundColor = [UIColor colorWithRed:227.0 / 255.0 green:227.0 / 255.0 blue:227.0 / 255.0 alpha:1.0];
        _commitBtnView.tuiChuBtn.userInteractionEnabled = NO;
    }
    return _commitBtnView;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
