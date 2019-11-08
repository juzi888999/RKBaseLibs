//
//  UIView+RoundCorner.m
//
//  Created by rk on 14-11-19.
//  Copyright (c) 2014年 juzi. All rights reserved.
//

#import "UIView+RoundCorner.h"

@implementation UIView (RoundCorner)

- (void)roundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)size
{
    // Create the path (with only the top-left corner rounded)
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:corners
                                                         cornerRadii:size];
    
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    
    // Set the newly created shape layer as the mask for the image view's layer
    self.layer.mask = maskLayer;
}

+ (UIView*)imageView:(UIImageView*)imageView roundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)size shadow:(NSDictionary*)shadow
{
    // Create a transparent view
    UIView *theView = [[UIView alloc] initWithFrame:imageView.frame];
    [theView setBackgroundColor:[UIColor clearColor]];
    
    // Create the path (with only the top-left corner rounded)
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:theView.bounds
                                                   byRoundingCorners:corners
                                                         cornerRadii:size];
    
    // Create the shadow layer
    CAShapeLayer *shadowLayer = [CAShapeLayer layer];
    [shadowLayer setFrame:theView.bounds];
    [shadowLayer setMasksToBounds:NO];
    [shadowLayer setShadowPath:maskPath.CGPath];
    // ...
    // Set the shadowColor, shadowOffset, shadowOpacity & shadowRadius as required
    // ...
    
    // Create the rounded layer, and mask it using the rounded mask layer
    CALayer *roundedLayer = [CALayer layer];
    [roundedLayer setFrame:theView.bounds];
    [roundedLayer setContents:(id)imageView.image.CGImage];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    [maskLayer setFrame:theView.bounds];
    [maskLayer setPath:maskPath.CGPath];
    
    roundedLayer.mask = maskLayer;
    
    // Add these two layers as sublayers to the view
    [theView.layer addSublayer:shadowLayer];
    [theView.layer addSublayer:roundedLayer];
    
    return theView;
}

//------
- (instancetype)cornerAllCornersWithCornerRadius:(CGFloat)cornerRadius
{
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    shapeLayer.path = path.CGPath;
    self.layer.mask = shapeLayer;
    self.layer.contentsScale = [[UIScreen mainScreen] scale];
    return self;
}


- (instancetype)cornerByRoundingCorners:(UIRectCorner)corners cornerRadius:(CGFloat)cornerRadius{
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    self.layer.contentsScale = [[UIScreen mainScreen] scale];
    return self;
}

@end
