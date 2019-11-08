//
//  NetworkClient+RKBaseLibs.m
//  RKBaseLibs
//
//  Created by rk on 2019/11/8.
//  Copyright © 2019 rk. All rights reserved.
//
// 此category为示例，请自己重新封装网络请求 NetworkClient的category

#import "NetworkClient+RKBaseLibs.h"
#import "NSString+ChineseEncode.h"
#import "HPJSONResponseSerializer.h"

typedef enum : NSUInteger {
    RKBaseLibsURLTypeNormal,
    RKBaseLibsURLTypeImage,
    RKBaseLibsURLTypeVideo,
}RKBaseLibsURLType;

@implementation NetworkClient (RKBaseLibs)

+ (void)initHosts_RKBaseLibs;
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

+ (void)sessionExpired:(NSDictionary *)userInfo
{
    [[NetworkClient sharedInstance].httpManager.operationQueue cancelAllOperations];
//    if ([[XBSession current] establish])
//    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:kHPNotificationClientSessionExpired object:nil userInfo:userInfo];
//    }
}

+ (NSURL *)urlForString:(NSString *)string
{
     return [NetworkClient urlForString:string withType:RKBaseLibsURLTypeNormal];
}

+ (NSURL *)imageUrlForString:(NSString *)string
{
    return [NetworkClient urlForString:string withType:RKBaseLibsURLTypeNormal];
}

+ (NSURL *)videoUrlForString:(NSString *)string
{
   return [NetworkClient urlForString:string withType:RKBaseLibsURLTypeVideo];
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

+ (NSString *)signWithParams:(NSArray *)params
{
     __block NSString * string = @"";
    [params enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * key = [[obj allKeys] firstObject];
        NSString * value = obj[key];
        string = [string stringByAppendingString:[key stringByAppendingFormat:@"=%@",value]];

    }];
    return [string md5Hash];
}

+ (NSError*)errorForResponse:(HPResponseEntity*)responseObject
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

+ (BOOL)shouldForwardError:(NSError*)error
{
    NSDictionary *userInfo = [error userInfo];
    if (error && [userInfo valueForKey:kSkipLocalErrorHandle] && [[userInfo valueForKey:kSkipLocalErrorHandle] boolValue])
        return NO;
    return YES;
}

+ (BOOL)isCustomErrorFromServer:(NSError*)error
{
    return [error.domain isEqualToString:KHPNetworkCustomErrorDomain];
}

+ (id)resultForResponse:(HPResponseEntity*)responseObject
{
    return responseObject.result;
}

+ (BOOL)isSuccessResponse:(HPResponseEntity*)responseObject
{
    if (responseObject && [[NSString checkString:responseObject.status] isEqualToString:@"200"]) {
        return YES;
    }
    return NO;
}

+ (NSString *)queryStatementWithConditions:(NSDictionary *)conditions
{
    NSArray *keys = [conditions allKeys];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:keys.count];
    [keys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [array addObject:[NSString stringWithFormat:@"%@=%@", obj, conditions[obj]]];
    }];
    return [array componentsJoinedByString:@"&"];
}


+ (void)setHeaderField
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
    AFHTTPRequestOperationManager *manager = [NetworkClient sharedInstance].httpManager;
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
        [manager.requestSerializer setValue:obj forHTTPHeaderField:key];//ios
    }];
}

+ (NSMutableDictionary*)commonParamsWithMethod:(NSString*)method
{
    return nil;
}

+ (NSMutableDictionary*)commonParamsWithMethod:(NSString*)method path:(NSString *)path params:(id)params
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

@end
