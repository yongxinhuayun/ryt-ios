//
//  TopRecordTableViewCell.h
//  
//
//  Created by dongxin on 16/5/5.
//
//

#import <UIKit/UIKit.h>

@interface TopRecordTableViewCell : UITableViewCell
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
@property (weak, nonatomic) IBOutlet UILabel *top1Money;

@property (weak, nonatomic) IBOutlet UILabel *top2Money;
@property (weak, nonatomic) IBOutlet UILabel *top3Money;


@end
