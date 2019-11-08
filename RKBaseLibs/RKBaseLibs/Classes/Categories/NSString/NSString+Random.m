//
//  NSString+Random.m
//
//  Created by rk on 14-12-17.
//  Copyright (c) 2014年. All rights reserved.
//

#import "NSString+Random.h"

@implementation NSString (Random)

+ (NSString *)randomWithLength:(NSUInteger)len
{
    NSMutableString *str = [[NSMutableString alloc] init];
    for (NSInteger ix = 0; ix < len; ++ix) {
        [str appendFormat:@"%c", arc4random_uniform('z'-'a')+'a'];
    }
    return str;
}

+ (NSString *)randomName {
    NSString *name = [NSString randomWithLength:arc4random_uniform(10) + 5];
    return [name capitalizedString];
}

+ (NSString *)randomNumbers:(NSUInteger)length {
    NSMutableString *name = [[NSMutableString alloc] init];
    for (NSInteger ix = 0; ix < length; ++ix) {
        [name appendFormat:@"%c", arc4random_uniform('9'-'0')+'0'];
    }
    return name;
}

+ (NSString *)randomNumbers
{
    return [[self class] randomNumbers:arc4random_uniform(10)+5];
}

@end
