//
//  RegViewController.h
//  融易投
//
//  Created by dongxin on 16/3/31.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *RegName;
@property (weak, nonatomic) IBOutlet UITextField *authName;
@property (weak, nonatomic) IBOutlet UITextField *pwdName;
- (IBAction)regBtn:(id)sender;
- (IBAction)geName:(id)sender;
- (IBAction)authBtb:(id)sender;

@end
