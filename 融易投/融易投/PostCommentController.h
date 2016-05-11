//
//  PostCommentController.h
//  融易投
//
//  Created by dongxin on 16/5/10.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostCommentController : UIViewController
@property(nonatomic,copy) NSString *artworkId;
@property(nonatomic,copy) NSString *currentUserId;
@property(nonatomic,copy) NSString *messageId;
@property(nonatomic,copy) NSString *fatherCommentId;
@end
