//
//  TopRecordTableViewCell.m
//  
//
//  Created by dongxin on 16/5/5.
//
//

#import "TopRecordTableViewCell.h"
#import "RecordModel.h"
#import "RecordModelList.h"
#import "UserMyModel.h"

@implementation TopRecordTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)clickUserImage:(UIButton *)sender {
    
    NSLog(@"点击了头像");
}

//设置数据
-(void)setupUI:(NSMutableArray *)topList{
    topList = [NSMutableArray array];
    int i = 0;
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
//    if (topList.count == 0) {
//        self.top1Icon.hidden = YES;
//        self.top1Name.hidden = YES;
//        self.top1Time.hidden = YES;
//        self.top1Icon.hidden = YES;
//        self.label1.hidden = YES;
//        self.top1img.hidden = YES;
//    }else
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
