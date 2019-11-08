    //
//  HPJSONResponseSerializer.m
//  iweilai
//
//  Created by rk on 15/4/13.
//  Copyright (c) 2015年. All rights reserved.
//

#import "HPJSONResponseSerializer.h"
#import "NSString+URLEncoding.h"

@implementation HPJSONResponseSerializer

- (id)responseObjectForResponse:(NSHTTPURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing *)error
{
    //由于服务端 某些自定义报错返回code 500 所以为了处理并显示这些错误提示，强制把code 500 改成 200
//    NSUInteger statusCode = response.statusCode;
//    if (statusCode == 500) {
//        statusCode = 200;
//    }
//    NSHTTPURLResponse * newResponse = [[NSHTTPURLResponse alloc]initWithURL:response.URL statusCode:statusCode HTTPVersion:nil headerFields:response.allHeaderFields];
//    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
//    U+0000...U+001F
//    U+0022 U+005C
//    for (int i = 0x0000; i < 0x001F; i ++) {
//        NSString * str = [NSString stringWithFormat:@"\\u%.4u",i];
//        responseString = [responseString stringByReplacingOccurrencesOfString:str withString:@""];
//    }
//    if (responseString.length >10000) {
//        responseString = [responseString substringFromIndex:7980];
//        responseString = [responseString stringByReplacingOccurrencesOfString:@",u5c3d" withString:@",\\u5c3d"];
//    }
//    if ([responseString hasPrefix:@"%"] || [responseString hasPrefix:@"\"%"])
//    {
//        responseString = [responseString stringByReplacingOccurrencesOfString:@"+" withString:@" "];
//        responseString = [responseString URLDecodedString];
//    } else {
//        responseString = [responseString stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
//    }
//    if (responseString.length > 0 && ([responseString hasPrefix:@"|"] || [responseString hasPrefix:@"\""]))
////        responseString = [responseString substringFromIndex:1 toIndex:responseString.length-1];
//        responseString = [responseString substringFromIndex:1];
//    responseString = [responseString substringToIndex:responseString.length-1];
//    NSLog(@"json:%@", responseString);
//    NSData *newData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
//
    return [super responseObjectForResponse:response data:data error:error];
}

@end
