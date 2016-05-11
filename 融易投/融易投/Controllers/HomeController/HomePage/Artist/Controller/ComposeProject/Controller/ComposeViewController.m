//
//  ComposeViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/13.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "ComposeViewController.h"

#import "WHC_PhotoListCell.h"
#import "WHC_PictureListVC.h"
#import "WHC_CameraVC.h"
#import "CollectionViewCell.h"
#import "imageViewController.h"

NSString *const ID = @"collectionViewCell";
#define kWHC_CellName     (@"WHC_PhotoListCellName")
#define WIDTH [UIScreen mainScreen].bounds.size.width

@interface ComposeViewController ()
<
WHC_ChoicePictureVCDelegate,
WHC_CameraVCDelegate,
UIActionSheetDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollewView;

@property (assign, nonatomic) NSInteger indexNum;//最大限度照片数量
@property (assign, nonatomic) NSInteger index;//当前索引
@property (nonatomic, strong) UIImage *image;//加号图片
@property (nonatomic, strong) NSMutableArray  *imageArr;//图片数组

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:ID];
    
    UIImage *image = [UIImage imageNamed:@"AddGroupMemberBtnHL"];
    self.image = image;
    
    
    self.scrollewView.contentSize = CGSizeMake(SSScreenW, 1000);
    
}

#pragma mark ======== CollectionView 数据源=============

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (!self.imageArr.count) {
        
        [self.imageArr addObject:self.image];
        
        return 1;
    }
    
    return self.imageArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    if (!self.imageArr.count) {
        cell.image = self.image;
    } else {
        cell.image = self.imageArr[indexPath.row];
    }
    
    return cell;
}

#pragma mark ========= CollectionView delegate==========

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIImage *image = [self.imageArr lastObject];
    
    self.index = indexPath.row;
    
    if (self.imageArr.count == (self.index + 1) && image == self.image) {
        
        UIActionSheet *as = [[UIActionSheet alloc]initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"相机", nil];
        [as showInView:self.view];
        
    } else {
        
        [self performSegueWithIdentifier:@"collectionCell" sender:self.imageArr];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"collectionCell"]) {
        
        imageViewController *vc = segue.destinationViewController;
        vc.imageArray = sender;
        vc.selectedIndex = self.index;
        vc.image = self.image;
        vc.imageCount = self.indexNum;
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    return CGSizeMake(85, 73);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    if (WIDTH == 320 || WIDTH == 414) { //4或者6+
        return UIEdgeInsetsMake(20, 15, 0, 15);
    } else if (WIDTH == 375) {
        return UIEdgeInsetsMake(20, 30, 0, 30);
    }
    return UIEdgeInsetsMake(20, 20, 0, 20);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    if (WIDTH == 320 || WIDTH == 414) {//4或者6+
        return 15;
    } else if (WIDTH == 375) {
        return 27;
    }
    return 15;
}

#pragma mark ======= UIActionSheet Delegate =========

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    self.indexNum = 9;
    
    switch (buttonIndex) {
            
        case 0:{//从相册选择多张
            WHC_PictureListVC  * vc = [WHC_PictureListVC new];
            vc.delegate = self;
            vc.maxChoiceImageNumberumber = self.indexNum - self.imageArr.count + 1;
            [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:nil];
        }
            break;
            
        case 1: {
            WHC_CameraVC * vc = [WHC_CameraVC new];
            vc.delegate = self;
            [self presentViewController:vc animated:YES completion:nil];
            
        }
            break;
    }
}

#pragma mark - WHC_ChoicePictureVCDelegate

- (void)WHCChoicePictureVC:(WHC_ChoicePictureVC *)choicePictureVC didSelectedPhotoArr:(NSArray *)photoArr{
    
    if ([self.imageArr firstObject] == self.image) {
        
        self.imageArr = [photoArr mutableCopy];
    } else {
        
        for (UIImage *image in photoArr) {
            
            [self.imageArr insertObject:image atIndex:0];
        }
    }
    
    if (self.imageArr.count > self.indexNum) {
        
        [self.imageArr removeObject:self.image];
        
    }
    
    if (self.imageArr.count < self.indexNum && [self.imageArr lastObject] != self.image) {
        
        [self.imageArr addObject:self.image];
    }
    
    [self.collectionView reloadData];
    
}

#pragma mark - WHC_CameraVCDelegate
- (void)WHCCameraVC:(WHC_CameraVC *)cameraVC didSelectedPhoto:(UIImage *)photo {
    
    [self.imageArr insertObject:photo atIndex:0];
    
    if (self.imageArr.count > self.indexNum) {
        
        [self.imageArr removeObject:self.image];
        
    }
    [self.collectionView reloadData];
    
}

#pragma  mark ==== 懒加载 ======

- (NSMutableArray *)imageArr {
    
    if (_imageArr == nil) {
        
        _imageArr = [NSMutableArray array];
    }
    
    return _imageArr;
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(noti:) name:@"byValue" object:nil];
}

- (void)noti:(NSNotification *)noti {
    
    NSDictionary *dict = noti.userInfo;
    
    self.imageArr = dict[@"array"];
    
    [self.collectionView reloadData];
    
}




@end
