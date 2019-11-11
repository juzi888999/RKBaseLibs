//
//  CityPickerView.m
//  RKBaseLibs
//
//  Created by rk on 15/7/21.
//  Copyright (c) 2015年 haixiaedu. All rights reserved.
//

#import "CityPickerView.h"
#import "BYInputAccessoryView.h"


@interface CityPickerView()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (strong,nonatomic) NSArray * provinces;
@property (strong,nonatomic) NSArray * citys;
@property (strong,nonatomic) NSArray * areas;

@property (strong,nonatomic) UIButton * sureButton;
@property (strong,nonatomic) UIButton * cancelButton;
@property (strong,nonatomic) BYInputAccessoryView * toolBar;

@end
@implementation CityPickerView

+ (NSArray *)cityList
{
    static NSArray *cityList = nil;
    if (nil == cityList) {
        cityList = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"]];
        
    }
    return cityList;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        NSArray * data = [CityPickerView cityList];
        self.provinces = data;
        self.citys = data[0][@"citys"];
        self.areas = data[0][@"citys"][0][@"areas"];
        [self configuration];
    }
    return self;
}

#pragma mark -- 选择器
- (void)configuration {
    
    @weakify(self);
    self.toolBar = [BYInputAccessoryView createThemeInputAccessoryView];
    [self.toolBar setCancelBlock:^() {
        @strongify(self);
        if (self) {
            if (self.cancelBlock) {
                self.cancelBlock(self.pickerView);
            }
        }
    }];
    [self.toolBar setSureBlock:^{
        @strongify(self);
        if (self) {
            if (self.sureBlock) {
                self.sureBlock(self.pickerView);
            }
        }
        
    }];
    [self addSubview:self.toolBar];
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.height.mas_equalTo(44);
    }];
    
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, HPPickerViewHeight)];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.showsSelectionIndicator = YES;
    [self addSubview:self.pickerView];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.top.mas_equalTo(self.toolBar.mas_bottom);
    }];
}

#pragma mark - 确定/取消
- (void)sureButtonAction:(UIButton *)sender
{
    if (self.sureBlock) {
        self.sureBlock(self.pickerView);
    }
}

- (void)cancelButtonAction:(UIButton *)sender
{
    if (self.cancelBlock) {
        self.cancelBlock(self.pickerView);
    }
}


#pragma mark - UIPickerViewDelegate & UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return self.provinces.count;
            break;
        case 1:
            return self.citys.count;
            break;
        case 2:
            return self.areas.count;
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [[self.provinces objectAtIndex:row] objectForKey:@"name"];
            break;
        case 1:
            return [[self.citys objectAtIndex:row] objectForKey:@"name"];
            break;
        case 2:
            if (self.areas && self.areas.count > 0) {
                return [[self.areas objectAtIndex:row] objectForKey:@"name"];
                break;
            }
        default:
            return  @"";
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            self.citys = [[self.provinces objectAtIndex:row] objectForKey:@"citys"];
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            
            self.areas = [[self.citys objectAtIndex:0] objectForKey:@"areas"];
            [pickerView reloadComponent:2];
            if (self.areas && self.areas.count > 0) {
                [pickerView selectRow:0 inComponent:2 animated:YES];
            }
            break;
        }
        case 1:
        {
            self.areas = [[self.citys objectAtIndex:row] objectForKey:@"areas"];
            [pickerView reloadComponent:2];
            if (self.areas && self.areas.count > 0) {
                [pickerView selectRow:0 inComponent:2 animated:YES];
            }
            
            break;
        }
        default:
            break;
    }
}

- (NSDictionary *)selectedAreasDic
{
    NSInteger row0 = [self.pickerView selectedRowInComponent:0];
    NSInteger row1 = [self.pickerView selectedRowInComponent:1];
    NSInteger row2 = [self.pickerView selectedRowInComponent:2];
    if (row0 == -1) row0 = 0;
    if (row1 == -1) row1 = 0;
    if (row2 == -1) row2 = 0;
    NSString * state = [CityPickerView cityList][row0][@"name"];
    
    NSDictionary * cityDic = [CityPickerView cityList][row0];
    NSString * city = cityDic[@"citys"][row1][@"name"];
    
    NSArray * citys = cityDic[@"citys"];
    NSDictionary * areaDic = citys[row1];
    NSArray * areas = areaDic[@"areas"];
    NSString * area = @"";
    if (areas.count > row2)
    {
        area = areas[row2][@"name"];
    }
    return @{@"state":[NSString checkString:state],@"city":[NSString checkString:city],@"area":[NSString checkString:area]};
}

- (NSString *)selectedAreas
{
    NSInteger row0 = [self.pickerView selectedRowInComponent:0];
    NSInteger row1 = [self.pickerView selectedRowInComponent:1];
    NSInteger row2 = [self.pickerView selectedRowInComponent:2];
    if (row0 == -1) row0 = 0;
    if (row1 == -1) row1 = 0;
    if (row2 == -1) row2 = 0;
    NSString * state = [CityPickerView cityList][row0][@"name"];
    
    NSDictionary * cityDic = [CityPickerView cityList][row0];
    NSString * city = cityDic[@"citys"][row1][@"name"];
    
    NSArray * citys = cityDic[@"citys"];
    NSDictionary * areaDic = citys[row1];
    NSArray * areas = areaDic[@"areas"];
    NSString * area = @"";
    if (areas.count > row2)
    {
        area = areas[row2][@"name"];
    }
    return [NSString stringWithFormat:@"%@-%@-%@",[NSString checkString:state],[NSString checkString:city],[NSString checkString:area]];
}

- (NSDictionary *)selectedObject
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    NSInteger row0 = [self.pickerView selectedRowInComponent:0];
    NSInteger row1 = [self.pickerView selectedRowInComponent:1];
    NSInteger row2 = [self.pickerView selectedRowInComponent:2];
    if (row0 == -1) row0 = 0;
    if (row1 == -1) row1 = 0;
    if (row2 == -1) row2 = 0;
    NSDictionary * state = [CityPickerView cityList][row0];
    NSDictionary * city = state[@"citys"][row1];
    NSArray * areas = city[@"areas"];
    
    [dic setObject:state forKey:@"province"];
    [dic setObject:city forKey:@"city"];
    if (areas.count > row2)
    {
        NSDictionary * areaDic = areas[row2];
        [dic setObject:areaDic forKey:@"area"];
    }
    return dic;
}

- (NSNumber *)selectedProvinceID
{
    NSDictionary * dic = [self selectedObject];
    NSDictionary * province = dic[@"province"];
    NSNumber * provinceID = province[@"code"];
    return provinceID;
}


- (NSNumber *)selectedCityID
{
    NSDictionary * dic = [self selectedObject];
    NSDictionary * city = dic[@"city"];
    NSNumber * cityID = city[@"code"];
    return cityID;
}


- (NSNumber *)selectedAreaID
{
    NSDictionary * dic = [self selectedObject];
    NSDictionary * area = dic[@"area"];
    if (area)
    {
        NSNumber * areaID = area[@"code"];
        return areaID;
    }
    else
    {
        return nil;
    }
}


@end
