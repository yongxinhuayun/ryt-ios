//
//  cityField.m
//  融易投
//
//  Created by efeiyi on 16/4/26.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "cityField.h"
#import "City.h"

#import "CNCityPickerView.h"

@interface cityField () <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) NSMutableArray *cites;

//记录选中的省
@property (nonatomic, assign) NSInteger index;

@end

@implementation cityField


-(NSMutableArray *)cites
{
    if (_cites == nil) {
        
        _cites = [NSMutableArray array];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"provinces.plist" ofType:nil];
        NSArray *provincesArray = [NSArray arrayWithContentsOfFile:path];
        
        
        for (NSDictionary *dict in provincesArray) {
            City *city = [City cityWithDict:dict];
            [_cites addObject:city];
        }
    }
    return _cites;
}

-(void)awakeFromNib
{
    [self setup];
}


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setup];
    }
    return self;
}

-(void)setup {

    // 使用代码的方式添加也行
    CGRect pickerViewFrame = CGRectMake(0, 0, SSScreenW, 180);
    
    // 1、创建
    CNCityPickerView *pickerView = [CNCityPickerView createPickerViewWithFrame:pickerViewFrame valueChangedCallback:^(NSString *province, NSString *city, NSString *area) {
        
        self.text = [NSString stringWithFormat:@"%@  %@  %@", province, city, area];
        
    }];
    
    // 2、可选设置的属性
    pickerView.textAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor],
                                  NSFontAttributeName : [UIFont boldSystemFontOfSize:15.0f]
                                  };
    pickerView.rowHeight = 30.0f;
    
    // 3、添加到指定视图
//    [self.view addSubview:pickerView];
    
    self.inputView = pickerView;
}

#pragma mark - UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;

}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //1.判断如果是第一列(第一列描述的是省会)
    if (component == 0) {
        //2.那么返回的就是省会的数量
        return self.cites.count;
    }else{
        //3.如果选中的时第二列(即是描述省的城市)
        //因为第二列的数量根据选中第一列的省有关系,所有第1列有多少行,取决于选中省的城市
        //4.因为不知道选中了哪个省,所以无法就行判断这一列的数量
        //UIPickerViewDelegate代理方法中又选中哪一行的方法,确定了用户选中的省份即可计算该省份对应的城市的数量
        
        //6.确定每个省份对应的城市
        City *city = self.cites[self.index];
        return city.cities.count;
    }
}


#pragma mark - UIPickerViewDelegate

//5.实现代理方法,判断选中了哪个省份
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        //记录选中省的角标
        self.index = row;
        
        //11.刷新城市
        [pickerView reloadComponent:1];
        
        //12.运行程序发现,可以根据选中的省份跳转到对应的城市列表
        //但是,跳转到了城市不是第一列的第一个城市
        
        //13.让第一列选中第0行
        [pickerView selectRow:0 inComponent:1 animated:YES];
        
    }

    //14.把选中的省份和城市显示在文本框上
    
    //15.获取选中的省份
    City *city = self.cites[self.index];
    //16.获取选中的城市
    //思路一:
    //        city.cities[row];  //如果这样写,代表不管是移动第一列还是第二列,pickerView的row属性都会变化,如果要是根据这种方法获取城市,可能会造成数据混乱
    //        NSString *cityName = city.cities[row];
    //        self.text = [NSString stringWithFormat:@"%@ %@",city.name,cityName];
    //思路二:
    //获取选中第一列的行数,根据选中的行数确定选中的城市
    NSInteger cityIndex = [pickerView selectedRowInComponent:1];  //获取选中第一列的索引
    NSString *cityName = city.cities[cityIndex];
    self.text = [NSString stringWithFormat:@"%@ %@",city.name,cityName];
    
    //假设第0列没动是,当选中第一列时,此时component == 1,不会来到上面的if方法
    //假设两边同时滚动,发现也没问题

}

//7.确定pickerView上面显示的标题
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //8.如果选中的是第一列,返回的标题应该是省的名字
    if (component == 0) {
        City *city = self.cites[row];
        return city.name;
    }else{
        //9.如果选中的是第二列,返回的标题应该是城市的名字
        //获取选中的省
        City *city = self.cites[self.index];
        return city.cities[row];
        //10.运行程序发现,在选择其他省份的时候,第二列还是第一列第一行省的城市,所以应该在选中省的同时对第一列就是刷新,即把城市刷新
        
    }

}

@end
