//
//  CustomURLCache.h
//  RKBaseLibs
//
//  Created by rk on 2018/5/8.
//  Copyright © 2018年 juzi. All rights reserved.
//
// 只支持 GET 请求

#import <Foundation/Foundation.h>

@interface CustomURLCache : NSURLCache

+ (instancetype)standardURLCache;
@end

