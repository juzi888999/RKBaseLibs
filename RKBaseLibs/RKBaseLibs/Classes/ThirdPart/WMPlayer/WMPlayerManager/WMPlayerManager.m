//
//  WMPlayerManager.m
//  RKBaseLibs
//
//  Created by rk on 2018/8/10.
//  Copyright © 2018年 juzi. All rights reserved.
//

#import "WMPlayerManager.h"
#import "WMPlayer.h"

@interface WMPlayerManager()<WMPlayerDelegate>
@property(nonatomic,strong) WMPlayer *wmPlayer;
@property (strong,nonatomic) UIView * playerSuperView;
@property (strong,nonatomic) UIScrollView * scrollView;
@property (strong,nonatomic) UIViewController * viewController;
@property (strong,nonatomic) WMPlayerModel * object;
@property (assign,nonatomic) CGRect originFrame;

@end

@implementation WMPlayerManager

static WMPlayerManager *_instance = nil;

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[WMPlayerManager alloc] init];
    });
    return _instance;
}

- (BOOL)isFullScreen
{
    return self.wmPlayer.isFullscreen;
}

- (void)playInView:(UIView *)playerSuperView viewController:(UIViewController *)viewController object:(WMPlayerModel *)object
{
    [self resetWMPlayer];
    self.playerSuperView = playerSuperView;
    self.viewController = viewController;
    self.object = object;
    self.scrollView = nil;
    [WMPlayerManager shareInstance].wmPlayer.playerModel = object;
    [self.playerSuperView addSubview:self.wmPlayer];
    [self.wmPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.playerSuperView);
    }];
    [self.wmPlayer play];
}
- (void)playInView:(UIView *)playerSuperView scrollView:(UIScrollView *)scrollView viewController:(UIViewController *)viewController object:(WMPlayerModel *)object
{
    [self resetWMPlayer];
    self.playerSuperView = playerSuperView;
    self.viewController = viewController;
    self.scrollView = scrollView;
    self.object = object;
    self.originFrame = [playerSuperView.superview convertRect:playerSuperView.frame toView:scrollView];
    [WMPlayerManager shareInstance].wmPlayer.playerModel = object;
    [scrollView addSubview:self.wmPlayer];
    [self.wmPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.originFrame.origin.x);
        make.top.mas_equalTo(self.originFrame.origin.y);
        make.size.mas_equalTo(self.originFrame.size);
    }];
    [self.wmPlayer play];
}

-(WMPlayer *)wmPlayer
{
    if (!_wmPlayer) {
        _wmPlayer = [WMPlayer playerWithModel:nil];
        _wmPlayer.tintColor = HPColorForKey(@"#f55c1e");
        _wmPlayer.delegate = self;
        _wmPlayer.backBtnStyle = BackBtnStyleNone;
    }
    return _wmPlayer;
}

#pragma mark - WMPlayer

//-(UIStatusBarStyle)preferredStatusBarStyle
//{
//    if (self.wmPlayer && self.wmPlayer.isFullscreen) {
//        return UIStatusBarStyleLightContent;
//    }else{
//        return [[[self.viewController.superclass alloc]init] preferredStatusBarStyle];
//    }
//}
-(BOOL)prefersStatusBarHidden{
    if (self.wmPlayer.isFullscreen) {
        return YES;
    }
    return NO;
}
/**
 *  旋转屏幕通知
 */
- (void)onDeviceOrientationChange:(NSNotification *)notification{
    if (!self.playerSuperView) {
        return;
    }
    if (self.wmPlayer==nil){
        return;
    }
    if (self.wmPlayer.playerModel.verticalVideo) {
        return;
    }
    if (self.wmPlayer.isLockScreen){
        return;
    }
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
            NSLog(@"第3个旋转方向---电池栏在下");
        }
            break;
        case UIInterfaceOrientationPortrait:{
            NSLog(@"第0个旋转方向---电池栏在上");
            [self toOrientation:UIInterfaceOrientationPortrait byClickFullScreenButton:NO];
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            NSLog(@"第2个旋转方向---电池栏在左");
            [self toOrientation:UIInterfaceOrientationLandscapeLeft byClickFullScreenButton:NO];
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            NSLog(@"第1个旋转方向---电池栏在右");
            [self toOrientation:UIInterfaceOrientationLandscapeRight byClickFullScreenButton:NO];
        }
            break;
        default:
            break;
    }
}
//点击进入,退出全屏,或者监测到屏幕旋转去调用的方法
-(void)toOrientation:(UIInterfaceOrientation)orientation byClickFullScreenButton:(BOOL)click{
    //获取到当前状态条的方向
    [self.wmPlayer removeFromSuperview];
    //根据要旋转的方向,使用Masonry重新修改限制
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown ||
        orientation == UIInterfaceOrientationUnknown) {
        self.wmPlayer.isFullscreen = NO;
        self.wmPlayer.backBtnStyle = BackBtnStyleNone;
        if (self.scrollView) {
            [self.scrollView addSubview:self.wmPlayer];
            [self.wmPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.originFrame.origin.x);
                make.top.mas_equalTo(self.originFrame.origin.y);
                make.size.mas_equalTo(self.originFrame.size);
            }];
        }else{
            [self.playerSuperView addSubview:self.wmPlayer];
            [self.wmPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self.playerSuperView);
            }];
        }
        
    }else{
        UIWindow * keyWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        [keyWindow addSubview:self.wmPlayer];
        self.wmPlayer.isFullscreen = YES;
        self.wmPlayer.backBtnStyle = BackBtnStylePop;
        if (self.wmPlayer.playerModel.verticalVideo) {
            [self.wmPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.wmPlayer.superview);
            }];
        }else{
            [self.wmPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@([UIScreen mainScreen].bounds.size.height));
                make.height.equalTo(@([UIScreen mainScreen].bounds.size.width));
                make.center.equalTo(self.wmPlayer.superview);
            }];
        }
    }
//iOS6.0之后,设置状态条的方法能使用的前提是shouldAutorotate为NO,也就是说这个视图控制器内,旋转要关掉;
    //也就是说在实现这个方法的时候-(BOOL)shouldAutorotate返回值要为NO
    if (self.wmPlayer.playerModel.verticalVideo) {
        [self.viewController setNeedsStatusBarAppearanceUpdate];
    }else{
        CGAffineTransform transform = CGAffineTransformIdentity;
            transform = [WMPlayer getTransformWithOrientation:orientation];
        //给你的播放视频的view视图设置旋转
        [UIView animateWithDuration:0.4 animations:^{
            self.wmPlayer.transform = CGAffineTransformIdentity;
            self.wmPlayer.transform = transform;
            [self.wmPlayer layoutIfNeeded];
            [self.viewController setNeedsStatusBarAppearanceUpdate];
        }];
    }
}

///播放器事件
-(void)wmplayer:(WMPlayer *)wmplayer clickedCloseButton:(UIButton *)closeBtn{
    NSLog(@"didClickedCloseButton");
    if (self.onlyFullScreenMode) {
        [self toOrientation:UIInterfaceOrientationPortrait byClickFullScreenButton:NO];
        [self releaseWMPlayer];
    }else{
        if (wmplayer.isFullscreen) {
            [self toOrientation:UIInterfaceOrientationPortrait byClickFullScreenButton:NO];
        }else{
            [self releaseWMPlayer];
        }
    }
}
-(void)wmplayer:(WMPlayer *)wmplayer clickedFullScreenButton:(UIButton *)fullScreenBtn{
    if (self.wmPlayer.isFullscreen) {//全屏
        [self toOrientation:UIInterfaceOrientationPortrait byClickFullScreenButton:YES];
        if (self.onlyFullScreenMode){        
            [self releaseWMPlayer];
        }
    }else{//非全屏
        
        [self toOrientation:UIInterfaceOrientationLandscapeRight byClickFullScreenButton:YES];
    }
}
//操作栏隐藏或者显示都会调用此方法
-(void)wmplayer:(WMPlayer *)wmplayer isHiddenTopAndBottomView:(BOOL)isHidden{
    [self.viewController setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)interactivePopGestureRecognizerEnable
{
    return NO;
}
/**
 *  释放WMPlayer
 */
-(void)releaseWMPlayer{
    [self.wmPlayer pause];
    [self.wmPlayer removeFromSuperview];
    self.wmPlayer = nil;
}
- (void)pause
{
    [self.wmPlayer pause];
}
- (void)resetWMPlayer
{
    [self.wmPlayer pause];
    [self.wmPlayer resetWMPlayer];
    [self.wmPlayer removeFromSuperview];
    self.scrollView = nil;
    self.originFrame = CGRectZero;
    self.object = nil;
    self.playerSuperView = nil;
    self.viewController = nil;
}

-(BOOL)isCurrentPlayingURL:(NSURL *)URL
{
    if (self.object) {
        return [self.object.videoURL.absoluteString isEqualToString:URL.absoluteString];
    }
    return NO;
}

+ (void)destroyInstance
{
    [_instance releaseWMPlayer];
    _instance = nil;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (void)dealloc {
    NSLog(@"%@:----释放了",NSStringFromSelector(_cmd));
}

#pragma mark - 锁屏功能
/**
 * 说明：播放器父类是UIView。
 屏幕锁屏方案需要用户根据实际情况，进行开发工作；
 如果viewcontroller在navigationcontroller中，需要添加子类重写navigationgController中的 以下方法，根据实际情况做判定 。
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    
    //    return toInterfaceOrientation = UIInterfaceOrientationLandscapeLeft|UIInterfaceOrientationPortrait;
    
    //    if (self.isBecome) {
    //        return toInterfaceOrientation = UIInterfaceOrientationLandscapeLeft;
    //    }
  
    if (self.wmPlayer.isLockScreen) {
        return toInterfaceOrientation = UIInterfaceOrientationPortrait;
        
    }else{
        return YES;
    }
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate{
    if (@available(iOS 13.0, *)) {
        return YES;
    }
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    if (self.wmPlayer.isLockScreen) {
        return UIInterfaceOrientationMaskLandscapeRight;
    }else{
        return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskLandscapeLeft|UIInterfaceOrientationMaskLandscapeRight;
    }
}
@end
