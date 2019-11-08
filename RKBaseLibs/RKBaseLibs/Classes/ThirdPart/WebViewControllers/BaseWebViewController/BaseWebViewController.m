//
//  BaseWebViewController.m
//  RKBaseLibs 
//
//  Created by rk on 16/3/14.
//  Copyright © 2016年 rk. All rights reserved.
//

#import "BaseWebViewController.h"
#import "NJKWebViewProgressView.h"

@interface BaseWebViewController ()
{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}

@end

@implementation BaseWebViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.by_navigationBarStyle = BYNavigationBarStyleWhite;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.showMoreBtn) {
        [self addRightNavigationBarButtonImage:nil Title:@"•••" block:^(UIButton *rightNavBtn, BaseWebViewController * viewController) {
            [viewController shareSheet];
        }];
    }
    
    if(_webTitle.length!=0)
    {
        self.title = _webTitle;
    }
    
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = NO;
//    [self setExtendLayoutMode:UIRectEdgeNone];
}

- (void)initSubviews
{
    _myWebView = [[UIWebView alloc]initWithFrame:CGRectZero];
    _myWebView.delegate = self;
    _myWebView.scalesPageToFit = NO;
    
    _myWebView.backgroundColor = [UIColor clearColor];
    _myWebView.opaque = NO;
    [self.view addSubview:_myWebView];
    
    [_myWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
    }];
    
    [self loadWebViewWithURLString:_address];
}

- (void)loadWebViewWithURLString:(NSString *)urlString
{
    if (_htmlStr.length != 0) {
        [_myWebView loadHTMLString:_htmlStr baseURL:[NSURL URLWithString:SERVER_IP]];
    }else{
        NSURL *url = nil;
        
        if ([urlString hasPrefix:@"file"]) {
            url = [NSURL URLWithString:urlString];
        }else{
            if (_isFullAddress) {
                url = [NSURL URLWithString:urlString];
            }else{
                url = [NetworkClient urlForString:urlString];
            }
        }
        
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_myWebView loadRequest:request];
        
        [self createProgress];
        [self hideScrollTopAndBottom];
    }
}

- (void)createProgress
{
    if (self.disableProgressView) {
        return;
    }
    if (_progressView)
    {
        [_progressView removeFromSuperview];
        _progressView = nil;
    }
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _myWebView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_progressView];
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_myWebView.mas_left);
        make.top.equalTo(_myWebView.mas_top);
        make.width.equalTo(_myWebView.mas_width);
        make.height.mas_equalTo(2);
    }];
}

- (void)hideScrollTopAndBottom
{
    _myWebView.backgroundColor=[UIColor clearColor];
    for (UIView *aView in [_myWebView subviews])
    {
        if ([aView isKindOfClass:[UIScrollView class]])
        {
            [(UIScrollView *)aView setShowsVerticalScrollIndicator:NO]; //右侧的滚动条 （水平的类似）
            
            for (UIView *shadowView in aView.subviews)
            {
                
                if ([shadowView isKindOfClass:[UIImageView class]])
                {
                    shadowView.hidden = YES;  //上下滚动出边界时的黑色的图片 也就是拖拽后的上下阴影
                }
            }
        }
    }
}

- (void)openInBrowserAction
{
    [[UIApplication sharedApplication] openURL:[NetworkClient urlForString:_address]];
}

- (void)showHUD:(BOOL)show
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = show;
    /*    if (show) {
     [UIGlobal showHudForView:self.view animated:YES];
     }else{
     [UIGlobal hideHudForView:self.view animated:YES];
     }
     */
}
#pragma mark - UIWebView delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showHUD:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self showHUD:NO];
    if (!_webTitle) {
        //获取当前页面的title
        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self showHUD:NO];
}

#pragma mark - NJKWebViewProgressDelegate

-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    if(progress>=1.0)
    {
        [_progressView removeFromSuperview];
        _progressView = nil;
        return;
    }
    [_progressView setProgress:progress animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)goBackButtonAction
//{
//    if (self.myWebView.canGoBack) {
//        [self.myWebView goBack];
//    }else{
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}

-(void)dealloc
{
    _myWebView.delegate = nil;
    [_myWebView stopLoading];
    _progressProxy.webViewProxyDelegate = nil;
    _progressProxy.progressDelegate = nil;
    [self showHUD:NO];
}

- (void)shareSheet
{
    //分享的标题
//    NSString *textToShare = @"标题";
    //分享的图片
//    UIImage *imageToShare = HPImageForKey(@"icon_my_n");
    //分享的url
    NSURL *urlToShare = [NSURL URLWithString:self.address];
    //在这里呢 如果想分享图片 就把图片添加进去  文字什么的通上
    NSArray *activityItems = @[urlToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    //不出现在活动项目
//    activityVC.excludedActivityTypes = @[UIActivityTypePostToFacebook,UIActivityTypePostToTwitter,UIActivityTypePostToWeibo,UIActivityTypeMessage,UIActivityTypeSaveToCameraRoll,UIActivityTypePostToFlickr,UIActivityTypeAddToReadingList,UIActivityTypePostToVimeo,UIActivityTypePostToTencentWeibo,UIActivityTypeAirDrop,UIActivityTypeOpenInIBooks];
    [self presentViewController:activityVC animated:YES completion:nil];
    // 分享之后的回调
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            NSLog(@"completed");
            //分享 成功
        } else  {
            NSLog(@"cancled");
            //分享 取消
        }
    };
}

-(void)setDisableProgressView:(BOOL)disableProgressView{
    _disableProgressView = disableProgressView;
    if (_progressView){
        _progressView.hidden = disableProgressView;
    }
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
