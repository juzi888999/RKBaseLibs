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

//具体方法：
//获取设备IP地址
//+(NSString *)getDeviceIPAddresses
//{
//    int sockfd = socket(AF_INET,SOCK_DGRAM, 0);
//    if (sockfd == 0) return nil; //这句报错，由于转载的，不太懂，注释掉无影响，懂的大神欢迎指导
//    NSMutableArray *ips = [NSMutableArray array];
//    
//    int BUFFERSIZE =4096;
//    
//    struct ifconf ifc;
//    
//    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
//    
//    struct ifreq *ifr, ifrcopy;
//    
//    ifc.ifc_len = BUFFERSIZE;
//    
//    ifc.ifc_buf = buffer;
//    
//    if (ioctl(sockfd,SIOCGIFCONF, &ifc) >= 0){
//        
//        for (ptr = buffer; ptr < buffer + ifc.ifc_len; ){
//            
//            ifr = (struct ifreq *)ptr;
//            
//            int len =sizeof(struct sockaddr);
//            
//            if (ifr->ifr_addr.sa_len > len) {
//                len = ifr->ifr_addr.sa_len;
//            }
//            
//            ptr += sizeof(ifr->ifr_name) + len;
//            
//            if (ifr->ifr_addr.sa_family !=AF_INET) continue;
//            
//            if ((cptr = (char *)strchr(ifr->ifr_name,':')) != NULL) *cptr =0;
//            
//            if (strncmp(lastname, ifr->ifr_name,IFNAMSIZ) == 0)continue;
//            
//            memcpy(lastname, ifr->ifr_name,IFNAMSIZ);
//            
//            ifrcopy = *ifr;
//            
//            ioctl(sockfd,SIOCGIFFLAGS, &ifrcopy);
//            
//            if ((ifrcopy.ifr_flags &IFF_UP) == 0)continue;
//            
//            NSString *ip = [NSString stringWithFormat:@"%s",inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
//            [ips addObject:ip];
//        }
//    }
//    close(sockfd);
//    
//    NSString *deviceIP =@"";
//    
//    for (int i=0; i < ips.count; i++){
//        if (ips.count >0){
//            deviceIP = [NSString stringWithFormat:@"%@",ips.lastObject];
//        }
//    }
//    
//    return deviceIP;
//}

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
               
                //                [self performSelectorOnMainThread:@selector(getDeviceIPAddresses) withObject:nil waitUntilDone:NO];
            }
        }
    });
}
//
//+ (void)getDeviceIPAddressWithSuccess:(HPSuccess)success failure:(HPFailure)failure
//{
//    [IPTool getDeviceIPAddresses];
//
////    if ([NSString checkString:[IPTool shareInstance].currentIp].length > 0) {
////        return;
////    }
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        @autoreleasepool {
//            @try {
//                // Get the external IP Address based on dynsns.org
//                NSError *error = nil;
//                NSString *theIpHtml = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.dyndns.org/cgi-bin/check_ip.cgi"]
//                                                               encoding:NSUTF8StringEncoding
//                                                                  error:&error];
//                NSLog(@"theIpHtml : %@",theIpHtml);
//                if (!error) {
//                    //     {"code":0,"data":{"ip":"96.9.83.177","country":"柬埔寨","area":"","region":"XX","city":"XX","county":"XX","isp":"SINET","country_id":"KH","area_id":"","region_id":"xx","city_id":"xx","county_id":"xx","isp_id":"2000777"}}
//                    //
//                    NSDictionary * ipDic = [theIpHtml mj_JSONObject];
//                    ipDic = [NSDictionary checkDictionary:ipDic];
//                    if (ipDic && [ipDic[@"code"] integerValue] == 0) { //获取成功
//                        NSString * ipStr = ipDic[@"data"][@"ip"];
//                        [IPTool shareInstance].currentIp = ipStr;
//                    }
//                }
//            } @finally {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (success) {
//                        success([IPTool shareInstance].currentIp);
//                    }
//                });
////                [self performSelectorOnMainThread:@selector(getDeviceIPAddresses) withObject:nil waitUntilDone:NO];
//            }
//        }
//    });
//
//
////    return [[NetworkClient sharedInstance] GET:@"http://ip.taobao.com/service/getIpInfo.php?ip=myip" parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary * responseObject) {
////        NSString *ipStr = nil;
////        NSDictionary * ipDic = [NSDictionary checkDictionary:responseObject];
////        if (ipDic && [ipDic[@"code"] integerValue] == 0) { //获取成功
////            ipStr = ipDic[@"data"][@"ip"];
////            [IPTool shareInstance].currentIp = ipStr;
////        }
////        NSLog(@"ipDic : %@",ipDic);
////        if (success) {
////            success(ipStr);
////        }
////    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
////        if (failure) {
////            failure(error);
////        }
////    }];
//}
@end
