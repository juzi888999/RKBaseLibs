//
//  PushMessageManager.h
//  xubo 
//
//  Created by rk on 2019/2/12.
//  Copyright © 2019年 rk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PushMessageManager : NSObject

+ (instancetype)shareInstance;
//
//- (void)didReceiveNotificationResponse:(NSDictionary *)userInfo;
//- (void)didReceiveNotification:(NSDictionary *)userInfo;
//
////- (void)dealWithPushUserInfo:(NSDictionary *)userInfo;
//- (void)dealWithResponsePushUserInfo:(NSDictionary *)userInfo
//   currentSelectedRootViewController:(BaseViewController *)currentSelectedRootViewController
//                  mineViewController:(BaseViewController *)mineViewController;

@end

NS_ASSUME_NONNULL_END
