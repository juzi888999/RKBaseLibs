//
//  NSObject+Check.h
//  PaoFu
//
//  Created by rk on 14/12/8.
//  Copyright (c) 2014年 yons. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Check)
- (NSString *)checkString:(id)string;
- (NSArray *)checkArray:(id)obj;
- (NSDictionary *)checkDictionary:(id)obj;
- (id)checkOject:(id)obj;

+ (NSArray *)checkArray:(id)obj;
+ (NSDictionary *)checkDictionary:(id)obj;
+ (NSString *)checkString:(id)string;
+ (id)checkOject:(id)obj;
@end
