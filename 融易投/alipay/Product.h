//
//  Product.h
//  SlideMenu
//
//  Created by hl95Q on 15/4/28.
//  Copyright (c) 2015年 Aryan Ghassemi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Product : NSObject{
@private
    float _price;
    NSString *_subject;
    NSString *_body;
    NSString *_orderId;
}

@property (nonatomic, assign) float price;
@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSString *orderId;

@end