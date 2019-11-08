//
//  CustomURLCache.m
//  RKBaseLibs
//
//  Created by rk on 2018/5/8.
//  Copyright © 2018年 juzi. All rights reserved.
//

#import "CustomURLCache.h"

static NSString * const CustomURLCacheExpirationKey = @"CustomURLCacheExpiration";
static NSTimeInterval const CustomURLCacheExpirationInterval = 300;//默认有效期
static NSString * const CacheExpirationIntervalKey = @"CacheExpirationIntervalKey";//自定义有效期key
static NSString * const CacheUrlPathKey = @"CacheUrlPathKey";

@implementation CustomURLCache

+ (instancetype)standardURLCache {
    static CustomURLCache *_standardURLCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _standardURLCache = [[CustomURLCache alloc]
                             initWithMemoryCapacity:(2 * 1024 * 1024)
                             diskCapacity:(100 * 1024 * 1024)
                             diskPath:nil];
//        [NSURLCache setSharedURLCache:_standardURLCache];
    });
    return _standardURLCache;
}
                  
#pragma mark - NSURLCache

- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request {
 
    NSCachedURLResponse *cachedResponse = [super cachedResponseForRequest:request];
    NSDictionary * dic = [self isRequestNeedCached:request];
    if (dic) {
        
        NSLog(@"取缓存:%@",cachedResponse);
        if (cachedResponse) {
            NSDate* cacheDate = cachedResponse.userInfo[CustomURLCacheExpirationKey];
            NSDate* currentDate = [NSDate date];
            NSTimeInterval interval = CustomURLCacheExpirationInterval;
            NSString * customInserval = dic[CacheExpirationIntervalKey];
            if (customInserval) {
                interval = [customInserval longLongValue];
            }
            NSDate* cacheExpirationDate = [cacheDate dateByAddingTimeInterval:interval];
            if ([cacheExpirationDate compare:currentDate] == NSOrderedAscending) {
                [self removeCachedResponseForRequest:request];
                return nil;
            }
            return cachedResponse;
        }else{
            
        }
    }
    return nil;
}

- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse forRequest:(NSURLRequest *)request
{
    NSDictionary * dic = [self isRequestNeedCached:request];
    if (!dic) {
        return;
    }
    NSLog(@"存缓存:%@",request);

  NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:cachedResponse.userInfo];
  userInfo[CustomURLCacheExpirationKey] = [NSDate date];
 
  NSCachedURLResponse *modifiedCachedResponse = [[NSCachedURLResponse alloc] initWithResponse:cachedResponse.response data:cachedResponse.data userInfo:userInfo storagePolicy:cachedResponse.storagePolicy];
  
  [super storeCachedResponse:modifiedCachedResponse forRequest:request];
}

- (void)getCachedResponseForDataTask:(NSURLSessionDataTask *)dataTask
                   completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler
{
    NSDictionary * dic = [self isRequestNeedCached:dataTask.currentRequest];
    if (!dic) {
        return;
    }
    [super getCachedResponseForDataTask:dataTask completionHandler:completionHandler];
}

- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse
                forDataTask:(NSURLSessionDataTask *)dataTask{
    
    NSDictionary * dic = [self isRequestNeedCached:dataTask.currentRequest];
    if (!dic) {
        return;
    }
    [super storeCachedResponse:cachedResponse
                   forDataTask:dataTask];
}

- (NSDictionary *)isRequestNeedCached:(NSURLRequest *)request
{
//    if (!self.isMatching) {
//        return NO;
//    }
//    if ([request.URL.absoluteString containsString:XBApi_newPlay_getRuleAll]) {
//        return @{CacheExpirationIntervalKey:@"3600",CacheUrlPathKey:XBApi_newPlay_getRuleAll};
//    }
    return nil;
}
@end
