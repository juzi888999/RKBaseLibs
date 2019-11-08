//
//  BYCitySelectView.h
//  RKBaseLibs 
//
//  Created by shingyin on 16/8/3.
//  Copyright © 2016年 juzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityPickerView.h"


typedef void(^AdressBlock) (NSString *province,NSString *city,NSString *town,NSString *provinceId,NSString *cityId,NSString *townId);



@interface BYCitySelectView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic,copy)AdressBlock block;
@property(nonatomic,strong)NSDictionary *pickerDic;
@property(nonatomic,strong)NSArray *provinceArray;
@property(nonatomic,strong)NSArray *selectedArray;
@property(nonatomic,strong)NSArray *cityArray;
@property(nonatomic,strong)NSArray *townArray;
@property(nonatomic,strong)UIView *bottomView;//包括导航视图和地址选择视图
@property(nonatomic,strong)UIPickerView *pickView;//地址选择视图
@property(nonatomic,strong)UIView *navigationView;//上面的导航视图


@property (strong,nonatomic) NSArray * provinces;
@property (strong,nonatomic) NSArray * citys;
@property (strong,nonatomic) NSArray * areas;


+ (instancetype)shareInstance;


@end
