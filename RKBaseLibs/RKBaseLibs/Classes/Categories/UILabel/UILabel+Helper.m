//
//  UILabel+Helper.m
//
//  Created by rk on 14-11-19.
//  Copyright (c) 2014年 juzi. All rights reserved.
//

#import "UILabel+Helper.h"

@implementation UILabel (Helper)

+ (UILabel *)centerAlignLabel
{
    UILabel *v = [UILabel new];
    v.backgroundColor = [UIColor clearColor];
    v.textAlignment = NSTextAlignmentCenter;
    return v;
}

+ (UILabel *)rightAlignLabel
{
    UILabel *v = [UILabel new];
    v.backgroundColor = [UIColor clearColor];
    v.textAlignment = NSTextAlignmentRight;
    return v;
}

+ (UILabel *)leftAlignLabel
{
    UILabel *v = [UILabel new];
    v.backgroundColor = [UIColor clearColor];
    v.textAlignment = NSTextAlignmentLeft;
    return v;
}

@end
