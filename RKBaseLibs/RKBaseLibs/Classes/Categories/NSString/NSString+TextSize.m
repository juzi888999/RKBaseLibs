//
//  NSString+TextSize.m
//
//  Created by rk on 14-11-28.
//  Copyright (c) 2014年 juzi. All rights reserved.
//

#import "NSString+TextSize.h"

@implementation NSString (TextSize)

- (CGSize)textSizeWithFont:(UIFont *)font
{
    if (self.length == 0)
        return CGSizeZero;
    if ([self respondsToSelector:@selector(sizeWithAttributes:)])
    {
        CGSize size = [self sizeWithAttributes:@{NSFontAttributeName:font}];
        return CGSizeMake(ceil(size.width), ceil(size.height));
    }
    else
    {
        return [self sizeWithFont:font];
    }
}

- (CGSize)textRectWithFont:(UIFont *)font maxSize:(CGSize)maxSize mode:(NSLineBreakMode)mode
{
    if (self.length == 0)
        return CGSizeZero;
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = mode;
        NSDictionary *attributes = @{NSFontAttributeName:font,
                                     NSParagraphStyleAttributeName:paragraphStyle};
        CGSize size = [self boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin)
                                      attributes:attributes context:nil].size;
        return CGSizeMake(ceil(size.width), ceil(size.height));
    }
    else
    {
        return [self sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode];
    }
}

@end
