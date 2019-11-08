//
//  NetworkClient+RKBaseLibs.h
//  RKBaseLibs
//
//  Created by rk. on 2019/11/8.
//  Copyright © 2019 rk. All rights reserved.
//
// 此category为示例，请自己重新封装网络请求 NetworkClient的category

#import "NetworkClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface NetworkClient (RKBaseLibs)

//初始化网络请求管理对象
- (AFHTTPRequestOperationManager*)httpManagerWithHost:(NSString*)host port:(NSString*)port;

//初始化接口域名ip，请在appdelegate didfinishlaunch 方法开头调用，
+ (void)initHosts_RKBaseLibs;

/*
 地址获取
 @param stirng 路径path
 */
+ (NSURL*)urlForString:(NSString*)string;
+ (NSURL*)imageUrlForString:(NSString*)string;
+ (NSURL *)videoUrlForString:(NSString *)string;

+ (void)sessionExpired:(NSDictionary *)userInfo;//登录失效的处理
+ (BOOL)isSuccessResponse:(HPResponseEntity*)responseObject;//判断网络请求是否成功的处理
+ (NSError*)errorForResponse:(HPResponseEntity*)responseObject;//判断失败的处理
+ (BOOL)shouldForwardError:(NSError*)error;//是否处理失败的处理
+ (BOOL)isCustomErrorFromServer:(NSError*)error;//判断是否是自定义的失败

+ (void)setHeaderField;//设置请求头
+ (NSString *)signWithParams:(NSArray *)params;//对参数进行签名的处理

+ (NSMutableDictionary*)commonParamsWithMethod:(NSString*)method;
+ (NSMutableDictionary*)commonParamsWithMethod:(NSString*)method path:(NSString *)path params:(id)params;
- (NSURLSessionDownloadTask *)sessionDownloadWithUrl:(NSURL *)url success:(void (^)(NSURL *fileURL))success failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
