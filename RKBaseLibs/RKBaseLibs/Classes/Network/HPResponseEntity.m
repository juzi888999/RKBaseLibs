//
//  HPResponseEntity.m
//  RKBaseLibs
//
//  Created by mac on 15/4/16.
//  Copyright (c) 2015年 haixiaedu. All rights reserved.
//

#import "HPResponseEntity.h"
#import <GTMBase64/GTMBase64.h>

@implementation HPResponseHeadEntity

@end

@implementation HPResponseEntity

+ (NSValueTransformer *)headJSONTransformer {
    return [MTLValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[HPResponseHeadEntity class]];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"result":@"data",
             @"msg":@"message"
             };
}
//
//-(NSDictionary *)dataDic
//{
//    if (!self.data) {
//        return @{};
//    }
//    if (!_dataDic) {
//        NSString * dataStr = [NSString checkString:self.data];
//        NSData * data = [GTMBase64 decodeString:dataStr];
//        if (data) {
//            _dataDic = [NSDictionary checkDictionary:[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]];
//        }
////        NSLog(@"dataDic : %@",_dataDic);
//        WQLogInf(@"WQLog dataDic : %@",_dataDic);
//    }
//    return _dataDic;
//}

-(NSString *)status
{
    if (!_status) {    
        NSString * status = [NSDictionary checkDictionary:self.result][@"status"];
        _status = status;
    }
    return _status;
}

-(NSString *)code
{
    if (_code) {
        NSString * code = [NSString checkString:self.head.code];
        _code = code;
    }
    return _code;
}

@end
