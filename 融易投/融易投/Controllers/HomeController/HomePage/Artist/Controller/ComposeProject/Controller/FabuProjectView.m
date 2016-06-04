//
//  ComposeProjectView.m
//  融易投
//
//  Created by efeiyi on 16/5/11.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "FabuProjectView.h"
#import "ProjectDetailsModel.h"
#import "ArtworkModel.h"


#import "UIImageView+WebCache.h"

@interface FabuProjectView ()

@end

@implementation FabuProjectView

+(instancetype)composeProjectView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

-(void)setProjectModel:(ProjectDetailsModel *)projectModel{
    
    _projectModel = projectModel;
    
    self.projectTextField.text = projectModel.artWork.title;
    
    NSLog(@"%@",projectModel.artWork.title);
    
    self.progectTextView.text = projectModel.artWork.brief;
    
    self.projectTimeTextField.text = projectModel.artWork.duration;
    
    self.projecTotaltTextField.text = [NSString stringWithFormat:@"%zd",projectModel.artWork.investGoalMoney];
    
    NSString *pictureUrlStr = [[NSString stringWithFormat:@"%@",projectModel.artWork.picture_url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *pictureUrlURL = [NSURL URLWithString:pictureUrlStr];
    
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    
    [self.imageView sd_setImageWithURL:pictureUrlURL placeholderImage:[UIImage imageNamed:@"defaultBackground"]];
    
    //    NSString *cacheImageKey = [[SDWebImageManager sharedManager] cacheKeyForURL:pictureUrlURL];
    //    if (cacheImageKey.length) {
    //        NSString *cacheImagePath = [[SDImageCache sharedImageCache] defaultCachePathForKey:cacheImageKey];
    //        SSLog(@"%@",cacheImagePath);
    //    }
    
}



@end
