//
//  DateTool.h
//  CDITVDuke
//
//  Created by juzien on 14/12/25.
//  Copyright (c) 2014年 CDITVD. All right·s reserved.
//

#import <Foundation/Foundation.h>

@interface DateTool : NSObject

+(NSString *)rk_formatDateWithFormat:(NSString *)format timesp:(double)timesp;
+(NSString *)rk_formatDate:(double)timesp;
+(NSString *)rk_formatDateToSecond:(double)timesp;
+(NSString *)rk_formatDateToMin:(double)timesp;
+(NSString *)rk_formatDateMMDDHHMM:(double)timesp;
+(NSString *)rk_formatNewsDate:(long long)timesp;

@end
