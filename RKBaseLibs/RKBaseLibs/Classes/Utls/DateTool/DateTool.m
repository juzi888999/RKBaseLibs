//
//  DateTool.m
//  CDITVDuke
//
//  Created by juzien on 14/12/25.
//  Copyright (c) 2014年 CDITVD. All rights reserved.
//

#import "DateTool.h"

@implementation DateTool


+(NSString *)rk_formatDate:(double)timesp
{
    if (timesp > 9999999999) {
        timesp = timesp/1000;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timesp];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
    
}

+(NSString *)rk_formatDateToSecond:(double)timesp
{
    if (timesp > 9999999999) {
        timesp = timesp/1000;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timesp];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
    
}
+(NSString *)rk_formatDateWithFormat:(NSString *)format timesp:(double)timesp
{
    if (timesp > 9999999999) {
        timesp = timesp/1000;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timesp];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
    
}

+(NSString *)rk_formatDateToMin:(double)timesp{
    if (timesp > 9999999999) {
        timesp = timesp/1000;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timesp];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

+(NSString *)rk_formatDateMMDDHHMM:(double)timesp{
    if (timesp > 9999999999) {
        timesp = timesp/1000;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timesp];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

+(NSString *)rk_formatNewsDate:(long long)timesp{
    if (timesp > 9999999999) {
        timesp = timesp/1000;
    }
    NSString *dateStr = nil;
    long long nowTime = [[NSDate date] timeIntervalSince1970];
    
    //今天已经过去的秒数
    long long todayTime = -[NSDate dateWithToday].timeIntervalSinceNow;
    if (timesp + 60 >= nowTime) {
        dateStr = [NSString stringWithFormat:@"刚刚"];
    } else if (timesp + 60 * 60 >= nowTime) {
        long long minute = (nowTime - timesp) / 60;
        dateStr = [NSString stringWithFormat:@"%lld分钟前", minute];
        
    } else if (timesp + todayTime >= nowTime) {
        //当天
        long long hour = (nowTime - timesp) / (60 * 60);
        dateStr = [NSString stringWithFormat:@"%lld小时前", hour];
    }
    /*
    else if (time + todayTime + 60 * 60 * 24 * 1 >= nowTime) {
        dateStr = @"昨天";
    }else if (time + todayTime + 60 * 60 * 24 * 2 >= nowTime) {
        dateStr = @"前天";
    }else if (time + todayTime + 60 * 60 * 24 * 10 >= nowTime) {
        int day = (int)((nowTime-time)/(60 * 60 * 24));
        dateStr = [NSString stringWithFormat:@"%d天前",day];
    }
     */
     else {
        dateStr = [NSString stringWithFormat:@"%@", [DateTool rk_formatDate:timesp]];
    }
    
    return dateStr;
}


@end
