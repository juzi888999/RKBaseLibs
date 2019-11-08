//
//  SSWebViewController.m
//  xubo 
//
//  Created by rk on 2018/9/11.
//  Copyright © 2018年 rk. All rights reserved.
//

#import "SSWebViewController.h"
#import "OpenURLManager.h"

static NSString * const ScriptHandleNameAppShare = @"AppShare";//分享
static NSString * const ScriptHandleNameShowPicture = @"jsCallBack";//点击图片回调
static NSString * const ScriptHandleNameLoadURL = @"loadUrl";//跳转 BaseWebViewController 控制器

static NSString * const ObserveKeyPathEstimatedProgress = @"estimatedProgress";

@interface SSWebViewController ()<WKNavigationDelegate, WKUIDelegate,WKScriptMessageHandler>
@property (strong,nonatomic) WKWebView * webView;
@property (nonatomic, strong) UIProgressView *myProgressView;
@property (strong,nonatomic) BYPhotoBrowser * photoBrowser;
@property (strong,nonatomic) UIImageView * topImageView;
@end

@implementation SSWebViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.progressColor = HPColorForKey(@"main");
        self.fontControl = NO;
        self.allowsBackForwardNavigationGestures = YES;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (!self.hiddenSafariBtn) {
        [self addRightNavigationBarButtonImage:@"video_safari" Title:nil block:^(UIButton *rightNavBtn, SSWebViewController * viewController) {
            [OpenURLManager openUrl:[NSString checkString:viewController.url]];
        }];
    }
    [self deleteWebCache];
    [self initWebView];
    [self.view addSubview:self.myProgressView];
}

- (void)initWebView
{
 
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    // 设置偏好设置
    config.preferences = [[WKPreferences alloc] init];
    // 默认为0
//    config.preferences.minimumFontSize = 10;
    // 默认认为YES
    config.preferences.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示不能自动通过窗口打开
    config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    // web内容处理池
    config.processPool = [[WKProcessPool alloc] init];
    
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    if (!self.disableAutoAdaptPage) {
        // 通过JS与webview内容交互 自适应屏幕
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";

        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [wkUController addUserScript:wkUScript];
    }
    config.userContentController = wkUController;
    // 注入JS对象名称AppModel，当JS通过AppModel来调用时，
    // 我们可以在WKScriptMessageHandler代理中接收到
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    webView.scrollView.backgroundColor = [UIColor whiteColor];
    webView.scrollView.bounces = NO;
    self.webView = webView;
    if (IOS9_OR_LATER) {
        webView.allowsLinkPreview = NO;
    }
    [self addScriptMessageHandle];
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    webView.allowsBackForwardNavigationGestures = self.allowsBackForwardNavigationGestures;
    [self loadURL];
    
    [self.view addSubview:webView];
    if ([NSString checkString:self.topImageURL].length > 0) {
        UIImageView * topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.topImageFrame.origin.x, self.topImageFrame.origin.y-self.topImageFrame.size.height, self.topImageFrame.size.width, self.topImageFrame.size.height)];
        [self.webView.scrollView addSubview:topImageView];
        self.webView.scrollView.contentInset = UIEdgeInsetsMake(self.topImageFrame.origin.y+self.topImageFrame.size.height, 0, 0, 0);
        [topImageView sd_setImageWithURL:[NetworkClient imageUrlForString:self.topImageURL]];
    }
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [webView addObserver:self forKeyPath:ObserveKeyPathEstimatedProgress options:NSKeyValueObservingOptionNew context:nil];
}

- (void)loadRequestWithUrl:(NSString *)url
{
    if ([NSString checkString:url].length == 0) {
        return;
    }
    self.url = url;
    if (!self.webView) {
        [self initWebView];
    }else{
        [self loadURL];
    }
}

- (void)loadURL
{
    if ([NSString checkString:self.htmlStr].length > 0) {
        self.htmlStr = [NSString stringWithFormat:@"<html> \n"
                           "<head> \n"
                           "<style type=\"text/css\"> \n"
                           "body {margin:18;font-size:14;color:0x666666}\n"
                           "</style> \n"
                           "</head> \n"
                           "<body>"
                           "<script type='text/javascript'>"
                           "window.onload = function(){\n"
                           "var $img = document.getElementsByTagName('img');\n"
                           "for(var p in  $img){\n"
                           " $img[p].style.width = '100%%';\n"
                           "$img[p].style.height ='auto'\n"
                           "}\n"
                           "}"
                           "</script>%@"
                           "</body>"
                           "</html>",self.htmlStr];
        [self.webView loadHTMLString:self.htmlStr baseURL:nil];
    }else if (self.url) {
        if ([self.url isKindOfClass:[NSURL class]]) {
            [self.webView loadRequest:[NSURLRequest requestWithURL:(NSURL *)(self.url)]];
        }else{
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
        }
    }else if(self.localURL){
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.localURL]];
    }
}

+ (NSString *)createHtmlStrWithImageName:(NSString *)imageName
{
    //编码图片
    UIImage *selectedImage = HPImageForKey(imageName);
    NSString *stringImage = [SSWebViewController htmlForJPGImage:selectedImage];
    
    //构造内容
    NSString *contentImg = [NSString stringWithFormat:@"%@", stringImage];
    NSString *content =[NSString stringWithFormat:
                        @"<html>"
                        "<style type=\"text/css\">"
                        "<!--"
                        "body{font-size:40pt;line-height:60pt;}"
                        "-->"
                        "</style>"
                        "<body>"
                        "%@"
                        "</body>"
                        "</html>"
                        , contentImg];
    //    [self.webView loadHTMLString:content baseURL:nil];
    return content;
}

//编码图片
+ (NSString *)htmlForJPGImage:(UIImage *)image
{
    NSData *imageData = UIImageJPEGRepresentation(image,1.0);
    NSString *imageSource = [NSString stringWithFormat:@"data:image/jpg;base64,%@",[imageData base64Encoding]];
    return [NSString stringWithFormat:@"<img src = \"%@\" />", imageSource];
}

#pragma mark - WKScriptMessageHandler
- (void)addScriptMessageHandle
{
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:ScriptHandleNameAppShare];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:ScriptHandleNameShowPicture];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:ScriptHandleNameLoadURL];
}

- (void)removeScriptMessageHandle
{
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:ScriptHandleNameAppShare];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:ScriptHandleNameShowPicture];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:ScriptHandleNameLoadURL];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    // 打印所传过来的参数，只支持NSNumber, NSString, NSDate, NSArray,
    // NSDictionary, and NSNull类型
    NSLog(@"JS传来的json字符串 ：  %@", message.body);
    if ([message.name isEqualToString:ScriptHandleNameAppShare]) {
        
        NSString * body = message.body;
        NSDictionary * jsDictionary = [NSJSONSerialization JSONObjectWithData:[body dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        NSString * appshareurl = jsDictionary[@"appshareurl"];
        NSString * desc = [NSString checkString:jsDictionary[@"desc"]];
        NSString * title = jsDictionary[@"title"];
        NSString * imgurl = jsDictionary[@"imgurl"];
       
//        ShareManager * manager = [[ShareManager alloc]init];
//        self.manager = manager;
//        [manager showShareSheetWithPaperNewsTitle:title content:desc url:appshareurl thumbImage:imgurl viewController:self];

        
    }else if ([message.name isEqualToString:ScriptHandleNameShowPicture]) {
        
        NSString * body = message.body;
        NSDictionary * jsDictionary = [NSJSONSerialization JSONObjectWithData:[body dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        NSInteger currentIndex = [[NSString checkString:jsDictionary[@"this_ck"]] integerValue];
        NSArray * imageArray = [NSArray checkArray:jsDictionary[@"img_url"]];
        [self showPhotoBrowserWithIndex:currentIndex photos:imageArray];
    }else if ([message.name isEqualToString:ScriptHandleNameLoadURL]) {
        
//        NSString * body = [NSString checkString:message.body];
//        if (body.length == 0) {
//            return;
//        }
//        BaseWebViewController * webView = [[BaseWebViewController alloc]init];
//        body = [body chineseEncoded];
//        body = [body stringByReplacingOccurrencesOfString:@"%22" withString:@""];
//        webView.address = body;
//        webView.isFullAddress = YES;
//        [self.navigationController pushViewController:webView animated:YES];
    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:
(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //    NSString *hostname = navigationAction.request.URL.host.lowercaseString;
    NSLog(@"navigationAction : %@",navigationAction);
    
    NSString * sourceUrl = [NSString checkString:navigationAction.sourceFrame.request.URL.absoluteString];
    self.preUrl = sourceUrl;
    self.currentUrl = [navigationAction.request.URL absoluteString];
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 在响应完成时，会回调此方法
// 如果设置为不允许响应，web内容就不会传过来
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
    
}

// 开始导航跳转时会回调
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
}

// 接收到重定向时会回调
- (void)webView:(WKWebView *)webView
didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
}

// 导航失败时会回调
- (void)webView:(WKWebView *)webView
didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
}


// 页面内容到达main frame时回调
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    
}

// 导航完成时，会回调（也就是页面载入完成了）
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"66===%s", __FUNCTION__);
    if (self.fontControl) {
        CGFloat fontScale = [[HPPreference shareInstance] fontScale];
        NSString * font = [NSString stringWithFormat:@"%d%%",(int)(fontScale*100.f)];
        NSString *jsString = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%@'",font];
        [webView evaluateJavaScript:jsString completionHandler:^(id _Nullable value, NSError * _Nullable error) {
            NSLog(@"%@",error);
        }];
    }
    // 禁用选中效果
    //    [self.webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none'" completionHandler:nil];
    //    [self.webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none'" completionHandler:nil];
    if (self.didFinishNavigation) {
        self.didFinishNavigation(self.webView);
    }
}

// 导航失败时会回调
- (void)webView:(WKWebView *)webView didFailNavigation:
(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    if (self.didFailNavigation) {
        self.didFailNavigation(webView, error);
    }
}

/* 对于HTTPS的都会触发此代理，如果不要求验证，传默认就行
 如果需要证书验证，与使用AFN进行HTTPS证书验证是一样的 */

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:
(NSURLAuthenticationChallenge *)challenge completionHandler:
(void (^)(NSURLSessionAuthChallengeDisposition disposition,
          NSURLCredential *__nullable credential))completionHandler
{
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
}

// 9.0才能使用，web内容处理中断时会触发
/*
 - (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
 }
 */
#pragma mark - WKUIDelegate
- (void)webViewDidClose:(WKWebView *)webView {
    
}
/* 在JS端调用alert函数时，会触发此代理方法。JS端调用alert时所传的数据可以通过message拿到 在原生得到结果后，需要回调JS，是通过completionHandler回调 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
    NSLog(@"%@", message);
}

// JS端调用confirm函数时，会触发此方法
// 通过message可以拿到JS端所传的数据
// 在iOS端显示原生alert得到YES/NO后
// 通过completionHandler回调给JS端
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                                                  completionHandler(YES);
                                              }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                      {
                          completionHandler(NO);
                      }]];
    [self presentViewController:alert animated:YES completion:NULL];
    NSLog(@"%@", message);
}
// JS端调用prompt函数时，会触发此方法
// 要求输入一段文本
// 在原生输入得到文本内容后，通过completionHandler回调给JS
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:prompt message:defaultText preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor blackColor];
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                  completionHandler([[alert.textFields lastObject] text]);
                                              }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

-(void)dealloc
{
    [self.webView removeObserver:self forKeyPath:ObserveKeyPathEstimatedProgress];
    [self removeScriptMessageHandle];
}

- (void)showPhotoBrowserWithIndex:(NSInteger)index photos:(NSArray *)photos
{
    if (!self.photoBrowser && photos) {
        self.photoBrowser = [[BYPhotoBrowser alloc] initWithPhotos:photos];
    }
    [self.photoBrowser.browser setCurrentPhotoIndex:index];
    [self.photoBrowser showInViewController:self.navigationController animated:YES completion:nil];
}

- (CGFloat)getFitingHeight
{
    return self.webView.scrollView.contentSize.height;
    //    [self.webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:completionHandler];
}

#pragma mark -
// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        self.myProgressView.alpha = 1.0f;
        [self.myProgressView setProgress:newprogress animated:YES];
        if (newprogress >= 1.0f) {
            [UIView animateWithDuration:0.3f
                                  delay:0.3f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 self.myProgressView.alpha = 0.0f;
                             }
                             completion:^(BOOL finished) {
                                 [self.myProgressView setProgress:0 animated:NO];
                             }];
        }
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - getter and setter
- (UIProgressView *)myProgressView
{
    if (_myProgressView == nil) {
        _myProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
        _myProgressView.trackTintColor = [UIColor whiteColor];
    }
    _myProgressView.tintColor = self.progressColor;

    return _myProgressView;
}


//清除所有的缓存
- (void)deleteWebCache {
    //allWebsiteDataTypes清除所有缓存
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        
    }];
}
//
////自定义清除缓存
//- (void)deleteWebCache {
//    /*
//     在磁盘缓存上。
//     WKWebsiteDataTypeDiskCache,
//
//     html离线Web应用程序缓存。
//     WKWebsiteDataTypeOfflineWebApplicationCache,
//
//     内存缓存。
//     WKWebsiteDataTypeMemoryCache,
//
//     本地存储。
//     WKWebsiteDataTypeLocalStorage,
//
//     Cookies
//     WKWebsiteDataTypeCookies,
//
//     会话存储
//     WKWebsiteDataTypeSessionStorage,
//
//     IndexedDB数据库。
//     WKWebsiteDataTypeIndexedDBDatabases,
//
//     查询数据库。
//     WKWebsiteDataTypeWebSQLDatabases
//     */
//    NSArray * types=@[WKWebsiteDataTypeCookies,WKWebsiteDataTypeLocalStorage];
//
//    NSSet *websiteDataTypes= [NSSet setWithArray:types];
//    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
//
//    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
//
//    }];
//}

@end
