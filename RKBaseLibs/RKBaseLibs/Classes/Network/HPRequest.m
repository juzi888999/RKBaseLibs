//
//  HPRequest.m
//  RKBaseLibs
//
//  Created by mac on 15/10/2.
//  Copyright © 2015年 haixiaedu. All rights reserved.
//

#import "HPRequest.h"

@implementation HPRequest

- (NSDictionary *)parameters {
    NSDictionary * params = [MTLJSONAdapter JSONDictionaryFromModel:self];
    return params;
}

//- (NSDictionary *)valueParameters {
//    NSDictionary * params = [MTLJSONAdapter JSONDictionaryFromModel:self];
//    NSMutableDictionary * temp = [NSMutableDictionary dictionary];
//    for (NSString * key in [params allKeys]) {
//        id value = params[key];
//        if ([value isMemberOfClass:[NSNull class]]) {
//            value = nil;
//        }
//        [temp setValue:value forKey:key];
//    }
//    return temp;
//}

- (NSDictionary *)parametersWithoutNull {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[MTLJSONAdapter JSONDictionaryFromModel:self]];
    NSMutableSet *set = [NSMutableSet set];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj == nil || obj == [NSNull null]) {
            [set addObject:key];
        }
    }];
    if (set.count > 0) {
        [dic removeObjectsForKeys:set.allObjects];
    }
    return dic;
}

@end

@implementation HPBodyRequest

- (NSDictionary *)parameters {
    NSDictionary * params = [MTLJSONAdapter JSONDictionaryFromModel:self];
    [params setValue:nil forKey:@"block"];
    return params;
}

@end

@implementation HPPageRequest

-(instancetype)init{
    if (self = [super init]) {
        self.pageNo = @"1";
        self.pageSize = @"10";
    }
    return self;
}
@end
