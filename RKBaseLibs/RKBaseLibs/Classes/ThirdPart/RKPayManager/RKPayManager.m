//
//  RKPayManager.m
//  webview
//
//  Created by rk on 2017/8/18.
//  Copyright © 2017年 rk. All rights reserved.
//

#import "RKPayManager.h"
//#import <AlipaySDK/AlipaySDK.h>
//#import <WXApi.h>

@interface RKPayManager()///<WXApiDelegate>

@end
@implementation RKPayManager

+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    static RKPayManager *s = nil;
    dispatch_once(&onceToken, ^{
        s = [[RKPayManager alloc] init];
    });
    return s;
}

-(BOOL)handleOpenURL:(NSURL *)url options:(NSDictionary*)options
{
//    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
//    if ([url.host isEqualToString:@"safepay"]) {
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
//            NSLog(@"result = %@",resultDic);
//        }];
//    }
//    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
//
//        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
//            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
//            NSLog(@"result = %@",resultDic);
//        }];
//    }
//    if ([url.host isEqualToString:@"pay"] && [url.scheme isEqualToString:WeixinAppKey]) {
//      [WXApi handleOpenURL:url delegate:[RKPayManager shareManager]];
//    }
    return YES;
}
//
//#pragma mark - WXApiDelegate
//- (void)onResp:(BaseResp *)resp {
//     if([resp isKindOfClass:[PayResp class]]){
//        //支付返回结果，实际支付结果需要去微信服务器端查询
//         [[NSNotificationCenter defaultCenter] postNotificationName:kHPNotificationClientWeiXinPayCallBack object:resp];
//    }
//
//}
@end
