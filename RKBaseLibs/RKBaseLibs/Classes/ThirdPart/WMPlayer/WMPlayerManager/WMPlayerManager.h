//
//  WMPlayerManager.h
//  RKBaseLibs
//
//  Created by rk on 2018/8/10.
//  Copyright © 2018年 juzi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMPlayerModel.h"

@interface WMPlayerManager : NSObject

@property (assign,nonatomic) BOOL onlyFullScreenMode;//只显示全屏模式
- (BOOL)isFullScreen;
- (void)pause;
+ (instancetype)shareInstance;
- (void)playInView:(UIView *)playerSuperView viewController:(UIViewController *)viewController object:(WMPlayerModel *)object;

//在tableView列表的cell种播放的时候使用这个方法,避免cell从用导致的一些bug
- (void)playInView:(UIView *)playerSuperView scrollView:(UIScrollView *)scrollView viewController:(UIViewController *)viewController object:(WMPlayerModel *)object;

//在所在控制器对应方法中调用
//-(UIStatusBarStyle)preferredStatusBarStyle;
-(BOOL)prefersStatusBarHidden;
- (void)onDeviceOrientationChange:(NSNotification *)notification;
- (BOOL)interactivePopGestureRecognizerEnable;
/**
 * 说明：播放器父类是UIView。
 屏幕锁屏方案需要用户根据实际情况，进行开发工作；
 如果viewcontroller在navigationcontroller中，需要添加子类重写navigationgController中的 以下方法，根据实际情况做判定 。
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
- (BOOL)shouldAutorotate;
-(UIInterfaceOrientationMask)supportedInterfaceOrientations;

- (void)resetWMPlayer;

-(BOOL)isCurrentPlayingURL:(NSURL *)URL;
-(void)releaseWMPlayer;

//click 参数废弃
-(void)toOrientation:(UIInterfaceOrientation)orientation byClickFullScreenButton:(BOOL)click;

@end
