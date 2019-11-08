//
//  HPBlockPickerView.h
//  RKBaseLibs
//
//  Created by rk on 16/5/4.
//  Copyright © 2016年 haixiaedu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPBlockPickerView : UIPickerView<UIPickerViewDelegate,UIPickerViewDataSource>
@property (copy,nonatomic) NSInteger(^numberOfComponentsInPickerView)(UIPickerView * pickerView);
@property (copy,nonatomic) NSInteger(^numberOfRowsInComponent)(UIPickerView * pickerView,NSInteger component);
@property (copy,nonatomic) void(^didSelectRow)(UIPickerView * pickerView,NSInteger component,NSInteger row);
@property (copy,nonatomic) NSString *(^titleForRow)(UIPickerView * pickerView,NSInteger component,NSInteger row);
@end
