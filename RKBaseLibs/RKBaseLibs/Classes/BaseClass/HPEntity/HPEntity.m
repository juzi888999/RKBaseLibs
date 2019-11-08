//
//  HPEntity.m
//
//  Created by rk on 14-12-14.
//  Copyright (c) 2014年. All rights reserved.
//

#import "HPEntity.h"

@implementation HPEntity

- (instancetype)initRandom
{
    return [super init];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return nil;
}

+ (NSString *)formatPrice:(NSNumber *)price
{
    return [[self class] formatCurrencyWithString:[price stringValue] showCurrencySymbol:NO];
}

+ (NSString*)formatCurrencyWithString:(NSString *)string showCurrencySymbol:(BOOL)symbol
{
    // alloc formatter
    NSNumberFormatter *currencyStyle = [[NSNumberFormatter alloc] init];
    
    // set options.
    [currencyStyle setFormatterBehavior:NSNumberFormatterBehaviorDefault];
    [currencyStyle setMinimumFractionDigits:0];
    [currencyStyle setMaximumFractionDigits:1];
    
    // reset style to no style for converting string to number.
    [currencyStyle setNumberStyle:NSNumberFormatterNoStyle];
    
    //create number from string
    NSNumber * balance = [currencyStyle numberFromString:string];
    
    //now set to currency format
    [currencyStyle setNumberStyle:NSNumberFormatterCurrencyStyle];
    if (symbol)
        [currencyStyle setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"]];
    else
        [currencyStyle setCurrencySymbol:@""];
    
    currencyStyle.negativePrefix = [NSString stringWithFormat:@"- %@", currencyStyle.currencySymbol];
    currencyStyle.negativeSuffix = @"";
    
    // get formatted string
    NSString* formatted = [currencyStyle stringFromNumber:balance];
    
    //return formatted string
    return formatted;
}

+ (BOOL)isEmpty:(id)object
{
    return object == nil || ([object isKindOfClass:[NSString class]] && [object length] == 0);
}

+ (NSString *)convertServerTextForDisplay:(NSString *)text
{
//    if ([text containsString:@"\\r\\n"])
        text = [text stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
//    if ([text containsString:@"\\n"])
        text = [text stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    return text;
}

@end
