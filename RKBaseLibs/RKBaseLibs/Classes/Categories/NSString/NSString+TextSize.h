//
//  NSString+TextSize.h
//
//  Created by rk on 14-11-28.
//  Copyright (c) 2014年 juzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (TextSize)

- (CGSize)textSizeWithFont:(UIFont*)font;
- (CGSize)textRectWithFont:(UIFont*)font maxSize:(CGSize)size mode:(NSLineBreakMode)mode;

@end
