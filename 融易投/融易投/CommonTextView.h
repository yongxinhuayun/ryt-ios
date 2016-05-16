//
//  CommonTextView.h
//  融易投
//
//  Created by efeiyi on 16/3/30.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonnTextView : UITextView
/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;

/* 示例:
 - (void)viewWillAppear:(BOOL)animated
 {
 [super viewWillAppear:animated];
 
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
 
 [self.textView becomeFirstResponder];
 }
 
 - (void)viewWillDisappear:(BOOL)animated
 {
 [super viewWillDisappear:animated];
 
 [[NSNotificationCenter defaultCenter] removeObserver:self];
 }
 
 - (void)setupToolbar
 {
 XMGPostWordToolbar *toolbar = [XMGPostWordToolbar viewFromXib];
 toolbar.width = self.view.width;
 toolbar.y = self.view.height - toolbar.height;
 [self.view addSubview:toolbar];
 self.toolbar = toolbar;
 }
 
 - (void)keyboardWillChangeFrame:(NSNotification *)note
 {
 // 动画时间
 double duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
 
 [UIView animateWithDuration:duration animations:^{
 CGFloat keyboardY = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
 CGFloat ty = keyboardY - XMGScreenH;
 self.toolbar.transform = CGAffineTransformMakeTranslation(0, ty);
 }];
 }
 
 - (void)setupTextView
 {
 XMGPlaceholderTextView *textView = [[XMGPlaceholderTextView alloc] init];
 textView.placeholder = @"把好玩的图片，好笑的段子或糗事发到这里，接受千万网友膜拜吧！发布违反国家法律内容的，我们将依法提交给有关部门处理。";
 textView.alwaysBounceVertical = YES;
 textView.delegate = self;
 textView.frame = self.view.bounds;
 [self.view addSubview:textView];
 self.textView = textView;
 }
 
 - (void)setupNav
 {
 self.title = @"发表文字";
 self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
 self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(post)];
 self.navigationItem.rightBarButtonItem.enabled = NO;
 // 强制更新
 [self.navigationController.navigationBar layoutIfNeeded];
 }
 
 - (void)cancel
 {
 [self dismissViewControllerAnimated:YES completion:nil];
 }
 
 - (void)post
 {
 XMGLogFunc;
 }
 
 #pragma mark - <UITextViewDelegate>
 - (void)textViewDidChange:(UITextView *)textView
 {
 self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
 }
 
 - (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
 {
 [self.view endEditing:YES];
 }

 */
@end
