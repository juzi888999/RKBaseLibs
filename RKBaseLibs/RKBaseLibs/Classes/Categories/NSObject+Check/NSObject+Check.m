//
//  NSObject+Check.m
//  PaoFu
//
//  Created by rk on 14/12/8.
//  Copyright (c) 2014年 yons. All rights reserved.
//

#import "NSObject+Check.h"

@implementation NSObject (Check)

- (NSString *)checkString:(id)string
{
    if (string == nil)
    {
        return @"";
    }
    if ([string isKindOfClass:[NSString class]])
    {
        return string;
    }
    else
    {
        return @"";
    }
    
    return string;
}

- (NSArray *)checkArray:(id)obj
{
    if (obj == nil || ![obj isKindOfClass:[NSArray class]])
    {
        return [NSArray array];
    }
    return obj;
}

+ (NSArray *)checkArray:(id)obj
{
    if (obj == nil || ![obj isKindOfClass:[NSArray class]])
    {
        return [NSArray array];
    }
    return obj;
}

- (NSDictionary *)checkDictionary:(id)obj
{
    if (obj == nil || ![obj isKindOfClass:[NSDictionary class]])
    {
        return [NSDictionary dictionary];
    }
    return obj;
}

+ (NSDictionary *)checkDictionary:(id)obj
{
    if (obj == nil || ![obj isKindOfClass:[NSDictionary class]])
    {
        return [NSDictionary dictionary];
    }
    return obj;
}

- (id)checkOject:(id)obj
{
    if (obj == nil || [obj isKindOfClass:[NSNull class]])
    {
        obj = nil;
    }
    return obj;
}
+ (NSString *)checkString:(id)string
{
    if (string == nil)
    {
        return @"";
    }
    if ([string isKindOfClass:[NSString class]])
    {
        return string;
    }
    else if ([string isKindOfClass:[NSNumber class]])
    {
        return [string stringValue];
    }
    else
    {
        return @"";
    }
    
    return string;
}

+ (id)checkOject:(id)obj
{
    if (obj == nil || [obj isKindOfClass:[NSNull class]])
    {
        obj = nil;
    }
    return obj;
}


@end
