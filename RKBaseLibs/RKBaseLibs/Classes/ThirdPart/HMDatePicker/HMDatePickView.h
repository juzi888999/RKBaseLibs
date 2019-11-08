//
//  HMpickViewController.h
//  CustomDatePickView
//
//  Created by WXYT-iOS2 on 16/8/13.
//  Copyright © 2016年 WXYT-iOS2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMDatePickView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (strong,nonatomic) UIDatePicker * datePicker;

@property (copy,nonatomic) void(^cancelBlock)(UIDatePicker *datePicker);
@property (copy,nonatomic) void(^sureBlock)(UIDatePicker *datePicker);

@end
