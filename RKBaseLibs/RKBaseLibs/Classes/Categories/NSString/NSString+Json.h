//
//  NSString+Json.h
//  RKBaseLibs
//
//  Created by rk on 16/2/20.
//  Copyright © 2016年 haixiaedu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Json)

+(NSString*)dataToJsonString:(id)object;

-(NSString *)convertToNSString:(NSData *)data;

- (NSDictionary *)jsonStringConvertToDictionary;
- (NSArray *)jsonStringConvertToArray;

@end
