//
//  BaseNavigationViewController.m
//  RKBaseLibs 
//
//  Created by rk on 16/2/4.
//  Copyright © 2016年 rk. All rights reserved.
//

#import "BaseNavigationViewController.h"
#import "BaseViewController.h"
#import "UIImage+Tint.h"
//#import "UINavigationController+FDFullscreenPopGesture.h"
#import "RKDeviceManager.h"


@interface BaseNavigationViewController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation BaseNavigationViewController

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}

- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.topViewController.preferredStatusBarStyle;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{

    UIViewController * vc = self.topViewController;
    if (vc.supportedInterfaceOrientations == UIInterfaceOrientationMaskPortrait) {
        if (![self shouldAutorotate]) {        
            [RKDeviceManager setDeviceOrientation:UIInterfaceOrientationPortrait];
        }
    }
    return self.topViewController.supportedInterfaceOrientations;
}

-(BOOL)shouldAutorotate
{
    return self.topViewController.shouldAutorotate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak BaseNavigationViewController *weakSelf = self;
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        [self setInTeractivePopGestureRecongnizerEnable:NO];

    if ( self.viewControllers.count > 0 )
    {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

#pragma mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
    // Enable the gesture again once the new controller is shown
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        //到根控制器的时候不可以把滑动返回手势打开，否则会出bug
        if(self.viewControllers.count!=1)
        {
            [self setInTeractivePopGestureRecongnizerEnable:YES];
            id vc = self.topViewController;
            if (vc && [vc respondsToSelector:@selector(interactivePopGestureRecognizerEnable)]) {
                [self setInTeractivePopGestureRecongnizerEnable:[vc interactivePopGestureRecognizerEnable]];
            }
        }
        else
        {
            [self setInTeractivePopGestureRecongnizerEnable:NO];
        }
      
    }
}

- (void)setInTeractivePopGestureRecongnizerEnable:(BOOL)enable
{
    self.interactivePopGestureRecognizer.enabled = enable;
//    self.fd_interactivePopDisabled = !enable;
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

@implementation UINavigationController(Helper)


- (UIViewController *)subViewControllerWithClass:(Class)className
{
    UIViewController * toVC = nil;
    for (UIViewController * vc in self.viewControllers) {
        if ([NSStringFromClass(className) isEqualToString:NSStringFromClass(vc.class)]) {
            toVC = vc;
            break;
        }
    }
    if (toVC) {
        return toVC;
    }else{
        NSLog(@"找不到 %@",className);
        return nil;
    }

}

- (BOOL)popToViewControllerWithClass:(Class)className animated:(BOOL)animated
{
    UIViewController * toVC = [self subViewControllerWithClass:className];
       if (toVC) {
        [self popToViewController:toVC animated:animated];
        return YES;
    }else{
        return NO;
    }
}

- (void)pushOnlyViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSMutableArray * temp = [NSMutableArray array];
    for (UIViewController * vc in self.viewControllers) {
        if (![NSStringFromClass(viewController.class) isEqualToString:NSStringFromClass(vc.class)]) {
            [temp addObject:vc];
        }
    }
    if (self.viewControllers.count != temp.count) {
        self.viewControllers = temp;
    }
    [self pushViewController:viewController animated:animated];
}

- (void)pushOnlyViewController:(UIViewController *)viewController needPopViewControllers:(NSArray <NSString *>*)needPopViewControllerClassArray animated:(BOOL)animated
{
    NSMutableArray * temp = [NSMutableArray array];
    for (UIViewController * vc in self.viewControllers) {
        
        if (![needPopViewControllerClassArray containsObject:NSStringFromClass(vc.class)]) {
            [temp addObject:vc];
        }
    }
    if (self.viewControllers.count != temp.count) {
        self.viewControllers = temp;
    }
    [self pushViewController:viewController animated:animated];
}
@end

@implementation UINavigationController(Animate)

- (void)setNavigationBarAlpha:(CGFloat)alpha animation:(BOOL)animation duration:(NSTimeInterval)duration {
    if (animation) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:duration animations:^{
            [weakSelf.navigationBar.subviews[0] setAlpha:alpha];
        }];
    }else {
        [self.navigationBar.subviews[0] setAlpha:alpha];
    }
}





@end
