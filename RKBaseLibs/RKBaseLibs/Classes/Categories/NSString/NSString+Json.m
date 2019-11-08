//
//  NSString+Json.m
//  RKBaseLibs
//
//  Created by rk on 16/2/20.
//  Copyright © 2016年 haixiaedu. All rights reserved.
//

#import "NSString+Json.h"

@implementation NSString (Json)

-(NSString *)convertToNSString:(NSData *)data
{
    const unsigned char *szBuffer = [data bytes];
    if(!szBuffer){
            return nil;
    }
    
    NSMutableString *strTemp = [NSMutableString stringWithCapacity:[data length]*2];
    NSUInteger dataLength = [data length];
     
    for (NSInteger i=0; i < dataLength; ++i) {
        [strTemp appendFormat:@"%02lx",(unsigned long)szBuffer[i]];
        
    }
  
    NSString* result = [NSString stringWithString:strTemp];
    return result;
}


+(NSString*)dataToJsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:0 // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

- (NSDictionary *)jsonStringConvertToDictionary
{
    if ([NSString checkString:self].length > 0) {
        NSData * data = [self dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        return dic;
    }
    return nil;
}

- (NSArray *)jsonStringConvertToArray
{
    if ([NSString checkString:self].length > 0) {
        NSData * data = [self dataUsingEncoding:NSUTF8StringEncoding];
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        return arr;
    }
    
    return nil;
}

@end
