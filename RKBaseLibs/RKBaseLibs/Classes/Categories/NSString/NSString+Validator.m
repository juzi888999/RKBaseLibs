//
//  NSString+Validator.m
//
//  Created by rk on 12-9-4.
//
//

#import "NSString+Validator.h"
#import "NSString+trim.h"

@implementation NSString (Validator)

- (BOOL)isSame:(NSString *)str
{
    if (self.length <= 0 && str.length <= 0)
        return YES;
    BOOL s = [self isEqualToString:str];
    return s;
}

- (BOOL)isAllDigits
{
    NSCharacterSet* nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSRange r = [self rangeOfCharacterFromSet: nonNumbers];
    return r.location == NSNotFound;
}

- (BOOL)isNumeric
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

- (BOOL)isMobilePhone
{
    if (self.length != 11)
    {
        return NO;
    }
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:@"^13[0-9]{9}$|15[0-9]{9}$|18[0-9]{9}$" options:NSRegularExpressionAnchorsMatchLines error:nil];
    NSUInteger n = [re numberOfMatchesInString:self options:NSMatchingReportCompletion range:NSMakeRange(0, self.length)];
    return n > 0;
}

- (BOOL)isEmail
{
    if (self.length <= 0)
    {
        return NO;
    }
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:@"\\w+@[0-9a-zA-Z_]+?\\.[0-9a-zA-Z]{2,6}"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];
    NSUInteger n = [re numberOfMatchesInString:self options:NSMatchingReportCompletion range:NSMakeRange(0, self.length)];
    return n > 0;
}

+ (BOOL)isIncludeChineseInString:(NSString*)str {
    
    if (!str) {
        return NO;
    }
    for (int i=0; i<str.length; i++) {
        unichar ch = [str characterAtIndex:i];
        if (0x4E00 <= ch  && ch <= 0x9FA5) {
            return YES;
        }
    }
    return NO;
}


@end
