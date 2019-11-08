//
//  XBNetworkDefines.m
//  RKBaseLibs
//
//  Created by rk on 4/30/19.
//  Copyright © 2019 rk. All rights reserved.
//

#import "XBNetworkDefines.h"

#ifdef SERVER_IP
#undef SERVER_IP
#endif
#ifdef IMAGE_SERVER_IP
#undef IMAGE_SERVER_IP
#endif
#ifdef VIDEO_SERVER_IP
#undef VIDEO_SERVER_IP
#endif

NSString * IMAGE_SERVER_IP = @"";
NSString * VIDEO_SERVER_IP = @"";
NSString * SERVER_IP = @"";
NSString * JPushAppKey = @"";

@implementation XBNetworkDefines

@end
