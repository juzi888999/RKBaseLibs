//
//  BYPopOverController.h
//  RKBaseLibs 
//
//  Created by rk on 16/7/20.
//  Copyright © 2016年 rk. All rights reserved.
//

typedef NS_ENUM(NSUInteger, BYPopControllerShowDirection) {
    BYPopControllerShowDirectionNone,
    BYPopControllerShowDirectionBottom,
    BYPopControllerShowDirectionTop
};
@interface BYPopController : NSObject

@property (strong,nonatomic) UIButton * closeButton;

@property (assign,nonatomic)BOOL enableTapDismiss;//default is NO
@property (assign,nonatomic) BOOL enableBlurEffect;//是否开启毛玻璃背景效果 默认 NO
@property (assign,nonatomic) BYPopControllerShowDirection showDirection;

- (void)updateShowViewFrame:(CGRect)newFrame animateTime:(NSTimeInterval)animateTime;

@property (copy,nonatomic) void (^willDismissBlock)(UIView *showView);

+ (instancetype)shareInstance;
+ (void)dismiss;
- (BOOL)isShow;

- (void)showView:(UIView *)showView inView:(UIView *)superview direction:(BYPopControllerShowDirection)showDirection animateTime:(CGFloat)animateTime blurEffect:(BOOL)blurEffect tapDismiss:(BOOL)tapDismiss addCloseButtonAtBottom:(BOOL)addCloseButtonAtBottom;
- (void)showView:(UIView *)showView inView:(UIView *)superview direction:(BYPopControllerShowDirection)showDirection animateTime:(CGFloat)animateTime blurEffect:(BOOL)blurEffect tapDismiss:(BOOL)tapDismiss;


- (void)dismissCurrentView;

@end

@interface BYPopBackgroundView : UIImageView
- (void)setBlurImageWithView:(UIView *)view;

@end
