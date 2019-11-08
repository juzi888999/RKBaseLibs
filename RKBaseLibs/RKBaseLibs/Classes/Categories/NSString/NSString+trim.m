//
//  NSString+trim.m
//  WOGameDev
//
//  Created by rk on 12-9-4.
//
//

#import "NSString+trim.h"

@implementation NSString (trim)

-(NSString *)rk_ltrim
{
    if (self.length == 0) {
        return self;
    }
    NSInteger i;
    NSCharacterSet *cs = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for(i = 0; i < [self length]; i++)
    {
        if ( ![cs characterIsMember: [self characterAtIndex: i]] ) break;
    }
    return [self substringFromIndex: i];
}

-(NSString *)rk_rtrim
{
    if (self.length == 0) {
        return self;
    }
    NSInteger i;
    NSCharacterSet *cs = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for(i = [self length] -1; i >= 0; i--)
    {
        if ( ![cs characterIsMember: [self characterAtIndex: i]] ) break;
    }
    return [self substringToIndex: (i+1)];
}

- (NSString *)rk_lrtrim {
    return [[self rk_ltrim] rk_rtrim];
}

-(NSString *)rk_trim
{
    return [self
            stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

-(NSString *)rk_trimAll
{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (BOOL)rk_isSame:(NSString *)str
{
    if (self.length <= 0 && str.length <= 0)
        return YES;
    BOOL s = [self isEqualToString:str];
    return s;
}

- (BOOL)rk_isAllDigits
{
    NSCharacterSet* nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSRange r = [self rangeOfCharacterFromSet: nonNumbers];
    return r.location == NSNotFound;
}

- (BOOL)rk_isNumeric
{
    NSScanner *sc = [NSScanner scannerWithString: self];
    // We can pass NULL because we don't actually need the value to test
    // for if the string is numeric. This is allowable.
    if ( [sc scanFloat:NULL] )
    {
        // Ensure nothing left in scanner so that "42foo" is not accepted.
        // ("42" would be consumed by scanFloat above leaving "foo".)
        return [sc isAtEnd];
    }
    // Couldn't even scan a float :(
    return NO;
}

//判断字符串是否为浮点数
- (BOOL)rk_isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}
//判断是否为整形：
- (BOOL)rk_isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

+ (NSString *)rk_formatFloat:(double)f
{
//    if (fmodf(f, 1)==0) {//如果有一位小数点
//        return [NSString stringWithFormat:@"%.0f",f];
//    } else if (fmodf(f*10, 1)==0) {//如果有两位小数点
//        return [NSString stringWithFormat:@"%.1f",f];
//    } else {
//        return [NSString stringWithFormat:@"%.2f",f];
//    }
    return [NSString stringWithFormat:@"%.1f",f];
}

+ (NSString *)rk_formatMoneyWithDoubleValue:(double)doubleValue
{
    return [NSString stringWithFormat:@"%.2f",doubleValue];
}
+ (NSString *)rk_formatMoneyWithString:(NSString *)string
{
    return [NSString stringWithFormat:@"%.2f",[NSString checkString:string].doubleValue];
}
@end
