//
//  UIView+RoundCorner.h
//
//  Created by rk on 14-11-19.
//  Copyright (c) 2014年 juzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (RoundCorner)

- (void)roundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)size;
+ (UIView*)imageView:(UIImageView*)imageView roundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)size shadow:(NSDictionary*)shadow;

- (instancetype)cornerAllCornersWithCornerRadius:(CGFloat)cornerRadius;
- (instancetype)cornerByRoundingCorners:(UIRectCorner)corners cornerRadius:(CGFloat)cornerRadius;

@end
