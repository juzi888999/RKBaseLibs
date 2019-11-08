//
//  BaseViewController.m
//  GPai
//
//  Created by rk on 15/12/6.
//  Copyright © 2015年 rk. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"
//#import <UMMobClick/MobClick.h>
#import <YYKit/NSObject+YYAdd.h>
#import "BaseNavigationViewController.h"
#import "UIImage+Tint.h"
#import <UIViewController+BackButtonHandler.h>

@interface BaseViewController ()

@end

@implementation BaseViewController

-(BOOL)navigationShouldPopOnBackButton
{
    [self by_backAction];
    return NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    if (self.by_navigationBarStyle == BYNavigationBarStyleMain) {
        return UIStatusBarStyleLightContent;
    }else if (self.by_navigationBarStyle == BYNavigationBarStyleWhite){
        return UIStatusBarStyleDefault;
    }
    return UIStatusBarStyleDefault;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    NSLog(@"\n%@",[self className]);
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.by_navigationBarStyle = BYNavigationBarStyleMain;//BYNavigationBarStyleMain;
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [MobClick beginLogPageView:[self className]];
    [self setNavigationStyle];
    if (self.navigationController && self.by_navigationBarHiddent) {
        [self.navigationController setNavigationBarHidden:self.by_navigationBarHiddent animated:animated];
    }
    if (self.bNavigationBarIsTransparent) {
        //设置导航栏背景图片为一个空的image，这样就透明了
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        //去掉透明后导航栏下边的黑边
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
        self.navigationController.navigationBar.translucent = YES;
    }else{
        self.navigationController.navigationBar.translucent = NO;
    }
    if (self.viewWillAppearBlock) {
        self.viewWillAppearBlock(animated);
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    [MobClick endLogPageView:[self className]];
    if (self.navigationController && !self.by_navigationBarHiddent) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    if (self.bNavigationBarIsTransparent) {
        //    如果不想让其他页面的导航栏变为透明 需要重置
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:nil];
        self.navigationController.navigationBar.translucent = YES;
    }else{
        self.navigationController.navigationBar.translucent = NO;
    }
    if (self.viewWillDisappearBlock) {
        self.viewWillDisappearBlock(animated);
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.viewDidDisappearBlock) {
        self.viewDidDisappearBlock(animated);
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.viewDidAppearBlock) {
        self.viewDidAppearBlock(animated);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HPColorForKey(@"tableView.bg");
    
    //    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    //    {
    //        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    //    }
    
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createGoBackItem];
}

@end

static NSString *navigationBarStyleKey = @"navigationBarStyleKey";
static NSString *naviLeftBtnKey = @"naviLeftBtnKey";
static NSString *naviLeftBtnHandleKey = @"naviLeftBtnHandleKey";
static NSString *naviRightBtnKey = @"naviRightBtnKey";
static NSString *naviRightBtnHandleKey = @"naviRightBtnHandleKey";
static NSString *navigationBarHiddentKey = @"navigationBarHiddentKey";
static NSString *bNavigationBarIsTransparentKey = @"bNavigationBarIsTransparentKey";

@implementation BaseViewController (Helper)

- (BYNavigationBarStyle)by_navigationBarStyle
{
    return [objc_getAssociatedObject(self, &navigationBarStyleKey) integerValue];
}

- (void)setBy_navigationBarStyle:(BYNavigationBarStyle)by_navigationBarStyle
{
    return objc_setAssociatedObject(self, &navigationBarStyleKey, @(by_navigationBarStyle), OBJC_ASSOCIATION_ASSIGN);
}

- (UIButton *)by_navLeftBtn
{
    return objc_getAssociatedObject(self, &naviLeftBtnKey);
}

- (void)setBy_navLeftBtn:(UIButton *)by_navLeftBtn
{
    return objc_setAssociatedObject(self, &naviLeftBtnKey, by_navLeftBtn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIButton *)by_navRightBtn
{
    return objc_getAssociatedObject(self, &naviRightBtnKey);
}

- (void)setBy_navRightBtn:(UIButton *)by_navRightBtn
{
    return objc_setAssociatedObject(self, &naviRightBtnKey, by_navRightBtn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (LeftNavBtnHandel)by_leftNavBtnHandel
{
    return objc_getAssociatedObject(self, &naviLeftBtnHandleKey);
}

- (void)setBy_leftNavBtnHandel:(LeftNavBtnHandel)by_leftNavBtnHandel
{
    return objc_setAssociatedObject(self, &naviLeftBtnHandleKey, by_leftNavBtnHandel, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (RightNavBtnHandel)by_rightNavBtnHandel
{
    return objc_getAssociatedObject(self, &naviRightBtnHandleKey);
}

- (void)setBy_rightNavBtnHandel:(RightNavBtnHandel)by_rightNavBtnHandel
{
    return objc_setAssociatedObject(self, &naviRightBtnHandleKey, by_rightNavBtnHandel, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (void)setBy_navigationBarHiddent:(BOOL)by_navigationBarHiddent
{
    return objc_setAssociatedObject(self, &navigationBarHiddentKey, @(by_navigationBarHiddent), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)bNavigationBarIsTransparent
{
    return [objc_getAssociatedObject(self, &bNavigationBarIsTransparentKey) integerValue];
}
- (void)setBNavigationBarIsTransparent:(BOOL)bNavigationBarIsTransparent
{
    return objc_setAssociatedObject(self, &bNavigationBarIsTransparentKey, @(bNavigationBarIsTransparent), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)by_navigationBarHiddent
{
    return [objc_getAssociatedObject(self, &navigationBarHiddentKey) integerValue];
}
- (void)by_backAction
{
    if (self.didTapBackBtnAction) {
        self.didTapBackBtnAction();
    }
    if (self.navigationController.viewControllers.count >= 2){
        BaseViewController * baseVC = self.navigationController.viewControllers[self.navigationController.viewControllers.count-2];
        [self.navigationController setNavigationBarHidden:baseVC.by_navigationBarHiddent animated:NO];
    }
    
    if(self.presentingViewController && self.navigationController.viewControllers.count==1)
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)createGoBackItem
{
//  if(self.navigationController.viewControllers.count>1||self.presentingViewController)
//    {
//        UIButton * navBackBtn = nil;
//        NSString * image = nil;
//        NSString * title = @"返回";
//        if (self.by_navigationBarStyle == BYNavigationBarStyleMain) {
//            image = @"Bar_white";
//        }else if (self.by_navigationBarStyle == BYNavigationBarStyleWhite){
//            image = @"Bar_back";
//        }
//        if (image == nil) {
//            title = @"返回";
//        }
//        navBackBtn = [self addLeftNavigationBarButtonImage:image Title:title block:^(UIButton *leftNavBtn, BaseViewController * viewController) {
//
//            [viewController by_backAction];
//        }];
//        navBackBtn.titleLabel.font = HPBoldFontWithSize(16);
//    }
    if (self.presentingViewController && self.navigationController.viewControllers.count == 1) {
        [self createDismissItem];
    }
}

-(void)createDismissItem
{
    NSString * image = @"dismiss_arrow";
    if (self.by_navigationBarStyle == BYNavigationBarStyleWhite) {
        image = @"arrow_down_gray";
    }else if (self.by_navigationBarStyle == BYNavigationBarStyleMain){
        image = @"dismiss_arrow";
    }
    [self addLeftNavigationBarButtonImage:image Title:nil block:^(UIButton *leftNavBtn, BaseViewController * viewController) {
        [viewController dismissViewControllerAnimated:YES completion:NULL];
    }];
}

-(UIButton *)addLeftNavigationBarButtonImage:(NSString *)image Title:(NSString *)title Target:(id)target Action:(SEL)action {
    
    UIButton * btn = [self createNavigationBarButton];
    self.by_navLeftBtn = btn;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    if (title == nil) {
        title = @"      ";
    }
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    if (image && image.length > 0) {
        UIImage * img = HPImageForKey(image);
        [btn setImage:img forState:UIControlStateNormal];
    }
    [btn sizeToFit];
    btn.height = 44;
    UIBarButtonItem * item =[[UIBarButtonItem alloc] initWithCustomView:btn];
    
    if (IOS7_OR_LATER) {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -5;
        self.navigationItem.leftBarButtonItems=@[negativeSpacer,item];
    }else{
        self.navigationItem.leftBarButtonItem = item;
    }
    
    return btn;
}

-(UIButton *)addRightNavigationBarButtonImage:(NSString *)image Title:(NSString *)title Target:(id)target Action:(SEL)action {
    
    UIButton * btn = [self createNavigationBarButton];
    self.by_navRightBtn = btn;
    if (self.by_navigationBarStyle == BYNavigationBarStyleWhite) {
        [btn setTitleColor:HPColorForKey(@"main") forState:UIControlStateNormal];
    }else if (self.by_navigationBarStyle == BYNavigationBarStyleMain){
        [btn setTitleColor:HPColorForKey(@"#ffffff") forState:UIControlStateNormal];
    }
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    
    if (image && image.length > 0) {
        [btn setImage:HPImageForKey(image) forState:UIControlStateNormal];
    }
    
    [btn sizeToFit];
    btn.size = CGSizeMake(btn.width+8, btn.height+8);
    UIBarButtonItem * item =[[UIBarButtonItem alloc] initWithCustomView:btn];
    
    if (IOS7_OR_LATER) {
//        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//        negativeSpacer.width = -5;
//        UIBarButtonItem *negativeSpacerRight = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//        negativeSpacerRight.width = -5;
        self.navigationItem.rightBarButtonItems=@[item];
    }else{
        self.navigationItem.rightBarButtonItem = item;
    }
    
    return btn;
}

-(NSArray *)addRightNavigationBarButtons:(NSArray *)items target:(id)target action:(SEL)action {
    
    NSMutableArray * btnItems = [NSMutableArray array];
    NSMutableArray * btnArray = [NSMutableArray array];
    NSArray * images = [items valueForKey:@"image"];
    NSArray * selectedImages = [items valueForKey:@"image_s"];
    NSArray * titles = [items valueForKey:@"title"];
    for (int i = 0; i < images.count; i++) {
        
        if (i > 0) {
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            negativeSpacer.width = 15;
            [btnItems addObject:negativeSpacer];
        }
        
        NSString * image = [NSString checkString:images[i]];
        NSString * title = [NSString checkString:titles[i]];
        NSString * image_s = [NSString checkString:selectedImages[i]];
        UIButton * btn = [self createNavigationBarButton];
        btn.tag = i;
        if (self.by_navigationBarStyle == BYNavigationBarStyleWhite) {
            [btn setTitleColor:HPColorForKey(@"main") forState:UIControlStateNormal];
        }
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:title forState:UIControlStateNormal];
        
        if (image.length > 0) {
            [btn setImage:HPImageForKey(image) forState:UIControlStateNormal];
        }
        if (image_s.length >0) {
            [btn setImage:HPImageForKey(image_s) forState:UIControlStateSelected];
        }
        [btn sizeToFit];
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [btnItems addObject:item];
        [btnArray addObject:btn];
    }
    self.navigationItem.rightBarButtonItems = btnItems;
    return btnArray;
}


- (UIButton *)addRightNavigationBarButtonImage:(NSString *)image Title:(NSString *)title  block:(RightNavBtnHandel)block
{
    self.by_rightNavBtnHandel = block;
    return [self addRightNavigationBarButtonImage:image Title:title Target:self Action:@selector(rightNavButtonAction:)];
}


-(UIButton *)addLeftNavigationBarButtonImage:(NSString *)image Title:(NSString *)title block:(LeftNavBtnHandel)block
{
    self.by_leftNavBtnHandel = block;
    return [self addLeftNavigationBarButtonImage:image Title:title Target:self Action:@selector(leftNavButtonAction:)];
}

- (UIButton *)createNavigationBarButton
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font= HPFontMediumSizeFont;
    btn.contentMode = UIViewContentModeCenter;
    if (self.by_navigationBarStyle == BYNavigationBarStyleMain) {
        [btn setTitleColor:HPColorForKey(@"#ffffff") forState:UIControlStateNormal];
        [btn setTitleColor:HPColorForKey(@"text.minor") forState:UIControlStateHighlighted];
        [btn setTitleColor:HPColorForKey(@"#f2f2f4") forState:UIControlStateDisabled];
    }else if(self.by_navigationBarStyle == BYNavigationBarStyleWhite){
        [btn setTitleColor:HPColorForKey(@"text.major") forState:UIControlStateNormal];
        [btn setTitleColor:HPColorForKey(@"text.minor") forState:UIControlStateHighlighted];
        [btn setTitleColor:HPColorForKey(@"#f2f2f4") forState:UIControlStateDisabled];
    }
    return btn;
}

- (void)rightNavButtonAction:(UIButton *)sender
{
    if (self.by_rightNavBtnHandel) {
        self.by_rightNavBtnHandel(sender,self);
    }
}

- (void)leftNavButtonAction:(UIButton *)sender
{
    if (self.by_leftNavBtnHandel) {
        self.by_leftNavBtnHandel(sender,self);
    }
}

- (void)setLeftNavBtnTitle:(NSString *)title
{
    if (self.by_navLeftBtn) {
        [self.by_navLeftBtn setTitle:title forState:UIControlStateNormal];
        [self.by_navLeftBtn sizeToFit];
    }
}

- (void)setRightNavBtnTitle:(NSString *)title
{
    if (self.by_navRightBtn) {
        [self.by_navRightBtn setTitle:title forState:UIControlStateNormal];
        [self.by_navRightBtn sizeToFit];
    }
}

- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
//    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    UIWindow * window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] firstObject];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

- (UILabel *)addTitleLabel
{
    CGFloat top = 20;
    if (isIphoneXScreen) {
        top = 44;
    } else {
        // Fallback on earlier versions
    }
    UILabel * titleLabel = [UILabel centerAlignLabel];
    titleLabel.font= HPFontWithSize(20);
    if (self.by_navigationBarStyle == BYNavigationBarStyleMain) {
        titleLabel.textColor = HPColorForKey(@"#ffffff");
    }else{
        titleLabel.textColor = [UIColor blackColor];
    }
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(60);
        make.right.mas_equalTo(-60);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(top);
    }];
    return titleLabel;

}
- (UIButton *)addBackButton
{
    CGFloat top = 20;
    if (isIphoneXScreen) {
        top = 44;
    } else {
        // Fallback on earlier versions
    }
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.contentMode = UIViewContentModeCenter;
    [backBtn addTarget:self action:@selector(by_backAction) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:HPImageForKey(@"Bar_back") forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(top);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    return backBtn;
}

- (void)setNavigationStyle
{
    [self.navigationController.navigationBar setShadowImage:nil];
    if ([self.navigationController.visibleViewController isEqual:self] || self.navigationController.presentedViewController) {
        if (self.by_navigationBarStyle == BYNavigationBarStyleMain) {
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:HPColorForKey(@"main")] forBarMetrics:UIBarMetricsDefault];
            [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
            [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:HPBoldFontWithSize(20), NSForegroundColorAttributeName:[UIColor whiteColor]}];
            
        }else if (self.by_navigationBarStyle == BYNavigationBarStyleWhite){
            
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:HPColorForKey(@"#ffffff")] forBarMetrics:UIBarMetricsDefault];
            [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
            [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:HPBoldFontWithSize(20), NSForegroundColorAttributeName:[UIColor blackColor]}];
        }
    }
}


@end
