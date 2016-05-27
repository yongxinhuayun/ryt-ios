//
//  UserReplyCommentCell.m
//  融易投
//
//  Created by dongxin on 16/5/6.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "UserReplyCommentCell.h"
#import "CreatorModel.h"
#import "ArtworkCommentListModel.h"
#import "UIImageView+WebCache.h"
#import <UIKit/UIKit.h>
@interface UserReplyCommentCell()
@property (weak, nonatomic) IBOutlet UIButton *userPic;
@property (weak, nonatomic) IBOutlet UIButton *userName;
@property (weak, nonatomic) IBOutlet UILabel *replyTime;
@property (weak, nonatomic) IBOutlet UIButton *replyName;
@property (weak, nonatomic) IBOutlet UITextView *content;
@end
@implementation UserReplyCommentCell

- (void)awakeFromNib {
    self.content.userInteractionEnabled = NO;
}

-(void)setModel:(ArtworkCommentListModel *)model{
    _model = model;
    
    
    
//    urlStr = [[NSString stringWithFormat:@"%@",author.pictureUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    picUrl = [NSURL URLWithString:urlStr];
//    
//    [self.financeHeader.userPicture ss_setHeader:picUrl];
    
//    NSString *urlStr = [model.creator.pictureUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlStr = [[NSString stringWithFormat:@"%@",model.creator.pictureUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    UIImageView *imgView = [[UIImageView alloc] init];
    [imgView ss_setHeader:url];
    [self.userPic setBackgroundImage:imgView.image forState:(UIControlStateNormal)];
    [self.userName setTitle:model.creator.name forState:(UIControlStateNormal)];
    ArtworkCommentListModel *fatherComment = [[ArtworkCommentListModel alloc] init];
    fatherComment = model.fatherComment;
    [self.replyName setTitle:fatherComment.creator.name forState:(UIControlStateNormal)];
    [self.replyName sizeToFit];
    
    CGFloat x = CGRectGetMaxX(self.replyName.frame);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.firstLineHeadIndent = x - 70;
    paragraphStyle.alignment = NSTextAlignmentJustified;
    NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName:[UIColor colorWithRed:76./255. green:75./255. blue:71./255. alpha:1]};
    NSString *appendString = [NSString stringWithFormat:@":%@",model.content];
    self.content.attributedText = [[NSAttributedString alloc]initWithString:appendString attributes:attributes];
}

- (IBAction)clickUserName:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(clickUserIcon:)]) {
        [self.delegate clickUserIcon:self.indexPath];
    }
//    NSLog(@"跳转到用户信息页面 %@",self.indexPath);
}
- (IBAction)clickFatherName:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(clickfatherIcon:)]) {
        [self.delegate clickfatherIcon:self.indexPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
}

@end
