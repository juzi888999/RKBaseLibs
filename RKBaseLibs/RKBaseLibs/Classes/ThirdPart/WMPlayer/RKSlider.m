//
//  RKSlider.m
//  juzi
//
//  Created by rk on 2018/7/9.
//  Copyright © 2018年 juzi. All rights reserved.
//

#import "RKSlider.h"

@implementation RKSlider

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
{
    //返回滑块大小
    UIImage * image = HPImageForKey(@"progressMax");
    rect.size.width = rect.size.width + image.size.width;
    rect.origin.x = rect.origin.x - image.size.width/2.f ;
    return CGRectInset ([super thumbRectForBounds:bounds trackRect:rect value:value], image.size.width/2.f , image.size.width/2.f);
}

@end
