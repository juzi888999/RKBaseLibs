//
//  OpenURLManager.h
//
//  Created by rk on 14-11-30.
//  Copyright (c) 2014年 juzi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpenURLManager : NSObject

+ (BOOL)isWeChatInstall;
+ (BOOL)openUrl:(NSString *)url;
+ (void)callTelephoneWithNumber:(NSString*)number;
+ (void)promptCallTelephoneWithNumber:(NSString *)number;
+ (void)webViewCallTelephoneWithNumber:(NSString *)number;

//百度地图
+ (BOOL)canOpenBaiduMap;
+ (void)openBaiduMapWithAddress:(NSString *)address;
//高德地图
+ (BOOL)canOpenIOSAmapMap;
+ (void)openIOSAmapMapWithAddress:(NSString *)address;
//苹果系统自带高德地图
+ (void)openIOSAmapSystemWithAddress:(NSString *)address;
//谷歌地图
+ (BOOL)canOpenGoogleMap;
+ (void)openGoogleMapWithAddress:(NSString *)address;

/**
 @param coordinate 目的地经纬度字符串@"118.0000,24.0000"
 @param name 目的地名称
 */
+ (void)gohereWithCoordinate:(NSString *)coordinate name:(NSString *)name;

@end
