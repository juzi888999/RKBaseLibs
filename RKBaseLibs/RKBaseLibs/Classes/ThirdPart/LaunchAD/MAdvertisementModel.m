//
//  MAdvertisementModel.m
//  RKBaseLibs
//
//  Created by minimac on 2019/10/12.
//  Copyright © 2019 rk. All rights reserved.
//

#import "MAdvertisementModel.h"

@implementation RKAdvertisementEntity

@end

@implementation RKAdvertisementRequest

@end

@implementation RKAdvertisementModel

static RKAdvertisementModel *_instance = nil;

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[RKAdvertisementModel alloc] init];
        RKAdvertisementRequest * req = [[RKAdvertisementRequest alloc]init];
        req.location = @"7";
        _instance.request = req;
    });
    return _instance;
}

+ (void)destroyInstance
{
    _instance = nil;
}

- (void)dealloc {
    NSLog(@"%@:----释放了",NSStringFromSelector(_cmd));
}

-(NSString *)relativePath
{
    return @"";
}

-(Class)objectClass
{
    return [RKAdvertisementEntity class];
}

-(HPTableModelHttpMethod)httpMethod
{
    return HPTableModelHttpMethodGet;
}



@end
