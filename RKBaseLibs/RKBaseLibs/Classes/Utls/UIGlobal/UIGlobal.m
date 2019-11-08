//
//  UIGlobal.m
//
//
//  Created by rk on 8/8/13.
//

#import "UIGlobal.h"
#import "MBProgressHUD.h"
#import "OpenURLManager.h"
#import <AVFoundation/AVFoundation.h>
#import "BaseWebViewController.h"

@implementation UIGlobal


+ (DLAVAlertView *)showAlertWithContentView:(UIView *)contentView completionBlock:(DLAVAlertViewCompletionHandler)completionHandler
{
    CGSize size = contentView.size;
    DLAVAlertViewTheme *theme = [DLAVAlertViewTheme theme];
    theme.contentViewMargins = DLAVTextControlMarginsMake(0, 0, 0, 0);
    DLAVAlertView *alertView = [[DLAVAlertView alloc] initWithTitle:nil message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    theme.backgroundColor = UIColor.clearColor;
    alertView.backgroundColor = UIColor.clearColor;
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width ,size.height)];
    alertView.minContentWidth = size.width;
    alertView.dismissesOnBackdropTap = NO;
    mainView.backgroundColor = UIColor.clearColor;
    [alertView applyTheme:theme];
    
    [mainView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(mainView);
    }];
    alertView.contentView = mainView;
    [alertView showWithCompletion:completionHandler];
    return alertView;
}

+ (void)performAlertBlock:(dispatch_block_t)block
{
    dispatch_after(0.2, dispatch_get_main_queue(), block);
}

+ (void)alert:(NSString *)message
{
    [[self class] alert:message withTitle:@"提示"];
}
+ (void)alert:(NSString *)message withTitle:(NSString *)title
{
    if (message.length <= 0)
        return;
    [[[DLAVAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
}

+ (void)alert:(NSString *)message withTitle:(NSString *)title buttonTitle:(NSString *)btnTitle
{
    if (message.length <= 0)
        return;
    [[[DLAVAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:btnTitle otherButtonTitles:nil] show];

}
+(void)alertLongMessage:(NSString*)message withTitle:(NSString*)title
{
    if (message.length <= 0)
        return;
    CGFloat w = MainScreenWidth*0.9;
    DLAVAlertViewTheme *theme = [DLAVAlertViewTheme theme];
    theme.contentViewMargins = DLAVTextControlMarginsMake(0, 0, 0, 0);
    DLAVAlertView *alertView = [[DLAVAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w , w)];
    [alertView applyTheme:theme];
    alertView.minContentWidth = w;
    alertView.dismissesOnBackdropTap = NO;
    mainView.backgroundColor = HPColorForKey(@"#EBEDFE");
    UIView *contentView = [UIView new];
    [mainView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(mainView).insets(UIEdgeInsetsMake(10, 10, 10, 0));
    }];
    UIScrollView *scrollView = [UIScrollView new];
    [contentView addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(contentView);
    }];
    UILabel *label = [UILabel leftAlignLabel];
    [scrollView addSubview:label];
    label.numberOfLines = 0;
    label.preferredMaxLayoutWidth = w-15;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentView);
        make.right.mas_equalTo(contentView).offset(-5);
        make.bottom.mas_equalTo(scrollView);
        make.top.mas_equalTo(scrollView);
    }];
    label.text = message;
    
    alertView.contentView = mainView;
}

+(void)alertLongMessage:(NSString*)message withTitle:(NSString*)title completionBlock:(DLAVAlertViewCompletionHandler)completionHandler cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    if (message.length <= 0)
        return;
    CGFloat w = [UIScreen mainScreen].bounds.size.width*0.8;
    DLAVAlertViewTheme *theme = [DLAVAlertViewTheme theme];
    theme.contentViewMargins = DLAVTextControlMarginsMake(0, 0, 0, 0);
    [DLAVAlertView setDefaultTheme:theme];
    
    DLAVAlertView *alertView = [[DLAVAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w , w)];
    alertView.minContentWidth = w;
    alertView.dismissesOnBackdropTap = NO;
    mainView.backgroundColor = HPColorForKey(@"#EBEDFE");
    [alertView applyTheme:theme];
    UIView *contentView = [UIView new];
    [mainView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(mainView).insets(UIEdgeInsetsMake(10, 10, 10, 0));
    }];
    UIScrollView *scrollView = [UIScrollView new];
    [contentView addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(contentView);
    }];
    UILabel *label = [UILabel leftAlignLabel];
    [scrollView addSubview:label];
    label.numberOfLines = 0;
    label.preferredMaxLayoutWidth = w-15;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentView);
        make.right.mas_equalTo(contentView).offset(-5);
        make.bottom.mas_equalTo(scrollView);
        make.top.mas_equalTo(scrollView);
    }];
    label.text = message;
    
    alertView.contentView = mainView;
    [alertView showWithCompletion:completionHandler];
}

+ (id)showAlertWithTitle:(NSString *)title message:(NSString *)message customizationBlock:(void (^)(DLAVAlertView *alertView))customization completionBlock:(DLAVAlertViewCompletionHandler)completionHandler cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    DLAVAlertView * alert = [[DLAVAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    if (customization) {
        customization(alert);
    }
    [alert showWithCompletion:completionHandler];
    return alert;
}

#pragma mark - MBProgressHUD

+ (void)showMessage:(NSString *)message
{
    if ([message isEqualToString:@"系统出现异常!"] ||
        [message isEqualToString:@"系统出现异常！"]) {
        return;
    }
    UIView *view = [[UIApplication sharedApplication].delegate window];
    if (!view) {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    CGFloat margin = 10;
    CGFloat labelMaxWidth = view.width - 4*margin;
    CGFloat textWidth = [message textSizeWithFont:hud.labelFont].width;
    if (textWidth < labelMaxWidth) {
        hud.userInteractionEnabled = NO;
        hud.mode = MBProgressHUDModeText;
        hud.labelText = message;
        hud.margin = margin;
        hud.minSize = CGSizeMake(200, 30);
        hud.removeFromSuperViewOnHide = YES;
    } else {
        hud.userInteractionEnabled = NO;
        hud.mode = MBProgressHUDModeCustomView;
        hud.removeFromSuperViewOnHide = YES;
        hud.margin = margin;
        CGFloat labelWidth = labelMaxWidth;
        CGSize textSize = [message textRectWithFont:hud.labelFont maxSize:CGSizeMake(labelWidth, CGFLOAT_MAX) mode:NSLineBreakByCharWrapping];
        UILabel *label = [UILabel leftAlignLabel];
        label.font = hud.labelFont;
        label.textColor = hud.labelColor;
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByCharWrapping;
        label.size = CGSizeMake(labelWidth, MIN(view.height-4*margin, textSize.height));
        label.text = message;
        
        hud.customView = label;
    }
    [hud hide:YES afterDelay:2.f];
}

+ (void)showMessage:(NSString *)message inView:(UIView *)view
{
    if ([message isEqualToString:@"系统出现异常!"] ||
        [message isEqualToString:@"系统出现异常！"]) {
        return;
    }
    if (!view) {
        view = [[UIApplication sharedApplication].delegate window];
    }
//    UIView *view = [[UIApplication sharedApplication] keyWindow];
    //    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    CGFloat margin = 10;
    CGFloat labelMaxWidth = view.width - 4*margin;
    CGFloat textWidth = [message textSizeWithFont:hud.labelFont].width;
    if (textWidth < labelMaxWidth) {
        hud.userInteractionEnabled = NO;
        hud.mode = MBProgressHUDModeText;
        hud.labelText = message;
        hud.margin = margin;
        hud.minSize = CGSizeMake(200, 30);
        hud.removeFromSuperViewOnHide = YES;
    } else {
        hud.userInteractionEnabled = NO;
        hud.mode = MBProgressHUDModeCustomView;
        hud.removeFromSuperViewOnHide = YES;
        hud.margin = margin;
        CGFloat labelWidth = labelMaxWidth;
        CGSize textSize = [message textRectWithFont:hud.labelFont maxSize:CGSizeMake(labelWidth, CGFLOAT_MAX) mode:NSLineBreakByCharWrapping];
        UILabel *label = [UILabel leftAlignLabel];
        label.font = hud.labelFont;
        label.textColor = hud.labelColor;
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByCharWrapping;
        label.size = CGSizeMake(labelWidth, MIN(view.height-4*margin, textSize.height));
        label.text = message;
        
        hud.customView = label;
    }
    [hud hide:YES afterDelay:2.f];
}

+ (void)showError:(NSError *)error
{
    [UIGlobal showError:error inView:nil];
}

+ (void)showError:(NSError *)error inView:(UIView *)view
{
    //        NSArray *strs = [[error localizedDescription] componentsSeparatedByString:@"。"];
    //        NSString *msg = [strs firstObject];
    //        if (msg.length == 0)
    //            msg = [NSString stringWithFormat:@"未知错误(%ld)", (long)error.code];
    //        return [UIGlobal showMessage:msg];
    if (!view) {
        view = RKAppDelegate.window;
    }
    NSDictionary * userInfo = [NSDictionary checkDictionary:error.userInfo];
    NSString * flag = userInfo[KXBSessionExpired];
    if (flag && [flag integerValue] == 1) {
//        [UIGlobal showAlertWithTitle:@"温馨提示" message:[NSString checkString:error.localizedDescription] customizationBlock:^(DLAVAlertView *alertView) {
//            
//        } completionBlock:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
//            
//        } cancelButtonTitle:@"确定" otherButtonTitles:nil];
    }
    else if ([NetworkClient isCustomErrorFromServer:error])
    {
        [[UIApplication sharedApplication] resignFirstResponder];
        return [UIGlobal showMessage:[error localizedDescription] inView:view];
    }
    else
    {
        if ([error code] == NSURLErrorCancelled)
        {
            //取消网络请求
            return;
        }
        else if ([error code] == NSURLErrorTimedOut)
        {
            [[UIApplication sharedApplication] resignFirstResponder];
            return [UIGlobal showMessage:HPTextForKey(@"请求超时") inView:view];
        }
        else
        {
            [[UIApplication sharedApplication] resignFirstResponder];
            return [UIGlobal showMessage:HPTextForKey(@"网络不给力，请检查网络！") inView:view];
        }
    }
}


+ (MBProgressHUD*)showHudForView:(UIView *)view animated:(BOOL)animated
{
//    return [UIGlobal showHudForView:view tip:@"正在努力加载中..." animated:YES];
    return [MBProgressHUD showHUDAddedTo:view animated:animated];
}

+ (MBProgressHUD *)showHudForView:(UIView *)view tip:(NSString *)tip animated:(BOOL)animated
{
    return [UIGlobal showHudForView:view tip:tip backgroundColor:[UIColor clearColor] animated:animated];
}

+ (MBProgressHUD *)showHudForView:(UIView *)view tip:(NSString *)tip backgroundColor:(UIColor *)backgroundColor animated:(BOOL)animated
{
    return [UIGlobal showHudForView:view tip:tip backgroundColor:backgroundColor textColor:HPColorForKey(@"#989898") animated:animated];
}

+ (MBProgressHUD *)showHudForView:(UIView *)view tip:(NSString *)tip backgroundColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor animated:(BOOL)animated
{
    animated = YES;
    if (!view)
        return nil;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.animationType = MBProgressHUDAnimationZoom;
    
    NSMutableArray * frames = [NSMutableArray array];
    for (int i = 1; i <= 20; i ++) {
        NSString * name = [NSString stringWithFormat:@"%03d",i];
        UIImage * image = [UIImage imageNamed:name];
        [frames addObject:image];
    }
    UIImageView * imageView = [[UIImageView alloc]initWithImage:[frames firstObject]];
    imageView.animationImages = (NSArray *)frames;
    imageView.animationDuration = frames.count*0.1f;;
    [imageView startAnimating];
    UIView * background = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 115, 115)];
    [background addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90, 90));
        make.centerX.mas_equalTo(background);
        make.top.mas_equalTo(background);
    }];
    UILabel * tipLabel = [UILabel centerAlignLabel];
    tipLabel.textColor = textColor;
    tipLabel.font = MainFontSize(14);
    tipLabel.text = tip;//@"正在努力加载中...";
    [background addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(background);
        make.bottom.mas_equalTo(background);
    }];
    hud.color = backgroundColor; //HPColorForKey(@"#eef1f4");
    hud.customView = background;
    return hud;
}

+ (MBProgressHUD *)showActivityHudForView:(UIView *)view
{
    MBProgressHUD * hud = [UIGlobal showHudForView:view animated:YES];
    hud.color = [UIColor clearColor];
    return hud;
}

+(void)showTip:(NSString *)tip inView:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = tip;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:3];
}

+(MBProgressHUD *)showHUDTip:(NSString *)tip inView:(UIView *)view
{
    if (!view) {
        return nil;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = tip;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

+ (MBProgressHUD *)showHudForView:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.animationType = MBProgressHUDAnimationZoom;
    
    return hud;
}

+ (void)hideHudForView:(UIView *)view animated:(BOOL)animated
{
    animated = NO;
    if (view)
        [MBProgressHUD hideHUDForView:view animated:animated];
}

+ (MBProgressHUD *)showLogoHUDForView:(UIView *)view
{
    if (!view)
        return nil;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.animationType = MBProgressHUDAnimationZoom;
    UIActivityIndicatorView * indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicatorView startAnimating];
    hud.bezelView.color = [UIColor clearColor];
    hud.customView = indicatorView;
    return hud;
}

@end

@implementation UIGlobal(helper)

+ (void)setupDefaultAlertViewTheme
{
    DLAVAlertViewTheme *theme = [DLAVAlertViewTheme defaultTheme];
    
    theme.backgroundColor = [UIColor whiteColor];
    theme.titleColor = HPColorForKey(@"#000000");
    theme.messageColor = HPColorForKey(@"text.major");
    theme.titleFont = HPBoldFontWithSize(18);
    theme.messageFont = HPFontWithSize(17);
    theme.messageAlignment = NSTextAlignmentCenter;
    theme.lineWidth = HPLineHeight;
    theme.lineColor = HPColorForKey(@"separator");
    theme.contentViewMargins = DLAVTextControlMarginsMake(0,0,0,0);
    theme.titleMargins = DLAVTextControlMarginsMake(20,20,25,25);
    theme.messageMargins = DLAVTextControlMarginsMake(0,20,30,30);

    DLAVAlertViewButtonTheme * buttonTheme = [DLAVAlertViewButtonTheme theme];
    buttonTheme.font = HPFontWithSize(16);
    buttonTheme.textColor = HPColorForKey(@"#FFA13F");
    theme.buttonTheme = buttonTheme;
    
    DLAVAlertViewButtonTheme * otherButtonTheme = [DLAVAlertViewButtonTheme theme];
    otherButtonTheme.textColor = HPColorForKey(@"#343434");
    otherButtonTheme.font = HPFontWithSize(16);
    theme.otherButtonTheme = otherButtonTheme;

//    DLAVAlertViewButtonTheme * primaryButtonTheme = [DLAVAlertViewButtonTheme theme];
//    primaryButtonTheme.textColor = HPColorForKey(@"#40affe");
//    primaryButtonTheme.font = HPFontWithSize(16);
//    theme.primaryButtonTheme = primaryButtonTheme;

    
    [DLAVAlertViewTheme setDefaultTheme:theme];
}

+ (void)callService
{
    [UIGlobal callAlertWithPhone:@"" title:@"现在是否拨打客服电话"];
}

+ (void)callAlertWithPhone:(NSString *)phone title:(NSString *)title
{
    DLAVAlertView *alertView = [[DLAVAlertView alloc] initWithTitle:title message:phone delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
    alertView.minContentWidth = AdaptedWidthValue(280);
    DLAVAlertViewTheme *theme = [DLAVAlertViewTheme defaultTheme];
    theme.backgroundColor = [UIColor whiteColor];
    theme.titleColor = HPColorForKey(@"text.major");
    theme.messageColor = HPColorForKey(@"text.green");
    theme.titleFont = HPBoldFontWithSize(17);
    theme.messageFont = HPFontWithSize(20);
    theme.messageAlignment = NSTextAlignmentCenter;
    theme.lineWidth = HPLineHeight;
    theme.lineColor = HPColorForKey(@"separator");
    DLAVAlertViewButtonTheme * buttonTheme = [DLAVAlertViewButtonTheme theme];
    buttonTheme.textColor = HPColorForKey(@"text.major");
    buttonTheme.font = HPFontWithSize(17);
    [alertView setCustomButtonTheme:buttonTheme forButtonAtIndex:0];
    [alertView setCustomButtonTheme:buttonTheme forButtonAtIndex:1];
    [alertView applyTheme:theme];
    
    [alertView showWithCompletion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [OpenURLManager promptCallTelephoneWithNumber:phone];
            });
        }
    }];
}

+ (UIColor *)defaultBackgroundColor
{
    return [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
}

+(BOOL)showCameraAuthAlertIfNeed
{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        [UIGlobal showAlertWithTitle:@"无法使用相机" message:@"请在“设置-隐私-相机”中允许访问相机。" customizationBlock:NULL completionBlock:NULL cancelButtonTitle:@"确定" otherButtonTitles:nil];
        return YES;
    }
    return NO;
}

+(void)showErrorWithSMSSKDError:(NSError *)error
{
    if (error) {
        if (error.code == 300477) {
            [UIGlobal showMessage:@"当前手机号发送短信的数量超过限额"];
        }else if (error.code == 300466){
            [UIGlobal showMessage:@"校验的验证码为空"];
        }else if (error.code == 300457){
            [UIGlobal showMessage:@"手机号码格式错误"];
        }else if (error.code == 300458){
            [UIGlobal showMessage:@"手机号码在黑名单中"];
        }else if (error.code == 300400){
            [UIGlobal showMessage:@"无效请求"];
        }else if (error.code == 300455){
            [UIGlobal showMessage:@"签名无效"];
        }else if (error.code == 300456){
            [UIGlobal showMessage:@"手机号码为空"];
        }else if (error.code == 300460){
            [UIGlobal showMessage:@"无权限发送短信"];
        }else if (error.code == 300462){
            [UIGlobal showMessage:@"每分钟发送次数超限"];
        }else if (error.code == 300463){
            [UIGlobal showMessage:@"手机号码每天发送次数超限"];
        }else if (error.code == 300465){
            [UIGlobal showMessage:@"号码在App中每天发送短信的次数超限"];
        }else if (error.code == 300467){
            [UIGlobal showMessage:@"校验验证码请求频繁"];
        }else if (error.code == 300463){
            [UIGlobal showMessage:@"手机号码每天发送次数超限"];
        }else if (error.code == 300468){
            [UIGlobal showMessage:@"需要校验的验证码错误"];
        }else if (error.code == 300472){
            [UIGlobal showMessage:@"客户端请求发送短信验证过于频繁"];
        }else if (error.code == 300476){
            [UIGlobal showMessage:@"当前appkey发送短信的数量超过限额"];
        }else{
            [UIGlobal showMessage:error.localizedDescription];
        }
    }
}

+ (void)showChooseMapSheetWithAddress:(NSString *)address inViewController:(UIViewController *)viewController
{
    int mapCount = 1;
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"请选择地图" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * appleMapAction = [UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [OpenURLManager openIOSAmapSystemWithAddress:[NSString checkString:address]];
    }];
    [alertController addAction:appleMapAction];
    
    if ([OpenURLManager canOpenBaiduMap]) {
        mapCount ++;
        UIAlertAction *baiduMapAction = [UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [OpenURLManager openBaiduMapWithAddress:[NSString checkString:address]];
        }];
        [alertController addAction:baiduMapAction];
    }
    if ([OpenURLManager canOpenIOSAmapMap]) {
        mapCount ++;
        UIAlertAction *baiduMapAction = [UIAlertAction actionWithTitle:@"高德德图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [OpenURLManager openIOSAmapMapWithAddress:[NSString checkString:address]];
        }];
        [alertController addAction:baiduMapAction];
    }
    if (mapCount==1) {
//        UIAlertAction *webMapAction = [UIAlertAction actionWithTitle:@"网页地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            BaseWebViewController * vc = [[BaseWebViewController alloc]init];
//            vc.address = [SERVER_IP_FOR_MALL stringByAppendingString:[NSString stringWithFormat:@"/wxweb/index.php?act=map&op=index&addr=%@&type=app",address]];
//            [viewController.navigationController pushViewController:vc animated:YES];
//        }];
//        [alertController addAction:webMapAction];
    }
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:cancelAction];
    [viewController presentViewController:alertController animated:YES completion:^{
        
    }];
}


@end
