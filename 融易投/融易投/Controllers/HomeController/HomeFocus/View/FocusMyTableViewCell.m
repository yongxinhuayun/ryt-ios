//
//  FocusMyTableViewCell.m
//  融易投
//
//  Created by efeiyi on 16/4/29.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "FocusMyTableViewCell.h"
#import "PageInfoListMyModel.h"

@interface FocusMyTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *focusBtn;


@end

@implementation FocusMyTableViewCell

-(void)awakeFromNib{

    //设置图片能够点击
    //记住:UIImageView默认情况下是不能接收事件的,如果要执行点击方法,必须把默认的User interaction Enable 改成yes
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    
    self.iconImageView.userInteractionEnabled = YES;
    [self.iconImageView addGestureRecognizer:tapGesture];
}

-(void)tap {
    
    if ([self.delegate respondsToSelector:@selector(clickUserIcon:)]) {
        [self.delegate clickUserIcon:self.indexPath];
    }
}

-(void)setModel:(PageInfoListMyModel *)model{
    
    _model = model;

    //代表type为1,model.master有值,为艺术家
    if (model.artUserFollowed.follower.master) {
        
        NSString *pictureUrlStr = [[NSString stringWithFormat:@"%@",model.artUserFollowed.follower.pictureUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *pictureUrlURL = [NSURL URLWithString:pictureUrlStr];
        
        [self.iconImageView ss_setHeader:pictureUrlURL];
        
        self.userNameLabel.text = model.artUserFollowed.follower.name;

        self.descriptionLabel.text = model.artUserFollowed.follower.userBrief.content;
    }else { //代表type为2,model.master无值,为普通用户
    
        NSString *pictureUrlStr = [[NSString stringWithFormat:@"%@",model.artUserFollowed.follower.pictureUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *pictureUrlURL = [NSURL URLWithString:pictureUrlStr];
        
        [self.iconImageView ss_setHeader:pictureUrlURL];
        
        self.userNameLabel.text = model.artUserFollowed.follower.name;
        
        self.descriptionLabel.text = model.artUserFollowed.follower.userBrief.content;
    }
    
    SSLog(@"%@",model.flag);
    
    //如果是自己看自己的关注,那么都是已经关注过的,所以直接显示关注状态
    UserMyModel *userModel = TakeLoginUserModel;
    NSString *userId = userModel.ID;
    if ([userId isEqualToString:model.artUserFollowed.user.ID]) {
        
        self.focusBtn.selected = YES;
        
    }else {
    
        //flag为1 为已关注
        if ([model.flag isEqualToString:@"1"]) {
            
            self.focusBtn.selected = YES;
            
        }else {  //flag为2 为未关注
            
            self.focusBtn.selected = NO;
        }
    }
}

- (IBAction)focusBtnClick:(UIButton *)sender {
    
    //判断当前用户是否登录
    RYTLoginManager *manager = [RYTLoginManager shareInstance];
    if (![manager showLoginViewIfNeed]) {
        // 如果用户登录了，获取当前用户的ID
        NSString *userId = [manager takeUser].ID;
        // 获取当前将要被关注的用户ID
        NSString *followId = self.model.artUserFollowed.follower.ID;
        //        NSString *identifier 0 为关注，1 为取消关注
        //因为后台返回的数据有时候可能为nil,当nil时即为关注,1为关注,2为未关注
        if (self.model.flag == nil) {
            self.model.flag = @"1";
        }
        
        NSString *identifier = self.model.flag ? @"1" : @"2";
        // followType 1:艺术家 2:普通用户
        NSString *followType = self.model.artUserFollowed.follower.master ? @"1" : @"2";
        NSDictionary *json = [ NSDictionary dictionary];
        
        //看别人即为既能关注也能取消关注
        //查看别人的ID
        NSString *otherID = self.model.artUserFollowed.user.ID;
        if (![userId isEqualToString:otherID]) {
            
            if (![self.model.artUserFollowed.ID isEqualToString:@""]) {
                json = @{ //取消关注
                         @"userId" : userId,
                         @"followId" : followId,
                         @"identifier" :identifier,
                         @"followType" : followType,
                         };
            }else{ //关注
                json = @{
                         @"userId" : userId,
                         @"followId" : followId,
                         @"identifier" :identifier,
                         @"followType" : followType,
                         };
            }
        }else{ //自己看自己即为取消关注
        
            json = @{ //取消关注
                     @"userId" : userId,
                     @"followId" : followId,
                     @"identifier" :identifier,
                     @"followType" : followType,
                     };
        }
        
        [[HttpRequstTool shareInstance] loadData:POST serverUrl:@"changeFollowStatus.do" parameters:json showHUDView:nil andBlock:^(id respondObj) {
            NSString *str = [[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
            NSLog(@"%@",str);
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
            NSString *resultCode = result[@"resultCode"];
            if ([resultCode isEqualToString:@"0"]) {
                sender.selected = !sender.selected;
                
                //发送通知,修改我的界面的数据
                [[NSNotificationCenter defaultCenter] postNotificationName:UpdateMeViewDataControllerNotification object:self];
            }
        }];
    }
}

//- (void)awakeFromNib {
//    // Initialization code
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
