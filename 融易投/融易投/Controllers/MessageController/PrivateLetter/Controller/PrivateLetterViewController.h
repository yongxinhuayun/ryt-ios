//
//  PrivateLetterViewController.h
//  融易投
//
//  Created by efeiyi on 16/4/8.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrivateLetterViewController : UIViewController
/*
 * UserId : 私信接受者,当前被查看的用户
 */
@property(nonatomic,copy)NSString *userId;

/*
 * fromUserId : 私信发送者,当前登录的用户
 */
@property(nonatomic,copy) NSString *fromUserId;
@end
