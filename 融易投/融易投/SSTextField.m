//
//  MiYiTextField.m
//  融易投
//
//  Created by efeiyi on 16/3/31.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "SSTextField.h"


@interface SSTextField ()

@end

#define kAlphaNum   @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

@implementation SSTextField

-(void)awakeFromNib{
    _cnInt =8;
    _enInt =12;
    _PhoneNumberWordLimitInt=11;
    
}


-(void)setIsWordLimit:(BOOL)isWordLimit
{
    if (isWordLimit==YES) {
        if(_isNumber==YES)
        {
            NSLog(@"以免冲突");
            return;
        }
        ///字数改变
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(textFiledEditChanged:)
                                                    name:UITextFieldTextDidChangeNotification
                                                  object:nil];
    }
}

-(void)setCnInt:(int)cnInt
{
    _cnInt=cnInt;
}
-(void)setEnInt:(int)enInt
{
    _enInt=enInt;
}

-(void)setIsNumber:(BOOL)isNumber
{
    _isNumber=isNumber;
    if (isNumber ==YES) {
        self.keyboardType=UIKeyboardTypeNumberPad;
    }
}
-(void)setPhoneNumberWordLimitInt:(int)PhoneNumberWordLimitInt
{
    _PhoneNumberWordLimitInt=PhoneNumberWordLimitInt;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSInteger strLength = textField.text.length - range.length + string.length;
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    
    if (_isNumber==YES) {
        
        BOOL isMatched =[self validateNumber:string];
        if (!isMatched) {
            NSLog(@"请输入数字");
            return NO;
        }
        if(_isPhoneNumberWordLimit ==YES)
        {
            if (strLength >_PhoneNumberWordLimitInt) {
                NSLog(@"手机号是11位数的");
                return NO;
            }
        }
    }
    
    return YES;
}


- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

///输入法字数限制
-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = [obj object];
    

    NSInteger length_cn = 0;
    NSInteger length_en = 0;
    
    length_cn = _cnInt;
    length_en = _enInt;
    
    NSString *toBeString = textField.text;
    
    //中英占位比例
    CGFloat scale = (CGFloat)length_en/(CGFloat)length_cn;
    UITextRange *selectedRange = [textField markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        //计算汉字和非汉字的数量，key：enNum和zhNum
        int enNum = 0;
        int cnNum = 0;
        for(int i=0; i< [toBeString length];i++){
            int a = [toBeString characterAtIndex:i];
            if( a > 0x4e00 && a < 0x9fff){
                cnNum++;
            } else {
                enNum++;
            }
            CGFloat length = cnNum * scale + enNum;
            if (length > length_en) {
                if (enNum == 0) {
                    ///纯汉字
                    textField.text = [toBeString substringToIndex:length_cn];
                }else if (cnNum == 0 ) {
                    ///纯英文
                    textField.text = [toBeString substringToIndex:length_en];
                }else {
                    ///中英文
                    textField.text = [toBeString substringToIndex:cnNum + enNum - 1];
                }
                
                return;
            }
            
            if (_isSpecialCharacters ==YES) {
                
                NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""];
                textField.text = [textField.text stringByTrimmingCharactersInSet:set];
            }
            
            if (_isNotAllowedToChinese==YES) {
                NSCharacterSet *cs;
                cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
                textField.text =
                [[textField.text componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            }
        }
        
    }
    // 有高亮选择的字符串，则暂不对文字进行统计和限制
    else{
        
    }
    
}


- (BOOL)isValidPhone
{
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     * 中国电信：China Telecom
     * 133,1349,153,180,189,181(增加)
     */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:self.text] == YES)
        || ([regextestcm evaluateWithObject:self.text] == YES)
        || ([regextestct evaluateWithObject:self.text] == YES)
        || ([regextestcu evaluateWithObject:self.text] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
