//
//  imageViewController.m
//  类似微信发朋友圈图片
//
//  Created by CuiJianZhou on 16/2/2.
//  Copyright © 2016年 CJZ. All rights reserved.
//

#import "imageViewController.h"
#import "MBProgressHUD.h"

CGFloat const gestureMinimumTranslation = 10.0 ;

typedef enum : NSInteger {
    
    kCameraMoveDirectionNone,
    
    kCameraMoveDirectionUp,
    
    kCameraMoveDirectionDown,
    
    kCameraMoveDirectionRight,
    
    kCameraMoveDirectionLeft
    
} CameraMoveDirection ;

@interface imageViewController (){
    
    CameraMoveDirection direction;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@end

@implementation imageViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.imageArray.count < self.imageCount) {
        
        [self.imageArray addObject:self.image];
    }
    
    NSDictionary *dic = @{@"array":self.imageArray};
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"byValue" object:nil userInfo:dic];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    self.imageV.userInteractionEnabled = YES;
    [self.imageV addGestureRecognizer:pan];
    
    UIImage *image = [self.imageArray lastObject];
    
    if (image == self.image) {
        
        [self.imageArray removeLastObject];
        
    }

    [self changeData];
}

#pragma mark ======= 删除图片的方法

- (IBAction)deleteImage:(id)sender {
    
    [self.imageArray removeObjectAtIndex:self.selectedIndex];
   
    if (self.selectedIndex == self.imageArray.count) {
        self.selectedIndex--;
    }

    [self changeData];
    
}

#pragma mark ===== 保存图片 ========

- (IBAction)saveImage:(id)sender {
    
    [self saveImageToPhotos:self.imageArray[self.selectedIndex]];
}

/**
 *  保存图片
 */
-(void)saveImageToPhotos:(UIImage *)image{
    
    UIImageWriteToSavedPhotosAlbum(image, self,@selector(image:didFinishSavingWithError:contextInfo:),NULL);
    
}

/**
 * 保存成功或者失败的回调
 */
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    [HUD show:YES];

    if (error != NULL){
         HUD.labelText = @"保存图片失败";
    } else{
         HUD.labelText = @"保存图片成功";
    }
    
    [HUD hide:YES afterDelay:2.0];
    
}

#pragma mark ======= 拖动手势 ====

- (void)pan:(UIPanGestureRecognizer *)sender {
    
    CGPoint translation = [sender translationInView:self.view];
    
    if (sender.state == UIGestureRecognizerStateBegan ) {
        
        direction = kCameraMoveDirectionNone;
        
    } else if (sender.state == UIGestureRecognizerStateChanged &&
               
               direction == kCameraMoveDirectionNone) {
        
        direction = [self determineCameraDirectionIfNeeded:translation];
        
        switch (direction) {
                
            case kCameraMoveDirectionDown:
                break ;
                
            case kCameraMoveDirectionUp:
                break ;
                
            case kCameraMoveDirectionRight:
    
                if (self.selectedIndex > 0) {
                    self.selectedIndex--;
                    [self changeData];
                }
                break ;
                
            case kCameraMoveDirectionLeft:
               
                if (self.selectedIndex + 1 < self.imageArray.count) {
                    self.selectedIndex++;
                    [self changeData];
                }
                break ;
                
        }
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        
        NSLog (@ "停止滑动" );
        
    }
    
}

- (void)changeData {
    
    if (!self.imageArray.count) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
        return;
    }
    
    //  设置索引文本
    self.title = [NSString stringWithFormat:@"%ld/%zd",self.selectedIndex + 1,self.imageArray.count];
    //  改变图片
    [UIView animateWithDuration:2.0 animations:^{
          self.imageV.image = self.imageArray[self.selectedIndex];
    }];
  

}

//判断拖动手势
- (CameraMoveDirection)determineCameraDirectionIfNeeded:(CGPoint)translation {
    
    if (direction != kCameraMoveDirectionNone){
        
        return direction;
    }
    
    if (fabs(translation.x) > gestureMinimumTranslation) {
        
        BOOL gestureHorizontal = NO;
        
        if (translation.y == 0.0 ) {
            gestureHorizontal = YES;
        }else {
            gestureHorizontal = (fabs(translation.x / translation.y) > 5.0 );
        }
        
        if (gestureHorizontal) {
            
            if (translation.x > 0.0 ) {
                return kCameraMoveDirectionRight;
            } else {
                return kCameraMoveDirectionLeft;
            }
            
        }
        
    } else if (fabs(translation.y) > gestureMinimumTranslation) {
        
        BOOL gestureVertical = NO;
        
        if (translation.x == 0.0 ) {
            gestureVertical = YES;
        } else {
            gestureVertical = (fabs(translation.y / translation.x) > 5.0 );
        }
        
        
        if (gestureVertical) {
            
            if (translation.y > 0.0 ) {
                
                return kCameraMoveDirectionDown;
            } else {
                
                return kCameraMoveDirectionUp;
            }
            
        }
        
    }
    
    return direction;
    
}

@end
