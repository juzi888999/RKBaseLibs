//
//  UIImage+Helper.h
//  RKBaseLibs
//
//  Created by mac on 15/9/29.
//  Copyright © 2015年 haixiaedu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Helper)

+ (UIImage*)originalRenderImageNamed:(NSString*)name;
- (UIImage*)stretchImageWithCapInsets:(UIEdgeInsets)inset;
+ (UIImage *)adjustImageWithImage:(UIImage *)image;
+ (UIImage *) imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize) newSize;
// 获取视频第一帧
//+ (UIImage*) getVideoPreViewImage:(NSURL *)path;

@end

@interface UIImage (UKImage)

-(UIImage*)rotate:(UIImageOrientation)orient;

@end
