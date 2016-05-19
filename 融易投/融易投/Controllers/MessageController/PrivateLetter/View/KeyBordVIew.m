//
//  KeyBordVIew.m
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//

#import "KeyBordVIew.h"
#import "ChartMessage.h"
#import "ChartCellFrame.h"

@interface KeyBordVIew()<UITextFieldDelegate>
@property (nonatomic,strong) UIImageView *backImageView;
//@property (nonatomic,strong) UIButton *voiceBtn;
//@property (nonatomic,strong) UIButton *imageBtn;
//@property (nonatomic,strong) UIButton *addBtn;
//@property (nonatomic,strong) UIButton *speakBtn;

@property (nonatomic,strong) UITextField *textField;

@property (nonatomic,strong) UIButton *sendBtn;

@end

@implementation KeyBordVIew

CGFloat sendBtnW = 60;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialData];
    }
    return self;
}

-(UIButton *)buttonWith:(NSString *)noraml hightLight:(NSString *)hightLight action:(SEL)action
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    // 235 94 117
    btn.backgroundColor = [UIColor colorWithRed:235.0 /255.0 green:94.0 / 255.0 blue:117.0 / 255.0 alpha:1.0];
    [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 2;
    btn.layer.masksToBounds = YES;
    return btn;
}
-(void)initialData
{
    self.backgroundColor = [UIColor colorWithRed:250.0 / 255.0 green:250.0 / 255 blue:250.0 / 255.0 alpha:1.0];
//    self.backImageView=[[UIImageView alloc]initWithFrame:self.bounds];
//    self.backImageView.image=[UIImage strethImageWith:@"toolbar_bottom_bar.png"];
//    self.bac
//    [self addSubview:self.backImageView];
    
//    self.voiceBtn=[self buttonWith:@"chat_bottom_voice_nor.png" hightLight:@"chat_bottom_voice_press.png" action:@selector(voiceBtnPress:)];
//    [self.voiceBtn setFrame:CGRectMake(0,0, 33, 33)];
//    [self.voiceBtn setCenter:CGPointMake(30, self.frame.size.height*0.5)];
//    [self addSubview:self.voiceBtn];
    
    self.textField=[[UITextField alloc]initWithFrame:CGRectMake(14, 5, SSScreenW - sendBtnW - 34, self.frame.size.height * 0.8)];
//    self.textField.center=CGPointMake(145, self.frame.size.height*0.5);
    
    self.textField.returnKeyType=UIReturnKeySend;
    self.textField.font=[UIFont fontWithName:@"HelveticaNeue" size:14];
    self.textField.placeholder=@"";
//    self.textField.background=[UIImage imageNamed:@"chat_bottom_textfield.png"];
    self.textField.delegate=self;
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    [self addSubview:self.textField];
    
    self.sendBtn = [self buttonWith:@"nil" hightLight:@"nil" action:@selector(sendMessage)];
    [self.sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendBtn setFrame:CGRectMake(SSScreenW - sendBtnW - 14, 5, sendBtnW,33)];
    [self addSubview:self.sendBtn];
    
//    self.imageBtn=[self buttonWith:@"chat_bottom_smile_nor.png" hightLight:@"chat_bottom_smile_press.png" action:@selector(imageBtnPress:)];
//    [self.imageBtn setFrame:CGRectMake(0, 0, 33, 33)];
//    [self.imageBtn setCenter:CGPointMake(260, self.frame.size.height*0.5)];
//    [self addSubview:self.imageBtn];
    
//    self.addBtn=[self buttonWith:@"chat_bottom_up_nor.png" hightLight:@"chat_bottom_up_press.png" action:@selector(addBtnPress:)];
//    [self.addBtn setFrame:CGRectMake(0, 0, 33, 33)];
//    [self.addBtn setCenter:CGPointMake(300, self.frame.size.height*0.5)];
//    [self addSubview:self.addBtn];
    
//    self.speakBtn=[self buttonWith:nil hightLight:nil action:@selector(speakBtnPress:)];
//    [self.speakBtn setTitle:@"按住说话" forState:UIControlStateNormal];
//    [self.speakBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [self.speakBtn addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
//    [self.speakBtn setTitleColor:[UIColor redColor] forState:(UIControlState)UIControlEventTouchDown];
//    [self.speakBtn setBackgroundColor:[UIColor whiteColor]];
//    [self.speakBtn setFrame:self.textField.frame];
//    self.speakBtn.hidden=YES;
//    [self addSubview:self.speakBtn];
}


//发送消息
-(void)sendMessage
{
    if([self.delegate respondsToSelector:@selector(KeyBordView:textFiledReturn:)]){
        
        [self.delegate KeyBordView:self textFiledReturn:self.textField];
    }
    
    NSLog(@"%@",self.textField.text);
}

//-(void)touchDown:(UIButton *)voice
//{
//    //开始录音
//    
//    if([self.delegate respondsToSelector:@selector(beginRecord)]){
//    
//        [self.delegate beginRecord];
//    }
//    NSLog(@"开始录音");
//}

//-(void)speakBtnPress:(UIButton *)voice
//{
//   //结束录音
//    
//    if([self.delegate respondsToSelector:@selector(finishRecord)]){
//    
//        [self.delegate finishRecord];
//    }
//    NSLog(@"结束录音");
//}

//-(void)voiceBtnPress:(UIButton *)voice
//{
//    NSString *normal,*hightLight;
//    if(self.speakBtn.hidden==YES){
//        
//        self.speakBtn.hidden=NO;
//        self.textField.hidden=YES;
//       normal=@"chat_bottom_keyboard_nor.png";
//       hightLight=@"chat_bottom_keyboard_press.png";
//    
//    }else{
//    
//        self.speakBtn.hidden=YES;
//        self.textField.hidden=NO;
//        normal=@"chat_bottom_voice_nor.png";
//        hightLight=@"chat_bottom_voice_press.png";
//    
//    }
//    [voice setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
//    [voice setImage:[UIImage imageNamed:hightLight] forState:UIControlStateHighlighted];
//}

//-(void)imageBtnPress:(UIButton *)image
//{
//    
//    
//}

//-(void)addBtnPress:(UIButton *)image
//{
//    
//    
//}

//输入框
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if([self.delegate respondsToSelector:@selector(KeyBordView:textFiledBegin:)]){
        
        [self.delegate KeyBordView:self textFiledBegin:textField];
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([self.delegate respondsToSelector:@selector(KeyBordView:textFiledReturn:)]){
    
        [self.delegate KeyBordView:self textFiledReturn:textField];
    }
    return YES;
}

@end
