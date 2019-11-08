//
//  RKDeviceManager.m
//  RKBaseLibs
//
//  Created by rk on 2018/1/8.
//  Copyright © 2018年 rk. All rights reserved.
//

#import "RKDeviceManager.h"

@implementation RKDeviceManager

static RKDeviceManager *_instance = nil;

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[RKDeviceManager alloc] init];
    });
    return _instance;
}

- (UIWindow *)keyWindow {
    UIWindow * keyWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
//    return [UIApplication sharedApplication].keyWindow;
    return keyWindow;
}

- (UIEdgeInsets)safeAreaInset {
    if (@available(iOS 11.0, *)) {
        if (self.keyWindow) {
            return self.keyWindow.safeAreaInsets;
        }
    }
    return UIEdgeInsetsZero;
}

- (BOOL)isHairHead {
    
    /// 先判断设备是否是iPhone/iPod
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return NO;
    }
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        return self.safeAreaInset.left > 20.0f;
    }else {
        // ios12 非刘海屏状态栏 20.0f
        return self.safeAreaInset.top > 20.0f;
    }
}

+ (void)setDeviceOrientation:(UIInterfaceOrientation)orientation
{
    if (@available(iOS 13.0, *)) {
    }else{
        [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:NO];
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:orientation] forKey:@"orientation"];
    }
}

@end
