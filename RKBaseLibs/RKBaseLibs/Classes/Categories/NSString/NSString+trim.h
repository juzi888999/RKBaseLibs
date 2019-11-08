//
//  NSString+trim.h
//  RKBaseLibs
//
//  Created by rk on 12-9-4.
//
//

#import <Foundation/Foundation.h>

@interface NSString (trim)

-(NSString *)rk_ltrim;
-(NSString *)rk_rtrim;
-(NSString *)rk_lrtrim;
-(NSString *)rk_trim;
-(NSString *)rk_trimAll;
-(BOOL)rk_isSame:(NSString*)str;
- (BOOL)rk_isAllDigits;
- (BOOL)rk_isNumeric;
- (BOOL)rk_isPureFloat:(NSString*)string;
- (BOOL)rk_isPureInt:(NSString*)string;

//+ (NSString *)rk_formatFloat:(double)f;
+ (NSString *)rk_formatMoneyWithDoubleValue:(double)doubleValue;
+ (NSString *)rk_formatMoneyWithString:(NSString *)string;
@end
