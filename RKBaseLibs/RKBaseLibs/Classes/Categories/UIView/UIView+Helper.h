//
//  UIView+Helper.h
//
//  Created by rk on 14-12-17.
//  Copyright (c) 2014年. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const CGFloat HPLineHeight;
extern const CGFloat BYLineHeight;

@interface UIView (Helper)

- (UIEdgeInsets)rk_safeAreaInset;
+ (UIView*)addLine:(UIView*)parent;
+ (UIButton *)addNormalButton:(UIView *)parent title:(NSString*)title;

- (UIView *)addBottomLine;
- (UIView *)addTopLine;
- (UIView *)addTopLineWithLeft:(CGFloat)left right:(CGFloat)right;
- (UIView *)addBottomLineWithLeft:(CGFloat)left right:(CGFloat)right;
- (UIView *)addRightLineWithTop:(CGFloat)top bottom:(CGFloat)bottom color:(UIColor *)color;
- (UIView *)addLeftLineWithTop:(CGFloat)top bottom:(CGFloat)bottom color:(UIColor *)color;

- (UIView *)addBottomLineWithHeight:(CGFloat)height topBorder:(BOOL)top bottomBorder:(BOOL)bottom;
- (UIView *)addTopLineWithHeight:(CGFloat)height topBorder:(BOOL)top bottomBorder:(BOOL)bottom;

- (void)showActivityInCenter:(BOOL)show;

- (BOOL)isOnScreen;

+ (UIWindow *)firstWindowWithLevel:(UIWindowLevel)windowLevel;
+ (UIWindow *)lastWindowWithLevel:(UIWindowLevel)windowLevel;
+ (UIWindow *)topVisibleWindow;
+ (UIView *)currentViewControllerView;

+ (void)windowsWithLevel:(UIWindowLevel)windowLevel block:(void (^)(UIWindow*))block;

- (UIView *)subViewWithSuffix:(NSString *)classNameSuffix;

@end
