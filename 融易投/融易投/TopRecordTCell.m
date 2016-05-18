//
//  TopRecordTCell.m
//  融易投
//
//  Created by 李鹏飞 on 16/5/17.
//  Copyright © 2016年 融艺投. All rights reserved.
//

#import "TopRecordTCell.h"
#import "RecordModel.h"
#import "RecordModelList.h"
#import "UserMyModel.h"


@interface TopRecordTCell()
@property (weak, nonatomic) IBOutlet UIButton *top1Icon;
@property (weak, nonatomic) IBOutlet UIButton *top2Icon;
@property (weak, nonatomic) IBOutlet UIButton *top3Icon;

@property (weak, nonatomic) IBOutlet UIImageView *top2img;
@property (weak, nonatomic) IBOutlet UIImageView *top1img;
@property (weak, nonatomic) IBOutlet UIImageView *top3img;

@property (weak, nonatomic) IBOutlet UILabel *top2Name;
@property (weak, nonatomic) IBOutlet UILabel *top1Name;
@property (weak, nonatomic) IBOutlet UILabel *top3Name;

@property (weak, nonatomic) IBOutlet UILabel *top2Time;
@property (weak, nonatomic) IBOutlet UILabel *top1Time;
@property (weak, nonatomic) IBOutlet UILabel *top3Time;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;

@property (weak, nonatomic) IBOutlet UIView *top1;
@property (weak, nonatomic) IBOutlet UIView *top2;
@property (weak, nonatomic) IBOutlet UIView *top3;

@property (weak, nonatomic) IBOutlet UILabel *top1Money;
@property (weak, nonatomic) IBOutlet UILabel *top2Money;
@property (weak, nonatomic) IBOutlet UILabel *top3Money;
@end

@implementation TopRecordTCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)setupUI:(NSMutableArray *)topList{
    int i = 0;
    self.top1.hidden = YES;
    self.top2.hidden = YES;
    self.top3.hidden = YES;
    for (int i = 0; i < topList.count; i++) {
        if (i == 0) {
            self.top1.hidden = NO;
        }else if(i == 1){
            self.top2.hidden = NO;
        }else{
            self.top3.hidden = NO;
        }
    }
    for (RecordModel *model in topList) {
        if (i == 0) {
            NSString *urlStr = [[NSString stringWithFormat:@"%@",model.creator.pictureUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            UIImageView *imgView = [[UIImageView alloc] init];
            [imgView ss_setHeader:[NSURL URLWithString:urlStr]];
            [self.top1Icon setImage:imgView.image forState:(UIControlStateNormal)];
            self.top1Name.text = model.creator.name;
            NSDate * date = [NSDate dateWithTimeIntervalSince1970:model.createDatetime / 1000];
            NSDateFormatter *dfm = [[NSDateFormatter alloc] init];
            [dfm setDateFormat:@"yyyy-MM-dd"];
            self.top1Time.text = [dfm stringFromDate:date];
            self.top1Money.text = [NSString stringWithFormat:@"￥%ld",model.price];            
        }else if (i == 1){
            NSString *urlStr = [[NSString stringWithFormat:@"%@",model.creator.pictureUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            UIImageView *imgView = [[UIImageView alloc] init];
            [imgView ss_setHeader:[NSURL URLWithString:urlStr]];
            [self.top2Icon setImage:imgView.image forState:(UIControlStateNormal)];
            self.top2Name.text = model.creator.name;
            NSDate * date = [NSDate dateWithTimeIntervalSince1970:model.createDatetime / 1000];
            NSDateFormatter *dfm = [[NSDateFormatter alloc] init];
            [dfm setDateFormat:@"yyyy-MM-dd"];
            
            self.top2Time.text = [dfm stringFromDate:date];
            self.top2Money.text = [NSString stringWithFormat:@"￥%ld",model.price];
            
        }else{
            
            NSString *urlStr = [[NSString stringWithFormat:@"%@",model.creator.pictureUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            UIImageView *imgView = [[UIImageView alloc] init];
            [imgView ss_setHeader:[NSURL URLWithString:urlStr]];
            [self.top3Icon setImage:imgView.image forState:(UIControlStateNormal)];
            self.top3Name.text = model.creator.name;
            NSDate * date = [NSDate dateWithTimeIntervalSince1970:model.createDatetime / 1000];
            NSDateFormatter *dfm = [[NSDateFormatter alloc] init];
            [dfm setDateFormat:@"yyyy-MM-dd"];
            
            self.top3Time.text = [dfm stringFromDate:date];
            self.top3Money.text = [NSString stringWithFormat:@"￥%ld",model.price];
        }
        i++;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //    [super setSelected:selected animated:animated];
}
- (IBAction)clickTop:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(clickUserBtn:)]) {
        [self.delegate clickUserBtn:sender.tag - 2000];
    }
}


@end
