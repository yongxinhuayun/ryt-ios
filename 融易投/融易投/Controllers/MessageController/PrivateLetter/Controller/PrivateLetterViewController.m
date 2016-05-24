 //
//  PrivateLetterViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/8.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "PrivateLetterViewController.h"

#import "ChartCellFrame.h"
#import "ChartCell.h"
#import "KeyBordVIew.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "MessageResultModel.h"
#import "PrivateLetterModel.h"
#import "UserMyModel.h"
#import <MJExtension.h>
#import "MessageResultModel.h"
#import "PrivateLetterModel.h"
#import "CommonNavigationController.h"

@interface PrivateLetterViewController ()<UITableViewDataSource,UITableViewDelegate,KeyBordVIewDelegate,ChartCellDelegate,AVAudioPlayerDelegate,CommonNavigationDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) KeyBordVIew *keyBordView;
@property (nonatomic,strong) NSMutableArray *cellFrames;
@property (nonatomic,assign) BOOL recording;
@property (nonatomic,strong) NSString *fileName;
@property (nonatomic,strong) AVAudioRecorder *recorder;
@property (nonatomic,strong) AVAudioPlayer *player;
@property(nonatomic,strong) NSMutableArray *letters;

@end

@implementation PrivateLetterViewController

static NSString *const cellIdentifier=@"QQChart";

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY=keyBoardRect.size.height;
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
        self.view.transform=CGAffineTransformMakeTranslation(0, -deltaY);
    }];
}
-(void)keyboardHide:(NSNotification *)note
{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //在此处修改跟当前用户聊天的名称
    self.title=@"私信";
    self.view.backgroundColor=[UIColor whiteColor];

    [UserMyModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return [NSDictionary dictionaryWithObject:@"id" forKey:@"ID"];
    }];
    [PrivateLetterModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return [NSDictionary dictionaryWithObject:@"id" forKey:@"ID"];
    }];
    [MessageResultModel mj_setupObjectClassInArray:^NSDictionary *{
        return [NSDictionary dictionaryWithObject:@"PrivateLetterModel" forKey:@"objectList"];
    }];
    //add UItableView
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44) style:UITableViewStylePlain];
    [self.tableView registerClass:[ChartCell class] forCellReuseIdentifier:cellIdentifier];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
//    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self.view addSubview:self.tableView];
    //add keyBorad
    self.keyBordView=[[KeyBordVIew alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height- 44, self.view.frame.size.width, 44)];
    self.keyBordView.delegate=self;
    [self.view addSubview:self.keyBordView];
//        [self postLetter];
    [self loadUserLetter];
}

//进入控制器加载聊天记录
-(void)loadUserLetter{
    //当前用户id
//    NSString *userId = @"ioe4rahi670jsgdt";
//    NSString *fromUserId = @"iijq9f1r7apprtab";
    // 私信用户id
    NSDictionary *json = @{
                           @"userId" : self.userId,
                           @"fromUserId" : self.fromUserId
                           };
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:@"commentDetail.do" parameters:json showHUDView:self.view andBlock:^(id respondObj) {
        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        NSLog(@"返回结果:%@",jsonStr);
        MessageResultModel *messModel = [MessageResultModel mj_objectWithKeyValues:respondObj];
        [self.letters addObjectsFromArray:messModel.objectList];
        //初始化数据
        dispatch_async(dispatch_get_main_queue(), ^{
            [self initwithData];
            [self.tableView reloadData];
            [self tableViewScrollCurrentIndexPath];
        });
    }];
}

//NSString *targetUserId = @"imhipoyk18s4k52u"; 接受者
//NSString *fromUserId = @"imhfp1yr4636pj49"; 发送者
//imhfp1yr4636pj49
-(void)postLetter:(NSString *)text{
    NSString *content = text;
    NSString *targetUserId = @"ioe4rahi670jsgdt"; // 消息接受方
    NSString *fromUserId = @"iijq9f1r7apprtab"; // 消息发送方
    NSDictionary *json = @{
                           @"content" : content,
                           @"targetUserId" : targetUserId,
                           @"fromUserId" : fromUserId
                           };
//    userBinding.do
//  注册cid
//    NSDictionary *j = @{
//                        @"cid":registrationID,
//                        @"username":@"18211025820",
//                        @"password":@"123456",
//                        };
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:@"pushMessage.do" parameters:json showHUDView:nil andBlock:^(id respondObj) {
        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
        NSLog(@"返回结果:%@",jsonStr);
        MessageResultModel *resultModel = [MessageResultModel mj_objectWithKeyValues:respondObj];
        [self.letters addObjectsFromArray:resultModel.objectList];
        
    }];
    
}

-(void)initwithData
{
    self.cellFrames=[NSMutableArray array];
    for(PrivateLetterModel *letter in self.letters){
        ChartCellFrame *cellFrame=[[ChartCellFrame alloc]init];
        ChartMessage *chartMessage=[[ChartMessage alloc]init];
        chartMessage.letterModel = letter;
        cellFrame.chartMessage=chartMessage;
        [self.cellFrames addObject:cellFrame];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellFrames.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChartCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.cellFrame=self.cellFrames[indexPath.row];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.cellFrames[indexPath.row] cellHeight];
}

//-(void)chartCell:(ChartCell *)chartCell tapContent:(NSString *)content
//{
//    if(self.player.isPlaying){
//        
//        [self.player stop];
//    }
//    //播放
//    NSString *filePath=[NSString documentPathWith:content];
//    NSURL *fileUrl=[NSURL fileURLWithPath:filePath];
//    [self initPlayer];
//    NSError *error;
//    self.player=[[AVAudioPlayer alloc]initWithContentsOfURL:fileUrl error:&error];
//    [self.player setVolume:1];
//    [self.player prepareToPlay];
//    [self.player setDelegate:self];
//    [self.player play];
//    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
//}
//-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
//{
//    [[UIDevice currentDevice]setProximityMonitoringEnabled:NO];
//    [self.player stop];
//    self.player=nil;
//}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    [self.view endEditing:YES];
}
-(void)KeyBordView:(KeyBordVIew *)keyBoardView textFiledReturn:(UITextField *)textFiled
{
    ChartCellFrame *cellFrame=[[ChartCellFrame alloc]init];
    ChartMessage *chartMessage=[[ChartMessage alloc]init];
    chartMessage.icon = nil;
    chartMessage.content =textFiled.text;
    chartMessage.messageType = kMessageTo;
    cellFrame.chartMessage=chartMessage;
    [self.cellFrames addObject:cellFrame];
//
//    int random=arc4random_uniform(2);
//    NSLog(@"%d",random);
//    chartMessage.icon=[NSString stringWithFormat:@"icon%02d.jpg",random+1];
//    chartMessage.messageType=kMessageFrom;
//    chartMessage.content=textFiled.text;
//    cellFrame.chartMessage=chartMessage;
//
//    [self.cellFrames addObject:cellFrame];
    
    //发送给后台
    [self postLetter:textFiled.text];
    
    [self.tableView reloadData];
    
    //滚动到当前行
    [self tableViewScrollCurrentIndexPath];
    
    //在此处调用服务器的接口
    textFiled.text = @"";
}

-(void)KeyBordView:(KeyBordVIew *)keyBoardView textFiledBegin:(UITextField *)textFiled
{
    [self tableViewScrollCurrentIndexPath];
    
}
-(void)beginRecord
{
    if(self.recording)return;
    
    self.recording=YES;
    
    NSDictionary *settings=[NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithFloat:8000],AVSampleRateKey,
                            [NSNumber numberWithInt:kAudioFormatLinearPCM],AVFormatIDKey,
                            [NSNumber numberWithInt:1],AVNumberOfChannelsKey,
                            [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                            [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                            [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                            nil];
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyyMMddHHmmss"];
    NSString *fileName = [NSString stringWithFormat:@"rec_%@.wav",[dateFormater stringFromDate:now]];
    self.fileName=fileName;
    NSString *filePath=[NSString documentPathWith:fileName];
    NSURL *fileUrl=[NSURL fileURLWithPath:filePath];
    NSError *error;
    self.recorder=[[AVAudioRecorder alloc]initWithURL:fileUrl settings:settings error:&error];
    [self.recorder prepareToRecord];
    [self.recorder setMeteringEnabled:YES];
    [self.recorder peakPowerForChannel:0];
    [self.recorder record];
    
}
-(void)finishRecord
{
    self.recording=NO;
    [self.recorder stop];
    self.recorder=nil;
    ChartCellFrame *cellFrame=[[ChartCellFrame alloc]init];
    ChartMessage *chartMessage=[[ChartMessage alloc]init];
    
    int random=arc4random_uniform(2);
    NSLog(@"%d",random);
    chartMessage.icon=[NSString stringWithFormat:@"icon%02d.jpg",random+1];
    chartMessage.messageType=random;
    chartMessage.content=self.fileName;
    cellFrame.chartMessage=chartMessage;
    [self.cellFrames addObject:cellFrame];
    [self.tableView reloadData];
    [self tableViewScrollCurrentIndexPath];
    
}
-(void)tableViewScrollCurrentIndexPath
{
//    if (self.cellFrames.count > 1) {
//        
//        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:self.cellFrames.count-1 inSection:0];
//        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//    }
    
    if(self.cellFrames.count == 0) return;
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:self.cellFrames.count-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

-(void)initPlayer{
    //初始化播放器的时候如下设置
    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
                            sizeof(sessionCategory),
                            &sessionCategory);
    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                             sizeof (audioRouteOverride),
                             &audioRouteOverride);
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //默认情况下扬声器播放
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    audioSession = nil;
}

-(NSMutableArray *)letters{
    if (!_letters) {
        _letters = [NSMutableArray array];
    }
    return _letters;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
