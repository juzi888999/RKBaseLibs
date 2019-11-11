//
//  IPTool.m
//  RKBaseLibs
//
//  Created by rk on 3/22/19.
//  Copyright © 2019 rk. All rights reserved.
//

#import "IPTool.h"

#import <ifaddrs.h>
//#import <arpa/inet.h>

//IP地址需求库
#import <sys/socket.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>
#import <net/if.h>
#import <arpa/inet.h>

@interface IPTool()
{
}
@end
@implementation IPTool

static IPTool *_instance = nil;

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[IPTool alloc] init];
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


//获取内网ip
+ (NSString*)getCurentLocalIP{
    NSString*address =nil;
    struct ifaddrs*interfaces =NULL;
    struct ifaddrs*temp_addr =NULL;
    int success =0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if(success ==0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr !=NULL) {
//            NSLog(@"%d",temp_addr->ifa_addr->sa_family);
            if(temp_addr->ifa_addr->sa_family==AF_INET|| temp_addr->ifa_addr->sa_family==AF_INET6|| temp_addr->ifa_addr->sa_family==AF_LINK) {
                
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

-(void)setCurrentIp:(NSString *)currentIp
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSString checkString:currentIp] forKey:@"currentIp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _currentIp = currentIp;
}

+(void)getDeviceIPAddressesWithSuccess:(HPSuccess)success failure:(HPFailure)failure
{
    if ([IPTool shareInstance].errorIp) {
        if (success) {
            success([IPTool shareInstance].errorIp);
        }
        return;
    }
    NSString * currentIp = [[NSUserDefaults standardUserDefaults] stringForKey:@"currentIp"];
    if ([NSString checkString:[IPTool shareInstance].currentIp].length > 0) {
        if (success) {
            NSLog(@"内存 currentIp : %@",[IPTool shareInstance].currentIp);
            success([IPTool shareInstance].currentIp);
        }
        return;
    }else if([NSString checkString:currentIp].length > 0){
        if (success) {
            NSLog(@"NSUserDefaults currentIp : %@",currentIp);
            [IPTool shareInstance].currentIp = currentIp;
            success(currentIp);
        }
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            @try {
                NSURL *ipURL = [NSURL URLWithString:@"http://ip.taobao.com/service/getIpInfo.php?ip=myip"];
                NSData *data = [NSData dataWithContentsOfURL:ipURL];
                if (!data) {
                    NSString * currentIp = [[NSUserDefaults standardUserDefaults] stringForKey:@"currentIp"];
                    if([NSString checkString:currentIp].length == 0){
                        dispatch_async(dispatch_get_main_queue(), ^{
                                if (failure) {
                                    failure(nil);
                                }
                        });
                    }
                    return ;
                }
                NSError *error = nil;
                NSDictionary *ipDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                if (!error) {
                    NSString *ipStr = nil;
                    if (ipDic && [ipDic[@"code"] integerValue] == 0) { //获取成功
                        ipStr = ipDic[@"data"][@"ip"];
                    }
                    [IPTool shareInstance].currentIp = (ipStr ? ipStr : @"");
                    NSLog(@"重新获取 currentIp : %@",[IPTool shareInstance].currentIp);
                    NSString * currentIp = [IPTool shareInstance].currentIp;
                    if([NSString checkString:currentIp].length > 0){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (success) {
                                success([IPTool shareInstance].currentIp);
                            }
                        });
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (failure) {
                                failure(error);
                            }
                        });
                    }
                }else{
                    NSString * currentIp = [[NSUserDefaults standardUserDefaults] stringForKey:@"currentIp"];
                    if([NSString checkString:currentIp].length == 0){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (failure) {
                                failure(error);
                            }
                        });
                    }
                }
                
            } @finally {
               
            }
        }
    });
}

@end
