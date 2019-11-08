//
//  RKDeviceManager.h
//  RKBaseLibs
//
//  Created by rk on 2018/1/8.
//  Copyright © 2018年 rk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIAlertController+supportedInterfaceOrientations.h"

@interface RKDeviceManager : NSObject

@property (nonatomic, assign, readonly) UIEdgeInsets safeAreaInset;
/*
 * 是否是刘海屏
 *经测试发现iOS12修改了非刘海屏safeArea的值! 拿iPhone6竖屏情况下为例iOS11中返回的safeAreaInsets为（0，0，0，0）；iOS12中返回的safeAreaInsets为（20，0，0，0）；是的这个top-20是状态栏。这里大家要注意下，不应该盲目使用safeAreaInsets，而是使用我下面类似的判断刘海屏的方法来区分刘海屏后再决定是否使用safeAreaInsets；
 * */
@property (nonatomic, assign, readonly) BOOL isHairHead;

+ (instancetype)sharedManager;
- (UIWindow *)keyWindow;

/*
 UIViewController 需要实现这两个
 -(UIInterfaceOrientationMask)supportedInterfaceOrientations{
 return UIInterfaceOrientationMaskAll;
 }
 
 -(BOOL)shouldAutorotate
 {
 return YES;
 }
 */
+ (void)setDeviceOrientation:(UIInterfaceOrientation)orientation;

@end
