//
//  NetworkClient.m
//
//  Created by rk on 14-10-6.
//
//

#import "NetworkClient.h"
#import "AFHTTPRequestOperationLogger.h"
#import "RKUUID.h"
#import "HPJSONResponseSerializer.h"
#import "NSString+ChineseEncode.h"

typedef enum : NSUInteger {
    RKBaseLibsURLTypeNormal,
    RKBaseLibsURLTypeImage,
    RKBaseLibsURLTypeVideo,
}RKBaseLibsURLType;

NSString *const KHPNetworkCustomErrorDomain = @"com.RKBaseLibs.networkService.error";
NSString *const kSkipLocalErrorHandle = @"skipLocalErrorHandle";
NSString *const KXBSessionExpired   = @"sessionExpired";
@interface NetworkClient ()

@end

@implementation NetworkClient

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static NetworkClient *shared = nil;
    dispatch_once(&onceToken, ^{
#ifdef DEBUG
        [[AFHTTPRequestOperationLogger sharedLogger] setLevel:AFLoggerLevelDebug];
        [[AFHTTPRequestOperationLogger sharedLogger] startLogging];
#endif
        shared = [[NetworkClient alloc] init];
        shared.hasNet = YES;
        [shared resetTimeInterval];
    });
    return shared;
}

- (void)initHosts;
{
    //需要在Preprocessor Macros 的debug 和 release 模式增加 TARGET_RKBaseLibs=1
   #ifdef TARGET_RKBaseLibs
       JPushAppKey = @"";
       #ifdef DEBUG
           SERVER_IP = @"";
       #else
           SERVER_IP = @"";
       #endif
   #endif
}

- (AFHTTPRequestOperationManager*)httpManagerWithHost:(NSString*)host port:(NSString*)port
{
    AFHTTPRequestOperationManager *manager = nil;
    if (!host)
        return manager;
    NSString *url = nil;
    if (!port)
        url = [NSString stringWithFormat:@"%@", host];
    else
        url = [NSString stringWithFormat:@"%@:%@", host, port];
    if (![url hasPrefix:@"http"])
        url = [NSString stringWithFormat:@"http://%@", url];
    manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:url]];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:[NSBundle mainBundle].bundleIdentifier forHTTPHeaderField:@"bundleId"];
    //设置缓存策略
//    requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    [manager setRequestSerializer:requestSerializer];
    AFJSONResponseSerializer *responseSerializer = [HPJSONResponseSerializer serializer];
    [manager setResponseSerializer:responseSerializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",
                                                         @"text/html",
                                                         @"text/json",
                                                         @"application/json",
                                                         @"application/json;charset=utf-8", nil];
    return manager;
}

- (void)sessionExpired:(NSDictionary *)userInfo
{
    [self.httpManager.operationQueue cancelAllOperations];
//    if ([[XBSession current] establish])
//    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:kHPNotificationClientSessionExpired object:nil userInfo:userInfo];
//    }
}

+ (NSURL *)urlForString:(NSString *)string
{
     return [[self class] urlForString:string withType:RKBaseLibsURLTypeNormal];
}

+ (NSURL *)imageUrlForString:(NSString *)string
{
    return [[self class] urlForString:string withType:RKBaseLibsURLTypeImage];
}

+ (NSURL *)videoUrlForString:(NSString *)string
{
   return [[self class] urlForString:string withType:RKBaseLibsURLTypeVideo];
}

+ (NSURL *)urlForString:(NSString *)string withType:(RKBaseLibsURLType)type
{
    NSString * ip = nil;
    if (type == RKBaseLibsURLTypeNormal) {
        ip = SERVER_IP;
    }else if (type == RKBaseLibsURLTypeImage){
        ip = IMAGE_SERVER_IP;
    }else if (type == RKBaseLibsURLTypeVideo){
        ip = VIDEO_SERVER_IP;
    }
    
   if (![string isKindOfClass:[NSString class]] || string == nil)
      {
          return nil;
      }
      BOOL isFileURL = [[HPFileManager shareManager] isLocalCacheFilePath:string];
      if (isFileURL) {
          return [NSURL URLWithString:string];
      }
      string = [string stringByReplacingOccurrencesOfString:@"\\u003d" withString:@"="];
      if (![string hasPrefix:@"http"] && ![string hasPrefix:@"rtmp"]) {
          NSArray *array = [[string componentsSeparatedByString:@"/"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.length > 0"]];
          string = [array componentsJoinedByString:@"/"];
          string = [string chineseEncoded];
          
          NSString * base = @"";
              if (![ip hasSuffix:@"/"]) {
                  base = [ip stringByAppendingString:@"/"];
              }else{
                  base = ip;
              }
              return [NSURL URLWithString:[base stringByAppendingString:string]];
      }
      NSURL *url = [NSURL URLWithString:[string chineseEncoded]];
      return url;
}

- (NSString *)signWithParams:(NSArray *)params
{
     __block NSString * string = @"";
    [params enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * key = [[obj allKeys] firstObject];
        NSString * value = obj[key];
        string = [string stringByAppendingString:[key stringByAppendingFormat:@"=%@",value]];

    }];
    return [string md5Hash];
}

- (NSError*)errorForResponse:(HPResponseEntity*)responseObject
{
//    NSInteger code = [responseObject.code integerValue];
    NSString *errStr = responseObject.msg;
    NSString * status = [NSString checkString:responseObject.status];
    
    if (errStr.length == 0)
        errStr = [NSString stringWithFormat:@"未知错误%ld", (long)status.integerValue];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setValue:errStr forKey:NSLocalizedDescriptionKey];
    if (responseObject) {
        [userInfo setValue:responseObject.result forKey:@"result"];
    }
    NSError *error = [[NSError alloc] initWithDomain:KHPNetworkCustomErrorDomain code:status.intValue userInfo:userInfo];
    return error;
}

- (void)systemMaintaining
{
    [self.httpManager.operationQueue cancelAllOperations];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kHPNotificationSystemMaintaining object:nil userInfo:nil];
}

- (BOOL)shouldForwardError:(NSError*)error
{
    NSDictionary *userInfo = [error userInfo];
    if (error && [userInfo valueForKey:kSkipLocalErrorHandle] && [[userInfo valueForKey:kSkipLocalErrorHandle] boolValue])
        return NO;
    return YES;
}

- (BOOL)isCustomErrorFromServer:(NSError*)error
{
    return [error.domain isEqualToString:KHPNetworkCustomErrorDomain];
}

- (id)resultForResponse:(HPResponseEntity*)responseObject
{
    return responseObject.result;
}

- (BOOL)isSuccessResponse:(HPResponseEntity*)responseObject
{
    if (responseObject && [[NSString checkString:responseObject.status] isEqualToString:@"200"]) {
        return YES;
    }
    return NO;
}

- (NSString *)queryStatementWithConditions:(NSDictionary *)conditions
{
    NSArray *keys = [conditions allKeys];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:keys.count];
    [keys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [array addObject:[NSString stringWithFormat:@"%@=%@", obj, conditions[obj]]];
    }];
    return [array componentsJoinedByString:@"&"];
}

- (void)setHeaderField
{
//    NSString * token = [NSString checkString:[XBUser current].token];
//    [[NetworkClient sharedInstance]setHeaderFieldWithDic:@{@"token":token}];
//    NSString * token_refresh = [NSString checkString:[XBUser current].token_refresh];
//    [[NetworkClient sharedInstance]setHeaderFieldWithDic:@{@"token_refresh":token_refresh}];
//    [[NetworkClient sharedInstance]setHeaderFieldWithDic:@{@"imei":[RKUUID getUsableDeviceID]}];
//    [[NetworkClient sharedInstance]setHeaderFieldWithDic:@{@"imeiType":@"ios"}];
}

- (void)setHeaderFieldWithDic:(NSDictionary <NSString * ,NSString *>*)dic
{
    AFHTTPRequestOperationManager *manager = self.httpManager;
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
        [manager.requestSerializer setValue:obj forHTTPHeaderField:key];//ios
    }];
}

- (NSMutableDictionary*)commonParamsWithMethod:(NSString*)method
{
    return nil;
}

- (NSMutableDictionary*)commonParamsWithMethod:(NSString*)method path:(NSString *)path params:(id)params
{
    return params;
}

- (NSURLSessionDownloadTask *)sessionDownloadWithUrl:(NSURL *)url success:(void (^)(NSURL *fileURL))success failure:(void (^)(NSError *error))failure
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    manager.responseSerializer = [HPJSONResponseSerializer new];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        // 将下载文件保存在缓存路径中
        NSArray * voiceFileExtensions = @[@"aac",@"mp3",@"arm"];
        NSURL * fileURL = nil;
        if ([voiceFileExtensions containsObject:response.URL.pathExtension]) {
            fileURL = [[HPFileManager shareManager] voiceFileUrlWithFileName:response.URL.lastPathComponent];
        }else{
            fileURL = [[HPFileManager shareManager] attachFileUrlWithFileName:response.URL.lastPathComponent];
        }
        return fileURL;
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (error) {
            if (failure)
            {
                failure(error);
            }
        }
        else
        {
            if (success) {
                success(filePath);
            }
        }
    }];
    
    [task resume];
    return task;
}

+(void)setServerHost:(NSString *)host
{
    SERVER_IP = host;
}
+(void)setImageHost:(NSString *)host
{
    IMAGE_SERVER_IP = host;
}
+ (void)setVideoHost:(NSString *)host
{
    VIDEO_SERVER_IP = host;
}

- (AFHTTPRequestOperationManager *)httpManager
{
    if (!_httpManager)
    {
        NSString *host = SERVER_IP;
        NSString *port = nil;
        _httpManager = [self httpManagerWithHost:host port:port];
    }
    return _httpManager;
}

#pragma mark public

- (void)checkNetworkStatus:(void(^)(bool has))hasNet once:(BOOL)once
{
    //创建网络监听对象
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //开始监听
    [manager startMonitoring];
    //监听改变
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            case AFNetworkReachabilityStatusNotReachable:
                [NetworkClient sharedInstance].hasNet = NO;
                hasNet(NO);
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [NetworkClient sharedInstance].hasNet = YES;
                hasNet(YES);
                break;
        }
    }];
    if (once) {
        //结束监听
        [manager stopMonitoring];
    }
}
- (void)resetTimeInterval
{
    self.timeInterval = 0;
}
/*
 解析获取服务器与本地时间差
 每次获取本地与服务器的时差都取绝值小的，请求接口越多次就越准
 */
- (void)analysisServerDateTimeWithResponse:(NSHTTPURLResponse *)response
{
    NSDictionary *allHeaders = response.allHeaderFields;
    NSString * dateServer = [NSString checkString:allHeaders[@"Date"]];
    NSDate *inputDate = [NSDate dateFromInternetDateTimeString:dateServer formatHint:DateFormatHintRFC822];
    NSTimeInterval localTimeStamp = [NSDate date].timeIntervalSince1970;
    NSTimeInterval serverTimeStamp = inputDate.timeIntervalSince1970;
    NSTimeInterval timeInterval = serverTimeStamp-localTimeStamp;
//    NSString * str = [NSString stringWithFormat:@"服务器时间：%.0f000\n本地时间：%.0f000\n时间差：%.0f000",serverTimeStamp,localTimeStamp,timeInterval];
//    [UIGlobal showAlertWithTitle:@"时间戳" message:str customizationBlock:NULL completionBlock:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
//    } cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    if (self.timeInterval == 0) {
        self.timeInterval = timeInterval;
    }else{
        
        NSTimeInterval minInterval = MIN(ABS(self.timeInterval),ABS(timeInterval));
        if (minInterval == ABS(timeInterval)) {
            self.timeInterval = timeInterval;
        }
    }
#ifdef DEBUG
//    [NetworkClient getCurrentServerDate];
#endif
}

//获取当前服务器时间
- (NSDate *)getCurrentServerDate
{
    NSDate * date = [NSDate dateWithTimeIntervalSinceNow:[NetworkClient sharedInstance].timeInterval];
    NSLog(@"\n当前服务器时间 ：%@\n 当前本地时间 ：%@",[DateTool rk_formatDateWithFormat:@"yyyy-MM-dd HH:mm:ss" timesp:date.timeIntervalSince1970],[DateTool rk_formatDateWithFormat:@"yyyy-MM-dd HH:mm:ss" timesp:[NSDate date].timeIntervalSince1970]);
    
    return date;
}

- (AFHTTPRequestOperation *)getWithPath:(NSString *)path params:(id)params success:(HPSuccess)success failure:(HPFailure)failure
{
    AFHTTPRequestOperationManager *manager = self.httpManager;
    [self setHeaderField];
    if ([path hasPrefix:@"/"]) {
        path = [path substringFromIndex:1];
    }
    NSDictionary *temp = [NSDictionary checkDictionary:params];
    [self commonParamsWithMethod:@"GET" path:path params:params];
    WQLogInf(@"path : %@\nparams : %@",path,params);
    AFHTTPRequestOperation *op = [manager GET:path parameters:temp success:^(AFHTTPRequestOperation *operation, id responseObject) {
        WQLogInf(@"responseObject : %@",responseObject);
        
        [self analysisServerDateTimeWithResponse:operation.response];
        HPResponseEntity *res = [MTLJSONAdapter modelOfClass:[HPResponseEntity class] fromJSONDictionary:responseObject error:nil];
        res.op = operation;
        if ([self isSuccessResponse:res]){
            if (success)
                success(res);
        }else{
//            NSString * status = [NSString checkString:res.status];
//            if (status.integerValue == 40101) {
//                //刷新token
//                if (self.tokenRefreshOperation) {
//                    return;
//                }
//               self.tokenRefreshOperation = [[NetworkClient sharedInstance] rawPostWithPath:MAPI_user_token_refresh params:nil success:^(HPResponseEntity * responseObject2) {
//                  //刷新成功重新调用此请求r
//                    NSDictionary * dic = [NSDictionary checkDictionary:responseObject2.op.response.allHeaderFields];
//                    [XBUser current].token = [NSString checkString:dic[@"token"]];
//                    [XBUser encodeCurrentUser];
//                    res.op = [self getWithPath:path params:temp success:success failure:failure];
//                   self.tokenRefreshOperation = nil;
//
//                } failure:^(NSError *error2) {
//                    //失败就是token过期
//                    HPResponseEntity * resp = [[HPResponseEntity alloc]init];
//                    resp.msg = @"登录过期，请重新登录";
//                    resp.status = @"40199";
//                    NSError *error = [self errorForResponse:resp];
//                    if (failure && [self shouldForwardError:error])
//                        failure(error);
//                    self.tokenRefreshOperation = nil;
//                }];
//            }else{
                NSError *error = [self errorForResponse:res];
                if (failure && [self shouldForwardError:error])
                    failure(error);
//            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure)
            failure(error);
    }];
    return op;
}

- (AFHTTPRequestOperation*)postWithPath:(NSString*)path params:(id)params success:(HPSuccess)success failure:(HPFailure)failure
{
    AFHTTPRequestOperationManager *manager = self.httpManager;
    [self setHeaderField];
    if ([path hasPrefix:@"/"]) {
        path = [path substringFromIndex:1];
    }
    
    NSMutableDictionary *temp = [self commonParamsWithMethod:@"POST" path:path params:params];
    AFHTTPRequestOperation *op = [manager POST:path parameters:temp success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self analysisServerDateTimeWithResponse:operation.response];
        HPResponseEntity *res = [MTLJSONAdapter modelOfClass:[HPResponseEntity class] fromJSONDictionary:responseObject error:nil];
        res.op = operation;
        if ([self isSuccessResponse:res]){
            if (success)
                success(res);
        }else{
            NSError *error = [self errorForResponse:res];
            if (failure && [self shouldForwardError:error])
                failure(error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure)
            failure(error);
    }];
    return op;
}

- (NSMutableDictionary *)parametersFromRequest:(HPRequest *)request {
    return [[request parameters]mutableCopy];
}

- (AFHTTPRequestOperation *)getWithPath:(NSString *)path request:(HPRequest *)request success:(HPSuccess)success failure:(HPFailure)failure {
    return [self getWithPath:path params:[self parametersFromRequest:request] success:success failure:failure];
}

- (AFHTTPRequestOperation *)postWithPath:(NSString *)path request:(HPRequest *)request success:(HPSuccess)success failure:(HPFailure)failure {
    return [self postWithPath:path params:[self parametersFromRequest:request] success:success failure:failure];
}

- (AFHTTPRequestOperation *)postWithPath:(NSString *)path bodyRequest:(HPBodyRequest *)request success:(HPSuccess)success failure:(HPFailure)failure {
    NSMutableDictionary *allParams = [self parametersFromRequest:request];
    // 设置超时时间
    [self.httpManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    self.httpManager.requestSerializer.timeoutInterval = 60.f;
    
    [self.httpManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [self setHeaderField];
    if ([path hasPrefix:@"/"]) {
        path = [path substringFromIndex:1];
    }
    NSMutableDictionary *temp = [self commonParamsWithMethod:@"POST" path:path params:allParams];
    AFHTTPRequestOperation *op = [self.httpManager POST:path parameters:temp constructingBodyWithBlock:request.block success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self analysisServerDateTimeWithResponse:operation.response];
        HPResponseEntity *res = [MTLJSONAdapter modelOfClass:[HPResponseEntity class] fromJSONDictionary:responseObject error:nil];
        if ([self isSuccessResponse:res]){
            if (success)
                success(res);
        }else{
            NSError *error = [self errorForResponse:res];
            if (failure && [self shouldForwardError:error])
                failure(error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure)
            failure(error);
    }];
    return op;
}

- (AFHTTPRequestOperation *)postForCustomResponseWithPath:(NSString *)path bodyRequest:(HPBodyRequest *)request success:(HPSuccess)success failure:(HPFailure)failure {
    NSMutableDictionary *allParams = [self parametersFromRequest:request];
    // 设置超时时间
    [self.httpManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    self.httpManager.requestSerializer.timeoutInterval = 60.f;
    [self.httpManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [self setHeaderField];
    if ([path hasPrefix:@"/"]) {
        path = [path substringFromIndex:1];
    }
    NSMutableDictionary *temp = [self commonParamsWithMethod:@"POST" path:path params:allParams];
    AFHTTPRequestOperation *op = [self.httpManager POST:path parameters:temp constructingBodyWithBlock:request.block success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success)
            success(responseObject);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure)
            failure(error);
    }];
    return op;
}


- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = self.httpManager;
    if ([URLString hasPrefix:@"/"]) {
        URLString = [URLString substringFromIndex:1];
    }
    NSMutableDictionary *temp = [self commonParamsWithMethod:@"GET" path:URLString params:parameters];
    [temp addEntriesFromDictionary:temp];
    AFHTTPRequestOperation *op = [manager GET:URLString parameters:temp success:success failure:failure];
    return op;
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = self.httpManager;
    if ([URLString hasPrefix:@"/"]) {
        URLString = [URLString substringFromIndex:1];
    }
    NSMutableDictionary *temp = [self commonParamsWithMethod:@"POST" path:URLString params:parameters];
    [temp addEntriesFromDictionary:temp];
    AFHTTPRequestOperation *op = [manager POST:URLString parameters:temp success:success failure:failure];
    return op;
}

#pragma mark - raw

- (AFHTTPRequestOperation*)rawPostWithPath:(NSString*)path params:(id)params success:(HPSuccess)success failure:(HPFailure)failure
{
    AFHTTPRequestOperationManager *manager = self.httpManager;
    [self setHeaderField];

    if ([path hasPrefix:@"/"]) {
        path = [path substringFromIndex:1];
    }
    
    NSMutableDictionary *temp = [self commonParamsWithMethod:@"POST" path:path params:params];
    NSError * error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:temp options:NSJSONWritingPrettyPrinted error:&error];
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:[NetworkClient urlForString:path].absoluteString parameters:nil error:nil];
    request.timeoutInterval= 15;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 设置body
    [request setHTTPBody:jsonData];

    AFHTTPRequestOperation *op = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nullable responseObject) {
        [self analysisServerDateTimeWithResponse:operation.response];

        
        HPResponseEntity *res = [MTLJSONAdapter modelOfClass:[HPResponseEntity class] fromJSONDictionary:responseObject error:nil];
        res.op = operation;
        if ([self isSuccessResponse:res]){
            if (success)
                success(res);
        }else{
            NSError *error = [self errorForResponse:res];
                if (failure && [self shouldForwardError:error])
                    failure(error);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (failure)
            failure(error);
    }];
    [op start];
    return op;
}

@end
