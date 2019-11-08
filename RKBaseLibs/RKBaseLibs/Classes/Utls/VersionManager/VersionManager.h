//
//  VersionManager.h
//  RKBaseLibs
//
//  Created by rk on 2017/12/27.
//  Copyright © 2017年 rk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XBVersionEntity : HPEntity
@property (assign,nonatomic) NSUInteger showTimes;

@property (strong,nonatomic) NSString * appName;
@property (assign,nonatomic) int versionCode;
@property (strong,nonatomic) NSString * versionName;
@property (strong,nonatomic) NSString * downloadUrl;
@property (strong,nonatomic) NSString * tips;
@property (assign,nonatomic) BOOL mustUpdate;

@end

@interface XBVersionCacheGameRuleVersionEntity : HPEntity
@property (copy,nonatomic) NSString * game;//    Int    大彩种id
@property (copy,nonatomic) NSString *type_id;//    int    具体彩票id
@property (copy,nonatomic) NSString *n_typename;//    String    彩票名称
@property (copy,nonatomic) NSString *version;//    Int    彩种赔率/倒计时版本号

@end

@interface XBVersionCacheVersionEntity : HPEntity

@property (copy,nonatomic) NSString * navigateVersion;//导航栏版本号
@property (strong,nonatomic) NSArray <XBVersionCacheGameRuleVersionEntity *>* gameClassVersions;//彩种赔率和倒计时版本号

@end

@interface VersionManager : NSObject

+ (instancetype)shareInstance;
@property (strong,nonatomic) UIViewController * viewController;
@property (strong,nonatomic) NSString * path;
#pragma mark - app version
@property (assign,nonatomic) int showTime;
- (void)checkVersion;
//+ (void)checkVersionWithSuccess:(HPSuccess)success failure:(HPFailure)failure;
+ (NSString *)getCurrentVersion;
@property (strong,nonatomic) XBVersionEntity * versionEntity;

-(void)showUpdateAlert;


#pragma mark - cached version

@property (strong,nonatomic) XBVersionCacheVersionEntity * cachedVersionEntity;
//获取最新缓存版本号
- (void)checkCacheVersionAndUpdateCachedIfNeed;

@end
