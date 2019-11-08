//
//  HMpickViewController.m
//  CustomDatePickView
//
//  Created by WXYT-iOS2 on 16/8/13.
//  Copyright © 2016年 WXYT-iOS2. All rights reserved.
//

#import "HMDatePickView.h"
#import "BYInputAccessoryView.h"

@interface HMDatePickView()
@property (strong,nonatomic) UIButton * sureButton;
@property (strong,nonatomic) UIButton * cancelButton;
@property (strong,nonatomic) BYInputAccessoryView * toolBar;

@end
@implementation HMDatePickView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = WhiteColor;
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
                self.cancelBlock(self.datePicker);
            }
        }
    }];
    [self.toolBar setSureBlock:^{
        @strongify(self);
        if (self) {
            if (self.sureBlock) {
                self.sureBlock(self.datePicker);
            }
        }
    }];
    [self addSubview:self.toolBar];
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.height.mas_equalTo(44);
    }];
    UIDatePicker *datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, self.toolBar.height,MainScreenWidth, 162)];
    self.datePicker = datePicker;
    datePicker.datePickerMode = UIDatePickerModeDate;
    [self addSubview: datePicker];
    [datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.top.mas_equalTo(self.toolBar.mas_bottom);
    }];
}

#pragma mark - 确定/取消
- (void)sureButtonAction:(UIButton *)sender
{
    if (self.sureBlock) {
        self.sureBlock(self.datePicker);
    }
}

- (void)cancelButtonAction:(UIButton *)sender
{
    if (self.cancelBlock) {
        self.cancelBlock(self.datePicker);
    }
}
@end
