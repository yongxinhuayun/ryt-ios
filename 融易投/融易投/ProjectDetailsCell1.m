//
//  ProjectDetailsCell1.m
//  融易投
//
//  Created by efeiyi on 16/4/20.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "ProjectDetailsCell1.h"
#import "ProjectDetailsModel.h"
#import "ProjectDetailsResultModel.h"
#import "ArtworkAttachmentListModel.h"

#import "ImageCollectionViewCell.h"

#import "UIImageView+WebCache.h"


@interface ProjectDetailsCell1 () //<UICollectionViewDataSource,UICollectionViewDelegate>

/** 所有照片 */
@property (nonatomic ,strong) NSMutableArray *imagesList;

@end


@implementation ProjectDetailsCell1

static NSString *ID4 = @"imageCell";

static NSInteger const cols = 4;
static CGFloat const margin = 10;

#define  cellWH  ((SSScreenW - (cols - 1) * margin) / cols)

//-(void)setModel:(ProjectDetailsResultModel *)model{
//
//
//    _model = model;
//    
//    self.label1.text = model.object.artWork.brief;
//    self.label2.text = model.object.artworkdirection.make_instru;
//    self.label3.text = model.object.artworkdirection.financing_aq;
//    
//    NSLog(@"%@",model.object.artWork.brief);
//    
////    NSLog(@"%@",model.object.artworkAttachmentList.fileName);
////    
////    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:model.object.artworkAttachmentList.fileName] placeholderImage:nil];
//    
////    self.imagesList = model.object.artworkAttachmentList;
////    
////    NSLog(@"%ld",self.imagesList.count);
////    
////    [self createSquares];
//    
//
//}

/**
 * 创建照片数组
 */
- (void)createSquares
{
    // 每行的列数
    int colsCount = cols;
    
    // 按钮尺寸
    CGFloat imageW =
    SSScreenW - 2 * margin/ colsCount;
    CGFloat imageH = imageW;
    
    // 遍历所有的模型
    NSUInteger count = self.imagesList.count;
    
    for (NSUInteger i = 0; i < count; i++) {
        // 创建按钮
        UIImageView *imageView = [[UIImageView alloc] init];
        
        [self.imagesView addSubview:imageView];
        
        // frame
        CGFloat imageX = (i % colsCount) * imageW;
        CGFloat imageY = (i / colsCount) * imageH;
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        
        // 设置照片数据

        for (ArtworkAttachmentListModel *model in self.imagesList) {
            
            NSLog(@"--------%@",model.fileName);
            
//            [imageView sd_setImageWithURL:[NSURL URLWithString:model.fileName] placeholderImage:nil];
        }
    }
}


/*
- (void)awakeFromNib {
    
    //设置cell中每个按钮的此存
    self.collectionViewFlowLayout.itemSize = CGSizeMake(cellWH, cellWH);
    
    //设置cell之间的间距
     self.collectionViewFlowLayout.minimumInteritemSpacing = margin;
     self.collectionViewFlowLayout.minimumLineSpacing = margin;
    
    
    //设置UICollectionView的数据源,设置数据
    self.collectionView.dataSource = self;
    
    //14. 处理点击方块的业务逻辑,实现点击方块,跳转到网页界面
    //设置点击方块代理
    self.collectionView.delegate = self;
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ImageCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:ID4];
    
    //10. 因为UICollectionView作为控制器的tableView的footerView,所以我们不能让UICollectionView视线自己滚动,而是跟着控制器的tableView的滚动而滚动
    //取消collectionView的弹簧效果,还是不行
    //        self.collectionView.bounces = NO;
    //设置collectionView不能滚动 ---- 直接跳进collectionView的头文件搜索scroll,发现并没有相关属性,跳进父类UIScrollView中搜素发现scrollEnabled属性
    self.collectionView.scrollEnabled = NO;



}

//实现UICollectionView数据源方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    NSLog(@"%ld",self.imagesList.count);
    
    return self.imagesList.count;

    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //创建cell,并且一看到方法中含有forIndexPath参数一定是要使用注册来创建的
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID4 forIndexPath:indexPath];
    
    //    cell.backgroundColor = [UIColor redColor];
    
    //6. 设置cell的数据---因为原图现实的cell是上下结构的,所以我们还得需要自定义cell
    //7. 因为要给cell设置数据,所以cell中应该有个属性,然后在cell中实现数据的set方法
    
    //取出数据
    ArtworkAttachmentListModel *model = self.imagesList[indexPath.row];

    cell.model = model;
    
    return cell;
}
*/



@end
