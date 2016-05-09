//
//  ArtworkAttachmentListModel.h
//  融易投
//
//  Created by efeiyi on 16/4/16.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArtworkAttachmentListModel : NSObject
//服务器返回的是数组
/** 用户上传项目图片附件 */
@property (nonatomic ,strong) NSString *fileName;
@property(nonatomic,copy) NSString *fileType;

@end
