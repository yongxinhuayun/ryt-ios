//
//  CompleteUserInfoController.m
//  融易投
//
//  Created by efeiyi on 16/3/31.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "CompleteUserInfoController.h"
#import "UIImageView+WebCache.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@interface CompleteUserInfoController ()
@property (weak, nonatomic) IBOutlet UIImageView *headPortrait;

@end

@implementation CompleteUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    NSURL *url = [NSURL URLWithString:@"http://e.hiphotos.baidu.com/image/pic/item/9825bc315c6034a852fd0096c81349540923768d.jpg"];
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:url options:kNilOptions progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        // expectedSize 下载的图片的总大小
        // receivedSize 已经接受的大小
        NSLog(@"expectedSize = %ld, receivedSize = %ld", expectedSize, receivedSize);
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        NSLog(@"%@", image);
        self.headPortrait.image = image;
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(NSString *) md5: (NSString *) inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

@end
