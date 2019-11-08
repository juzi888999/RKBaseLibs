//
//  BaseWebViewController.h
//  RKBaseLibs 
//
//  Created by rk on 16/3/14.
//  Copyright © 2016年 rk. All rights reserved.
//

#import "BaseViewController.h"
#import "NJKWebViewProgress.h"

@interface BaseWebViewController : BaseViewController<UIWebViewDelegate,NJKWebViewProgressDelegate>

@property (copy,nonatomic) NSString * webTitle;

@property (copy,nonatomic) NSString * address;//网址
@property (assign,nonatomic) BOOL isFullAddress;
@property (copy,nonatomic) NSString * htmlStr;//html字符串
@property (assign,nonatomic) BOOL disableProgressView;
@property (assign,nonatomic) BOOL showMoreBtn;
@property (strong, nonatomic) UIWebView *myWebView;
- (void)loadWebViewWithURLString:(NSString *)urlString;

@end
