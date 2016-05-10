//
//  ComposeProjectViewController.m
//  融易投
//
//  Created by efeiyi on 16/5/10.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "ComposeProjectViewController.h"

@interface ComposeProjectViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ComposeProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.contentSize = CGSizeMake(SSScreenW, 2000);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
