//
//  BaseNavigationViewController.h
//  RKBaseLibs 
//
//  Created by rk on 16/2/4.
//  Copyright © 2016年 rk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BaseNavigationViewControllerDelegate

- (BOOL)interactivePopGestureRecognizerEnable;

@end

@interface BaseNavigationViewController : UINavigationController

@end

@interface UINavigationController(Helper)

/*
 @params
 */
- (BOOL)popToViewControllerWithClass:(Class)className animated:(BOOL)animated;

//self.viewControllers 最多同时存在一个 viewController.class 类控制器
- (void)pushOnlyViewController:(UIViewController *)viewController animated:(BOOL)animated;

//self.viewControllers 最多同时存在一个 needPopViewControllerClassArray 数组里面的控制器
- (void)pushOnlyViewController:(UIViewController *)viewController needPopViewControllers:(NSArray <NSString */*控制器类名*/>*)needPopViewControllerClassArray animated:(BOOL)animated;

- (UIViewController *)subViewControllerWithClass:(Class)className;


@end

@interface UINavigationController(Animate)

- (void)setNavigationBarAlpha:(CGFloat)alpha animation:(BOOL)animation duration:(NSTimeInterval)duration;

@end
