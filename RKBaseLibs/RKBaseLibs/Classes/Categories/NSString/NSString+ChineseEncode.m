//
//  NSString+ChineseEncode.m
//  baiyi
//
//  Created by rk on 16/7/5.
//  Copyright © 2016年 rk. All rights reserved.
//

#import "NSString+ChineseEncode.h"

@implementation NSString (ChineseEncode)


- (id)chineseEncoded {
    CFStringRef cfUrlEncodedString = CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                             (CFStringRef)self,
                                                                             (CFStringRef)@"!#$%&'()*+,/:;=?@[]",
                                                                             NULL,
                                                                             kCFStringEncodingUTF8);
    
    NSString *urlEncoded = [NSString stringWithString:(__bridge NSString *)cfUrlEncodedString];
    //CFRelease(cfUrlEncodedString);
    return urlEncoded;
}

@end
