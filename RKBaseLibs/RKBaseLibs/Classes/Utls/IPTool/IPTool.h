//
//  IPTool.h
//  RKBaseLibs
//
//  Created by rk on 3/22/19.
//  Copyright © 2019 rk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IPTool : NSObject

+ (instancetype)shareInstance;

@property (copy,nonatomic) NSString * errorIp;
@property (copy,nonatomic) NSString * currentIp;
//局域网ip
+ (NSString*)getCurentLocalIP;

+(void)getDeviceIPAddressesWithSuccess:(HPSuccess)success failure:(HPFailure)failure;

@end

NS_ASSUME_NONNULL_END
