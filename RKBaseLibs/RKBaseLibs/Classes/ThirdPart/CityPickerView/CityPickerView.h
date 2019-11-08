//
//  CityPickerView.h
//  RKBaseLibs
//
//  Created by rk on 15/7/21.
//  Copyright (c) 2015年 haixiaedu. All rights reserved.
//

#import <UIKit/UIKit.h>

//@interface BYCityEntity : HPEntity
//@property (strong,nonatomic) NSString* code;//	Long	区域编码
//@property (strong,nonatomic) NSString* name;//	String	区域名称
//@property (strong,nonatomic) NSString* level;//	String	区域级别
//@property (strong,nonatomic) NSString* parent;//	String	父级编码
//
//@property (strong,nonatomic) NSArray * citys;
//@property (strong,nonatomic) NSArray * areas;
//
//
//@end

@interface CityPickerView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (strong,nonatomic) UIPickerView * pickerView;

@property (copy,nonatomic) void(^cancelBlock)(UIPickerView *pickerView);
@property (copy,nonatomic) void(^sureBlock)(UIPickerView *pickerView);

- (NSString *)selectedAreas;
- (NSDictionary *)selectedAreasDic;
- (NSNumber *)selectedProvinceID;
- (NSNumber *)selectedCityID;
- (NSNumber *)selectedAreaID;


//-(NSString *)selectedProvince;
//-(NSString *)selectedCity;
//-(NSString *)selectedAreas;


@end
