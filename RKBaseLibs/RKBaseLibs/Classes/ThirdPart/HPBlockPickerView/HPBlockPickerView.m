//
//  HPBlockPickerView.m
//  RKBaseLibs
//
//  Created by rk on 16/5/4.
//  Copyright © 2016年 haixiaedu. All rights reserved.
//

#import "HPBlockPickerView.h"

@implementation HPBlockPickerView

- (instancetype)init
{
    if (self = [super init]) {
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.numberOfComponentsInPickerView) {
        return self.numberOfComponentsInPickerView(pickerView);
    }
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.numberOfRowsInComponent) {
        return self.numberOfRowsInComponent(pickerView,component);
    }
    return 0;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.didSelectRow) {
        self.didSelectRow(pickerView,component,row);
    }
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.titleForRow) {
       return self.titleForRow(pickerView,component,row);
    }
    return @"";
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
