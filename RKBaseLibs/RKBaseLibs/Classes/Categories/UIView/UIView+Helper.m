//
//  UIView+Helper.m
//
//  Created by rk on 14-12-17.
//  Copyright (c) 2014年. All rights reserved.
//

#import "UIView+Helper.h"

const CGFloat HPLineHeight = 0.5;
const CGFloat BYLineHeight = 0.5;
static NSString *activityViewKey_hp = @"activityViewKey_hp";

//static inline UIEdgeInsets rk_safeAreaInset(UIView *view) {
//    if (@available(iOS 11.0, *)) {
//        return view.safeAreaInsets;
//    }
//    return UIEdgeInsetsZero;
//}
@implementation UIView (Helper)

- (UIEdgeInsets)rk_safeAreaInset
{
    if (@available(iOS 11.0, *)) {
        if (self.keyWindow) {
            return self.keyWindow.safeAreaInsets;
        }
    }
    return UIEdgeInsetsZero;
}

- (UIWindow *)keyWindow {
//    return [UIApplication sharedApplication].keyWindow;
    UIWindow * keyWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    return keyWindow;
}

+ (UIView*)addLine:(UIView*)parent
{
    UIView *line = [UIView new];
    line.backgroundColor = HPColorForKey(@"#e1e1e1");
    [parent addSubview:line];
    return line;
}

- (UIView *)addBottomLine
{
    UIView *line = [UIView new];
    line.backgroundColor = HPColorForKey(@"separator");
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HPLineHeight);
        make.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
    }];
    return line;
}

- (UIView *)addTopLine
{
    UIView *line = [UIView new];
    line.backgroundColor = HPColorForKey(@"separator");
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HPLineHeight);
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self);
    }];
    return line;
}
- (UIView *)addTopLineWithLeft:(CGFloat)left right:(CGFloat)right
{
    UIView *line = [UIView new];
    line.backgroundColor = HPColorForKey(@"separator");
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HPLineHeight);
        make.left.mas_equalTo(left);
        make.right.mas_equalTo(-right);
        make.top.mas_equalTo(self);
    }];
    return line;
}

- (UIView *)addBottomLineWithLeft:(CGFloat)left right:(CGFloat)right
{
    UIView *line = [UIView new];
    line.backgroundColor = HPColorForKey(@"separator");
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HPLineHeight);
        make.left.mas_equalTo(left);
        make.right.mas_equalTo(-right);
        make.bottom.mas_equalTo(self);
    }];
    return line;
}


- (UIView *)addBottomLineWithHeight:(CGFloat)height topBorder:(BOOL)top bottomBorder:(BOOL)bottom
{
    UIView *line = [UIView new];
    line.backgroundColor = HPColorForKey(@"tableView.bg");
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
        make.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
    }];
    if (top)
    {
        [line addTopLine];
    }
    if (bottom)
    {
        [line addBottomLine];
    }
    return line;
}

- (UIView *)addTopLineWithHeight:(CGFloat)height topBorder:(BOOL)top bottomBorder:(BOOL)bottom
{
    UIView *line = [UIView new];
    line.backgroundColor = HPColorForKey(@"tableView.bg");
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self);
    }];
    if (top)
    {
        [line addTopLine];
    }
    if (bottom)
    {
        [line addBottomLine];
    }
    return line;
}

- (UIView *)addRightLineWithTop:(CGFloat)top bottom:(CGFloat)bottom color:(UIColor *)color
{
    UIView *line = [UIView new];
    line.backgroundColor = color;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(top);
        make.right.mas_equalTo(self);
        make.width.mas_equalTo(HPLineHeight);
        make.bottom.mas_equalTo(-bottom);
    }];
    return line;
}

- (UIView *)addLeftLineWithTop:(CGFloat)top bottom:(CGFloat)bottom color:(UIColor *)color
{
    UIView *line = [UIView new];
    line.backgroundColor = color;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(top);
        make.left.mas_equalTo(self);
        make.width.mas_equalTo(HPLineHeight);
        make.bottom.mas_equalTo(-bottom);
    }];
    return line;
}

+ (UIButton *)addNormalButton:(UIView *)parent title:(NSString*)title
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = HPColorForKey(@"button_bg");
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5;
    [parent addSubview:btn];
    return btn;
}

- (UIActivityIndicatorView *)activityView_hp
{
    return objc_getAssociatedObject(self, &activityViewKey_hp);
}

- (void)setActivityView_hp:(UIActivityIndicatorView *)activityView_hp
{
    return objc_setAssociatedObject(self, &activityViewKey_hp, activityView_hp, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showActivityInCenter:(BOOL)show
{
    self.userInteractionEnabled = !show;
    if ([self activityView_hp])
    {
        [[self activityView_hp] stopAnimating];
        [[self activityView_hp] removeFromSuperview];
        [self setActivityView_hp:nil];
    }
    if (show)
    {
        if ([self isOnScreen])
        {
            UIActivityIndicatorView * activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            self.activityView_hp = activityView;
            [activityView startAnimating];
            [self addSubview:activityView];
            [self layoutIfNeeded];
            activityView.frame = CGRectMake(self.width/2-activityView.width/2, self.height/2-activityView.height/2, activityView.width, activityView.height);
            
            //ios 7以下会奔溃
//            [activityView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.center.mas_equalTo(self);
//            }];
            [self bringSubviewToFront:activityView];
        }
    }
}

- (BOOL)isOnScreen {
    return !self.hidden && self.window;
}

#pragma mark - Windows

+ (UIWindow *)topVisibleWindow
{
    NSArray *windows = [[UIApplication sharedApplication] windows];
    windows = [[windows reverseObjectEnumerator] allObjects];
    for (UIWindow *window in windows) {
        if (!window.hidden) {
            return window;
        }
    }
    return nil;
}

+ (UIView *)currentViewControllerView
{
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    UINavigationController * nav = (UINavigationController *)window.rootViewController;
    if (nav && [nav isKindOfClass:[UINavigationController class]]) {
        UIView * view = nav.visibleViewController.view;
        if (view && [view isOnScreen]) {
            return view;
        }
    }
    return nil;
}

+ (UIWindow *)firstWindowWithLevel:(UIWindowLevel)windowLevel {
    NSArray *windows = [[UIApplication sharedApplication] windows];
    
    for (UIWindow *window in windows) {
        if (window.windowLevel == windowLevel) {
            return window;
        }
    }
    
    return nil;
}

+ (UIWindow *)lastWindowWithLevel:(UIWindowLevel)windowLevel {
    NSArray *windows = [[UIApplication sharedApplication] windows];
    
    for (UIWindow *window in [windows reverseObjectEnumerator]) {
        if (window.windowLevel == windowLevel) {
            return window;
        }
    }
    
    return nil;
}

+ (void)windowsWithLevel:(UIWindowLevel)windowLevel block:(void (^)(UIWindow*))block {
    if (!block) {
        return;
    }
    
    NSArray *windows = [[UIApplication sharedApplication] windows];
    
    for (UIWindow *window in windows) {
        if (window.windowLevel == windowLevel) {
            block(window);
        }
    }
}

- (UIView *)subViewWithSuffix:(NSString *)classNameSuffix {
    if (classNameSuffix.length == 0) 
        return nil;
    
    UIView *theView = nil;
    for (__unsafe_unretained UIView *subview in self.subviews) {
        if ([NSStringFromClass(subview.class) hasSuffix:classNameSuffix]) {
            return subview;
        } else {
            if ((theView = [subview subViewWithSuffix:classNameSuffix]))
                break;
        }
    }
    return theView;
}

@end
