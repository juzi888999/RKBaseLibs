//
//  UIGlobal.h
//
//  Created by rk on 8/8/13.
//  Copyright (c) 2013. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <DLAlertView/DLAVAlertView.h>
#import <DLAlertView/DLAVAlertViewTheme.h>
#import <DLAlertView/DLAVAlertViewController.h>
#import <DLAlertView/DLAVAlertViewButtonTheme.h>

@class MBProgressHUD;

@interface UIGlobal : NSObject

+ (void)performAlertBlock:(dispatch_block_t)block;
+ (void)alert:(NSString*)message;
+ (void)alert:(NSString*)message withTitle:(NSString*)title;
+ (void)alert:(NSString *)message withTitle:(NSString *)title buttonTitle:(NSString *)btnTitle;
+ (void)alertLongMessage:(NSString*)message withTitle:(NSString*)title;
+(void)alertLongMessage:(NSString*)message withTitle:(NSString*)title completionBlock:(DLAVAlertViewCompletionHandler)completionHandler cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

+ (id)showAlertWithTitle:(NSString *)title message:(NSString *)message customizationBlock:(void (^)(DLAVAlertView *alertView))customization completionBlock:(DLAVAlertViewCompletionHandler)completionHandler cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

+ (void)showMessage:(NSString*)message;
+ (void)showMessage:(NSString *)message inView:(UIView *)view;
+ (void)showError:(NSError *)error;
+ (void)showError:(NSError *)error inView:(UIView *)view;

+ (MBProgressHUD*)showHudForView:(UIView*)view animated:(BOOL)animated;
+ (MBProgressHUD *)showHudForView:(UIView *)view tip:(NSString *)tip animated:(BOOL)animated;
+ (MBProgressHUD *)showHUDTip:(NSString *)tip inView:(UIView *)view;
+ (MBProgressHUD *)showActivityHudForView:(UIView *)view;
+ (MBProgressHUD *)showHudForView:(UIView *)view tip:(NSString *)tip backgroundColor:(UIColor *)backgroundColor animated:(BOOL)animated;
+ (MBProgressHUD *)showHudForView:(UIView *)view tip:(NSString *)tip backgroundColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor animated:(BOOL)animated;

+ (MBProgressHUD *)showLogoHUDForView:(UIView *)view;
+ (void)hideHudForView:(UIView*)view animated:(BOOL)animated;

+ (DLAVAlertView *)showAlertWithContentView:(UIView *)contentView completionBlock:(DLAVAlertViewCompletionHandler)completionHandler;

@end

@interface UIGlobal(helper)

//设置全局DLAlerview的风格
+ (void)setupDefaultAlertViewTheme;
+ (void)showErrorWithSMSSKDError:(NSError *)error;
+ (void)callAlertWithPhone:(NSString *)phone title:(NSString *)title;
+ (void)callService;
+ (UIColor *)defaultBackgroundColor;
+ (BOOL)showCameraAuthAlertIfNeed;
+ (void)showChooseMapSheetWithAddress:(NSString *)address inViewController:(UIViewController *)viewController;
+ (DLAVAlertView *)showAlertWithContentView:(UIView *)contentView
            title:(NSString *)title
cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitle
  completionBlock:(DLAVAlertViewCompletionHandler)completionHandler;

@end

