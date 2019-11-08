//
//  NSString+Validator.h
//
//  Created by rk on 12-9-4.
//
//

#import <Foundation/Foundation.h>

@interface NSString (Validator)

- (BOOL)isSame:(NSString*)str;
- (BOOL)isAllDigits;
- (BOOL)isNumeric;
- (BOOL)isMobilePhone;
- (BOOL)isEmail;
+ (BOOL)isIncludeChineseInString:(NSString*)str;


@end

