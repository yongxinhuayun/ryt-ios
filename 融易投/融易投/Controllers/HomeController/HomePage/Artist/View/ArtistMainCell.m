//
//  MyArtworkCell.m
//  融易投
//
//  Created by efeiyi on 16/4/25.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "ArtistMainCell.h"
#import "ArtworkListModel.h"

#import "UIImageView+WebCache.h"

@interface ArtistMainCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *projectTitle;
@property (weak, nonatomic) IBOutlet UILabel *projectTotal;
@property (weak, nonatomic) IBOutlet UILabel *projectDes;


@end



@implementation ArtistMainCell

-(void)setModel:(ArtworkListModel *)model{

    _model = model;
    
    NSString *pictureUrlStr = [[NSString stringWithFormat:@"%@",model.picture_url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *pictureUrlURL = [NSURL URLWithString:pictureUrlStr];
    
    [self.iconImageView sd_setImageWithURL:pictureUrlURL placeholderImage:[UIImage imageNamed:@"defaultBackground"]];
    
    self.projectTitle.text = model.title;
    self.projectTotal.text = [NSString stringWithFormat:@"%ld",model.investGoalMoney];
    self.projectDes.text = model.brief;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
