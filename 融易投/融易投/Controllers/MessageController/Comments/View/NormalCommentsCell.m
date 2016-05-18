//
//  NormalCommentsCell.m
//  融易投
//
//  Created by 李鹏飞 on 16/5/18.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import "NormalCommentsCell.h"
#import "UserCommentListModel.h"
#import "CreatorModel.h"
#import "NSDate+Interval.h"
#import "ArtworkModel.h"
#import <UIImageView+WebCache.h>

@interface NormalCommentsCell()
@property (weak, nonatomic) IBOutlet UIButton *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *commentTime;

@property (weak, nonatomic) IBOutlet UITextView *content;
@property (weak, nonatomic) IBOutlet UILabel *HFLabel;
@property (weak, nonatomic) IBOutlet UIButton *HFUserName;
@property (weak, nonatomic) IBOutlet UIButton *HFUserNameBtn;
@property (weak, nonatomic) IBOutlet UITextView *HFContent;
@property (weak, nonatomic) IBOutlet UIImageView *artworkPicture;

@property (weak, nonatomic) IBOutlet UILabel *artworkTitle;
@property (weak, nonatomic) IBOutlet UILabel *artworkBrief;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnConstriant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *HFContentConstriant;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *HFBtn;


@end
@implementation NormalCommentsCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.HFBtn.layer setMasksToBounds:YES];
    [self.HFBtn.layer setCornerRadius:3.0]; //设置矩形四个圆角半径
    [self.HFBtn.layer setBorderWidth:1.0]; //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.8, 0.2, 0.1, 0.8 });
    [self.HFBtn.layer setBorderColor:colorref];//边框颜色
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickArtworkView)];
    [self.bottomView addGestureRecognizer:tapGesture];
}

-(void)setCommentModel:(UserCommentListModel *)commentModel{
        //设置cell 的属性值
    _commentModel = commentModel;
    //设置用户的头像
    NSString *urlStr = [[NSString stringWithFormat:@"%@",commentModel.creator.pictureUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UIImageView *imgView = [[UIImageView alloc] init];
    [imgView ss_setHeader:[NSURL URLWithString:urlStr]];
    [self.userIcon setImage:imgView.image forState:(UIControlStateNormal)];
    //设置用户名称
    self.userName.text = commentModel.creator.name;
    //设置时间
    NSDate *date =[NSDate dateWithTimeIntervalSince1970:commentModel.createDatetime / 1000];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateStr = [fmt stringFromDate:date];
    self.commentTime.text = [date createdAt:dateStr];
    //设置评论内容
    if (commentModel.fatherArtworkCommentBean) {
        self.HFUserName.hidden = NO;
        self.HFUserNameBtn.hidden = NO;
        self.HFContent.hidden = NO;
        self.HFLabel.hidden = NO;
        self.btnConstriant.constant = 29;
        self.HFContentConstriant.constant = 30;
        [self.HFUserName setTitle:commentModel.fatherArtworkCommentBean.creator.name forState:(UIControlStateNormal)];
        NSString *name = [NSString stringWithFormat:@"@%@",commentModel.fatherArtworkCommentBean.creator.name];
        [self.HFUserNameBtn setTitle:name forState:(UIControlStateNormal)];
        
        self.HFContent.text = commentModel.fatherArtworkCommentBean.content;
        // 具有父评论的时候，设置content 首行缩进        
        self.content.attributedText = [self setAttributesString:commentModel.content withFrame:self.HFUserName.frame firstLineHeadIndent:20];
        self.HFContent.attributedText = [self setAttributesString:commentModel.fatherArtworkCommentBean.content withFrame:self.HFUserNameBtn.frame firstLineHeadIndent:20];
    }else{
        self.HFUserName.hidden = YES;
        self.HFLabel.hidden = YES;
        self.HFUserNameBtn.hidden = YES;
        self.HFContent.hidden = YES;
        self.btnConstriant.constant = 0;
        self.HFContentConstriant.constant = 0;
        self.content.text = commentModel.content;
    }
    //设置项目图片
    NSString *picStr = [[NSString stringWithFormat:@"%@",commentModel.creator.pictureUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.artworkPicture sd_setImageWithURL:[NSURL URLWithString:picStr] placeholderImage:[UIImage imageNamed:@"defaultBackground"]];
    self.artworkTitle.text = commentModel.artwork.title;
    self.artworkBrief.text = commentModel.artwork.brief;
}

-(NSAttributedString *)setAttributesString:(NSString *)string withFrame:(CGRect)frame firstLineHeadIndent:(CGFloat)margin{
    CGFloat x = CGRectGetMaxX(frame);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.firstLineHeadIndent = x - margin;
    paragraphStyle.alignment = NSTextAlignmentJustified;
    NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName:[UIColor colorWithRed:76./255. green:75./255. blue:71./255. alpha:1]};
    NSString *appendString = [NSString stringWithFormat:@": %@",string];
    return [[NSAttributedString alloc]initWithString:appendString attributes:attributes];

}

- (IBAction)clickHFBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(postUserComments:)]) {
        [self.delegate postUserComments:self.commentModel];
    }
}

-(void)clickArtworkView{
    if ([self.delegate respondsToSelector:@selector(jumpToDetailController:)]) {
        [self.delegate jumpToDetailController:self.commentModel.artwork.ID];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
}

@end
