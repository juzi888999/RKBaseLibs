//
//  SSWebViewController.h
//  xubo 
//
//  Created by rk on 2018/9/11.
//  Copyright © 2018年 rk. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>

@interface SSWebViewController : BaseViewController

@property (assign,nonatomic) BOOL allowsBackForwardNavigationGestures;
@property (copy,nonatomic) NSString * url;
@property (strong,nonatomic) NSURL * localURL;
@property (copy,nonatomic) NSString * htmlStr;
@property (copy,nonatomic) void(^didFinishNavigation)(WKWebView * webView);
@property (copy,nonatomic) void(^didFailNavigation)(WKWebView * webView,NSError * error);
- (void)loadRequestWithUrl:(NSString *)url;
@property (strong,nonatomic) UIColor * progressColor;
@property (assign,nonatomic) BOOL fontControl;//default is YES
@property (copy,nonatomic) NSString * preUrl;
@property (copy,nonatomic) NSString * currentUrl;
@property (assign,nonatomic) BOOL disableAutoAdaptPage;//default is NO
@property (strong,nonatomic) NSString * topImageURL;
@property (assign,nonatomic) CGRect topImageFrame;
@property (assign,nonatomic) BOOL hiddenSafariBtn;//用safari打开
/*
 @param imageName 本地图片名
 */
+ (NSString *)createHtmlStrWithImageName:(NSString *)imageName;

@end
