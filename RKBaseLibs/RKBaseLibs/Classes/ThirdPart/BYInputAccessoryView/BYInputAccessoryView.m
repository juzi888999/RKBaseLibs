//
//  BYInputAccessoryView.m
//  RKBaseLibs 
//
//  Created by rk on 16/10/9.
//  Copyright © 2016年 rk. All rights reserved.
//

#import "BYInputAccessoryView.h"

@interface BYInputAccessoryView()
@property (strong,nonatomic) UIButton * sureButton;
@property (strong,nonatomic) UIButton * cancelButton;
@property (strong,nonatomic) UILabel * titleLabel;

@end
@implementation BYInputAccessoryView

+ (instancetype)createThemeInputAccessoryView
{
    BYInputAccessoryView * inputAccessory = [[BYInputAccessoryView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 44)];
    return inputAccessory;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = WhiteColor;
        [self configuration];
    }
    return self;
}

- (void)configuration {
    //时间选择器
    UIView *toolBar = [[UIView alloc] initWithFrame:self.bounds];
    toolBar.backgroundColor = WhiteColor;
    [self addSubview:toolBar];
    [toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.height.mas_equalTo(44);
    }];
    
    //确定按钮
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sureButton = commitBtn;
    commitBtn.titleLabel.font = MainFontSize(16);
    [commitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [commitBtn setTitleColor:HPColorForKey(@"main") forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [commitBtn addTarget:self action:@selector(sureButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:commitBtn];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(toolBar);
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(50, 40));
    }];
    //取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton = cancelBtn;
    cancelBtn.titleLabel.font = MainFontSize(16);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:HPColorForKey(@"text.minor") forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [cancelBtn addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(toolBar);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(50, 40));
    }];
    
    UILabel * titleLabel = [UILabel centerAlignLabel];
    self.titleLabel = titleLabel;
    titleLabel.textColor = HPColorForKey(@"text.major");
    titleLabel.font = MainFontSize(16);
    [toolBar addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cancelBtn.mas_right);
        make.right.mas_equalTo(commitBtn.mas_left);
        make.centerY.mas_equalTo(toolBar);
    }];
    [toolBar addTopLine];
}

#pragma mark - 确定/取消
- (void)sureButtonAction:(UIButton *)sender
{
    if (self.sureBlock) {
        self.sureBlock();
    }
}

- (void)cancelButtonAction:(UIButton *)sender
{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}
@end
