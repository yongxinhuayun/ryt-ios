//
//  ComposeProjectView.h
//  融易投
//
//  Created by efeiyi on 16/5/11.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProjectDetailsModel;

@interface FabuProjectView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UITextField *projectTextField;
@property (weak, nonatomic) IBOutlet UITextView *progectTextView;

@property (weak, nonatomic) IBOutlet UITextField *projecTotaltTextField;
@property (weak, nonatomic) IBOutlet UITextField *projectTimeTextField;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;


@property (nonatomic, strong) ProjectDetailsModel *projectModel;

+(instancetype)composeProjectView;

@end
