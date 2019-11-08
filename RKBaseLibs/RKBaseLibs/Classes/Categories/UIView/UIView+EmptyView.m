//
//  UIView+EmptyView.m
//  RKBaseLibs 
//
//  Created by rk on 16/8/16.
//  Copyright © 2016年 rk. All rights reserved.
//

#import "UIView+EmptyView.h"

static NSString *by_defaultHintTextKey = @"by_defaultHintTextKey";
static NSString *by_defaultViewKey = @"by_defaultViewKey";
static NSString *by_customViewKey = @"by_customViewKey";
static NSString *by_defaultRequestFailureViewKey = @"by_defaultRequestFailureViewKey";
static NSString *by_customRequestFailureViewKey = @"by_customRequestFailureViewKey";
static NSString *by_emptyViewTapBlockKey = @"by_emptyViewTapBlockKey";
static NSString *by_requestFailureTapBlockKey = @"by_requestFailureTapBlockKey";

@implementation UIView (EmptyView)


- (void)by_removeCurrentShowView
{
    if (self.by_defaultEmptyView && self.by_defaultEmptyView.superview) {
        [self.by_defaultEmptyView removeFromSuperview];
    }
    if (self.by_customEmptyView && self.by_customEmptyView.superview) {
        [self.by_customEmptyView removeFromSuperview];
    }
    if (self.by_defaultRequestFailureView && self.by_defaultRequestFailureView.superview) {
        [self.by_defaultRequestFailureView removeFromSuperview];
    }
    if (self.by_customRequestFailureView && self.by_customRequestFailureView.superview) {
        [self.by_customRequestFailureView removeFromSuperview];
    }
}
- (void)by_showEmptyViewInCenter:(BOOL)show
{
    UIView * emptyView = self.by_customEmptyView?self.by_customEmptyView:self.by_defaultEmptyView;
    if (emptyView == nil) {
        emptyView = [self by_createDefaultEmptyView];
    }
    [self by_showEmptyViewInCenter:show withFrame:CGRectMake(self.width/2-emptyView.width/2, self.height/2-emptyView.height/2, emptyView.width, emptyView.height)];
}

- (void)by_showEmptyViewInCenter:(BOOL)show withFrame:(CGRect)frame
{
    [self by_removeCurrentShowView];
    if (show) {
        UIView * emptyView = nil;
        if (self.by_customEmptyView) {
            emptyView = self.by_customEmptyView;
        }else{
            self.by_defaultEmptyView = [self by_createDefaultEmptyView];
            emptyView = self.by_defaultEmptyView;
        }
        [self addSubview:emptyView];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(emptyViewTap:)];
        [emptyView addGestureRecognizer:tap];
        //        [self setNeedsLayout];
        emptyView.frame = frame;
        [self bringSubviewToFront:emptyView];
    }
}

- (void)by_showRequestFailureViewInCenter:(BOOL)show
{
    UIView * emptyView = self.by_customRequestFailureView?self.by_customRequestFailureView:self.by_defaultRequestFailureView;
    if (emptyView == nil) {
        emptyView = [self by_createDefaultRequestFailureView];
    }
    [self by_showRequestFailureViewInCenter:show withFrame:CGRectMake(self.width/2-emptyView.width/2, self.height/2-emptyView.height/2, emptyView.width, emptyView.height)];
}

- (void)by_showRequestFailureViewInCenter:(BOOL)show withFrame:(CGRect)frame
{
    [self by_removeCurrentShowView];
    if (show) {
        UIView * emptyView = nil;
        if (self.by_customRequestFailureView) {
            emptyView = self.by_customRequestFailureView;
        }else{
            self.by_defaultRequestFailureView = [self by_createDefaultRequestFailureView];
            emptyView = self.by_defaultRequestFailureView;
        }
        [self addSubview:emptyView];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(requestFailureViewTap:)];
        [emptyView addGestureRecognizer:tap];
        emptyView.frame = frame;
        [self bringSubviewToFront:emptyView];
    }
    
}
- (UIView *)by_createDefaultEmptyView
{
    if (![self by_defaultHintText]) {
        [self setBy_defaultHintText:@"去其它页面逛逛吧～"];
    }
    UIView * emptyView = [self by_hintViewWithText:[self by_defaultHintText]];
    return emptyView;
}

- (UIView *)by_createDefaultRequestFailureView
{
    UIView * customRequestFailureView = [[UIView alloc] initWithFrame:self.bounds];
    UIView * emptyView = customRequestFailureView;
    customRequestFailureView.backgroundColor = [UIColor whiteColor];
    UIImageView * icon = [[UIImageView alloc] initWithImage:HPImageForKey(@"request_fail_icon")];
    [customRequestFailureView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(customRequestFailureView);
        make.centerY.mas_equalTo(customRequestFailureView).offset(-80);
    }];
    
    UILabel * tipLabel = [UILabel centerAlignLabel];
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.text = @"网络错误，点击重新加载…";
    tipLabel.textColor = HPColorForKey(@"#999999");
    [customRequestFailureView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(customRequestFailureView);
        make.top.mas_equalTo(icon.mas_bottom).offset(20);
    }];
    
    UIButton * reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [reloadButton setTitle:@"重新加载" forState:UIControlStateNormal];
    //    [reloadButton addTarget:self action:@selector(firstLoadDataWithHUD) forControlEvents:UIControlEventTouchUpInside];
    reloadButton.userInteractionEnabled = NO;
//    reloadButton.layer.borderColor = HPColorForKey(@"#ec7517").CGColor;
//    reloadButton.layer.borderWidth = 0.5f;
//    reloadButton.layer.cornerRadius = 5;
//    reloadButton.layer.masksToBounds = YES;
    reloadButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [reloadButton setBackgroundColor:HPColorForKey(@"#ec7517")];
    [reloadButton setTitleColor:HPColorForKey(@"#ffffff") forState:UIControlStateNormal];
    [customRequestFailureView addSubview:reloadButton];
    [reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(customRequestFailureView);
        make.top.mas_equalTo(tipLabel.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(130, 31));
    }];
    //    UIView * emptyView = [self by_hintViewWithText:@"网络连接失败\n请点击刷新"];
    return emptyView;
}

- (UIView *)by_hintViewWithText:(NSString *)text
{
    UIView * hintView = [[UIView alloc]initWithFrame:self.bounds];
    UILabel * label = [UILabel centerAlignLabel];
    [hintView addSubview:label];
    label.text = text;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = HPColorForKey(@"text.major");
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(hintView);
    }];
    return hintView;
}

- (void)emptyViewTap:(UITapGestureRecognizer *)tap
{
    if (self.by_emptyViewTapBlock) {
        self.by_emptyViewTapBlock();
    }
}

- (void)requestFailureViewTap:(UITapGestureRecognizer *)tap
{
    if (self.by_requestFailureTapBlock) {
        self.by_requestFailureTapBlock();
    }
}

#pragma mark - setter && getter

- (NSString *)by_defaultHintText
{
    return objc_getAssociatedObject(self, &by_defaultHintTextKey);
}

- (void)setBy_defaultHintText:(NSString *)by_defaultHintText
{
    return objc_setAssociatedObject(self, &by_defaultHintTextKey, by_defaultHintText, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (UIView *)by_defaultEmptyView
{
    return objc_getAssociatedObject(self, &by_defaultViewKey);
}

- (void)setBy_defaultEmptyView:(UIView *)by_defaultEmptyView
{
    return objc_setAssociatedObject(self, &by_defaultViewKey, by_defaultEmptyView, OBJC_ASSOCIATION_RETAIN);
}
- (UIView *)by_defaultRequestFailureView
{
    return objc_getAssociatedObject(self, &by_defaultRequestFailureViewKey);
}
- (void)setBy_defaultRequestFailureView:(UIView *)by_defaultRequestFailureView
{
    return objc_setAssociatedObject(self, &by_defaultRequestFailureViewKey, by_defaultRequestFailureView, OBJC_ASSOCIATION_RETAIN);
}
- (UIView *)by_customRequestFailureView
{
    return objc_getAssociatedObject(self, &by_customRequestFailureViewKey);
}
- (void)setBy_customRequestFailureView:(UIView *)by_customRequestFailureView
{
    return objc_setAssociatedObject(self, &by_customRequestFailureViewKey, by_customRequestFailureView, OBJC_ASSOCIATION_RETAIN);
}

-(UIView *)by_customEmptyView
{
    return objc_getAssociatedObject(self, &by_customViewKey);
}

-(void)setBy_customEmptyView:(UIView *)by_customEmptyView
{
    return objc_setAssociatedObject(self, &by_customViewKey, by_customEmptyView, OBJC_ASSOCIATION_RETAIN);
}

-(void(^)())by_emptyViewTapBlock
{
    return objc_getAssociatedObject(self, &by_emptyViewTapBlockKey);
    
}
- (void)setBy_emptyViewTapBlock:(void(^)())by_emptyViewTapBlock
{
    return objc_setAssociatedObject(self, &by_emptyViewTapBlockKey, by_emptyViewTapBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(void(^)())by_requestFailureTapBlock
{
    return objc_getAssociatedObject(self, &by_requestFailureTapBlockKey);
}

-(void)setBy_requestFailureTapBlock:(void(^)())by_requestFailureTapBlock
{
    return objc_setAssociatedObject(self, &by_requestFailureTapBlockKey, by_requestFailureTapBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
