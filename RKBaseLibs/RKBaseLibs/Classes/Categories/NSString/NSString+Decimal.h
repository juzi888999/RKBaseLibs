//
//  NSString+Decimal.h
//  RKBaseLibs
//
//  Created by rk on 7/24/19.
//  Copyright © 2019 rk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Decimal)

NSString *decimalNumberWithDouble(double conversionValue);

//4舍5入
NSString *decimalNumBerWithDouble_roundPlain(double conversionValue,int scale);

+(NSString *)getMovieTimeWithStr:(long)movieTime;

@end

NS_ASSUME_NONNULL_END
