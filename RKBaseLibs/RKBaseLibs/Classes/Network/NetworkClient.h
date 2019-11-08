//
//  NetworkClient.h
//
//  Created by rk on 14-10-6.
//
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIKit+AFNetworking.h>
#import "HPResponseEntity.h"
#import "HPRequest.h"
#import "XBNetworkDefines.h"

extern NSString *const KHPNetworkCustomErrorDomain;
extern NSString *const kSkipLocalErrorHandle;
extern NSString *const KXBSessionExpired;

typedef  void ((^HPSuccess)(id responseObject));
typedef  void ((^HPFailure)(NSError *error));

@interface NetworkClient : NSObject

@property (assign,nonatomic) BOOL hasNet;//是否有网络
/*
 监听网络状态
 @param once 是否监听到状态马上停止监听
 */
+ (void)checkNetworkStatus:(void(^)(bool has))hasNet once:(BOOL)once;

@property (nonatomic, strong) AFHTTPRequestOperationManager *httpManager;

+ (instancetype)sharedInstance;

+ (void)setServerHost:(NSString *)host;
+ (void)setImageHost:(NSString *)host;
+ (void)setVideoHost:(NSString *)host;

#pragma mark - 服务器时间与时间差

//解析获取服务器与本地时间差
+ (void)analysisServerDateTimeWithResponse:(NSHTTPURLResponse *)response;
//调用方法analysisServerDateTimeWithResponse 之后再使用 getCurrentServerDate 才能获取准确的服务器时间，否则获取到的是本地时间
+ (NSDate *)getCurrentServerDate;
@property (assign,nonatomic) NSTimeInterval timeInterval;//服务器时间戳 - 本地时间戳
- (void)resetTimeInterval;

#pragma mark -

- (AFHTTPRequestOperation*)getWithPath:(NSString*)path params:(id)params success:(HPSuccess)success failure:(HPFailure)failure;
- (AFHTTPRequestOperation*)postWithPath:(NSString*)path params:(id)params success:(HPSuccess)success failure:(HPFailure)failure;
- (AFHTTPRequestOperation*)rawPostWithPath:(NSString*)path params:(id)params success:(HPSuccess)success failure:(HPFailure)failure;
- (AFHTTPRequestOperation*)getWithPath:(NSString*)path request:(HPRequest *)request success:(HPSuccess)success failure:(HPFailure)failure;
- (AFHTTPRequestOperation*)postWithPath:(NSString*)path request:(HPRequest *)request success:(HPSuccess)success failure:(HPFailure)failure;
- (AFHTTPRequestOperation *)postWithPath:(NSString *)path bodyRequest:(HPBodyRequest *)request success:(HPSuccess)success failure:(HPFailure)failure;

- (AFHTTPRequestOperation *)postForCustomResponseWithPath:(NSString *)path bodyRequest:(HPBodyRequest *)request success:(HPSuccess)success failure:(HPFailure)failure;


- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;



@end
