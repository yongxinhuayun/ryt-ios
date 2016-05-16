//
//  PostCommentController.m
//  融易投
//
//  Created by dongxin on 16/5/10.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "PostCommentController.h"

@interface PostCommentController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *placeholder;
@property (weak, nonatomic) IBOutlet UITextView *commentView;

@end

@implementation PostCommentController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.commentView.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpNavBar];
}

// 设置导航条
-(void)setUpNavBar
{
    //设置导航条按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [rightButton setTitle:@"发布" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    //运行程序,发现按钮没有出现导航条上面,因为没有设置尺寸
    [rightButton sizeToFit];
    [rightButton addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

-(void)send{
    // 发送网络请求
    [self postComment];
}

#pragma mark TODO
//发布评论
-(void)postComment
{
    NSString *url = @"artworkComment.do";
    NSDictionary *JSON = @{ @"artworkId" : self.artworkId,
                            @"currentUserId" : self.currentUserId,
                            @"content":self.commentView.text
                            };
    [[HttpRequstTool shareInstance] loadData:POST serverUrl:url parameters:JSON showHUDView:self.view andBlock:^(id respondObj) {
                NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
                NSLog(@"返回结果:%@",jsonStr);
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        SSLog(@"%@",modelDict);
        NSString *result = modelDict[@"resultMsg"];
        if ([result isEqualToString:@"成功"]) {
                NSNotificationCenter *notCenter = [NSNotificationCenter defaultCenter];
            [notCenter postNotificationName:@"POSTCOMMENT" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
        //字典数组 -> 模型数组
        //在主线程刷新UI数据
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        }];
    }];
//    [[HttpRequstTool shareInstance] handlerNetworkingPOSTRequstWithServerUrl:url Parameters:json showHUDView:self.view success:^(id respondObj) {
//        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
//        SSLog(@"%@",modelDict);
//        //字典数组 -> 模型数组
//        //在主线程刷新UI数据
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        }];
//    }];
}




#pragma mark - Text View Delegate
-(void)textViewDidChange:(UITextView *)textView
{
    self.placeholder.hidden = [textView.text length];
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([@"\n" isEqualToString:text])
    {
        if ([self.commentView.text length]) {
            [self.commentView resignFirstResponder];
        }
        else
        {
            return NO;
        }
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
