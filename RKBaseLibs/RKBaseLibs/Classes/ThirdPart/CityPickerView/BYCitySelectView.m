//
//  BYCitySelectView.m
//  RKBaseLibs 
//
//  Created by shingyin on 16/8/3.
//  Copyright © 2016年 juzi. All rights reserved.
//

#import "BYCitySelectView.h"
#import "CityPickerView.h"

#define navigationViewHeight 44.0f
#define pickViewViewHeight 200.0f
#define buttonWidth 60.0f
#define windowColor  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]

#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation BYCitySelectView

+ (instancetype)shareInstance
{
    static BYCitySelectView *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[BYCitySelectView alloc] init];
        
    });
    
    [shareInstance showBottomView];
    return shareInstance;
}


-(instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        [self _addTapGestureRecognizerToSelf];
//        [self createView];
        _bottomView.backgroundColor = [UIColor clearColor];
    }
    return self;
}


+ (NSArray *)cityList
{
    static NSArray *cityList = nil;
    if (nil == cityList) {
        cityList = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"]];
        NSMutableArray * temp = [NSMutableArray arrayWithArray:cityList];
        NSDictionary * firstItem = [temp firstObject];
        NSString * name = firstItem[@"name"];
        if ([name isEqualToString:@"全国"]) {
            [temp removeObject:firstItem];
        }
        cityList = temp;
    }
    return cityList;
}

-(void)_addTapGestureRecognizerToSelf
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenBottomView)];
    [self addGestureRecognizer:tap];
}


-(void)createView
{
    if (_bottomView && _bottomView.superview) {
        [_bottomView removeFromSuperview];
    }
    if (_navigationView && _navigationView.superview) {
        [_navigationView removeFromSuperview];
    }
    if (_pickView && _pickView.superview) {
        [_pickView removeFromSuperview];
    }
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, navigationViewHeight+pickViewViewHeight)];
    
    [self addSubview:_bottomView];
    //导航视图
    _navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 65, KScreenWidth, navigationViewHeight)];
    _navigationView.backgroundColor = [UIColor whiteColor];
    [_bottomView addSubview:_navigationView];
    //这里添加空手势不然点击navigationView也会隐藏,
    UITapGestureRecognizer *tapNavigationView = [[UITapGestureRecognizer alloc]initWithTarget:self action:nil];
    [_navigationView addGestureRecognizer:tapNavigationView];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.tag = 0;
    button.frame = CGRectMake(0, 0, buttonWidth, navigationViewHeight);
    [button setTintColor:HPColorForKey(@"#666666")];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    button1.tag = 1;
    button1.frame = CGRectMake(MainScreenWidth-buttonWidth, 0, buttonWidth, navigationViewHeight);
    //[button1 setTintColor:[UIColor colorWithHexString:@"666666"]];
    [button1 setTitle:@"确定" forState:UIControlStateNormal];
  [button addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
    [button1 addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
    
            [_navigationView addSubview:button];
            [_navigationView addSubview:button1];

    
    _pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, navigationViewHeight+65, KScreenWidth, pickViewViewHeight)];
    _pickView.backgroundColor = HPColorForKey(@"#f6f6f6");
    _pickView.dataSource = self;
    _pickView.delegate =self;
    [_bottomView addSubview:_pickView];
    
    NSArray * data = [BYCitySelectView cityList];
    self.provinces = data;
    self.citys = data[0][@"citys"];
    self.areas = data[0][@"citys"][0][@"areas"];
}


- (NSDictionary *)selectedObject
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    NSInteger row0 = [_pickView selectedRowInComponent:0];
    NSInteger row1 = [_pickView selectedRowInComponent:1];
    NSInteger row2 = [_pickView selectedRowInComponent:2];
    if (row0 == -1) row0 = 0;
    if (row1 == -1) row1 = 0;
    if (row2 == -1) row2 = 0;
    NSDictionary * state = [BYCitySelectView cityList][row0];
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


-(void)tapButton:(UIButton*)button
{
    //点击确定回调block
    if (button.tag == 1) {
        NSString *province = [[self.provinces objectAtIndex:[_pickView selectedRowInComponent:0]]objectForKey:@"name"];
        NSString *city = [[self.citys objectAtIndex:[_pickView selectedRowInComponent:1]]objectForKey:@"name"];
        NSString *town;
        NSString *townId;
        if (self.areas.count>0) {
            town = [[self.areas objectAtIndex:[_pickView selectedRowInComponent:2]]objectForKey:@"name"];;
            townId = [[self.areas objectAtIndex:[_pickView selectedRowInComponent:2]]objectForKey:@"code"];
        }
        else{
            town = @"";
            townId = @"";
        }
        NSString *provinceId = [[self.provinces objectAtIndex:[_pickView selectedRowInComponent:0]]objectForKey:@"code"];
        NSString *cityId = [[self.citys objectAtIndex:[_pickView selectedRowInComponent:1]]objectForKey:@"code"];
    
        
        _block(province,city,town,provinceId,cityId,townId);
    }
    
    [self hiddenBottomView];
    
}


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
#pragma pickDelegate
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


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    CGFloat pickViewWidth = KScreenWidth/3;
    
    return pickViewWidth;
}

#pragma mark 隐藏－－出现
-(void)showBottomView
{
    [self createView];

    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.3 animations:^{
       // [self createView];
        _bottomView.top = KScreenHeight-navigationViewHeight-pickViewViewHeight-64;
        self.backgroundColor = windowColor;
    } completion:^(BOOL finished) {
        
    }];
}
-(void)hiddenBottomView
{
    [UIView animateWithDuration:0.3 animations:^{
        _bottomView.top = KScreenHeight;
        self.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [_pickView removeFromSuperview];
        _pickView = nil;
        [self removeFromSuperview];
    }];
}

@end
