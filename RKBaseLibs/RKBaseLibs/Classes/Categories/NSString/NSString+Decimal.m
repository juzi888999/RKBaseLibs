//
//  NSString+Decimal.m
//  RKBaseLibs
//
//  Created by rk on 7/24/19.
//  Copyright © 2019 rk. All rights reserved.
//

#import "NSString+Decimal.h"

@implementation NSString (Decimal)

NSString *decimalNumberWithDouble(double conversionValue){
    
    NSString *doubleString        = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber    = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

NSString *decimalNumBerWithDouble_roundPlain(double conversionValue,int scale)
{
    NSDecimalNumber * decimalMoney = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lf",conversionValue]];
    NSDecimalNumberHandler*roundPlain = [NSDecimalNumberHandler
                                         decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                         scale:scale
                                         raiseOnExactness:NO
                                         raiseOnOverflow:NO
                                         raiseOnUnderflow:NO
                                         raiseOnDivideByZero:YES];
    decimalMoney = [decimalMoney decimalNumberByRoundingAccordingToBehavior:roundPlain];
    NSString * result = [NSString stringWithFormat:@"%.2f",decimalMoney.doubleValue];
    return result;
}

+(NSString *)getMovieTimeWithStr:(long)movieTime
{
    if (movieTime == 0) {
        return @"";
    }
    NSString * miaoStr;
    NSString * fenStr;
    NSString * shiStr;
    miaoStr = [NSString stringWithFormat:@"%02ld",movieTime%60];
    fenStr = [NSString stringWithFormat:@"%02ld",(movieTime%3600)/60];
    shiStr = [NSString stringWithFormat:@"%02ld",movieTime/3600];
    if (shiStr.intValue == 0) {
        return [NSString stringWithFormat:@"%@:%@",fenStr,miaoStr];
    }else{
        return [NSString stringWithFormat:@"%@:%@:%@",shiStr,fenStr,miaoStr];
    }
}

@end
