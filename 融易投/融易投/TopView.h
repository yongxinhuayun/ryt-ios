//
//  TopView.h
//  融易投
//
//  Created by dongxin on 16/4/27.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIImageView *userPicture;

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userTitle;
@property (weak, nonatomic) IBOutlet UITextView *brief;
@property (weak, nonatomic) IBOutlet UILabel *finishedTime;
@end
