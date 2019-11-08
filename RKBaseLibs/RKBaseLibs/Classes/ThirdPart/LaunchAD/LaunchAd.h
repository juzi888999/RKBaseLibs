//
//  LaunchAd.h
//  RKBaseLibs
//
//  Created by rk on 2017/12/25.
//  Copyright © 2017年 rk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADRootViewController.h"

@interface LaunchAdEntity : HPEntity

@property (strong,nonatomic) NSString *apd_id;//"14",
@property (strong,nonatomic) NSString *apd_name;//"vivo x20新耀红",
@property (strong,nonatomic) NSString *apd_sort;//"1",
@property (strong,nonatomic) NSString *apd_addtime;//"1514195805",
@property (strong,nonatomic) NSString *apd_updatetime;//"1514195805",
@property (strong,nonatomic) NSString *apd_linkUrl;//"https://shopact.vivo.com.cn/page/20171218sd",
@property (strong,nonatomic) NSString *apd_hits;//"0",
@property (strong,nonatomic) NSString *apd_filepath;//"http://test.gzrbs.com.cn:100/data/upload/advert/2017/12/25/05675397733468039.png",
@property (strong,nonatomic) NSString *apd_time;//"3"

@property (assign,nonatomic) NSInteger removeTime;
@end

@class CycleProgressView;

typedef NS_ENUM(NSUInteger, LaunchAdType) {
    LaunchAdTypeTotalTime,//所有广告时间累加,点击跳过按钮跳过所有广告
    LaunchAdTypeSignleTime//每个广告时间单独倒计时,点击跳过按钮跳过当前广告,进入下个广告倒计时
};
@interface LaunchAd : NSObject

@property (strong,nonatomic) ADRootViewController * rootViewController;
@property (strong,nonatomic) BaseNavigationViewController * rootNavigationController;
@property (assign,nonatomic) LaunchAdType type;
@property (assign,nonatomic) NSInteger currentTime;
@property (assign,nonatomic) CGFloat currentFloatTime;
@property (assign,nonatomic) NSInteger totalTime;
@property (strong,nonatomic) NSTimer * timer;
@property (strong,nonatomic) NSTimer * progressTimer;
//@property (strong,nonatomic) AFHTTPRequestOperation * op;
@property (strong,nonatomic) NSArray * adList;
@property (strong,nonatomic) UIView * baseView;
@property (strong,nonatomic) NSMutableArray * imageViewArray;
@property (strong,nonatomic) UIButton * enterBtn;
@property (strong,nonatomic) CycleProgressView * progressView;
- (void)requestLaunchAdSuccess:(HPSuccess)success failure:(HPFailure)failure;
- (void)showADsInView:(UIView *)superView;
@property (copy,nonatomic) void(^imageViewDidTap)(LaunchAdEntity * object);
@property (copy,nonatomic) void(^enterBtnAction)(BOOL canEnter);

- (void)startTimer;
- (void)stopTimer;


@end
