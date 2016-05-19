//
//  ArtistWorksCell.m
//  融易投
//
//  Created by efeiyi on 16/5/6.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "ArtistWorksCell.h"

#import "MasterWorkListModel.h"

#import "UIImageView+WebCache.h"

@interface ArtistWorksCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *year;
@property (weak, nonatomic) IBOutlet UILabel *status;

@end

@implementation ArtistWorksCell

-(void)setModel:(MasterWorkListModel *)model{

    NSString *pictureUrlStr = [[NSString stringWithFormat:@"%@",model.pictureUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *pictureUrlURL = [NSURL URLWithString:pictureUrlStr];
    
    [self.iconView sd_setImageWithURL:pictureUrlURL placeholderImage:[UIImage imageNamed:@"defaultBackground"]];

    self.title.text = model.name;
    self.type.text = model.material;
    self.year.text = model.createYear;
    
    //0:非卖品 1:可售 2:已售
    if ([model.status isEqualToString:@"0"]){
        
       self.status.text = @"非卖品";
        
    }else if ([model.status isEqualToString:@"1"]){
        
        self.status.text = @"可售";
        
    }else {
        
       self.status.text = @"已售";
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
