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

@implementation TopRecordTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)clickUserImage:(UIButton *)sender {
    
    NSLog(@"点击了头像");
}

//设置数据
-(void)setupUI:(NSMutableArray *)topList{
    int i = 0;
    for (RecordModel *model in topList) {
        if (i == 0) {
//            ID;
//            status;
//            createDatetime;
//            self.top1Icon   creator.icon
//            self.top1img     creator.
//            self.top1Money  price
//            self.top1Name
//            self.top1Time
            
        }
        i++;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
