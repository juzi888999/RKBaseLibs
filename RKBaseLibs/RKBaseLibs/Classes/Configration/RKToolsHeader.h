//
//  RKToolsHeader.h
//  RKBaseLibs
//
//  Created by rk on 15/8/27.
//  Copyright (c) 2015年 rk. All rights reserved.
//

#ifndef RKToolsHeader_h
#define RKToolsHeader_h

#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif

#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//判断iOS版本
#ifndef IOS7_OR_LATER
#define IOS7_OR_LATER   SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")
#endif
#ifndef IOS8_OR_LATER
#define IOS8_OR_LATER   SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")
#endif
#ifndef IOS9_OR_LATER
#define IOS9_OR_LATER   SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")
#endif
#ifndef IOS10_OR_LATER
#define IOS10_OR_LATER  SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")
#endif
#ifndef IOS11_OR_LATER
#define IOS11_OR_LATER  SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0")
#endif

#define MainScreenHeight                [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth                 [UIScreen mainScreen].bounds.size.width
#define ScreenHeight                [UIScreen mainScreen].bounds.size.height
#define ScreenWidth                 [UIScreen mainScreen].bounds.size.width

// 设备物理尺寸
#define SC_WIDTH      [UIScreen mainScreen].bounds.size.width
#define SC_HEIGHT     [UIScreen mainScreen].bounds.size.height

#define kScreenWidthRatio  (MainScreenWidth / 414)
#define kScreenHeightRatio (MainScreenHeight / 736)

#define AdaptedWidthValue(x)  (ceilf((x) * kScreenWidthRatio))
#define AdaptedHeightValue(x) (ceilf((x) * kScreenHeightRatio))
#define fitValue(x) (ceilf((x) * (MainScreenWidth / 375)))



//375x812 pt
#define isIphoneXScreen             [RKDeviceManager sharedManager].isHairHead
#define isIphone6PlusScreen             (MainScreenHeight == 736 && MainScreenWidth == 414)
#define isIphone5Screen             (MainScreenHeight == 568 && MainScreenWidth == 320)
#define isIphone4Screen             (MainScreenHeight == 480 && MainScreenWidth == 320)

#define TabBarHeight                    (isIphoneXScreen ?83:49)
#define StatusBarHeight                 (isIphoneXScreen ?44:((IOS7_OR_LATER)?0:20))
#define safeAreaTopInset                 (isIphoneXScreen ?44:20)
#define NavBarHeight                    (isIphoneXScreen ?88:(44 + (20 - StatusBarHeight)))

//全局字体
#define MainFontSize(x) [UIFont systemFontOfSize:x]
#define MainBoldFontSize(x)  [UIFont boldSystemFontOfSize:x]

#define COMMONCOLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f \
green:(g)/255.0f \
blue:(b)/255.0f \
alpha:1.0f]
// RGB
#define COMMONCOLOR_A(r, g, b, a)       [UIColor colorWithRed:(r)/255.0f \
green:(g)/255.0f \
blue:(b)/255.0f \
alpha:a]


//全局颜色
#define MainColor HPColorForKey(@"main")
#define MainBackgroundColor RGBCOLOR(237.0, 238.0, 239.0)
#define WhiteColor [UIColor whiteColor]
#define MainTextColor [UIColor darkTextColor]
#define MainDarkGrayColor [UIColor darkGrayColor]
#define MainGrayColor [UIColor grayColor]

// 消息通知
#define RegisterNotify(_name, _selector)                    \
[[NSNotificationCenter defaultCenter] addObserver:self  \
selector:_selector name:_name object:nil];

#define RemoveNofify            \
[[NSNotificationCenter defaultCenter] removeObserver:self];

#define SendNotify(_name, _object)  \
[[NSNotificationCenter defaultCenter] postNotificationName:_name object:_object];

#define RKAppDelegate ((AppDelegate *)([UIApplication sharedApplication].delegate))

#endif
//
//// -------- 调试相关
//#ifdef DEBUG
//
//#define NSLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
//
//#else
//
//#define NSLog(fmt, ...)
//
//#endif

#define XBVersionTestCached  0
