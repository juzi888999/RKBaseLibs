//
//  NSString+Random.h
//
//  Created by rk on 14-12-17.
//  Copyright (c) 2014年. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Random)

+ (NSString *)randomWithLength:(NSUInteger)len;
+ (NSString *)randomName;
+ (NSString *)randomNumbers;
+ (NSString *)randomNumbers:(NSUInteger)length;

@end
