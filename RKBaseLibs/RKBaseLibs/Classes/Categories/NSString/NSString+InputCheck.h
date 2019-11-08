//
//  NSString+InputCheck.h
//  RKBaseLibs
//
//  Created by rk on 15/7/22.
//  Copyright (c) 2015年 haixiaedu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (InputCheck)

- (BOOL)validateEmail;
- (BOOL)validateMobile;
- (BOOL)isMobileNumber;

- (BOOL)isPureInt;
- (BOOL)isPureFloat;
- (BOOL)hasContainsString:(NSString *)aString;

@end
