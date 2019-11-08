//
//  BYPopOverController.m
//  RKBaseLibs 
//
//  Created by rk on 16/7/20.
//  Copyright © 2016年 rk. All rights reserved.
//

#import "BYPopController.h"
#import <JHChainableAnimations/JHChainableAnimations.h>
#import <UIImage+YYAdd.h>

@interface BYPopController()
@property (strong,nonatomic) BYPopBackgroundView * backgroundView;
@property (strong,nonatomic) UIView * contentView;
@property (strong,nonatomic) UIView * superview;
@property (strong,nonatomic) UIView * showView;
@property (assign,nonatomic) CGRect originShowViewFrame;
@end
@implementation BYPopController

- (void)commonInit
{
}

- (instancetype)init{
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static BYPopController *s = nil;
    dispatch_once(&onceToken, ^{
        s = [[BYPopController alloc] init];
        s.enableTapDismiss = NO;
        [s commonInit];
    });
    return s;
}

- (void)updateShowViewFrame:(CGRect)newFrame animateTime:(NSTimeInterval)animateTime
{
    self.originShowViewFrame = newFrame;
    [UIView animateWithDuration:animateTime animations:^{
        self.showView.frame = newFrame;
    }];
}

- (void)showView:(UIView *)showView inView:(UIView *)superview direction:(BYPopControllerShowDirection)showDirection animateTime:(CGFloat)animateTime blurEffect:(BOOL)blurEffect tapDismiss:(BOOL)tapDismiss addCloseButtonAtBottom:(BOOL)addCloseButtonAtBottom
{
    if (!superview || !showView) {
        return;
    }
    UIWindow * keyWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    [keyWindow endEditing:YES];
    CGRect showFrame = showView.frame;
    self.originShowViewFrame = showFrame;
    self.showDirection = showDirection;
    self.enableTapDismiss = tapDismiss;
    self.showView = showView;
    self.superview = superview;
    BYPopBackgroundView * background = [[BYPopBackgroundView alloc]initWithFrame:superview.bounds];
    
    if (blurEffect) {
        [background setBlurImageWithView:superview];
        
    }else{
        background.opaque = NO;
        background.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
    }
    self.backgroundView = background;
    
    [superview addSubview:background];
    background.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    UIView * contentView = [[UIView alloc]initWithFrame:background.bounds];
    self.contentView = contentView;
    [background addSubview:contentView];
    contentView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer * dismissTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissTapAction:)];
    dismissTap.cancelsTouchesInView = NO;
    [contentView addGestureRecognizer:dismissTap];
    [self.contentView addSubview:showView];
    
    //用来屏蔽导航的返回手势，避免弹窗之后还能操作到导航的手势返回
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    [self.contentView addGestureRecognizer:pan];
    
    if (showDirection == BYPopControllerShowDirectionBottom) {
        showView.frame = showFrame;
        showView.top = superview.height;
        [UIView animateWithDuration:animateTime animations:^{
            background.layer.opacity = 1.f;
            showView.top = showFrame.origin.y;
        }];
//        JHChainableAnimator * animator = [[JHChainableAnimator alloc]initWithView:background];
//        animator.makeOpacity(1.f).animate(animateTime);
//        JHChainableAnimator * animator2 = [[JHChainableAnimator alloc]initWithView:showView];
//        animator2.makeY(showFrame.origin.y).animate(animateTime);
    }else if (showDirection == BYPopControllerShowDirectionTop) {
        showView.frame = showFrame;
        showView.bottom = 0;
//        JHChainableAnimator * animator = [[JHChainableAnimator alloc]initWithView:background];
//        animator.makeOpacity(1.f).animate(animateTime);
//        JHChainableAnimator * animator2 = [[JHChainableAnimator alloc]initWithView:showView];
//        animator2.makeY(showFrame.origin.y).animate(animateTime);
        [UIView animateWithDuration:animateTime animations:^{
            background.layer.opacity = 1.f;
            showView.top = showFrame.origin.y;
        }];
    }else if (showDirection == BYPopControllerShowDirectionNone){
        showView.frame = showFrame;
    }
    
    if (addCloseButtonAtBottom) {
        UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.closeButton = closeBtn;
        [self.contentView addSubview:closeBtn];
        [closeBtn setImage:HPImageForKey(@"pop_close") forState:UIControlStateNormal];
        closeBtn.frame = CGRectMake(0, 0, 38, 38);
        closeBtn.centerX = self.contentView.width/2;
        closeBtn.bottom = self.contentView.height - 55;
    }
    
}
- (void)showView:(UIView *)showView inView:(UIView *)superview direction:(BYPopControllerShowDirection)showDirection animateTime:(CGFloat)animateTime blurEffect:(BOOL)blurEffect tapDismiss:(BOOL)tapDismiss
{
    [self showView:showView inView:superview direction:showDirection animateTime:animateTime blurEffect:blurEffect tapDismiss:tapDismiss addCloseButtonAtBottom:NO];
}

- (BOOL)isShow
{
    return self.showView?YES:NO;
}

-(void)dismissCurrentView
{
    if (self.closeButton && self.closeButton.superview) {
        [self.closeButton removeFromSuperview];
        self.closeButton = nil;
    }
    if (self.showView && self.backgroundView && self.backgroundView.superview) {
        JHChainableAnimator * animator = [[JHChainableAnimator alloc]initWithView:self.backgroundView];
        CGFloat animateTime = 0.2;
        animator.makeOpacity(NO).animate(animateTime);
        JHChainableAnimator * animator2 = [[JHChainableAnimator alloc]initWithView:self.showView];
        
        if (self.showDirection == BYPopControllerShowDirectionBottom) {
            animator2.makeY(self.contentView.height).animate(animateTime).makeY(self.originShowViewFrame.origin.y).animateWithCompletion(0.3,^{
                    if (self.willDismissBlock) {
                        self.willDismissBlock(self.showView);
                    }
                    [self.showView removeFromSuperview];
                    [self.contentView removeFromSuperview];
                    [self.backgroundView removeFromSuperview];
                    self.showView.frame = self.originShowViewFrame;
                    self.showView = nil;
                    self.backgroundView = nil;
                    self.contentView = nil;
                });
        }else if (self.showDirection == BYPopControllerShowDirectionTop) {
            animator2.makeY(-self.showView.height).animate(animateTime).makeY(self.originShowViewFrame.origin.y).animateWithCompletion(0.3,^{
                    if (self.willDismissBlock) {
                        self.willDismissBlock(self.showView);
                    }
                    [self.showView removeFromSuperview];
                    [self.contentView removeFromSuperview];
                    [self.backgroundView removeFromSuperview];
                    self.showView = nil;
                    self.backgroundView = nil;
                    self.contentView = nil;
                });
        }else if (self.showDirection == BYPopControllerShowDirectionNone) {
            animator2.makeY(-self.showView.height).animate(animateTime).makeY(self.originShowViewFrame.origin.y).animateWithCompletion(0.3,^{
                    if (self.willDismissBlock) {
                        self.willDismissBlock(self.showView);
                    }
                    [self.showView removeFromSuperview];
                    [self.contentView removeFromSuperview];
                    [self.backgroundView removeFromSuperview];
                    self.showView.frame = self.originShowViewFrame;
                    self.showView = nil;
                    self.backgroundView = nil;
                    self.contentView = nil;
                });
        }
    }
}

+ (void)dismiss
{
    [[BYPopController shareInstance] dismissCurrentView];
}

- (void)dismissTapAction:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:self.contentView];
    if (self.showView && !CGRectContainsPoint(self.showView.frame, point)) {
        
        if (self.enableTapDismiss) {
            [self dismissCurrentView];
        }
    }
}

- (void)panAction:(UIPanGestureRecognizer *)pan
{
    
}
@end

@implementation BYPopBackgroundView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
    }
    return self;
}

- (UIImage *)getImageWithView:(UIView *)theView
{
    //************** 得到图片 *******************
    CGRect rect = theView.frame;  //截取图片大小
    
    //开始取图，参数：截图图片大小
    UIGraphicsBeginImageContext(rect.size);
    //截图层放入上下文中
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    //从上下文中获得图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //结束截图
    UIGraphicsEndImageContext();
    return image;
}

- (void)setBlurImageWithView:(UIView *)view
{
    UIImage * image = [self getImageWithView:view];
    self.image = [image imageByBlurDark];
    //    self.image = [image imageByBlurWithTint:HPColorForKey(@"#000000")];
    //    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    //    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    //    effectView.frame = view.bounds;
    //    [self addSubview:effectView];
    
    //    [self setImageToBlur:image blurRadius:20 completionBlock:^{
    //
    //    }];
}

@end
