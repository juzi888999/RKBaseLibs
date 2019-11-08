//
//  PushMessageManager.m
//  xubo 
//
//  Created by rk on 2019/2/12.
//  Copyright © 2019年 rk. All rights reserved.
//

#import "PushMessageManager.h"

@implementation PushMessageManager

static PushMessageManager *_instance = nil;

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[PushMessageManager alloc] init];
    });
    return _instance;
}

+ (void)destroyInstance
{
    _instance = nil;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (void)dealloc {
    NSLog(@"%@:----释放了",NSStringFromSelector(_cmd));
}



@end
