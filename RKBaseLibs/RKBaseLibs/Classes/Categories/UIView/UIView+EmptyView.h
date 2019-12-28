//
//  UIView+EmptyView.h
//  RKBaseLibs 
//
//  Created by rk on 16/8/16.
//  Copyright © 2016年 rk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (EmptyView)

@property (strong,nonatomic) NSString * by_defaultHintText;
@property (strong,nonatomic) UIView * by_defaultEmptyView;
@property (strong,nonatomic) UIView * by_customEmptyView;
@property (strong,nonatomic) UIView * by_defaultRequestFailureView;
@property (strong,nonatomic) UIView * by_customRequestFailureView;

@property (copy,nonatomic) void(^by_emptyViewTapBlock)(void);
@property (copy,nonatomic) void(^by_requestFailureTapBlock)(void) ;

- (void)by_showEmptyViewInCenter:(BOOL)show;
- (void)by_showEmptyViewInCenter:(BOOL)show withFrame:(CGRect)frame;

- (void)by_showRequestFailureViewInCenter:(BOOL)show;
- (void)by_showRequestFailureViewInCenter:(BOOL)show withFrame:(CGRect)frame;
- (void)by_removeCurrentShowView;
- (UIView *)by_createDefaultRequestFailureView;
- (UIView *)by_hintViewWithText:(NSString *)text;
@end

