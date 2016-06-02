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

@interface ArtworkFinishedController ()<AddImageCellDelegate,HMImagePickerControllerDelegate>
/// 选中照片数组
@property (nonatomic) NSArray *images;
/// 选中资源素材数组，用于定位已经选择的照片
@property (nonatomic) NSArray *selectedAssets;
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
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ArtworkFinishCell" bundle:nil] forCellReuseIdentifier:@"ArtworkFinishCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddImageCell" bundle:nil] forCellReuseIdentifier:@"AddImageCell"];
    [self.tableView improveTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.images.count > indexPath.row) {
        UIImage *img = self.images[indexPath.row];
        ArtworkFinishCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArtworkFinishCell"];
        cell.imgView.image = img;
        return cell;
    }else{
        AddImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddImageCell"];
        cell.delegate = self;
        return cell;
    }
}

-(void)clickAddPhotoBtn{
    NSLog(@"添加图片");
    HMImagePickerController *picker = [[HMImagePickerController alloc] initWithSelectedAssets:self.selectedAssets];
    // 设置图像选择代理
    picker.pickerDelegate = self;
    // 设置目标图片尺寸
    picker.targetSize = CGSizeMake(600, 600);
    // 设置最大选择照片数量
    picker.maxPickerCount = 3;
    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - HMImagePickerControllerDelegate
- (void)imagePickerController:(HMImagePickerController *)picker
      didFinishSelectedImages:(NSArray<UIImage *> *)images
               selectedAssets:(NSArray<PHAsset *> *)selectedAssets {
    
    // 记录图像，方便在 CollectionView 显示
    self.images = images;
    // 记录选中资源集合，方便再次选择照片定位
    self.selectedAssets = selectedAssets;
    
    [self.tableView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self cellHeight];
}

-(CGFloat)cellHeight{
    if (self.images.count <= 3 && self.images.count > 0) {
        return 233;
    }else{
        return 88;
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
